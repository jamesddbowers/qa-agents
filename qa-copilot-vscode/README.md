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

## Quick Start (Testing)

**One-liner to pull QA Copilot into any project:**

```bash
# Replace YOUR_USERNAME with your GitHub username
cd /path/to/your/project && npx degit github:YOUR_USERNAME/qa-copilot-vscode/.github .github
```

> **Note:** If using the parent qa-agents repo instead, use:
> `npx degit github:YOUR_USERNAME/qa-agents/qa-copilot-vscode/.github .github`

Then enable VS Code settings (paste into settings.json):

```json
"github.copilot.chat.codeGeneration.useInstructionFiles": true,
"chat.promptFiles": true,
"chat.useAgentSkills": true,
"chat.agent.enabled": true
```

**Verify:** Open Copilot Chat, type `/` — you should see the QA prompts listed.

---

## Installation & Setup

### Step 1: Prerequisites

Before installing, ensure you have:

- [ ] VS Code **1.102+** (check: Help → About)
- [ ] GitHub Copilot extension installed
- [ ] Active GitHub Copilot subscription
- [ ] Copilot Chat enabled

### Step 2: Enable Required Settings

Open VS Code Settings (JSON) and add these settings:

```json
{
  "github.copilot.chat.codeGeneration.useInstructionFiles": true,
  "chat.promptFiles": true,
  "chat.useAgentSkills": true,
  "chat.agent.enabled": true
}
```

**How to access Settings JSON:**

1. Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac)
2. Type "Preferences: Open User Settings (JSON)"
3. Add the settings above

### Step 3: Pull Files from GitHub to Your Project

Choose the method that works best for your setup:

#### Method 1: npx degit (Recommended - No Clone Required)

```bash
# From your target project directory
cd /path/to/your/project

# Pull just the .github folder from the standalone repo
npx degit github:YOUR_USERNAME/qa-copilot-vscode/.github .github
```

**Why degit?** Downloads only the files you need without git history or full clone.

#### Method 2: Git Sparse Checkout (No npm Required)

```bash
# From your target project directory
cd /path/to/your/project

# Clone only the .github folder (shallow, sparse)
git clone --depth 1 --filter=blob:none --sparse \
  https://github.com/YOUR_USERNAME/qa-copilot-vscode.git temp-qa-copilot

cd temp-qa-copilot
git sparse-checkout set .github

# Copy to your project and cleanup
cp -r .github ../
cd ..
rm -rf temp-qa-copilot
```

#### Method 3: GitHub CLI (If you have `gh` installed)

```bash
# From your target project directory
cd /path/to/your/project

# Clone and extract .github folder
gh repo clone YOUR_USERNAME/qa-copilot-vscode -- --depth 1 --filter=blob:none --sparse
cd qa-copilot-vscode
git sparse-checkout set .github
cp -r .github ../
cd ..
rm -rf qa-copilot-vscode
```

#### Method 4: Direct Download (Manual)

1. Go to `https://github.com/YOUR_USERNAME/qa-copilot-vscode`
2. Navigate to `.github/`
3. Click "Download ZIP" or download individual files
4. Extract to your project's `.github/` folder

#### Method 5: curl Individual Files (For CI/CD)

```bash
# From your target project directory
cd /path/to/your/project
mkdir -p .github/prompts .github/agents .github/skills

# Base URL for raw files (standalone repo)
BASE="https://raw.githubusercontent.com/YOUR_USERNAME/qa-copilot-vscode/main/.github"

# Download custom instructions
curl -o .github/copilot-instructions.md "$BASE/copilot-instructions.md"

# Download prompts
for f in discover-endpoints analyze-auth analyze-traffic generate-collection generate-pipeline diagnose; do
  curl -o ".github/prompts/$f.prompt.md" "$BASE/prompts/$f.prompt.md"
done

# Download agents
for f in endpoint-discoverer auth-analyzer traffic-analyzer collection-generator pipeline-generator diagnostics-agent; do
  curl -o ".github/agents/$f.agent.md" "$BASE/agents/$f.agent.md"
done
```

