# Endpoint Prioritization Algorithms

## Priority Score Calculation

### Standard Formula

```javascript
function calculatePriorityScore(endpoint, allEndpoints) {
    // Normalize traffic (0-100)
    const maxTraffic = Math.max(...allEndpoints.map(e => e.requestCount));
    const trafficScore = (endpoint.requestCount / maxTraffic) * 100;

    // Error score (direct percentage, capped at 100)
    const errorRate = (endpoint.errorCount / endpoint.requestCount) * 100;
    const errorScore = Math.min(errorRate * 10, 100); // Amplify for visibility

    // Performance score (inverse - lower latency = higher score)
    const maxLatency = Math.max(...allEndpoints.map(e => e.p95Latency));
    const performanceScore = ((maxLatency - endpoint.p95Latency) / maxLatency) * 100;

    // Business impact (default 50 if not specified)
    const impactScore = endpoint.businessImpact || 50;

    // Weighted combination
    return (trafficScore * 0.4) +
           (errorScore * 0.3) +
           (impactScore * 0.2) +
           (performanceScore * 0.1);
}
```

### Alternate: Percentile-Based

```javascript
function calculatePercentileScore(endpoint, allEndpoints) {
    const trafficRank = getPercentileRank(endpoint.requestCount,
        allEndpoints.map(e => e.requestCount));
    const errorRank = getPercentileRank(endpoint.errorCount / endpoint.requestCount,
        allEndpoints.map(e => e.errorCount / e.requestCount));

    return (trafficRank + errorRank) / 2;
}

function getPercentileRank(value, allValues) {
    const sorted = [...allValues].sort((a, b) => a - b);
    const index = sorted.indexOf(value);
    return (index / sorted.length) * 100;
}
```

## Categorization Logic

### Traffic-Based Tiers

```javascript
function categorizeEndpoints(endpoints) {
    // Sort by priority score descending
    const sorted = [...endpoints].sort((a, b) => b.priorityScore - a.priorityScore);
    const total = sorted.length;

    return sorted.map((endpoint, index) => {
        const percentile = ((index + 1) / total) * 100;

        if (percentile <= 10) {
            endpoint.category = 'critical';
            endpoint.testSuite = 'smoke';
        } else if (percentile <= 30) {
            endpoint.category = 'high';
            endpoint.testSuite = 'smoke';
        } else if (percentile <= 60) {
            endpoint.category = 'medium';
            endpoint.testSuite = 'regression';
        } else {
            endpoint.category = 'low';
            endpoint.testSuite = 'extended';
        }

        return endpoint;
    });
}
```

### Error-Based Override

```javascript
function applyErrorOverrides(endpoints) {
    return endpoints.map(endpoint => {
        const errorRate = (endpoint.errorCount / endpoint.requestCount) * 100;

        // Elevate to smoke if error rate is concerning
        if (errorRate > 1 && endpoint.testSuite !== 'smoke') {
            endpoint.testSuite = 'smoke';
            endpoint.overrideReason = `High error rate: ${errorRate.toFixed(2)}%`;
        }

        // Flag critical error rates
        if (errorRate > 5) {
            endpoint.alert = 'CRITICAL_ERROR_RATE';
        }

        return endpoint;
    });
}
```

## Smoke Test Selection

### Criteria

Select for smoke tests when ANY of:
1. Top 20% by request volume
2. Error rate > 1%
3. Business-critical flag set
4. Dependency for other tests

### Time Budget

Smoke tests should complete in < 2 minutes:

```javascript
function selectSmokeTests(endpoints, maxDuration = 120) {
    const smokeCandiates = endpoints.filter(e => e.testSuite === 'smoke');

    // Estimate 2 seconds per request
    const estimatedDuration = smokeCandiates.length * 2;

    if (estimatedDuration > maxDuration) {
        // Trim to fit time budget
        const maxTests = Math.floor(maxDuration / 2);
        return smokeCandiates
            .sort((a, b) => b.priorityScore - a.priorityScore)
            .slice(0, maxTests);
    }

    return smokeCandiates;
}
```

## Output Generation

```javascript
function generatePriorityReport(endpoints) {
    const smoke = endpoints.filter(e => e.testSuite === 'smoke');
    const regression = endpoints.filter(e => e.testSuite === 'regression');
    const errorProne = endpoints.filter(e =>
        (e.errorCount / e.requestCount) > 0.01);

    return {
        summary: {
            total: endpoints.length,
            smoke: smoke.length,
            regression: regression.length,
            errorProne: errorProne.length
        },
        smokeTests: smoke.map(e => ({
            endpoint: e.endpoint,
            method: e.method,
            score: e.priorityScore.toFixed(1),
            reason: e.overrideReason || 'High traffic'
        })),
        regressionTests: regression.map(e => ({
            endpoint: e.endpoint,
            method: e.method,
            score: e.priorityScore.toFixed(1)
        })),
        alerts: errorProne.map(e => ({
            endpoint: e.endpoint,
            errorRate: ((e.errorCount / e.requestCount) * 100).toFixed(2) + '%',
            severity: e.alert || 'WARNING'
        }))
    };
}
```

## Confidence Assessment

Rate confidence based on data quality:

| Factor | High Confidence | Low Confidence |
|--------|-----------------|----------------|
| Sample size | > 1000 requests | < 100 requests |
| Time range | > 7 days | < 1 day |
| Error data | Complete | Missing |
| Coverage | All endpoints | Partial |
