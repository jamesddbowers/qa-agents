# Tagging Conventions

## Industry Standard Tags

### By Test Type

| Tag | Description | Newman Filter |
|-----|-------------|---------------|
| `smoke` | Quick validation of critical paths | `--folder smoke` |
| `regression` | Comprehensive test coverage | `--folder regression` |
| `integration` | Cross-service integration tests | `--folder integration` |
| `e2e` | End-to-end user flows | `--folder e2e` |
| `contract` | API contract validation | `--folder contract` |

### By Priority

| Tag | Description | Alert Level |
|-----|-------------|-------------|
| `critical` | Must pass for deployment | Page on failure |
| `high` | Important functionality | Alert on failure |
| `medium` | Standard coverage | Log on failure |
| `low` | Nice-to-have coverage | Silent |

### By Feature

| Tag | Description |
|-----|-------------|
| `auth` | Authentication tests |
| `crud` | Basic CRUD operations |
| `search` | Search/filter functionality |
| `validation` | Input validation |
| `error-handling` | Error scenarios |

### By Status

| Tag | Description | CI Behavior |
|-----|-------------|-------------|
| `wip` | Work in progress | Skip |
| `flaky` | Known flaky test | Retry or skip |
| `disabled` | Temporarily disabled | Skip |
| `manual` | Requires manual verification | Skip |

## Folder Structure Patterns

### By Tag (Flat)

```
Collection
├── 📁 smoke
│   ├── Auth - Login
│   ├── Users - List
│   └── Orders - Create
├── 📁 regression
│   ├── Users - Get by ID
│   ├── Users - Update
│   └── Users - Delete
└── 📁 wip
    └── New Feature
```

### By Resource with Tag Subfolders

```
Collection
├── 📁 Auth
│   └── 📁 smoke
│       └── Login
├── 📁 Users
│   ├── 📁 smoke
│   │   └── List Users
│   └── 📁 regression
│       ├── Get User
│       └── Delete User
└── 📁 Orders
    └── 📁 smoke
        └── Create Order
```

### By Tag with Resource Subfolders

```
Collection
├── 📁 smoke
│   ├── 📁 Auth
│   │   └── Login
│   ├── 📁 Users
│   │   └── List
│   └── 📁 Orders
│       └── Create
└── 📁 regression
    └── 📁 Users
        ├── Get
        └── Delete
```

## Tag Application Examples

### In Request Name

```
GET /api/users [smoke, critical]
POST /api/users [smoke]
PUT /api/users/{id} [regression]
DELETE /api/users/{id} [regression, destructive]
```

### In Request Description

```markdown
**Tags**: smoke, critical

This test validates user authentication.
```

### In Folder Name

```
Users [smoke]
├── GET List Users
├── POST Create User
└── GET User by ID
```

## CI/CD Integration

### Azure DevOps Pipeline

```yaml
# Smoke tests on PR
- script: newman run collection.json --folder smoke
  displayName: 'Smoke Tests'
  condition: eq(variables['Build.Reason'], 'PullRequest')

# Full regression nightly
- script: newman run collection.json --folder regression
  displayName: 'Regression Tests'
  condition: eq(variables['Build.CronSchedule.DisplayName'], 'Nightly')
```

### GitHub Actions

```yaml
- name: Run Smoke Tests
  if: github.event_name == 'pull_request'
  run: newman run collection.json --folder smoke

- name: Run Regression Tests
  if: github.event_name == 'schedule'
  run: newman run collection.json --folder regression
```

## Tag Review Checklist

- [ ] All requests are tagged
- [ ] Smoke tests cover critical paths
- [ ] Smoke tests complete in < 2 minutes
- [ ] No `wip` tests in smoke folder
- [ ] Critical tests have `critical` tag
- [ ] Tag rationale is documented
- [ ] Folder structure matches tag organization
