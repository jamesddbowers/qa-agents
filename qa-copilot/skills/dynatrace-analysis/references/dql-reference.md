# DQL (Dynatrace Query Language) Reference

## Basic Syntax

```dql
fetch [data-type]
| filter [condition]
| summarize [aggregation] by [dimensions]
| sort [field] [direction]
| limit [count]
```

## Common Queries for API Analysis

### Request Count by Endpoint

```dql
fetch spans
| filter span.kind == "SERVER"
| summarize requestCount = count() by http.route, http.request.method
| sort requestCount desc
| limit 100
```

### Error Rate by Endpoint

```dql
fetch spans
| filter span.kind == "SERVER"
| summarize
    totalRequests = count(),
    errorCount = countIf(http.status_code >= 400)
  by http.route, http.request.method
| fieldsAdd errorRate = (errorCount / totalRequests) * 100
| sort errorRate desc
```

### Response Time Percentiles

```dql
fetch spans
| filter span.kind == "SERVER"
| summarize
    avgDuration = avg(duration),
    p50Duration = percentile(duration, 50),
    p95Duration = percentile(duration, 95),
    p99Duration = percentile(duration, 99)
  by http.route, http.request.method
| sort p95Duration desc
```

### Golden Signals Combined

```dql
fetch spans
| filter span.kind == "SERVER"
| filter timestamp > now() - 7d
| summarize
    requestCount = count(),
    errorCount = countIf(http.status_code >= 400),
    avgLatency = avg(duration),
    p95Latency = percentile(duration, 95)
  by http.route, http.request.method
| fieldsAdd errorRate = (errorCount / requestCount) * 100
| sort requestCount desc
| limit 100
```

## Filtering Patterns

### By Service

```dql
fetch spans
| filter dt.entity.service == "SERVICE-XXXXXXXX"
```

### By Time Range

```dql
fetch spans
| filter timestamp > now() - 24h
| filter timestamp < now()
```

### By HTTP Status

```dql
fetch spans
| filter http.status_code >= 200 and http.status_code < 300  // Success only
| filter http.status_code >= 400  // Errors only
| filter http.status_code >= 500  // Server errors only
```

### By Endpoint Pattern

```dql
fetch spans
| filter matchesPhrase(http.route, "/api/")
| filter not matchesPhrase(http.route, "/health")
```

## Aggregation Functions

| Function | Description |
|----------|-------------|
| `count()` | Total count |
| `countIf(condition)` | Conditional count |
| `sum(field)` | Sum of values |
| `avg(field)` | Average |
| `min(field)` | Minimum |
| `max(field)` | Maximum |
| `percentile(field, n)` | Nth percentile |

## Time Bucketing

```dql
fetch spans
| filter span.kind == "SERVER"
| summarize requestCount = count() by bin(timestamp, 1h), http.route
```

## Service Dependencies

```dql
fetch spans
| filter span.kind == "CLIENT"
| summarize callCount = count()
  by source.service.name, destination.service.name
| sort callCount desc
```

## Export Results

### To CSV

In Dynatrace UI: Run query → Export → CSV

### Via API

```bash
curl -X POST "https://{environment}.live.dynatrace.com/api/v2/metrics/query" \
  -H "Authorization: Api-Token {token}" \
  -H "Content-Type: application/json" \
  -d '{"metricSelector": "builtin:service.requestCount.total"}'
```

## Common Metric Selectors

| Selector | Description |
|----------|-------------|
| `builtin:service.requestCount.total` | Total requests |
| `builtin:service.errors.total.rate` | Error rate |
| `builtin:service.response.time` | Response time |
| `builtin:service.requestCount.server` | Server-side requests |

## Query Optimization Tips

1. Always add time filter first
2. Filter before aggregating
3. Limit results for large datasets
4. Use specific service filters when possible
