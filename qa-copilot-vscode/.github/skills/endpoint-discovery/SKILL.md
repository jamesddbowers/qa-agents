---
name: endpoint-discovery
description: Discover and inventory API endpoints across Java, .NET, Node.js, and Python frameworks for QA automation. Use when you need to identify REST endpoints in a codebase, extract HTTP methods and paths, detect authentication requirements, build an endpoint inventory for test planning, analyze API surface for test coverage, or support QA MVP Step 1. Supports Spring Boot, JAX-RS, ASP.NET Core, Express, NestJS, FastAPI, Flask, and Django REST Framework.
---

# Endpoint Discovery

Discover all API endpoints in a codebase and build a comprehensive inventory for QA test planning.

## Quick Start

1. Identify the framework by scanning for configuration files
2. Locate controller/route files using framework-specific patterns
3. Extract endpoint definitions (method, path, parameters)
4. Document authentication requirements
5. Generate structured inventory

## Framework Detection

Scan for these markers to identify the technology stack:

| Framework | Detection Files | Key Packages |
|-----------|----------------|--------------|
| Spring Boot | pom.xml, build.gradle | spring-boot-starter-web |
| JAX-RS | pom.xml | javax.ws.rs, jakarta.ws.rs |
| ASP.NET Core | *.csproj | Microsoft.AspNetCore |
| Express | package.json | express |
| NestJS | package.json | @nestjs/core |
| FastAPI | requirements.txt, pyproject.toml | fastapi |
| Flask | requirements.txt | flask |
| Django REST | requirements.txt | djangorestframework |

## Discovery Process

### Step 1: Identify Framework

Search for configuration files in project root:
- `pom.xml` or `build.gradle` → Java (check dependencies for Spring vs JAX-RS)
- `*.csproj` → .NET
- `package.json` → Node.js (check for express, @nestjs)
- `requirements.txt` or `pyproject.toml` → Python

### Step 2: Locate Route Definitions

Use framework-specific patterns. See references for detailed patterns:
- **Java**: See `references/java-patterns.md`
- **.NET**: See `references/dotnet-patterns.md`
- **Node.js**: See `references/node-patterns.md`
- **Python**: See `references/python-patterns.md`

### Step 3: Extract Endpoints

For each route definition, extract:
- HTTP method (GET, POST, PUT, DELETE, PATCH)
- Path/URL pattern (including path parameters)
- Query parameters (if annotated)
- Request body type (if annotated)
- Response type (if annotated)

### Step 4: Detect Authentication

Look for security annotations/decorators:
- `@Secured`, `@PreAuthorize` (Spring)
- `[Authorize]` (ASP.NET)
- Middleware patterns (Express, NestJS)
- `@auth_required` decorators (Python)

### Step 5: Generate Inventory

Output structured inventory with:
- Source file and line number for each endpoint
- Confidence level (High/Medium/Low)
- Authentication requirements
- Parameter documentation

## Output Format

Generate inventory in this structure:

```markdown
## Endpoint Inventory

### Summary
- Total endpoints: [count]
- Tech stack: [framework]
- Protected endpoints: [count]

### Endpoints by Resource

#### [Resource Name]

| Method | Path | Auth | Source | Confidence |
|--------|------|------|--------|------------|
| GET | /api/resource | Yes | File.java:42 | High |

**GET /api/resource**
- Parameters: id (path), filter (query)
- Auth: Bearer token
- Source: src/controllers/ResourceController.java:42
```

## Confidence Levels

| Level | Criteria |
|-------|----------|
| High | Explicit annotation/decorator with full metadata |
| Medium | Annotation found but missing some metadata |
| Low | Inferred from code patterns, not explicit |

## Common Patterns Reference

### Quick Grep Patterns

```bash
# Spring Boot
grep -rn "@RequestMapping\|@GetMapping\|@PostMapping" src/

# ASP.NET Core
grep -rn "\[HttpGet\]\|\[HttpPost\]\|\[Route\]" src/

# Express
grep -rn "app\.get\|app\.post\|router\." src/

# FastAPI
grep -rn "@app\.get\|@app\.post\|@router\." src/
```

## Edge Cases

- **No endpoints found**: Report framework detected, suggest alternative search patterns
- **Mixed frameworks**: Document each separately with clear separation
- **GraphQL**: List queries and mutations instead of REST paths
- **OpenAPI/Swagger**: Extract from spec if available, cross-reference with code
- **Microservices**: Note service-to-service calls and external dependencies
