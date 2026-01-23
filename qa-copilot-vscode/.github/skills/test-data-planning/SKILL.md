---
name: test-data-planning
description: Plan test data strategy including seeding, cleanup, and dynamic generation for API testing. Use when you need to plan test data dependencies, create seed data collections, generate fake data with Faker, design cleanup strategies, manage test fixtures, or support QA MVP Step 6. Covers API-based seeding, dynamic data generation, and test isolation patterns.
---

# Test Data Planning

Design test data strategy for reliable, repeatable API tests.

## Quick Start

1. Analyze data dependencies
2. Design seeding strategy
3. Configure dynamic data generation
4. Plan cleanup approach
5. Document data lifecycle

## Data Dependency Analysis

### Entity Relationships

Map dependencies between entities:
```
User
└── Orders (requires userId)
    └── OrderItems (requires orderId, productId)
Product
```

### Required Seed Data

| Entity | Dependencies | Seed Order |
|--------|--------------|------------|
| Product | None | 1 |
| User | None | 1 |
| Order | User, Product | 2 |
| OrderItem | Order, Product | 3 |

## Seeding Strategies

See `references/seeding-patterns.md` for detailed patterns.

### API-Based Seeding (Recommended)

Create test data via API before tests:
```javascript
// Pre-request script
pm.sendRequest({
    url: pm.environment.get('baseUrl') + '/api/users',
    method: 'POST',
    header: { 'Content-Type': 'application/json' },
    body: {
        mode: 'raw',
        raw: JSON.stringify({
            name: 'Test User',
            email: `test_${Date.now()}@test.com`
        })
    }
}, (err, res) => {
    pm.environment.set('testUserId', res.json().id);
});
```

### Fixture-Based

Pre-configured test data in environment:
```json
{
    "testUserId": "12345",
    "testProductId": "67890"
}
```

## Dynamic Data Generation

See `references/faker-patterns.md` for Postman dynamic variables.

### Built-in Variables

```
{{$randomFirstName}}
{{$randomEmail}}
{{$randomInt}}
{{$guid}}
{{$timestamp}}
```

### Custom Generation

```javascript
const uniqueEmail = `user_${Date.now()}_${Math.random().toString(36).substr(2, 9)}@test.com`;
pm.environment.set('testEmail', uniqueEmail);
```

## Cleanup Strategies

See `references/cleanup-strategies.md` for patterns.

### Delete After Test

```javascript
// Test script
pm.test("Cleanup: Delete test user", function () {
    const userId = pm.environment.get('testUserId');
    pm.sendRequest({
        url: pm.environment.get('baseUrl') + '/api/users/' + userId,
        method: 'DELETE'
    });
});
```

### Cleanup Collection

Dedicated requests for teardown:
```
📁 Cleanup
├── Delete Test Orders
├── Delete Test Users
└── Reset Test Data
```

## Test Isolation

Ensure tests don't interfere with each other:

1. **Unique identifiers**: Generate unique IDs per test run
2. **Isolated data**: Each test creates its own data
3. **No shared state**: Don't rely on data from other tests
4. **Cleanup on failure**: Handle failed test cleanup

## Output Format

```markdown
## Test Data Plan

### Dependencies
| Entity | Required By | Seed Priority |
|--------|-------------|---------------|
| User | Orders | 1 |
| Product | OrderItems | 1 |

### Seed Collection
- 📁 Setup
  - Create Test User
  - Create Test Product

### Cleanup Collection
- 📁 Teardown
  - Delete Test Data

### Environment Variables
| Variable | Purpose | Generation |
|----------|---------|------------|
| testUserId | User ID for tests | API create |
| testEmail | Unique email | Dynamic |
```
