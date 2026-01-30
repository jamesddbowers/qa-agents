# Azure DevOps Test Plans — Import and Organization Patterns

## Feature-Based Organization

Test plans in ADO are organized by **feature**, not by user story. This means:

- Each feature gets its own **test suite**
- Test suites group test cases that cover a cohesive business capability
- A feature may span multiple user stories — the test suite covers the feature as a whole
- This prevents test case duplication when multiple stories touch the same feature

### ADO Hierarchy
```
Test Plan: {Service Name} Test Plan
├── Test Suite: User Management (feature)
│   ├── TC-USR-001: Verify list users returns paginated results
│   ├── TC-USR-002: Verify create user with valid data
│   └── TC-USR-003: Verify create user with duplicate email returns 409
├── Test Suite: Order Processing (feature)
│   ├── TC-ORD-001: Verify create order with valid data
│   └── TC-ORD-002: Verify order status transitions
├── Test Suite: Authentication (cross-cutting)
│   ├── TC-AUTH-001: Verify request with expired token returns 401
│   └── TC-AUTH-002: Verify insufficient role returns 403
└── Test Suite: Error Handling (cross-cutting)
    ├── TC-ERR-001: Verify invalid JSON body returns 400
    └── TC-ERR-002: Verify nonexistent resource returns 404
```

---

## CSV Import Format

ADO Test Plans supports CSV import with these columns:

### Required Columns
| Column | Description | Example |
|--------|-------------|---------|
| ID | Unique test case identifier | TC-USR-001 |
| Title | Descriptive test case name | Verify list users returns paginated results |

### Recommended Columns
| Column | Description | Example |
|--------|-------------|---------|
| Test Suite | Suite name for grouping | User Management |
| Priority | 1 (Critical) through 4 (Low) | 2 |
| Automation Status | Planned, Automated, Not Automated | Planned |
| Tags | Semicolon-separated tags | smoke;regression;api |
| Steps | Test steps (HTML or plain text) | Shell — to be detailed |
| Expected Result | Expected outcome | 200 OK with user list |

### ADO Priority Mapping
| Our Priority | ADO Priority Value |
|-------------|-------------------|
| Critical | 1 |
| High | 2 |
| Medium | 3 |
| Low | 4 |

### CSV Formatting Rules
- Use commas as delimiters
- Quote any field containing commas: `"smoke,regression,api"`
- Escape quotes within fields: `""quoted text""`
- First row must be column headers
- UTF-8 encoding

### Example CSV
```csv
ID,Title,Test Suite,Priority,Type,Automation Status,Tags,Endpoint,Preconditions,Steps,Expected Result
TC-USR-001,"Verify list users returns paginated results",User Management,2,Functional,Planned,"smoke,regression,api",GET /api/users,At least 1 user exists,Shell — to be detailed in Dev phase,200 OK with paginated user list
TC-USR-002,"Verify create user with valid data",User Management,2,Functional,Planned,"regression,api",POST /api/users,Unique email address available,Shell — to be detailed in Dev phase,201 Created with user object
TC-USR-003,"Verify create user with duplicate email returns 409",User Management,3,Negative,Planned,"regression,api,negative",POST /api/users,User with target email already exists,Shell — to be detailed in Dev phase,409 Conflict
```

---

## Test Case ID Convention

### Format: `TC-{PREFIX}-{NNN}`

| Suite Type | Prefix | Example |
|-----------|--------|---------|
| User Management | USR | TC-USR-001 |
| Order Processing | ORD | TC-ORD-001 |
| Product Catalog | PRD | TC-PRD-001 |
| Authentication | AUTH | TC-AUTH-001 |
| Error Handling | ERR | TC-ERR-001 |
| Dependency Failures | DEP | TC-DEP-001 |
| Performance | PERF | TC-PERF-001 |

**Prefix rules**:
- Feature suites: 3-4 letter abbreviation of the resource name
- Cross-cutting suites: Fixed prefixes (AUTH, ERR, DEP, PERF)
- Numbers are zero-padded to 3 digits, starting at 001
- IDs are unique across the entire test plan

---

## Tag Conventions

### Standard Tags
| Tag | Meaning | Applied To |
|-----|---------|-----------|
| `smoke` | Runs on every deployment | Core happy-path tests, health checks |
| `regression` | Full regression suite | All test cases |
| `api` | API endpoint tests | All REST API test cases |
| `ui` | UI tests | Playwright/browser tests (added in Dev phase) |
| `security` | Security-related | Auth tests, role enforcement, injection tests |
| `negative` | Negative/error path | Invalid input, missing data, unauthorized access |
| `performance` | Performance tests | Response time, load, stress tests |
| `data-driven` | Parameterized tests | Tests using multiple data sets |
| `manual` | Cannot be automated | Visual checks, usability, exploratory |

### Tag Usage Rules
- Every test case gets `regression` (everything runs in regression)
- `smoke` is selective — only core happy paths and health checks
- `api` and `ui` are mutually exclusive
- `negative` combines with `api` or `ui`
- `security` combines with other tags
- A test case typically has 2-4 tags

---

## Standard Test Case Types per HTTP Method

### GET (List/Search)
| Test Case Pattern | Type | Priority | Tags |
|------------------|------|----------|------|
| Happy path — returns expected list | Functional | High | smoke, regression, api |
| With pagination parameters | Functional | Medium | regression, api |
| With filter/search parameters | Functional | Medium | regression, api |
| Empty result set | Functional | Medium | regression, api |
| Unauthorized request | Security | High | regression, api, security |

### GET (By ID)
| Test Case Pattern | Type | Priority | Tags |
|------------------|------|----------|------|
| Happy path — returns resource | Functional | High | smoke, regression, api |
| Not found (404) | Negative | Medium | regression, api, negative |
| Invalid ID format | Negative | Low | regression, api, negative |
| Unauthorized request | Security | High | regression, api, security |

### POST (Create)
| Test Case Pattern | Type | Priority | Tags |
|------------------|------|----------|------|
| Happy path — creates resource | Functional | High | smoke, regression, api |
| Missing required fields (400) | Negative | Medium | regression, api, negative |
| Invalid field format (400) | Negative | Medium | regression, api, negative |
| Duplicate unique field (409) | Negative | Medium | regression, api, negative |
| Unauthorized request | Security | High | regression, api, security |

### PUT/PATCH (Update)
| Test Case Pattern | Type | Priority | Tags |
|------------------|------|----------|------|
| Happy path — updates resource | Functional | High | regression, api |
| Not found (404) | Negative | Medium | regression, api, negative |
| Invalid data (400) | Negative | Medium | regression, api, negative |
| Unauthorized / wrong role | Security | High | regression, api, security |

### DELETE
| Test Case Pattern | Type | Priority | Tags |
|------------------|------|----------|------|
| Happy path — deletes resource | Functional | Critical | regression, api |
| Not found (404) | Negative | Medium | regression, api, negative |
| Unauthorized / wrong role (403) | Security | Critical | regression, api, security |
| Cascading effects verified | Functional | High | regression, api |
