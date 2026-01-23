# Request Chaining Patterns

## Variable Extraction

### Extract to Environment

```javascript
// Extract ID from response for next request
pm.test("Extract user ID", function () {
    const json = pm.response.json();
    pm.environment.set("userId", json.id);
});

// Extract nested value
pm.test("Extract token", function () {
    const json = pm.response.json();
    pm.environment.set("ACCESS_TOKEN", json.data.token);
});
```

### Extract to Collection Variable

```javascript
// For values shared across collection
pm.test("Set collection variable", function () {
    const json = pm.response.json();
    pm.collectionVariables.set("resourceId", json.id);
});
```

## Authentication Flow

### Token Acquisition

```javascript
// Pre-request script at collection level
const tokenExpiry = pm.environment.get('TOKEN_EXPIRY');
const accessToken = pm.environment.get('ACCESS_TOKEN');

if (!accessToken || Date.now() > parseInt(tokenExpiry)) {
    const authUrl = pm.environment.get('authUrl') + '/oauth/token';

    pm.sendRequest({
        url: authUrl,
        method: 'POST',
        header: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
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
            pm.environment.set('TOKEN_EXPIRY', Date.now() + (json.expires_in * 1000) - 60000);
        }
    });
}
```

### Token Usage

```javascript
// Pre-request script to add token header
const token = pm.environment.get('ACCESS_TOKEN');
if (token) {
    pm.request.headers.add({
        key: 'Authorization',
        value: 'Bearer ' + token
    });
}
```

## Data Dependencies

### Create-Then-Use Pattern

**Request 1: Create User (Pre-request)**
```javascript
// No pre-request needed
```

**Request 1: Create User (Test)**
```javascript
pm.test("Save created user ID", function () {
    pm.response.to.have.status(201);
    const json = pm.response.json();
    pm.environment.set("createdUserId", json.id);
});
```

**Request 2: Get User (URL)**
```
{{baseUrl}}/api/users/{{createdUserId}}
```

### Cleanup Pattern

**Test Script for Cleanup**
```javascript
// Store IDs for cleanup
let cleanupIds = JSON.parse(pm.environment.get("cleanupIds") || "[]");
cleanupIds.push(pm.response.json().id);
pm.environment.set("cleanupIds", JSON.stringify(cleanupIds));
```

**Pre-request for Cleanup Request**
```javascript
let cleanupIds = JSON.parse(pm.environment.get("cleanupIds") || "[]");
if (cleanupIds.length > 0) {
    pm.environment.set("deleteId", cleanupIds.pop());
    pm.environment.set("cleanupIds", JSON.stringify(cleanupIds));
}
```

## Dynamic Data Generation

### Using Built-in Variables

```javascript
// Pre-request script
pm.environment.set("randomEmail", `user_${pm.variables.replaceIn('{{$randomInt}}')}@test.com`);
pm.environment.set("timestamp", new Date().toISOString());
pm.environment.set("guid", pm.variables.replaceIn('{{$guid}}'));
```

### Using Faker (if available)

```javascript
// Postman Dynamic Variables
// {{$randomFirstName}}
// {{$randomLastName}}
// {{$randomEmail}}
// {{$randomInt}}
// {{$randomUUID}}
// {{$timestamp}}
```

### Custom Random Data

```javascript
// Pre-request script
function randomString(length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    let result = '';
    for (let i = 0; i < length; i++) {
        result += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return result;
}

pm.environment.set("randomUsername", "user_" + randomString(8));
```

## Conditional Execution

### Skip Request Based on Condition

```javascript
// Pre-request script
const shouldSkip = pm.environment.get("skipOptionalTests") === "true";
if (shouldSkip) {
    pm.execution.skipRequest();
}
```

### Branch Based on Response

```javascript
// Test script
if (pm.response.code === 404) {
    pm.environment.set("userExists", "false");
    // Next request will create user
} else {
    pm.environment.set("userExists", "true");
    // Next request will update user
}
```

## Sequential Workflow Pattern

```
1. Auth (get token)
   └─ Set ACCESS_TOKEN

2. Create User
   └─ Set createdUserId

3. Get User
   └─ Use createdUserId, verify data

4. Update User
   └─ Use createdUserId

5. Delete User
   └─ Use createdUserId, cleanup
```

## Error Handling

```javascript
// Pre-request with error handling
pm.sendRequest({
    url: pm.environment.get('authUrl'),
    method: 'POST',
    // ...
}, (err, res) => {
    if (err) {
        console.error('Auth request failed:', err);
        return;
    }

    if (res.code !== 200) {
        console.error('Auth failed with status:', res.code);
        console.error('Response:', res.json());
        return;
    }

    // Success handling
    pm.environment.set('ACCESS_TOKEN', res.json().access_token);
});
```
