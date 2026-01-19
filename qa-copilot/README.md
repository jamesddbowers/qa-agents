# qa-copilot

QA automation agents for API integration testing with Postman, Newman, and Azure DevOps.

## Overview

qa-copilot is a Claude Code plugin that provides human-in-the-loop QA automation assistants. These agents analyze codebases, generate test collections, create CI/CD pipelines, and provide diagnostics — all while asking permission before taking actions.

## Installation

### Option 1: Session-based (for testing)

```bash
# Load plugin for current session only
claude --plugin-dir ./qa-copilot
```

### Option 2: Project-level (recommended)

Copy the plugin to your project's `.claude-plugins/` directory:

```bash
# From your target project
cp -r /path/to/qa-agents/qa-copilot .claude-plugins/
```

### Option 3: User-level

Copy to your user plugins directory:

```bash
# macOS/Linux
cp -r ./qa-copilot ~/.claude/plugins/

# Windows
cp -r ./qa-copilot $env:USERPROFILE\.claude\plugins\
```

## Commands

| Command | Description |
|---------|-------------|
| `/discover-endpoints [path]` | Discover API endpoints and build inventory |
| `/analyze-auth [path]` | Analyze authentication patterns for testing |
| `/analyze-traffic [file]` | Analyze traffic data to prioritize test coverage |
| `/generate-collection [type]` | Generate Postman collection (smoke/regression/full) |
| `/generate-pipeline [type]` | Generate Azure DevOps pipeline (smoke/regression/scheduled) |
| `/diagnose [results]` | Diagnose and triage test failures |

## Agents

| Agent | MVP Step | Purpose |
|-------|----------|---------|
| `endpoint-discoverer` | Step 1 | Discover API endpoints from code (Spring Boot, ASP.NET Core, Express, etc.) |
| `auth-analyzer` | Step 2 | Analyze auth patterns for non-browser token acquisition |
| `traffic-analyzer` | Step 3 | Analyze Dynatrace/APM exports to prioritize endpoints |
| `collection-generator` | Step 5 | Generate tagged Postman collections with test scripts |
| `pipeline-generator` | Step 7 | Generate Azure DevOps YAML pipelines for Newman |
| `diagnostics-agent` | Step 8 | Diagnose test failures and provide remediation |

## Workflow

### Recommended Order

1. **Discover endpoints**: `/discover-endpoints` or let the endpoint-discoverer agent analyze your codebase
2. **Analyze auth**: `/analyze-auth` to understand how to authenticate for testing
3. **Prioritize** (optional): `/analyze-traffic` if you have Dynatrace/APM data
4. **Generate collection**: `/generate-collection smoke` for critical paths
5. **Generate pipeline**: `/generate-pipeline smoke` for CI/CD integration
6. **Run and diagnose**: Use `/diagnose` when tests fail

### Example Session

```
> /discover-endpoints src/
[Agent analyzes codebase, generates qa-agent-output/endpoint-inventory.md]

> /analyze-auth
[Agent documents auth patterns, generates qa-agent-output/auth-analysis.md]

> /generate-collection smoke
[Agent creates postman/project-smoke.postman_collection.json]

> /generate-pipeline smoke
[Agent creates ado/newman-smoke.yml]
```

## Operating Principles

1. **Read-only by default** — Agents don't modify application source code
2. **Human-in-the-loop** — Always ask permission before running commands or writing files
3. **Safe output locations** — Write only to designated folders
4. **Explainability** — Every inference includes source pointers and confidence levels
5. **No secrets in output** — Never expose credentials, tokens, or sensitive data

## Output Locations

```text
qa-agent-output/     # Reports, inventories, diagnostics
docs/generated/      # OpenAPI drafts
postman/             # Collections and environments
ado/                 # Pipeline templates
```

## Guardrails (Hooks)

The plugin includes prompt-based hooks that enforce safety:

- **Write/Edit validation**: Only allows writes to safe output locations
- **Read validation**: Prompts for confirmation when reading sensitive files (.env, credentials)
- **Bash validation**: Blocks destructive commands, confirms risky operations
- **Stop validation**: Verifies task completion and secret safety

## Tech Stack Support

### Backend Frameworks
- **Java**: Spring Boot (@RestController, @RequestMapping), JAX-RS (@Path, @GET)
- **.NET**: ASP.NET Core ([ApiController], [HttpGet], [Route])
- **Node.js**: Express (app.get, router.post), NestJS (@Controller)
- **Python**: FastAPI, Flask, Django REST Framework

### Authentication Patterns
- OAuth2 (authorization code, client credentials, resource owner password)
- JWT (direct issuance, refresh tokens)
- API Keys (header, query parameter)
- Azure AD, Auth0, Okta

### CI/CD
- Azure DevOps YAML pipelines
- Newman with JUnit and HTML reporters

## File Structure

```
qa-copilot/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest
├── agents/
│   ├── endpoint-discoverer.md
│   ├── auth-analyzer.md
│   ├── traffic-analyzer.md
│   ├── collection-generator.md
│   ├── pipeline-generator.md
│   └── diagnostics-agent.md
├── commands/
│   ├── discover-endpoints.md
│   ├── analyze-auth.md
│   ├── analyze-traffic.md
│   ├── generate-collection.md
│   ├── generate-pipeline.md
│   └── diagnose.md
├── hooks/
│   └── hooks.json           # Safety guardrails
├── skills/                  # Domain-specific knowledge (8 skills)
└── README.md
```

## Future Phases

- **Phase 2**: Playwright framework hardening, Postman → Playwright migration
- **Phase 3**: Developer enablement (unit/component testing)
- **Phase 4**: UI E2E rationalization
- **Phase 5**: k6 performance testing

## Development

This plugin is under active development. See the main project [CLAUDE.md](../CLAUDE.md) for contribution guidelines and the research-first approach.
