# Failure Classification Matrix

## HTTP Status Code Classification

### 1xx Informational (Rare in API Testing)

| Code | Meaning | Test Implication |
|------|---------|------------------|
| 100 | Continue | Rarely tested |
| 101 | Switching Protocols | WebSocket upgrade |

### 2xx Success

| Code | Meaning | Expected For |
|------|---------|--------------|
| 200 | OK | GET, PUT, PATCH |
| 201 | Created | POST (resource creation) |
| 202 | Accepted | Async operations |
| 204 | No Content | DELETE, some PUT |

### 3xx Redirection

| Code | Meaning | Action Required |
|------|---------|-----------------|
| 301 | Moved Permanently | Update URL in tests |
| 302 | Found (Temporary) | Follow redirect |
| 304 | Not Modified | Caching test |
| 307 | Temporary Redirect | Follow with same method |

### 4xx Client Errors

| Code | Meaning | Common Cause | Remediation |
|------|---------|--------------|-------------|
| 400 | Bad Request | Malformed JSON, missing field | Fix request body/params |
| 401 | Unauthorized | Missing/expired token | Refresh authentication |
| 403 | Forbidden | Insufficient permissions | Check user roles/scopes |
| 404 | Not Found | Wrong URL, deleted resource | Verify endpoint/resource |
| 405 | Method Not Allowed | Wrong HTTP method | Check API docs |
| 409 | Conflict | Duplicate resource | Handle idempotency |
| 422 | Unprocessable Entity | Validation failure | Fix data validation |
| 429 | Too Many Requests | Rate limited | Add delays, reduce load |

### 5xx Server Errors

| Code | Meaning | Common Cause | Remediation |
|------|---------|--------------|-------------|
| 500 | Internal Server Error | Backend bug, unhandled exception | Report to dev team |
| 501 | Not Implemented | Feature not built | Verify feature exists |
| 502 | Bad Gateway | Proxy/gateway issue | Check infrastructure |
| 503 | Service Unavailable | Overload, maintenance | Retry later |
| 504 | Gateway Timeout | Backend timeout | Increase timeout, optimize |

## Connection Error Classification

| Error | Meaning | Common Cause | Remediation |
|-------|---------|--------------|-------------|
| ECONNREFUSED | Connection refused | Service not running | Start service, check port |
| ETIMEDOUT | Connection timeout | Network issue, firewall | Check network, VPN |
| ENOTFOUND | DNS lookup failed | Wrong hostname | Verify URL |
| ECONNRESET | Connection reset | Server closed connection | Check server logs |
| CERT_* errors | SSL/TLS issue | Certificate problem | Update certs, check config |

## Assertion Error Classification

| Type | Example | Cause | Remediation |
|------|---------|-------|-------------|
| Status mismatch | Expected 200, got 500 | Server error or wrong expectation | Investigate server |
| Body mismatch | Expected field missing | API change or data issue | Update test or fix API |
| Schema violation | Wrong data type | Contract change | Update schema assertions |
| Value mismatch | Expected "active", got "inactive" | Data state issue | Fix test data |
| Array length | Expected 10, got 0 | Data not seeded | Ensure test data exists |

## Timing Error Classification

| Type | Threshold | Cause | Remediation |
|------|-----------|-------|-------------|
| Request timeout | > 30s | Slow endpoint | Optimize or increase timeout |
| Script timeout | > 10s | Complex test script | Simplify assertions |
| Slow response | > 5s | Performance issue | Performance testing needed |

## Environment-Specific Classification

| Environment | Typical Issues | Priority |
|-------------|----------------|----------|
| Local | Service not running, port conflicts | Low |
| Dev | Frequent deployments, unstable data | Medium |
| Staging | Config differences, missing data | High |
| Production | Critical issues only | Critical |

## Flaky Test Classification

| Pattern | Indicator | Root Cause | Fix |
|---------|-----------|------------|-----|
| Race condition | Random pass/fail | Timing dependency | Add waits |
| Order dependency | Fails in isolation | Shared state | Isolate tests |
| Data dependency | Fails after other tests | Data modification | Reset data |
| Time sensitivity | Fails at certain times | Hardcoded dates | Use dynamic dates |
| Resource exhaustion | Fails under load | Limited resources | Cleanup, scaling |

## Severity Matrix

| Category | Business Impact | Examples |
|----------|-----------------|----------|
| **Critical** | Revenue loss, security breach | Auth failures in prod, data corruption |
| **High** | Major feature broken | CRUD operations failing |
| **Medium** | Feature degraded | Slow responses, partial failures |
| **Low** | Minor inconvenience | Cosmetic issues, edge cases |
| **Info** | No user impact | Deprecated warnings |

## Decision Tree

```
Failure occurred
    │
    ├─ Connection error?
    │   ├─ Yes → Check service health → Fix infrastructure
    │   └─ No ↓
    │
    ├─ Status 5xx?
    │   ├─ Yes → Server issue → Escalate to dev team
    │   └─ No ↓
    │
    ├─ Status 401/403?
    │   ├─ Yes → Auth issue → Check tokens/credentials
    │   └─ No ↓
    │
    ├─ Status 4xx?
    │   ├─ Yes → Client error → Fix request data
    │   └─ No ↓
    │
    ├─ Assertion failure?
    │   ├─ Yes → Response changed → Update test or report bug
    │   └─ No ↓
    │
    └─ Timeout?
        ├─ Yes → Performance issue → Optimize or adjust timeout
        └─ No → Unknown → Collect more data
```

## Quick Reference Card

### Red Flags (Immediate Action)

- 500 errors in production
- Auth failures across all tests
- Connection refused to all endpoints
- Data integrity issues

### Yellow Flags (Monitor)

- Intermittent 503 errors
- Increasing response times
- Occasional auth refresh failures
- Rate limiting warnings

### Green Flags (Informational)

- Expected 404 for deleted resources
- Validation rejections for bad input
- Deprecation warnings
