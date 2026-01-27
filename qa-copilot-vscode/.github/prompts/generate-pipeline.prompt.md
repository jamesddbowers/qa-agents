---
description: Generate Azure DevOps pipeline for Newman test execution
agent: 'agent'
tools:
  - read
  - write
  - search
argument-hint: "[type: smoke|regression|scheduled]"
---

Generate an Azure DevOps YAML pipeline template for running Newman tests.

**Pipeline Type**: ${input:type}

Options:
- `smoke` - Run on every deployment (CI trigger)
- `regression` - Full test suite (manual or scheduled trigger)
- `scheduled` - Nightly/weekly scheduled runs

If no type specified, default to `smoke`.

## Prerequisites

Check for required input files:
- Postman collection at `postman/*.postman_collection.json`
- Environment template at `postman/*.postman_environment.json`

If prerequisites are missing, inform the user to run `/generate-collection` first.

## Generation Goals

1. Create appropriate pipeline trigger configuration
2. Set up Node.js and Newman installation
3. Configure secure variable group references
4. Add Newman execution with proper reporters
5. Configure test result publishing for ADO
6. Set up artifact upload for HTML reports

## Output Files

- `ado/newman-[type].yml`

## Required Variable Groups

The generated pipeline expects these ADO Library variable groups:
- `qa-api-secrets` - Auth credentials
- `qa-environments` - Environment URLs

## Safety Guardrails

ONLY write to:
- `ado/` (pipeline templates)

NEVER:
- Include actual secret values in pipelines
- Use hardcoded credentials

Before writing any files, ask for confirmation showing:
- Pipeline structure preview
- Required variable groups and their variables
- Setup instructions for Azure DevOps
