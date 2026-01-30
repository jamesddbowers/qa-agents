# Test File Discovery Patterns

## Test File Glob Patterns by Framework

### Java (JUnit, TestNG)
```
**/src/test/**/*Test.java
**/src/test/**/*Tests.java
**/src/test/**/*IT.java
**/src/test/**/*IntegrationTest.java
**/src/test/**/*Spec.java
```

### ASP.NET Core (xUnit, NUnit, MSTest)
```
**/*.Tests/**/*.cs
**/*.UnitTests/**/*.cs
**/*.IntegrationTests/**/*.cs
**/*Tests.cs
**/*Test.cs
**/tests/**/*.cs
```

### Node.js (Jest, Mocha, Vitest)
```
**/*.test.js
**/*.test.ts
**/*.spec.js
**/*.spec.ts
**/__tests__/**/*.{js,ts}
**/test/**/*.{js,ts}
```

### Python (pytest, unittest)
```
**/test_*.py
**/*_test.py
**/tests/**/*.py
**/test/**/*.py
```

---

## Grep Patterns for Test Content Analysis

### Endpoint Path Coverage
Search test files for endpoint path strings:
```regex
/api/users
/api/orders
```
Use the exact paths from endpoint-inventory.json.

### Handler Method Coverage
Search test files for handler/controller method names:
```regex
getUsers
createUser
deleteUser
```

### HTTP Status Code Coverage
```regex
200|201|204    — success responses
400            — bad request / validation error
401            — unauthorized
403            — forbidden
404            — not found
409            — conflict (unique constraint violation)
500            — internal server error
```

### Auth Test Patterns
```regex
unauthorized|Unauthorized|401
forbidden|Forbidden|403
expired.*token|token.*expired
invalid.*token|token.*invalid
bearer|Bearer|authorization|Authorization
no.*auth|without.*auth|missing.*token
```

### Negative Test Patterns
```regex
should.*fail
should.*throw
should.*reject
expect.*error|expect.*exception
assertThrows|Assert\.Throws
invalid|Invalid
notFound|not_found|NotFound
badRequest|bad_request|BadRequest
```

### Mock/Stub Patterns
```regex
mock|Mock|@Mock|jest\.mock
stub|Stub|sinon\.stub
WireMock|wiremock
nock\(|Nock
Moq|NSubstitute
when\(.*\)\.thenReturn
mockReturnValue|mockResolvedValue
```

---

## Severity Assignment Rules

### Critical
- DELETE endpoints without tests
- Bulk update/delete operations without tests
- Admin-only endpoints without role enforcement tests
- Payment or financial transaction endpoints without tests
- Auth bypass risk (no test for missing/invalid token)

### High
- POST (create) endpoints without tests
- PUT/PATCH (update) endpoints without tests
- Authenticated endpoints without auth negative tests
- Downstream service failure without fallback tests
- Core business flow gaps (order creation, user registration)

### Medium
- GET endpoints with parameters/filters without tests
- Validation rule enforcement without tests (unique constraints, format validation)
- Pagination without tests
- Error response format without tests
- Missing OpenAPI documentation

### Low
- Simple GET endpoints without tests (list all, health check)
- Missing README or contributing guide
- Missing code comments or inline documentation
- Already-deprecated endpoint without tests

---

## Coverage Estimation Heuristic

Since this is static analysis (not runtime coverage), estimate coverage as:

```
coverageEstimate = endpointsWithTests / totalEndpoints * 100
```

Adjust downward if:
- Tests found are only positive path (no negative tests) → subtract 10%
- No auth negative tests found → subtract 5%
- No error handling tests found → subtract 5%

Report as approximate: "~58%" not "58.33%"
