# Remediation Patterns

## Authentication Failures

### Pattern: Token Expired (401)

**Symptoms**:
```json
{
  "error": "invalid_token",
  "error_description": "The access token expired"
}
```

**Remediation**:

1. **Immediate Fix** - Refresh token before test run:
```javascript
// Collection pre-request script
const tokenExpiry = pm.environment.get('TOKEN_EXPIRY');
if (!tokenExpiry || Date.now() > parseInt(tokenExpiry) - 60000) {
    // Token expired or expiring soon - refresh
    pm.sendRequest({
        url: pm.environment.get('authUrl') + '/oauth/token',
        method: 'POST',
        header: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: {
            mode: 'urlencoded',
            urlencoded: [
                { key: 'grant_type', value: 'client_credentials' },
                { key: 'client_id', value: pm.environment.get('clientId') },
                { key: 'client_secret', value: pm.environment.get('clientSecret') }
            ]
        }
    }, (err, res) => {
        if (!err && res.code === 200) {
            const json = res.json();
            pm.environment.set('ACCESS_TOKEN', json.access_token);
            pm.environment.set('TOKEN_EXPIRY', Date.now() + (json.expires_in * 1000));
        }
    });
}
```

2. **Pipeline Fix** - Add auth step before tests:
```yaml
- script: |
    # Get fresh token before running tests
    TOKEN=$(curl -s -X POST $(AUTH_URL)/oauth/token \
      -d "grant_type=client_credentials" \
      -d "client_id=$(CLIENT_ID)" \
      -d "client_secret=$(CLIENT_SECRET)" | jq -r '.access_token')
    echo "##vso[task.setvariable variable=ACCESS_TOKEN;issecret=true]$TOKEN"
  displayName: 'Refresh Auth Token'
```

### Pattern: Wrong Credentials (401)

**Symptoms**:
```json
{
  "error": "invalid_client",
  "error_description": "Client authentication failed"
}
```

**Remediation**:

1. Verify variable group values in ADO Library
2. Check for typos in CLIENT_ID/CLIENT_SECRET
3. Confirm credentials match target environment
4. Verify OAuth scopes are correct

### Pattern: Insufficient Permissions (403)

**Symptoms**:
```json
{
  "error": "access_denied",
  "error_description": "Insufficient scope"
}
```

**Remediation**:

1. Review required scopes for endpoint
2. Update OAuth request with correct scopes:
```javascript
body: {
    mode: 'urlencoded',
    urlencoded: [
        { key: 'grant_type', value: 'client_credentials' },
        { key: 'scope', value: 'read:users write:users' }  // Add required scopes
    ]
}
```

## Connection Failures

### Pattern: Service Unavailable (ECONNREFUSED)

**Symptoms**:
```
Error: connect ECONNREFUSED 127.0.0.1:8080
```

**Remediation**:

1. **Check service health**:
```yaml
- script: |
    curl -f $(BASE_URL)/health || echo "Service not healthy"
  displayName: 'Health Check'
  continueOnError: true
```

2. **Add wait-for-service logic**:
```yaml
- script: |
    for i in {1..30}; do
      curl -s $(BASE_URL)/health && exit 0
      echo "Waiting for service... ($i/30)"
      sleep 10
    done
    exit 1
  displayName: 'Wait for Service'
```

3. **Verify BASE_URL**:
   - Check environment variable group
   - Confirm URL matches deployment environment
   - Check for trailing slashes

### Pattern: Timeout (ETIMEDOUT)

**Symptoms**:
```
Error: connect ETIMEDOUT
```

**Remediation**:

1. **Increase Newman timeout**:
```bash
newman run collection.json \
  --timeout-request 60000 \
  --timeout-script 30000
```

2. **Check network connectivity**:
```yaml
- script: |
    # Test DNS resolution
    nslookup $(echo $(BASE_URL) | sed 's|https://||' | cut -d'/' -f1)
    # Test TCP connectivity
    nc -zv $(echo $(BASE_URL) | sed 's|https://||' | cut -d'/' -f1) 443
  displayName: 'Network Diagnostics'
```

3. **VPN/Firewall issues**:
   - Verify agent has network access
   - Check if endpoints require VPN
   - Review firewall rules

## Server Errors

### Pattern: Internal Server Error (500)

**Symptoms**:
```json
{
  "status": 500,
  "message": "Internal Server Error"
}
```

**Remediation**:

1. **Collect diagnostic info**:
```javascript
// Test script
if (pm.response.code === 500) {
    console.log('Server Error Details:');
    console.log('Request URL:', pm.request.url.toString());
    console.log('Request Body:', JSON.stringify(pm.request.body, null, 2));
    console.log('Response:', pm.response.text());
}
```

2. **Check for correlation ID**:
```javascript
const correlationId = pm.response.headers.get('X-Correlation-ID');
if (correlationId) {
    console.log('Correlation ID for log search:', correlationId);
}
```

3. **Escalation**:
   - Capture full request/response
   - Note timestamp for log correlation
   - File bug with reproduction steps

### Pattern: Bad Gateway (502)

**Symptoms**:
```
502 Bad Gateway
nginx/1.x.x
```

**Remediation**:

1. Check upstream service health
2. Review load balancer configuration
3. Add retry logic:
```yaml
- script: |
    newman run collection.json || \
    (sleep 30 && newman run collection.json)
  displayName: 'Run with Retry'
```

