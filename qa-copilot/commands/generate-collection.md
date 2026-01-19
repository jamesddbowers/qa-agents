---
description: Generate a Postman collection for API testing
allowed-tools: Read, Write, Grep, Glob
argument-hint: [collection-type: smoke|regression|full]
---

Generate a Postman collection for API testing based on the endpoint inventory.

**Collection Type**: $ARGUMENTS

Options:
- `smoke` - Critical path endpoints only (fast execution)
- `regression` - Comprehensive test coverage
- `full` - All discovered endpoints

If no type specified, default to `smoke`.

**Prerequisites:**
- Check for endpoint inventory at `qa-agent-output/endpoint-inventory.md`
- Check for auth analysis at `qa-agent-output/auth-analysis.md`
- Check for traffic analysis at `qa-agent-output/traffic-analysis.md` (optional but helpful)

If prerequisites are missing, inform the user which commands to run first.

**Generation Goals:**
1. Create folder structure by resource/domain
2. Generate requests with proper HTTP methods and paths
3. Add test scripts with status code and response time checks
4. Configure pre-request scripts for authentication
5. Apply smoke/regression tags appropriately
6. Create environment template with required variables

**Output Files:**
- `postman/[project-name]-[type].postman_collection.json`
- `postman/[project-name].postman_environment.json`

Before writing any files, ask for confirmation showing:
- Collection structure preview
- Number of requests by category
- Required environment variables
