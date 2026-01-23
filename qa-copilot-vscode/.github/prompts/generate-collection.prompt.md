---
mode: agent
description: Generate a Postman collection for API testing
tools:
  - read
  - write
  - search
variables:
  - name: type
    description: Collection type (smoke, regression, or full)
    default: "smoke"
---

Generate a Postman collection for API testing based on the endpoint inventory.

**Collection Type**: ${input:type}

Options:
- `smoke` - Critical path endpoints only (fast execution)
- `regression` - Comprehensive test coverage
- `full` - All discovered endpoints

If no type specified, default to `smoke`.

## Prerequisites

Check for required input files:
- Endpoint inventory at `qa-agent-output/endpoint-inventory.md`
- Auth analysis at `qa-agent-output/auth-analysis.md`
- Traffic analysis at `qa-agent-output/traffic-analysis.md` (optional but helpful)

If prerequisites are missing, inform the user which commands to run first:
- `/discover-endpoints` for endpoint inventory
- `/analyze-auth` for auth analysis
- `/analyze-traffic` for traffic prioritization

## Generation Goals

1. Create folder structure by resource/domain
2. Generate requests with proper HTTP methods and paths
3. Add test scripts with status code and response time checks
4. Configure pre-request scripts for authentication
5. Apply smoke/regression tags appropriately
6. Create environment template with required variables

## Output Files

- `postman/[project-name]-[type].postman_collection.json`
- `postman/[project-name].postman_environment.json`

## Safety Guardrails

ONLY write to:
- `postman/` (collections, environments)

NEVER:
- Include actual secret values in collections
- Modify application source code

Before writing any files, ask for confirmation showing:
- Collection structure preview
- Number of requests by category
- Required environment variables
