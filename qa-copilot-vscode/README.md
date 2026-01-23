# qa-copilot-vscode

QA automation agents for API integration testing, ported from Claude Code to GitHub Copilot.

## Overview

This is the GitHub Copilot VS Code version of qa-copilot. It provides the same QA automation capabilities:
- Discover API endpoints in codebases
- Analyze authentication patterns
- Prioritize endpoints from traffic data
- Generate Postman collections
- Create Azure DevOps pipelines
- Diagnose test failures

## Installation

Copy the `.github/` directory to your project's root:

```bash
cp -r .github/ /path/to/your/project/
```

Or clone just the `.github/` contents:

```bash
git clone --depth 1 --filter=blob:none --sparse https://github.com/your-repo/qa-copilot-vscode
cd qa-copilot-vscode
git sparse-checkout set .github
cp -r .github /path/to/your/project/
```

## Prerequisites

- VS Code 1.95+
- GitHub Copilot extension with active subscription
- Copilot Chat enabled

Enable experimental features in VS Code settings:

```json
{
  "chat.useAgentSkills": true,
  "chat.experimental.agentMode": true
}
```

## Usage

### Prompt Files (Commands)

Invoke prompts in Copilot Chat:

| Prompt | Description |
|--------|-------------|
| `discover-endpoints` | Find API endpoints in code |
| `analyze-auth` | Analyze authentication patterns |
| `analyze-traffic` | Prioritize endpoints from traffic data |
| `generate-collection` | Create Postman collection |
| `generate-pipeline` | Create ADO pipeline |
| `diagnose` | Triage test failures |

### Agents

Agents are automatically available via `@agent-name` syntax in Copilot Chat:

| Agent | Purpose |
|-------|---------|
| `@endpoint-discoverer` | Discover API endpoints from code |
| `@auth-analyzer` | Analyze auth patterns for testing |
| `@traffic-analyzer` | Analyze APM exports to prioritize endpoints |
| `@collection-generator` | Generate Postman collections |
| `@pipeline-generator` | Generate Azure DevOps pipelines |
| `@diagnostics-agent` | Diagnose test failures |

### Skills

Skills are automatically loaded when relevant. They provide domain knowledge for:
- Endpoint discovery (Java, .NET, Node.js, Python)
- Auth patterns (OAuth, JWT, API Keys, Azure AD)
- Dynatrace/APM analysis
- Test tagging conventions
- Postman collection generation
- Test data planning
- ADO pipeline patterns
- Failure triage

## Recommended Workflow

1. **Discover endpoints**: Use `discover-endpoints` prompt or `@endpoint-discoverer`
2. **Analyze auth**: Use `analyze-auth` prompt to understand authentication
3. **Prioritize** (optional): Use `analyze-traffic` if you have APM data
4. **Generate collection**: Use `generate-collection` for Postman
5. **Generate pipeline**: Use `generate-pipeline` for ADO CI/CD
6. **Diagnose**: Use `diagnose` when tests fail

## Output Locations

All outputs go to safe directories:

```text
qa-agent-output/     # Reports, inventories, diagnostics
docs/generated/      # OpenAPI drafts
postman/             # Collections and environments
ado/                 # Pipeline templates
```

## Differences from Claude Code Version

| Feature | Claude Code | VS Code Copilot |
|---------|-------------|-----------------|
| Commands | `/discover-endpoints` | Prompt file invocation |
| Agents | Auto-delegation | `@agent-name` syntax |
| Hooks | hooks.json enforcement | Prompt-based guards |

## Source

Ported from [qa-copilot](../qa-copilot/) Claude Code plugin.

See [COPILOT-PORTING-GUIDE.md](../research/github-copilot-research/COPILOT-PORTING-GUIDE.md) for conversion details.
