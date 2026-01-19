# Test Data Cleanup Strategies

## Cleanup Approaches

### 1. Delete After Each Test

Clean up immediately after test completes.

```javascript
// Test script
pm.test("Cleanup created resource", function () {
    const resourceId = pm.environment.get('createdResourceId');

    pm.sendRequest({
        url: pm.environment.get('baseUrl') + '/api/resources/' + resourceId,
        method: 'DELETE',
        header: {
            'Authorization': 'Bearer ' + pm.environment.get('ACCESS_TOKEN')
        }
    }, (err, res) => {
        if (!err) {
            console.log('Cleanup completed');
        }
    });
});
```

**Pros**: Immediate cleanup, no leftover data
**Cons**: Slower tests, can't debug data after failure

### 2. Cleanup Folder at End

Dedicated cleanup requests run after all tests.

```
📁 Tests
├── Create User
├── Update User
└── Get User

📁 Cleanup [run last]
├── Delete Test Users
└── Delete Test Orders
```

**Cleanup Request Example**:
```json
{
    "name": "Delete Test Users",
    "request": {
        "method": "DELETE",
        "url": "{{baseUrl}}/api/users/{{testUserId}}"
    }
}
```

### 3. Batch Cleanup

Collect IDs during tests, delete all at end.

```javascript
// Test script - collect IDs
let cleanupIds = JSON.parse(pm.environment.get('cleanupUserIds') || '[]');
cleanupIds.push(pm.response.json().id);
pm.environment.set('cleanupUserIds', JSON.stringify(cleanupIds));
```

```javascript
// Cleanup request - pre-request script
let cleanupIds = JSON.parse(pm.environment.get('cleanupUserIds') || '[]');
pm.environment.set('currentDeleteId', cleanupIds.pop());
pm.environment.set('cleanupUserIds', JSON.stringify(cleanupIds));

// Skip if no more IDs
if (!pm.environment.get('currentDeleteId')) {
    pm.execution.skipRequest();
}
```

### 4. TTL-Based Cleanup

Create data with expiration, let system clean up.

```json
{
    "name": "Test User",
    "email": "test@test.com",
    "expiresAt": "2024-01-16T00:00:00Z"
}
```

**Pros**: No explicit cleanup needed
**Cons**: Requires API support for TTL

### 5. Namespace Cleanup

Tag test data with namespace, bulk delete.

```javascript
// Create with namespace
const namespace = pm.environment.get('testNamespace');
// { "name": "User", "tags": ["test", "namespace-abc123"] }
```

```javascript
// Cleanup by namespace
pm.sendRequest({
    url: pm.environment.get('baseUrl') + '/api/cleanup',
    method: 'POST',
    body: {
        mode: 'raw',
        raw: JSON.stringify({
            namespace: pm.environment.get('testNamespace')
        })
    }
});
```

## Cleanup on Failure

### Always Run Cleanup

```javascript
// Collection-level test script
pm.test("Ensure cleanup runs", function () {
    // This runs even if other tests fail
    const testUserId = pm.environment.get('testUserId');
    if (testUserId) {
        pm.sendRequest({
            url: pm.environment.get('baseUrl') + '/api/users/' + testUserId,
            method: 'DELETE'
        });
    }
});
```

### Newman Cleanup Hook

```bash
# Run cleanup even if tests fail
newman run collection.json --folder Tests || true
newman run collection.json --folder Cleanup
```

### Pipeline Cleanup Step

```yaml
- script: newman run collection.json --folder Cleanup
  displayName: 'Cleanup Test Data'
  condition: always()  # Run even if tests fail
```

## Cleanup Verification

### Verify Deletion

```javascript
pm.test("Verify resource deleted", function () {
    const resourceId = pm.environment.get('deletedResourceId');

    pm.sendRequest({
        url: pm.environment.get('baseUrl') + '/api/resources/' + resourceId,
        method: 'GET'
    }, (err, res) => {
        pm.expect(res.code).to.eql(404);
    });
});
```

### Clear Environment

```javascript
// Final cleanup script
pm.environment.unset('testUserId');
pm.environment.unset('testOrderId');
pm.environment.unset('cleanupUserIds');
pm.environment.set('testDataSeeded', 'false');
```

## Best Practices

1. **Always plan for cleanup**: Every create needs a delete
2. **Handle failures**: Cleanup should run even when tests fail
3. **Use unique data**: Avoid conflicts with parallel runs
4. **Log cleanup actions**: Helps debugging
5. **Verify cleanup**: Confirm data is actually deleted
6. **Clear environment**: Reset state after test run
