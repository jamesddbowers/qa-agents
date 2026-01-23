---
mode: agent
description: Discover and inventory API endpoints in a codebase
tools:
  - read
  - search
variables:
  - name: path
    description: Path to analyze (defaults to entire project)
    default: "."
---

Analyze the codebase to discover all API endpoints and build a comprehensive inventory.

**Target Path**: ${input:path}

If no path provided, analyze the entire project starting from the current directory.

## Analysis Goals

1. Identify the technology stack and framework (Spring Boot, ASP.NET Core, Express, etc.)
2. Find all controller/route files
3. Extract endpoint definitions (method, path, parameters)
4. Detect authentication requirements
5. Note any OpenAPI/Swagger definitions
6. Categorize endpoints by resource/domain

## Output Requirements

- Write the inventory to `qa-agent-output/endpoint-inventory.md`
- Include source file and line number for each endpoint
- Mark confidence levels for each discovery
- Group endpoints logically by resource

## Safety Guardrails

ONLY write to:
- `qa-agent-output/` (reports, inventories)

NEVER modify:
- Application source code (src/, app/, lib/)
- Configuration files

Before writing any files, ask for confirmation showing a preview of what will be generated.
