# .NET Endpoint Discovery Patterns

## ASP.NET Core Controllers

### Controller Attributes

| Attribute | Purpose |
|-----------|---------|
| `[ApiController]` | Marks class as API controller |
| `[Controller]` | MVC controller |
| `[Route("api/[controller]")]` | Base route template |

### Method Attributes

| Attribute | HTTP Method |
|-----------|-------------|
| `[HttpGet]` | GET |
| `[HttpPost]` | POST |
| `[HttpPut]` | PUT |
| `[HttpDelete]` | DELETE |
| `[HttpPatch]` | PATCH |
| `[HttpHead]` | HEAD |
| `[HttpOptions]` | OPTIONS |

### Route Templates

```csharp
[ApiController]
[Route("api/[controller]")]  // [controller] = "users" from UsersController
public class UsersController : ControllerBase
{
    // GET /api/users
    [HttpGet]
    public ActionResult<IEnumerable<User>> GetUsers() { }

    // GET /api/users/{id}
    [HttpGet("{id}")]
    public ActionResult<User> GetUser(int id) { }

    // GET /api/users/{id}/orders
    [HttpGet("{id}/orders")]
    public ActionResult<IEnumerable<Order>> GetUserOrders(int id) { }

    // POST /api/users
    [HttpPost]
    public ActionResult<User> CreateUser([FromBody] CreateUserRequest request) { }

    // PUT /api/users/{id}
    [HttpPut("{id}")]
    public IActionResult UpdateUser(int id, [FromBody] UpdateUserRequest request) { }

    // DELETE /api/users/{id}
    [HttpDelete("{id}")]
    public IActionResult DeleteUser(int id) { }
}
```

### Parameter Binding Attributes

| Attribute | Source | Example |
|-----------|--------|---------|
| `[FromRoute]` | URL path | `[FromRoute] int id` |
| `[FromQuery]` | Query string | `[FromQuery] string filter` |
| `[FromBody]` | Request body | `[FromBody] UserDto dto` |
| `[FromHeader]` | HTTP header | `[FromHeader] string authorization` |
| `[FromForm]` | Form data | `[FromForm] IFormFile file` |

### Authorization Attributes

```csharp
[Authorize]                           // Requires authentication
[Authorize(Roles = "Admin")]          // Requires Admin role
[Authorize(Policy = "MinimumAge")]    // Custom policy
[AllowAnonymous]                      // No auth required
```

### Grep Patterns

```bash
# Find all controllers
grep -rn "\[ApiController\]\|\[Controller\]" --include="*.cs" src/

# Find all endpoints
grep -rn "\[HttpGet\]\|\[HttpPost\]\|\[HttpPut\]\|\[HttpDelete\]\|\[HttpPatch\]" --include="*.cs" src/

# Find routes
grep -rn "\[Route\(" --include="*.cs" src/

# Find authorized endpoints
grep -rn "\[Authorize\]" --include="*.cs" src/
```

## Minimal APIs (.NET 6+)

```csharp
// Program.cs or endpoint registration
app.MapGet("/api/users", () => GetUsers());
app.MapGet("/api/users/{id}", (int id) => GetUser(id));
app.MapPost("/api/users", (CreateUserRequest request) => CreateUser(request));
app.MapPut("/api/users/{id}", (int id, UpdateUserRequest request) => UpdateUser(id, request));
app.MapDelete("/api/users/{id}", (int id) => DeleteUser(id));

// With authorization
app.MapGet("/api/admin", () => AdminData()).RequireAuthorization();
```

### Minimal API Grep Patterns

```bash
# Find minimal API endpoints
grep -rn "app\.MapGet\|app\.MapPost\|app\.MapPut\|app\.MapDelete" --include="*.cs" src/
```

## OpenAPI/Swagger Attributes

```csharp
[ProducesResponseType(typeof(User), StatusCodes.Status200OK)]
[ProducesResponseType(StatusCodes.Status404NotFound)]
[SwaggerOperation(Summary = "Get user by ID")]
```

Extract documentation from these attributes when present.
