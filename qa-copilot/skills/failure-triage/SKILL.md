---
name: failure-triage
description: Diagnose and triage API test failures from Newman/Postman runs. Use when you need to analyze test failures, classify failure types, identify root causes, suggest remediation steps, create failure reports, prioritize fixes, debug flaky tests, or support QA MVP Step 8. Covers HTTP error classification, assertion failure analysis, timeout diagnosis, and actionable remediation patterns.
---

# Failure Triage

Diagnose API test failures and provide actionable remediation guidance.

## Quick Start

1. Collect failure data (Newman output, JUnit XML, logs)
2. Classify failure type
3. Identify root cause
4. Suggest remediation
5. Document for future reference

## Failure Classification

| Category | Examples | Typical Cause |
|----------|----------|---------------|
| Connection | ECONNREFUSED, ETIMEDOUT | Service down, network issue |
| Authentication | 401, 403 | Token expired, wrong credentials |
| Client Error | 400, 404, 422 | Bad request data, wrong endpoint |
| Server Error | 500, 502, 503 | Backend bug, deployment issue |
| Assertion | Test script failures | Response changed, wrong expectation |
| Timeout | Request timeout | Slow endpoint, overload |
| Data | Missing/wrong data | Test data issue, environment mismatch |

See `references/classification-matrix.md` for detailed classification.

## Triage Workflow

### Step 1: Gather Context

```
Required information:
- Error message/code
- Request details (method, URL, headers)
- Response received (status, body)
- Test assertion that failed
- Environment (dev/staging/prod)
- Recent changes (deployments, data changes)
```

### Step 2: Classify Failure

```
Questions to ask:
1. Did the request reach the server? (Connection vs other)
2. What HTTP status was returned? (4xx vs 5xx)
3. Did the response format change? (Schema vs assertion)
4. Is this reproducible? (Flaky vs consistent)
5. Is this environment-specific? (Config vs code)
```

### Step 3: Root Cause Analysis

```
Analysis pattern:
1. Check if multiple tests failed (systemic vs isolated)
2. Compare with last successful run
3. Review recent deployments/changes
4. Check service health/logs
5. Verify test data state
```

### Step 4: Document and Remediate

See `references/remediation-patterns.md` for specific fixes.

## Common Failure Patterns

### Authentication Failures (401/403)

**Symptoms**:
- Status 401 Unauthorized
- Token expired/invalid message

**Diagnosis**:
```javascript
// Check token expiry
const tokenExpiry = pm.environment.get('TOKEN_EXPIRY');
console.log('Token expires:', new Date(parseInt(tokenExpiry)));
console.log('Current time:', new Date());
```

**Resolution**:
1. Verify auth credentials in variable group
2. Check token refresh logic in pre-request script
3. Ensure auth request runs before dependent tests

### Connection Failures

**Symptoms**:
- ECONNREFUSED
- ETIMEDOUT
- ENOTFOUND

**Diagnosis**:
```bash
# Check service availability
curl -I https://api.example.com/health

# Check DNS resolution
nslookup api.example.com
```

**Resolution**:
1. Verify BASE_URL is correct for environment
2. Check if service is deployed and healthy
3. Verify network connectivity (VPN, firewall)

### Assertion Failures

**Symptoms**:
- AssertionError in test script
- Expected vs actual mismatch

**Diagnosis**:
```javascript
// Log actual response for comparison
console.log('Response:', JSON.stringify(pm.response.json(), null, 2));
console.log('Status:', pm.response.code);
console.log('Headers:', JSON.stringify(pm.response.headers, null, 2));
```

**Resolution**:
1. Verify if API contract changed
2. Update assertions to match new contract
3. Check if test data produces expected response

### Flaky Test Detection

**Indicators**:
- Inconsistent pass/fail on same code
- Timing-dependent failures
- Order-dependent failures

**Diagnosis**:
```yaml
# Run multiple iterations
newman run collection.json --iteration-count 10
```

**Resolution**:
1. Add explicit waits/delays where needed
2. Remove test interdependencies
3. Ensure test data isolation

## Failure Report Format

```markdown
## Test Failure Report

**Build**: $(Build.BuildNumber)
**Environment**: $(ENVIRONMENT)
**Date**: $(date)

### Summary
- Total Tests: X
- Passed: Y
- Failed: Z

### Failed Tests

#### 1. [Test Name]
- **Request**: POST /api/users
- **Expected**: 201 Created
- **Actual**: 500 Internal Server Error
- **Category**: Server Error
- **Root Cause**: [Analysis]
- **Remediation**: [Steps]

### Patterns Observed
- [Any systemic issues]

### Recommendations
- [Action items]
```

## Integration with ADO

### Capture Detailed Logs

```yaml
- script: |
    newman run collection.json \
      --reporters cli,json \
      --reporter-json-export $(Build.ArtifactStagingDirectory)/results.json \
      2>&1 | tee $(Build.ArtifactStagingDirectory)/newman.log
  displayName: 'Run Tests with Logging'
  continueOnError: true
```

### Parse Failures for Analysis

```yaml
- script: |
    node scripts/analyze-failures.js \
      $(Build.ArtifactStagingDirectory)/results.json \
      > $(Build.ArtifactStagingDirectory)/failure-report.md
  displayName: 'Analyze Failures'
  condition: failed()
```

## Priority Matrix

| Failure Type | Impact | Priority | Response Time |
|--------------|--------|----------|---------------|
| Auth (production) | Blocking | P0 | Immediate |
| Server Error (500) | Blocking | P0 | < 1 hour |
| Connection | Blocking | P1 | < 4 hours |
| Client Error (4xx) | Non-blocking | P2 | Next sprint |
| Assertion (contract) | Informational | P2 | Next sprint |
| Flaky | Degrading | P3 | Backlog |

## Output Files

```
qa-agent-output/
├── failure-analysis/
│   ├── failure-report-YYYYMMDD.md
│   ├── classification-summary.json
│   └── remediation-plan.md
└── triage-history/
    └── [build-number]/
        ├── raw-results.json
        └── analysis.md
```
