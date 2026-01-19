---
name: test-tagging
description: Define and apply test categorization conventions for smoke and regression testing. Use when you need to tag API tests, define smoke test criteria, categorize regression tests, organize test suites by priority, create test tiers for CI/CD, or support QA MVP Step 4. Provides tagging standards for Postman collections and Newman execution.
---

# Test Tagging

Define test categorization conventions for organizing smoke and regression test suites.

## Quick Start

1. Define tag taxonomy
2. Establish categorization criteria
3. Apply tags to requests
4. Configure Newman filtering

## Standard Tag Taxonomy

| Tag | Purpose | Run Frequency | Max Duration |
|-----|---------|---------------|--------------|
| `smoke` | Critical path validation | Every deployment | < 2 min |
| `regression` | Comprehensive coverage | Nightly/Weekly | < 30 min |
| `critical` | Business-critical, alert on failure | Every deployment | N/A |
| `performance` | Include response time assertions | With regression | N/A |
| `wip` | Work in progress, skip in CI | Never in CI | N/A |

## Categorization Criteria

### Smoke Test Criteria

Include in smoke tests if ANY of:
- Top 20% by traffic volume
- Authentication/authorization endpoints
- Critical business transactions (checkout, payment)
- Health check endpoints
- Core CRUD operations for primary entities

### Regression Test Criteria

Include in regression tests if ANY of:
- All smoke tests (superset)
- Complete CRUD coverage for all entities
- Edge cases and error scenarios
- Validation and input handling
- Less frequent but important workflows

### Tag Decision Tree

```
Is this endpoint critical to business?
├─ YES → smoke, critical
└─ NO
   Is this a high-traffic endpoint (top 20%)?
   ├─ YES → smoke
   └─ NO
      Is this endpoint tested elsewhere?
      ├─ YES (covered by smoke) → regression
      └─ NO → regression
         Is this work in progress?
         ├─ YES → wip
         └─ NO → regression
```

## Postman Tagging

### Folder-Based Organization

```
Collection
├── 📁 Auth [smoke, critical]
│   ├── Login
│   └── Token Refresh
├── 📁 Users
│   ├── 📁 smoke
│   │   ├── GET List Users
│   │   └── POST Create User
│   └── 📁 regression
│       ├── GET User by ID
│       ├── PUT Update User
│       └── DELETE User
└── 📁 Orders [smoke, critical]
    ├── GET List Orders
    └── POST Create Order
```

### Request-Level Tags

In request description or name:
```
GET List Users [smoke]
POST Create Order [smoke, critical]
DELETE User [regression]
```

## Newman Filtering

### By Folder Name

```bash
# Run smoke tests only
newman run collection.json --folder "smoke"

# Run specific resource folder
newman run collection.json --folder "Users"
```

### By Collection Tag (Custom Implementation)

Pre-request script to skip non-matching tags:
```javascript
const requiredTag = pm.environment.get('TEST_TAG') || 'smoke';
const requestTags = pm.info.requestName.match(/\[(.*?)\]/);

if (requestTags && !requestTags[1].includes(requiredTag)) {
    pm.execution.skipRequest();
}
```

## Tagging Best Practices

1. **Consistent naming**: Use lowercase tags
2. **Folder structure**: Mirror tag hierarchy
3. **Document criteria**: Explain why tests are tagged
4. **Review regularly**: Update tags as traffic patterns change
5. **Minimal smoke**: Keep smoke tests fast (< 2 min total)

## Output Format

When categorizing tests, generate:

```markdown
## Test Tagging Summary

### Smoke Tests ([count])
- [ ] GET /api/users [smoke]
- [ ] POST /api/orders [smoke, critical]

### Regression Tests ([count])
- [ ] PUT /api/users/{id} [regression]
- [ ] DELETE /api/users/{id} [regression]

### Tagging Rationale
| Endpoint | Tag | Reason |
|----------|-----|--------|
| GET /api/users | smoke | High traffic (1.2M/week) |
| POST /api/orders | smoke, critical | Revenue-critical |
```

See `references/tagging-conventions.md` for detailed conventions.
