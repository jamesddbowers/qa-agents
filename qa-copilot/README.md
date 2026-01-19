# qa-copilot

QA automation agents for API integration testing with Postman, Newman, and Azure DevOps.

## Overview

qa-copilot is a Claude Code plugin that provides human-in-the-loop QA automation assistants. These agents analyze codebases, generate test collections, create CI/CD pipelines, and provide diagnostics — all while asking permission before taking actions.

## Installation

```bash
# From the qa-agents repo root
claude plugin add ./qa-copilot
```

## Features

### Phase 1 MVP (Current)

| Command | Purpose |
| ------- | ------- |
| `/qa-copilot:discover-endpoints` | Discover API endpoints from code |
| `/qa-copilot:analyze-auth` | Analyze authentication patterns |
| `/qa-copilot:prioritize-endpoints` | Prioritize endpoints using telemetry data |
| `/qa-copilot:generate-postman` | Generate Postman collections |
| `/qa-copilot:generate-pipeline` | Generate Azure DevOps pipeline templates |
| `/qa-copilot:triage-failure` | Diagnose and classify test failures |

### Agents

| Agent | Purpose |
| ----- | ------- |
| `api-surface-extraction-agent` | Extract API surface from codebase |
| `auth-access-discovery-agent` | Discover auth mechanisms |
| `telemetry-prioritization-agent` | Prioritize based on Dynatrace data |
| `postman-authoring-agent` | Generate Postman collections |
| `ado-pipeline-agent` | Generate ADO pipeline templates |
| `diagnostics-triage-agent` | Classify and diagnose failures |

### Skills

| Skill | Purpose |
| ----- | ------- |
| `endpoint-discovery` | Patterns for finding endpoints in Java/.NET/TS |
| `auth-patterns` | OAuth, JWT, Azure AD token patterns |
| `postman-generation` | Postman collection schema and assertions |
| `ado-pipeline-patterns` | Azure DevOps YAML patterns |
| `failure-triage` | Failure classification methodology |

## Operating Principles

1. **Read-only by default** — Agents don't modify app source code
2. **Human-in-the-loop** — Always ask permission before running commands or writing files
3. **Safe output locations** — Write only to designated folders
4. **Explainability** — Every inference includes source pointers and confidence levels
5. **No pushing** — Generate commit/PR notes but never push code

## Output Locations

```text
qa-agent-output/     # Reports, inventories, diagnostics
docs/generated/      # OpenAPI drafts
postman/             # Collections and environments
ado/                 # Pipeline templates
```

## Tech Stack Support

- **Backend**: Java (Spring Boot, JAX-RS), .NET (ASP.NET Core)
- **Frontend**: HTML, JavaScript, CSS, TypeScript
- **CI/CD**: Azure DevOps YAML pipelines
- **Testing**: Postman/Newman

## Future Phases

- **Phase 2**: Playwright framework hardening, Postman → Playwright forklift
- **Phase 3**: Developer enablement (unit/component testing)
- **Phase 4**: UI E2E rationalization
- **Phase 5**: k6 performance testing

## Development

This plugin is under active development. See the main project [CLAUDE.md](../CLAUDE.md) for contribution guidelines and the research-first approach.
