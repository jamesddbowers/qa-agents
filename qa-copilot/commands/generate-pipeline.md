---
description: Generate Azure DevOps pipeline for Newman test execution
allowed-tools: Read, Write, Grep, Glob
argument-hint: [pipeline-type: smoke|regression|scheduled]
---

Generate an Azure DevOps YAML pipeline template for running Newman tests.

**Pipeline Type**: $ARGUMENTS

Options:
- `smoke` - Run on every deployment (CI trigger)
- `regression` - Full test suite (manual or scheduled trigger)
- `scheduled` - Nightly/weekly scheduled runs

If no type specified, default to `smoke`.

**Prerequisites:**
- Check for Postman collection at `postman/*.postman_collection.json`
- Check for environment template at `postman/*.postman_environment.json`

If prerequisites are missing, inform the user which commands to run first.

**Generation Goals:**
1. Create appropriate pipeline trigger configuration
2. Set up Node.js and Newman installation
3. Configure secure variable group references
4. Add Newman execution with proper reporters
5. Configure test result publishing for ADO
6. Set up artifact upload for HTML reports

**Output Files:**
- `ado/newman-[type].yml`

**Required Variable Groups** (to be created in ADO Library):
- `qa-api-secrets` - Auth credentials
- `qa-environments` - Environment URLs

Before writing any files, ask for confirmation showing:
- Pipeline structure preview
- Required variable groups and their variables
- Setup instructions for Azure DevOps