### Pattern: Service Unavailable (503)

**Symptoms**:
```json
{
  "status": 503,
  "message": "Service temporarily unavailable"
}
```

**Remediation**:

1. **Check deployment status** - Is a deployment in progress?
2. **Check scaling events** - Is the service scaling up?
3. **Add backoff and retry**:
```javascript
// Pre-request script with exponential backoff
const retryCount = pm.environment.get('retryCount') || 0;
if (retryCount > 0) {
    const delay = Math.min(1000 * Math.pow(2, retryCount), 30000);
    setTimeout(() => {}, delay);
}
```

## Client Errors

### Pattern: Bad Request (400)

**Symptoms**:
```json
{
  "errors": [
    { "field": "email", "message": "Invalid email format" }
  ]
}
```

**Remediation**:

1. **Validate request body**:
```javascript
// Pre-request script
const body = JSON.parse(pm.request.body.raw);
if (!body.email || !body.email.includes('@')) {
    throw new Error('Invalid email in request body');
}
```

2. **Check required fields**:
```javascript
const requiredFields = ['name', 'email', 'role'];
const body = JSON.parse(pm.request.body.raw);
for (const field of requiredFields) {
    if (!body[field]) {
        throw new Error(`Missing required field: ${field}`);
    }
}
```

### Pattern: Not Found (404)

**Symptoms**:
```json
{
  "error": "Resource not found"
}
```

**Remediation**:

1. **Dynamic resource handling**:
```javascript
// Pre-request: Create resource if not exists
pm.sendRequest({
    url: pm.environment.get('baseUrl') + '/api/users',
    method: 'POST',
    body: { mode: 'raw', raw: JSON.stringify({ name: 'Test User' }) }
}, (err, res) => {
    if (res.code === 201) {
        pm.environment.set('userId', res.json().id);
    }
});
```

2. **Verify test data seeded**:
```yaml
- script: |
    node scripts/seed-test-data.js
  displayName: 'Seed Test Data'
```

### Pattern: Unprocessable Entity (422)

**Symptoms**:
```json
{
  "errors": {
    "age": ["must be greater than 0"],
    "status": ["is not included in the list"]
  }
}
```

**Remediation**:

1. Review validation rules in API docs
2. Update test data to match constraints
3. Add validation in pre-request:
```javascript
const validStatuses = ['active', 'inactive', 'pending'];
const status = pm.environment.get('userStatus');
if (!validStatuses.includes(status)) {
    pm.environment.set('userStatus', 'active');
}
```

## Flaky Test Fixes

### Pattern: Race Condition

**Symptoms**: Test passes/fails randomly

**Remediation**:
```javascript
// Add explicit wait for async operations
pm.test("Wait for resource", function() {
    const pollInterval = 1000;
    const maxAttempts = 10;
    let attempts = 0;

    function checkResource() {
        return new Promise((resolve) => {
            pm.sendRequest(pm.environment.get('resourceUrl'), (err, res) => {
                if (res.code === 200 && res.json().status === 'ready') {
                    resolve(true);
                } else if (attempts < maxAttempts) {
                    attempts++;
                    setTimeout(() => checkResource().then(resolve), pollInterval);
                } else {
                    resolve(false);
                }
            });
        });
    }

    return checkResource().then(ready => {
        pm.expect(ready).to.be.true;
    });
});
```

### Pattern: Order Dependency

**Symptoms**: Test fails when run in isolation

**Remediation**:

1. Make tests self-contained:
```javascript
// Setup in pre-request
pm.sendRequest({...}, (err, res) => {
    // Create required resources
});

// Teardown in test
pm.test("Cleanup", function() {
    pm.sendRequest({
        url: pm.environment.get('resourceUrl'),
        method: 'DELETE'
    });
});
```

2. Use collection-level setup/teardown folders

### Pattern: Data Dependency

**Symptoms**: Test fails because data was modified

**Remediation**:
```javascript
// Generate unique test data each run
const uniqueId = Date.now();
pm.environment.set('testEmail', `test_${uniqueId}@example.com`);
pm.environment.set('testUsername', `user_${uniqueId}`);
```

## Pipeline-Level Fixes

### Add Diagnostic Output

```yaml
- script: |
    newman run collection.json \
      --reporters cli,json \
      --reporter-json-export results.json \
      --verbose
  displayName: 'Run Tests'
  continueOnError: true

- script: |
    echo "=== Failed Tests ==="
    cat results.json | jq '.run.failures[]'
  displayName: 'Show Failures'
  condition: failed()
```

### Retry Failed Tests Only

```yaml
- script: |
    # Extract failed test names and retry
    FAILED=$(cat results.json | jq -r '.run.failures[].source.name' | uniq)
    for test in $FAILED; do
      newman run collection.json --folder "$test"
    done
  displayName: 'Retry Failures'
  condition: failed()
```

### Notification on Failure

```yaml
- script: |
    PASSED=$(cat results.json | jq '.run.stats.assertions.passed')
    FAILED=$(cat results.json | jq '.run.stats.assertions.failed')
    curl -X POST $(SLACK_WEBHOOK) \
      -H 'Content-Type: application/json' \
      -d "{\"text\": \"Build $(Build.BuildNumber): $PASSED passed, $FAILED failed\"}"
  displayName: 'Notify'
  condition: always()
```
