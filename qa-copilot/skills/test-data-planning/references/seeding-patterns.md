# Test Data Seeding Patterns

## API-Based Seeding

### Collection-Level Pre-Request

```javascript
// Run once at collection start
if (!pm.environment.get('testDataSeeded')) {
    // Create test user
    pm.sendRequest({
        url: pm.environment.get('baseUrl') + '/api/users',
        method: 'POST',
        header: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ' + pm.environment.get('ACCESS_TOKEN')
        },
        body: {
            mode: 'raw',
            raw: JSON.stringify({
                name: 'Test User ' + Date.now(),
                email: `test_${Date.now()}@test.com`
            })
        }
    }, (err, res) => {
        if (!err && res.code === 201) {
            pm.environment.set('testUserId', res.json().id);
        }
    });

    pm.environment.set('testDataSeeded', 'true');
}
```

### Setup Folder Pattern

```
📁 Setup [run first]
├── 01 - Create Test User
├── 02 - Create Test Product
└── 03 - Create Test Order

📁 Tests
├── Get User [smoke]
└── Update Order [regression]

📁 Teardown [run last]
└── Delete Test Data
```

### Seed Request Example

```json
{
    "name": "01 - Create Test User",
    "request": {
        "method": "POST",
        "url": "{{baseUrl}}/api/users",
        "body": {
            "mode": "raw",
            "raw": "{\n    \"name\": \"Test User {{$timestamp}}\",\n    \"email\": \"test_{{$timestamp}}@test.com\"\n}"
        }
    },
    "event": [
        {
            "listen": "test",
            "script": {
                "exec": [
                    "pm.test('User created', function() {",
                    "    pm.response.to.have.status(201);",
                    "    pm.environment.set('testUserId', pm.response.json().id);",
                    "});"
                ]
            }
        }
    ]
}
```

## Fixture-Based Seeding

### Static Fixtures

Environment file with pre-configured IDs:
```json
{
    "values": [
        { "key": "testUserId", "value": "user-12345" },
        { "key": "testProductId", "value": "prod-67890" },
        { "key": "testOrderId", "value": "order-11111" }
    ]
}
```

### When to Use Fixtures

- Test environment has stable seed data
- Database is reset to known state before tests
- IDs are deterministic (e.g., UUIDs from fixtures)

### Hybrid Approach

```javascript
// Use fixture if available, otherwise create
const existingUserId = pm.environment.get('fixtureUserId');

if (existingUserId) {
    pm.environment.set('testUserId', existingUserId);
} else {
    // Create via API
    pm.sendRequest({ /* ... */ });
}
```

## Database Seeding (Reference Only)

For environments with direct DB access:

### SQL Seed Script

```sql
-- seed-test-data.sql
INSERT INTO users (id, name, email) VALUES
    ('test-user-1', 'Test User 1', 'test1@test.com'),
    ('test-user-2', 'Test User 2', 'test2@test.com');

INSERT INTO products (id, name, price) VALUES
    ('test-prod-1', 'Test Product 1', 9.99),
    ('test-prod-2', 'Test Product 2', 19.99);
```

### Pipeline Integration

```yaml
- script: |
    sqlcmd -S $(DB_SERVER) -d $(DB_NAME) -i seed-test-data.sql
  displayName: 'Seed Test Data'
```

## Seed Data Validation

### Verify Seed Succeeded

```javascript
pm.test("Verify test user exists", function () {
    const userId = pm.environment.get('testUserId');
    pm.expect(userId).to.not.be.undefined;
    pm.expect(userId).to.not.be.empty;
});
```

### Skip Tests if Seed Failed

```javascript
// Pre-request for dependent tests
const testUserId = pm.environment.get('testUserId');
if (!testUserId) {
    console.error('Test user not seeded, skipping test');
    pm.execution.skipRequest();
}
```

## Seed Data Isolation

### Unique Prefixes

```javascript
const testRunId = pm.environment.get('testRunId') || Date.now().toString();
pm.environment.set('testRunId', testRunId);

const uniqueName = `TestUser_${testRunId}`;
```

### Namespace Pattern

```javascript
const namespace = `test_${new Date().toISOString().slice(0,10)}_${Math.random().toString(36).substr(2, 5)}`;
pm.environment.set('testNamespace', namespace);

// Use in requests
// email: {{testNamespace}}_user@test.com
```
