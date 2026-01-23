# Dynatrace Export Formats

## CSV Export Format

### Service Request Metrics

Common columns in Dynatrace CSV exports:

| Column | Description | Example |
|--------|-------------|---------|
| `Service` | Service name | `user-service` |
| `Request name` | Endpoint path | `/api/users/{id}` |
| `Method` | HTTP method | `GET` |
| `Request count` | Total requests | `125000` |
| `Failed request count` | Failed requests | `125` |
| `Response time (avg)` | Average latency ms | `45.2` |
| `Response time (p95)` | P95 latency ms | `120.5` |
| `Response time (p99)` | P99 latency ms | `250.0` |

### Parsing Example

```javascript
// Parse Dynatrace CSV
function parseDynatraceCSV(csvContent) {
    const lines = csvContent.split('\n');
    const headers = lines[0].split(',');

    return lines.slice(1).map(line => {
        const values = line.split(',');
        return {
            service: values[headers.indexOf('Service')],
            endpoint: values[headers.indexOf('Request name')],
            method: values[headers.indexOf('Method')],
            requestCount: parseInt(values[headers.indexOf('Request count')]),
            errorCount: parseInt(values[headers.indexOf('Failed request count')]),
            avgLatency: parseFloat(values[headers.indexOf('Response time (avg)')]),
            p95Latency: parseFloat(values[headers.indexOf('Response time (p95)')])
        };
    });
}
```

## JSON Export Format

### Metrics API Response

```json
{
  "totalCount": 150,
  "nextPageKey": null,
  "result": [
    {
      "metricId": "builtin:service.requestCount.total",
      "data": [
        {
          "dimensions": [
            "/api/users",
            "GET"
          ],
          "values": [125000]
        }
      ]
    }
  ]
}
```

### Service Flow Export

```json
{
  "services": [
    {
      "name": "user-service",
      "endpoints": [
        {
          "path": "/api/users",
          "method": "GET",
          "metrics": {
            "requestCount": 125000,
            "errorCount": 125,
            "avgResponseTime": 45.2,
            "p95ResponseTime": 120.5
          }
        }
      ]
    }
  ]
}
```

## Custom Export Mapping

If your export has different column names, create a mapping:

```javascript
const columnMapping = {
    'endpoint': ['Request name', 'path', 'url', 'endpoint'],
    'method': ['Method', 'http_method', 'verb'],
    'requests': ['Request count', 'total_requests', 'count'],
    'errors': ['Failed request count', 'error_count', 'failures'],
    'latency': ['Response time (p95)', 'p95_latency', 'latency_p95']
};

function findColumn(headers, possibleNames) {
    for (const name of possibleNames) {
        if (headers.includes(name)) return name;
    }
    return null;
}
```

## Time Range Handling

### Extracting Time Range

Look for metadata in export:
- File name pattern: `metrics_2024-01-01_2024-01-07.csv`
- Header row with date range
- JSON metadata field

### Aggregation Periods

| Period | Use Case |
|--------|----------|
| 1 hour | Recent spike analysis |
| 1 day | Daily pattern analysis |
| 1 week | Baseline establishment |
| 1 month | Trend analysis |

For test prioritization, prefer 1-week minimum to capture typical traffic patterns.

## Data Quality Checks

Before analysis, validate:

1. **Completeness**: No missing endpoints
2. **Consistency**: Same time range for all metrics
3. **Reasonability**: No negative values, error rate <= 100%
4. **Coverage**: All expected services present

```javascript
function validateExport(data) {
    const issues = [];

    data.forEach((row, index) => {
        if (!row.endpoint) issues.push(`Row ${index}: Missing endpoint`);
        if (row.requestCount < 0) issues.push(`Row ${index}: Negative request count`);
        if (row.errorCount > row.requestCount) issues.push(`Row ${index}: Errors exceed requests`);
    });

    return issues;
}
```