Your project should now have this structure:

```text
your-project/
├── .github/
│   ├── copilot-instructions.md    # Project-wide QA guidelines
│   ├── prompts/
│   │   ├── discover-endpoints.prompt.md
│   │   ├── analyze-auth.prompt.md
│   │   ├── analyze-traffic.prompt.md
│   │   ├── generate-collection.prompt.md
│   │   ├── generate-pipeline.prompt.md
│   │   └── diagnose.prompt.md
│   ├── agents/
│   │   ├── endpoint-discoverer.agent.md
│   │   ├── auth-analyzer.agent.md
│   │   ├── traffic-analyzer.agent.md
│   │   ├── collection-generator.agent.md
│   │   ├── pipeline-generator.agent.md
│   │   └── diagnostics-agent.agent.md
│   └── skills/
│       └── [skill-folders]/
└── your-existing-files...
```

### Step 4: Open Project in VS Code

Open the target project folder in VS Code. **No restart required** - VS Code auto-detects files in `.github/` folders.

### Step 5: Verify Installation

| Component | How to Verify | Expected Result |
|-----------|---------------|-----------------|
| **Prompts** | Type `/` in Copilot Chat | See `discover-endpoints`, `analyze-auth`, etc. |
| **Agents** | Click agents dropdown in Chat | See `endpoint-discoverer`, `auth-analyzer`, etc. |
| **Skills** | Ask "How do I find REST endpoints?" | Skill context loads automatically |
| **Instructions** | Ask Copilot to write code | Should mention QA guidelines |

**Quick Test:**
1. Open Copilot Chat (`Ctrl+Alt+I` or `Cmd+Alt+I`)
2. Type `/` - you should see your prompt names listed
3. Click the agent picker dropdown - you should see custom agents

---

## Troubleshooting

### Prompts Not Appearing

| Symptom | Solution |
|---------|----------|
| `/` shows no custom prompts | Enable `chat.promptFiles: true` in settings |
| Prompts listed but won't run | Check `.prompt.md` files have valid YAML frontmatter |

### Agents Not Appearing

| Symptom | Solution |
|---------|----------|
| No custom agents in dropdown | Enable `chat.agent.enabled: true` in settings |
| Agent picker missing entirely | Update VS Code to 1.102+ |
| Org agents not showing | Enable `github.copilot.chat.customAgents.showOrganizationAndEnterpriseAgents: true` |

### Skills Not Loading

| Symptom | Solution |
|---------|----------|
| Skills never activate | Enable `chat.useAgentSkills: true` in settings |
| Wrong skill loads | Check `description` field in SKILL.md frontmatter |

### General Issues

| Symptom | Solution |
|---------|----------|
| Nothing works | Verify `.github/` folder is at project root (not nested) |
| Files not detected | Close and reopen the project folder |
| Legacy `.chatmode.md` files | Use VS Code Quick Fix to convert to `.agent.md` |

---

## Custom Instructions

This project includes `.github/copilot-instructions.md` which provides project-wide QA guidelines:

- Safe output locations
- Security rules (never output secrets)
- Human-in-the-loop requirements
- Quality standards for output

## Usage

### Prompt Files (Commands)

Invoke prompts in Copilot Chat using the `/` prefix:

| Command | Description |
|---------|-------------|
| `/discover-endpoints` | Find API endpoints in code |
| `/analyze-auth` | Analyze authentication patterns |
| `/analyze-traffic` | Prioritize endpoints from traffic data |
| `/generate-collection` | Create Postman collection |
| `/generate-pipeline` | Create ADO pipeline |
| `/diagnose` | Triage test failures |

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

This project was ported from the Claude Code plugin version of qa-copilot.

For the original Claude Code plugin, see the [qa-agents repository](https://github.com/YOUR_USERNAME/qa-agents).
