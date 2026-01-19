# Java Endpoint Discovery Patterns

## Spring Boot

### Controller Annotations

| Annotation | Purpose |
|------------|---------|
| `@RestController` | Marks class as REST controller |
| `@Controller` | MVC controller (check for `@ResponseBody`) |
| `@RequestMapping` | Base path for controller |

### Method Annotations

| Annotation | HTTP Method |
|------------|-------------|
| `@GetMapping` | GET |
| `@PostMapping` | POST |
| `@PutMapping` | PUT |
| `@DeleteMapping` | DELETE |
| `@PatchMapping` | PATCH |
| `@RequestMapping(method=...)` | Any method |

### Path Extraction

```java
// Class-level path
@RestController
@RequestMapping("/api/users")
public class UserController {

    // Method-level path combines: /api/users + /{id} = /api/users/{id}
    @GetMapping("/{id}")
    public User getUser(@PathVariable Long id) { }

    // Query parameters
    @GetMapping
    public List<User> getUsers(
        @RequestParam(required = false) String filter,
        @RequestParam(defaultValue = "10") int limit) { }

    // Request body
    @PostMapping
    public User createUser(@RequestBody CreateUserRequest request) { }
}
```

### Parameter Annotations

| Annotation | Type | Example |
|------------|------|---------|
| `@PathVariable` | Path | `/{id}` → `@PathVariable Long id` |
| `@RequestParam` | Query | `?filter=x` → `@RequestParam String filter` |
| `@RequestBody` | Body | JSON body → `@RequestBody UserDTO dto` |
| `@RequestHeader` | Header | `@RequestHeader("X-Token") String token` |

### Security Annotations

```java
@PreAuthorize("hasRole('ADMIN')")
@Secured("ROLE_USER")
@RolesAllowed("manager")
```

### Grep Patterns

```bash
# Find all controllers
grep -rn "@RestController\|@Controller" --include="*.java" src/

# Find all endpoints
grep -rn "@GetMapping\|@PostMapping\|@PutMapping\|@DeleteMapping\|@PatchMapping\|@RequestMapping" --include="*.java" src/

# Find secured endpoints
grep -rn "@PreAuthorize\|@Secured\|@RolesAllowed" --include="*.java" src/
```

## JAX-RS (Jakarta RS)

### Class Annotations

```java
@Path("/api/users")
public class UserResource {

    @GET
    @Path("/{id}")
    @Produces(MediaType.APPLICATION_JSON)
    public User getUser(@PathParam("id") Long id) { }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    public Response createUser(CreateUserRequest request) { }
}
```

### Method Annotations

| Annotation | HTTP Method |
|------------|-------------|
| `@GET` | GET |
| `@POST` | POST |
| `@PUT` | PUT |
| `@DELETE` | DELETE |
| `@PATCH` | PATCH |
| `@HEAD` | HEAD |
| `@OPTIONS` | OPTIONS |

### Parameter Annotations

| Annotation | Type |
|------------|------|
| `@PathParam` | Path parameter |
| `@QueryParam` | Query parameter |
| `@HeaderParam` | Header |
| `@FormParam` | Form data |
| `@BeanParam` | Complex object |

### Media Type Annotations

```java
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
```

### Grep Patterns

```bash
# Find all resources
grep -rn "@Path" --include="*.java" src/

# Find all endpoints
grep -rn "@GET\|@POST\|@PUT\|@DELETE\|@PATCH" --include="*.java" src/
```

## OpenAPI/Swagger Annotations

```java
@Operation(summary = "Get user by ID")
@ApiResponse(responseCode = "200", description = "User found")
@ApiResponse(responseCode = "404", description = "User not found")
@Parameter(description = "User ID", required = true)
```

Extract documentation from these annotations when present.
