---
name: postman-generation
description: Generate Postman collections for API testing with test scripts and environment configuration. Use when you need to create Postman collections, write test assertions, configure pre-request scripts, set up request chaining, generate Newman-ready collections, or support QA MVP Step 5. Produces Postman Collection v2.1 format with pm.test scripts.
---

# Postman Generation

Generate Postman collections with test scripts for smoke and regression testing.

## Quick Start

1. Structure collection with folders
2. Generate requests with proper configuration
3. Add test scripts with assertions
4. Configure pre-request scripts for auth
5. Set up environment template

## Collection Structure

```
Collection Name
├── 📁 Auth
│   └── Get Token (pre-request for all)
├── 📁 Users [smoke]
│   ├── GET List Users
│   ├── POST Create User
│   └── GET User by ID
├── 📁 Orders [smoke]
│   ├── GET List Orders
│   └── POST Create Order
└── 📁 regression
    └── Additional tests
```

## Request Configuration

### Required Elements

| Element | Purpose |
|---------|---------|
| Name | Descriptive with tags: `GET List Users [smoke]` |
| Method | GET, POST, PUT, DELETE, PATCH |
| URL | `{{baseUrl}}/api/resource` |
| Headers | Content-Type, Authorization |
| Body | JSON for POST/PUT/PATCH |
| Tests | Assertions for response |

### URL Variables

Always use environment variables:
```
{{baseUrl}}/api/users/{{userId}}
```

Never hardcode:
```
https://api.example.com/api/users/123  ❌
```

## Test Scripts

See `references/assertion-patterns.md` for complete patterns.

### Essential Assertions

```javascript
// Status code
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});

// Response time
pm.test("Response time is acceptable", function () {
    pm.expect(pm.response.responseTime).to.be.below(500);
});

// JSON structure
pm.test("Response has required fields", function () {
    const json = pm.response.json();
    pm.expect(json).to.have.property('id');
    pm.expect(json).to.have.property('name');
});
```

## Pre-Request Scripts

See `references/chaining-patterns.md` for auth and chaining.

### Collection-Level Auth

```javascript
// Set at collection level to run before every request
const token = pm.environment.get('ACCESS_TOKEN');
if (token) {
    pm.request.headers.add({
        key: 'Authorization',
        value: 'Bearer ' + token
    });
}
```

## Environment Template

| Variable | Description | Example |
|----------|-------------|---------|
| `baseUrl` | API base URL | `https://api.example.com` |
| `authUrl` | Auth server URL | `https://auth.example.com` |
| `clientId` | OAuth client ID | (secret) |
| `clientSecret` | OAuth client secret | (secret) |
| `ACCESS_TOKEN` | Current token | (set by script) |

## Collection Format

See `references/collection-schema.md` for v2.1 schema.

### Minimal Structure

```json
{
    "info": {
        "name": "API Tests",
        "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
    },
    "item": [
        {
            "name": "Request Name",
            "request": {
                "method": "GET",
                "url": "{{baseUrl}}/api/resource"
            },
            "event": [
                {
                    "listen": "test",
                    "script": {
                        "exec": ["pm.test('Status 200', () => pm.response.to.have.status(200));"]
                    }
                }
            ]
        }
    ]
}
```

## Generation Workflow

1. **Input**: Endpoint inventory from discovery
2. **Group**: Organize by resource/domain
3. **Generate**: Create request for each endpoint
4. **Script**: Add appropriate test assertions
5. **Auth**: Configure authentication handling
6. **Environment**: Create variable template
7. **Output**: Save as `.postman_collection.json`

## Output Files

```
postman/
├── [project]-smoke.postman_collection.json
├── [project]-regression.postman_collection.json
└── [project].postman_environment.json
```

## Newman Compatibility

Ensure collections work with Newman:
- No GUI-only features
- All variables in environment file
- Relative paths where possible
- Console output for debugging
