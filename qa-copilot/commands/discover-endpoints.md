---
description: Discover and inventory API endpoints in a codebase
allowed-tools: Read, Grep, Glob
argument-hint: [path-to-analyze]
---

Analyze the codebase to discover all API endpoints and build a comprehensive inventory.

**Target Path**: $ARGUMENTS

If no path provided, analyze the entire project starting from the current directory.

**Analysis Goals:**
1. Identify the technology stack and framework (Spring Boot, ASP.NET Core, Express, etc.)
2. Find all controller/route files
3. Extract endpoint definitions (method, path, parameters)
4. Detect authentication requirements
5. Note any OpenAPI/Swagger definitions
6. Categorize endpoints by resource/domain

**Output Requirements:**
- Write the inventory to `qa-agent-output/endpoint-inventory.md`
- Include source file and line number for each endpoint
- Mark confidence levels for each discovery
- Group endpoints logically by resource

Before writing any files, ask for confirmation showing a preview of what will be generated.
