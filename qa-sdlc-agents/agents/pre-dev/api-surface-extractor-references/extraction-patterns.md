# Endpoint Extraction Patterns by Framework

## Glob Patterns for Locating Controllers/Routes

### Java — Spring Boot
```
**/controller/**/*.java
**/controllers/**/*.java
**/rest/**/*.java
**/api/**/*.java
**/web/**/*.java
**/resource/**/*.java
**/resources/**/*.java
```

### Java — JAX-RS
```
**/resource/**/*.java
**/resources/**/*.java
**/rest/**/*.java
**/api/**/*.java
**/endpoint/**/*.java
```

### ASP.NET Core
```
**/Controllers/**/*.cs
**/Endpoints/**/*.cs
**/Program.cs
**/Startup.cs
```

### Node.js — Express
```
**/routes/**/*.{js,ts}
**/router/**/*.{js,ts}
**/controllers/**/*.{js,ts}
**/api/**/*.{js,ts}
**/app.{js,ts}
**/index.{js,ts}
**/server.{js,ts}
```

### Node.js — NestJS
```
**/*.controller.{js,ts}
**/*.resolver.{js,ts}
```

### Python — FastAPI
```
**/routers/**/*.py
**/routes/**/*.py
**/api/**/*.py
**/endpoints/**/*.py
**/main.py
**/app.py
```

### Python — Django
```
**/urls.py
**/views.py
**/viewsets.py
**/api/**/*.py
```

---

## Grep Patterns for Extracting Endpoints

### Spring Boot Annotations
```regex
@(Get|Post|Put|Delete|Patch|Request)Mapping\s*\(
@RestController
@RequestMapping\s*\(
```

### JAX-RS Annotations
```regex
@(GET|POST|PUT|DELETE|PATCH|HEAD|OPTIONS)
@Path\s*\(
```

### ASP.NET Attributes
```regex
\[(Http(Get|Post|Put|Delete|Patch)|Route)\s*\(
\[ApiController\]
```

### ASP.NET Minimal API
```regex
app\.Map(Get|Post|Put|Delete|Patch)\s*\(
app\.MapGroup\s*\(
```

### Express Patterns
```regex
(app|router)\.(get|post|put|delete|patch|all|use)\s*\(
```

### NestJS Decorators
```regex
@(Get|Post|Put|Delete|Patch|All)\s*\(
@Controller\s*\(
```

### FastAPI Decorators
```regex
@(app|router)\.(get|post|put|delete|patch)\s*\(
```

### Django URL Patterns
```regex
path\s*\(\s*['"]
re_path\s*\(\s*['"]
```

---

## Path Composition Rules

### Spring Boot
- Class: `@RequestMapping("/api/users")` → base path `/api/users`
- Method: `@GetMapping("/{id}")` → appended to class path
- Full: `/api/users/{id}`
- Context path: Check `server.servlet.context-path` in application.yml

### ASP.NET Core
- Class: `[Route("api/[controller]")]` → `[controller]` replaced by class name minus "Controller"
- Method: `[HttpGet("{id}")]` → appended
- Full: `api/users/{id}`

### Express
- Router mount: `app.use("/api/users", userRouter)` → base path
- Route: `router.get("/:id", handler)` → appended
- Full: `/api/users/:id`

### NestJS
- Controller: `@Controller("users")` → base
- Method: `@Get(":id")` → appended
- Global prefix: Check `app.setGlobalPrefix("api")` in main.ts
- Full: `api/users/:id`

### FastAPI
- Router prefix: `app.include_router(router, prefix="/api/users")`
- Route: `@router.get("/{user_id}")`
- Full: `/api/users/{user_id}`

---

## Auth Detection Patterns

### Spring Security
- Global config: `SecurityFilterChain` bean with `requestMatchers` / `antMatchers`
- Per-method: `@PreAuthorize("hasRole('ADMIN')")`, `@Secured("ROLE_USER")`
- Public: `.permitAll()` in security config

### ASP.NET Core
- Global: `builder.Services.AddAuthorization()` policies
- Per-endpoint: `[Authorize]`, `[Authorize(Roles = "Admin")]`
- Public: `[AllowAnonymous]`
- Minimal API: `.RequireAuthorization()`, `.AllowAnonymous()`

### Express / Passport
- Middleware: `passport.authenticate('jwt')` as route middleware
- Custom: Auth middleware function as argument before handler

### NestJS
- Guards: `@UseGuards(JwtAuthGuard)`, `@UseGuards(RolesGuard)`
- Roles: `@Roles('admin')` custom decorator
- Public: `@Public()` or `@SkipAuth()` custom decorator

### FastAPI
- Dependencies: `Depends(get_current_user)` in route signature
- Security: `Security(oauth2_scheme)` dependency
- Public: No auth dependency in route

### Django REST Framework
- Class: `permission_classes = [IsAuthenticated]`
- View: `@permission_classes([IsAdminUser])`
- Public: `permission_classes = [AllowAny]`
