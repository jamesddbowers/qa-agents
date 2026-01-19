---
name: dynatrace-analysis
description: Analyze Dynatrace exports and APM data to prioritize API endpoints for testing. Use when you need to parse Dynatrace exports, analyze traffic patterns, calculate endpoint priority scores, identify high-traffic endpoints, detect error-prone endpoints, create smoke vs regression test categorization, or support QA MVP Step 3. Handles CSV and JSON export formats with traffic volume, error rate, and latency metrics.
---

# Dynatrace Analysis

Parse APM data from Dynatrace exports to prioritize endpoints for smoke and regression testing.

## Quick Start

1. Identify export format (CSV or JSON)
2. Parse traffic metrics (requests, errors, latency)
3. Calculate priority scores
4. Categorize endpoints for smoke vs regression
5. Generate prioritized inventory

## Supported Data Formats

| Format | Source | Common Files |
|--------|--------|--------------|
| CSV | Dynatrace export | `service-requests.csv`, `api-metrics.csv` |
| JSON | API export | `metrics.json`, `service-flow.json` |
| Custom | Manual export | Structured traffic data |

## Key Metrics

### Golden Signals

| Metric | Description | Priority Weight |
|--------|-------------|-----------------|
| Request Count | Total requests per endpoint | 40% |
| Error Rate | Percentage of failed requests | 30% |
| P95 Latency | 95th percentile response time | 20% |
| Business Impact | Manual or inferred criticality | 10% |

## Priority Scoring

### Formula

```
Priority Score = (Traffic × 0.4) + (Error × 0.3) + (Impact × 0.2) + (Performance × 0.1)

Where:
- Traffic = Normalized request count (0-100)
- Error = Error rate × 100 (0-100)
- Impact = Business criticality (0-100)
- Performance = Normalized P95 latency (0-100)
```

### Normalization

```
Normalized Value = (Value - Min) / (Max - Min) × 100
```

## Categorization Thresholds

| Category | Criteria | Test Suite |
|----------|----------|------------|
| Critical | Top 10% by traffic OR error rate > 1% | Smoke |
| High | Top 30% by traffic | Smoke |
| Medium | Top 60% by traffic | Regression |
| Low | Bottom 40% by traffic | Extended |

## Analysis Process

### Step 1: Parse Export

Identify columns/fields mapping:
- Endpoint path
- HTTP method
- Request count
- Error count/rate
- Response time metrics

See `references/export-formats.md` for format-specific parsing.

### Step 2: Calculate Metrics

For each endpoint:
1. Calculate total requests
2. Calculate error rate: `errors / total × 100`
3. Extract P95 latency
4. Normalize all values to 0-100 scale

### Step 3: Score and Rank

Apply priority formula and sort by score descending.

### Step 4: Categorize

Apply thresholds to assign smoke/regression categories.

See `references/prioritization.md` for detailed algorithms.

## Output Format

```markdown
## Traffic Analysis Report

### Data Summary
- Source: [Dynatrace / Custom]
- Time Range: [start] to [end]
- Total Requests: [count]
- Unique Endpoints: [count]

### Top Endpoints by Traffic

| Rank | Endpoint | Method | Requests | Errors | P95 | Score | Category |
|------|----------|--------|----------|--------|-----|-------|----------|
| 1 | /api/users | GET | 1.2M | 0.1% | 45ms | 95 | Smoke |
| 2 | /api/orders | POST | 850K | 0.3% | 120ms | 88 | Smoke |

### Smoke Test Candidates
[List with justification]

### Regression Test Candidates
[List with justification]

### Error-Prone Endpoints
[Endpoints with elevated error rates]

### Performance Concerns
[Endpoints with high latency]
```

## DQL Reference

For direct Dynatrace queries, see `references/dql-reference.md`.

## Edge Cases

- **Incomplete data**: Note gaps, adjust confidence
- **Sparse traffic**: Lower thresholds, note statistical limitations
- **Anomalous spikes**: Filter outliers or note in report
- **No error data**: Prioritize by traffic only
- **Mixed environments**: Separate by environment tag
