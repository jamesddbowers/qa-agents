---
mode: agent
description: Analyze authentication patterns for API testing
tools:
  - read
  - search
variables:
  - name: path
    description: Path to analyze (defaults to entire project)
    default: "."
---

Analyze the authentication implementation to understand how to authenticate for API testing without browser-based flows.

**Target Path**: ${input:path}

If no path provided, analyze the entire project.

## Analysis Goals

1. Identify authentication libraries and frameworks
2. Locate auth configuration files
3. Map authentication flows (OAuth2, JWT, API keys, etc.)
4. Find service account or client credentials options
5. Document token acquisition endpoints
6. Identify environment variables needed (names only, NEVER values)

## Security Rules

- NEVER output actual credentials, tokens, or secrets
- Document environment variable NAMES but not VALUES
- If secrets are found hardcoded in code, flag as security issue but do NOT display them

## Output Requirements

- Write the analysis to `qa-agent-output/auth-analysis.md`
- Include Postman/Newman configuration patterns
- Provide environment variable templates
- Document pre-request script patterns for token handling

## Safety Guardrails

ONLY write to:
- `qa-agent-output/` (reports, inventories)

NEVER:
- Read .env files or credentials
- Output secret values
- Modify application code

Before writing any files, ask for confirmation showing a preview of what will be generated.
