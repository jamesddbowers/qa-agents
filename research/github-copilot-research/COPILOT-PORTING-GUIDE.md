# qa-copilot: Claude Code to GitHub Copilot Porting Guide

A comprehensive guide for porting the qa-copilot plugin from Claude Code to GitHub Copilot in VS Code.

---

## 1. Executive Summary

### What's Portable (80%)

| Component | Claude Code | Copilot VS Code | Portability |
|-----------|-------------|-----------------|-------------|
| **Commands** | commands/*.md | .github/prompts/*.prompt.md | Full |
| **Agents** | agents/*.md | .github/agents/*.agent.md | Full |
| **Skills** | skills/*/SKILL.md | .github/skills/*/SKILL.md | Full |
| **MCP Tools** | .mcp.json | .vscode/mcp.json | Full |

### What Needs Adaptation (20%)

| Component | Claude Code | Copilot VS Code | Status |
|-----------|-------------|-----------------|--------|
| **PreToolUse Hooks** | hooks.json | Extension code | Partial (extension required) |
| **PostToolUse Hooks** | hooks.json | VS Code events | Partial |
| **Session Hooks** | hooks.json | Extension lifecycle | Partial |
| **Stop/SubagentStop** | hooks.json | Not exposed | None |

### Recommended Approach

1. **File-based first**: Port commands, agents, and skills using Copilot's native file formats
2. **Accept graceful degradation**: Hooks provide safety guardrails in Claude Code but Copilot lacks native equivalents
3. **No extension initially**: Build and test file-based components before considering a VS Code extension

### qa-copilot Workflow Compatibility

The qa-copilot workflow is **sequential but user-invoked**:

```
User: /discover-endpoints → outputs endpoint-inventory.md
   ↓ (user reviews)
User: /analyze-auth → outputs auth-analysis.md
   ↓ (user reviews)
User: /analyze-traffic (optional) → prioritizes endpoints
   ↓ (user reviews)
User: /generate-collection → outputs postman/*.json
   ↓ (user reviews)
User: /generate-pipeline → outputs ado/*.yml
   ↓ (user reviews, runs tests)
User: /diagnose → triages failures
```

This maps perfectly to Copilot's prompt-based interaction. No automatic orchestration or handoffs needed.

---

## 2. Prerequisites

### Required Software

- **VS Code** 1.95+ (for latest Copilot features)
- **GitHub Copilot extension** with active subscription
- **Copilot Chat** enabled

### Enable Experimental Features

Add to VS Code settings (`settings.json`):

```json
{
  "chat.useAgentSkills": true,
  "chat.experimental.agentMode": true
}
```

### Verify Copilot Extensibility

1. Open VS Code
2. Press `Ctrl+Shift+P` → "GitHub Copilot: Chat"
3. Type `@` and verify you see built-in participants (@workspace, @terminal, @vscode)

---

## 3. File Structure Mapping

### Claude Code Structure

```
qa-copilot/
├── .claude-plugin/
│   └── plugin.json           # Plugin manifest
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
├── skills/
│   ├── endpoint-discovery/SKILL.md
│   ├── auth-patterns/SKILL.md
│   ├── dynatrace-analysis/SKILL.md
│   ├── test-tagging/SKILL.md
│   ├── postman-generation/SKILL.md
│   ├── test-data-planning/SKILL.md
│   ├── ado-pipeline-patterns/SKILL.md
│   └── failure-triage/SKILL.md
├── hooks/
│   └── hooks.json
└── README.md
```

### Copilot VS Code Structure

```
qa-copilot-vscode/
├── .github/
│   ├── prompts/              # Commands → Prompt files
│   │   ├── discover-endpoints.prompt.md
│   │   ├── analyze-auth.prompt.md
│   │   ├── analyze-traffic.prompt.md
│   │   ├── generate-collection.prompt.md
│   │   ├── generate-pipeline.prompt.md
│   │   └── diagnose.prompt.md
│   ├── agents/               # Agents → Agent files
│   │   ├── endpoint-discoverer.agent.md
│   │   ├── auth-analyzer.agent.md
│   │   ├── traffic-analyzer.agent.md
│   │   ├── collection-generator.agent.md
│   │   ├── pipeline-generator.agent.md
│   │   └── diagnostics-agent.agent.md
│   └── skills/               # Skills → Direct copy
│       ├── endpoint-discovery/
│       │   ├── SKILL.md
│       │   └── references/
│       ├── auth-patterns/
│       │   ├── SKILL.md
│       │   └── references/
│       └── ... (6 more)
├── .vscode/
│   └── settings.json         # Copilot settings
└── README.md
```

### Key Differences

| Aspect | Claude Code | Copilot VS Code |
|--------|-------------|-----------------|
| Root location | Plugin directory | `.github/` in workspace |
| Command extension | `.md` | `.prompt.md` |
| Agent extension | `.md` | `.agent.md` |
| Skill extension | `SKILL.md` | `SKILL.md` (same) |
| Config file | `.claude-plugin/plugin.json` | None (file-based discovery) |

---

## 4. Porting Commands

### Format Comparison

**Claude Code Command** (`commands/discover-endpoints.md`):

```markdown
---
description: Discover and inventory API endpoints in a codebase
allowed-tools: Read, Grep, Glob
argument-hint: [path-to-analyze]
---

Analyze the codebase to discover all API endpoints...

**Target Path**: $ARGUMENTS
```

**Copilot Prompt File** (`.github/prompts/discover-endpoints.prompt.md`):

```markdown
---
mode: agent
description: Discover and inventory API endpoints in a codebase
tools:
  - read
  - search
variables:
  - name: path
    description: Path to analyze (defaults to entire project)
    default: "."
---

Analyze the codebase to discover all API endpoints and build a comprehensive inventory.

**Target Path**: ${input:path}

## Analysis Goals
1. Identify the technology stack and framework
2. Find all controller/route files
3. Extract endpoint definitions (method, path, parameters)
4. Detect authentication requirements
5. Note any OpenAPI/Swagger definitions
6. Categorize endpoints by resource/domain

## Output Requirements
- Write the inventory to `qa-agent-output/endpoint-inventory.md`
- Include source file and line number for each endpoint
- Mark confidence levels for each discovery
- Group endpoints logically by resource

Before writing any files, ask for confirmation showing a preview.
```

### Conversion Rules

| Claude Code | Copilot Prompt | Notes |
|-------------|---------------|-------|
| `description:` | `description:` | Same |
| `allowed-tools:` | `tools:` | Lowercase, different tool names |
| `argument-hint:` | `variables:` + `${input:name}` | More structured |
| `$ARGUMENTS` | `${input:varname}` | Named variables |
| `$1`, `$2` | `${input:var1}`, `${input:var2}` | Positional → named |

### Tool Name Mapping

| Claude Code Tool | Copilot Tool | Notes |
|-----------------|--------------|-------|
| `Read` | `read` | Lowercase |
| `Grep` | `search` | Different name |
| `Glob` | `search` | Combined |
| `Write` | `write` | Lowercase |
| `Edit` | `edit` | Lowercase |
| `Bash` | `terminal` | Different name |

### All 6 Commands to Port

| Command | Source | Destination |
|---------|--------|-------------|
| `/discover-endpoints` | `commands/discover-endpoints.md` | `.github/prompts/discover-endpoints.prompt.md` |
| `/analyze-auth` | `commands/analyze-auth.md` | `.github/prompts/analyze-auth.prompt.md` |
| `/analyze-traffic` | `commands/analyze-traffic.md` | `.github/prompts/analyze-traffic.prompt.md` |
| `/generate-collection` | `commands/generate-collection.md` | `.github/prompts/generate-collection.prompt.md` |
| `/generate-pipeline` | `commands/generate-pipeline.md` | `.github/prompts/generate-pipeline.prompt.md` |
| `/diagnose` | `commands/diagnose.md` | `.github/prompts/diagnose.prompt.md` |

---

## 5. Porting Agents

### Format Comparison

**Claude Code Agent** (`agents/endpoint-discoverer.md`):

```markdown
---
name: endpoint-discoverer
description: Use this agent when you need to discover API endpoints...

<example>
Context: User wants to understand the API surface
user: "What API endpoints does this project have?"
assistant: "I'll analyze the codebase to discover all API endpoints."
</example>

model: inherit
color: cyan
tools: ["Read", "Grep", "Glob"]
---

You are an expert API analyst specializing in discovering and documenting API endpoints...
```

**Copilot Agent File** (`.github/agents/endpoint-discoverer.agent.md`):

```markdown
---
name: endpoint-discoverer
description: Discovers API endpoints in codebases. Use for building endpoint inventories, analyzing API surfaces, finding routes and controllers, or starting QA automation.
mode: agent
tools:
  - read
  - search
---

You are an expert API analyst specializing in discovering and documenting API endpoints across various technology stacks. You analyze codebases to build comprehensive endpoint inventories for QA automation.

## Core Responsibilities

1. Discover all API endpoints in a codebase (REST, GraphQL, SOAP)
2. Identify HTTP methods, paths, and parameters for each endpoint
3. Detect authentication requirements and middleware
4. Document request/response patterns where visible
5. Categorize endpoints by domain, resource, or module
6. Output findings with source file references and confidence levels

## Supported Tech Stacks

- **Java**: Spring Boot, JAX-RS
- **.NET**: ASP.NET Core
- **Node.js**: Express, NestJS
- **Python**: FastAPI, Flask, Django REST Framework

## Output Format

Generate inventory as markdown with:
- Summary (total endpoints, tech stack, confidence)
- Endpoints by resource (table format)
- Authentication patterns detected
- Recommendations for QA coverage
```

### Conversion Rules

| Claude Code | Copilot Agent | Notes |
|-------------|---------------|-------|
| `name:` | `name:` | Same |
| `description:` (with examples) | `description:` (shorter) | Remove `<example>` blocks |
| `model:` | Omit | Copilot uses its own model |
| `color:` | Omit | No equivalent |
| `tools:` (array) | `tools:` (list) | Lowercase names |
| System prompt (body) | Same | Keep the prompt content |

### All 6 Agents to Port

| Agent | Source | Destination |
|-------|--------|-------------|
| endpoint-discoverer | `agents/endpoint-discoverer.md` | `.github/agents/endpoint-discoverer.agent.md` |
| auth-analyzer | `agents/auth-analyzer.md` | `.github/agents/auth-analyzer.agent.md` |
| traffic-analyzer | `agents/traffic-analyzer.md` | `.github/agents/traffic-analyzer.agent.md` |
| collection-generator | `agents/collection-generator.md` | `.github/agents/collection-generator.agent.md` |
| pipeline-generator | `agents/pipeline-generator.md` | `.github/agents/pipeline-generator.agent.md` |
| diagnostics-agent | `agents/diagnostics-agent.md` | `.github/agents/diagnostics-agent.agent.md` |

---

## 6. Porting Skills

### Format Comparison

Skills use nearly identical formats. The main difference is frontmatter fields.

**Claude Code Skill** (`skills/endpoint-discovery/SKILL.md`):

```markdown
---
name: endpoint-discovery
description: Discover and inventory API endpoints across Java, .NET, Node.js, and Python frameworks for QA automation. Use when you need to identify REST endpoints...
---

# Endpoint Discovery

Discover all API endpoints in a codebase...
```

**Copilot Skill** (`.github/skills/endpoint-discovery/SKILL.md`):

```markdown
---
name: endpoint-discovery
description: Discover and inventory API endpoints across Java, .NET, Node.js, and Python frameworks for QA automation. Use when you need to identify REST endpoints...
---

# Endpoint Discovery

Discover all API endpoints in a codebase...
```

### Conversion Rules

**Skills are nearly identical** - the main work is:

1. Copy the skill directory to `.github/skills/`
2. Keep the same `SKILL.md` format
3. Copy all `references/` subdirectories

### All 8 Skills to Port

| Skill | Source | Destination |
|-------|--------|-------------|
| endpoint-discovery | `skills/endpoint-discovery/` | `.github/skills/endpoint-discovery/` |
| auth-patterns | `skills/auth-patterns/` | `.github/skills/auth-patterns/` |
| dynatrace-analysis | `skills/dynatrace-analysis/` | `.github/skills/dynatrace-analysis/` |
| test-tagging | `skills/test-tagging/` | `.github/skills/test-tagging/` |
| postman-generation | `skills/postman-generation/` | `.github/skills/postman-generation/` |
| test-data-planning | `skills/test-data-planning/` | `.github/skills/test-data-planning/` |
| ado-pipeline-patterns | `skills/ado-pipeline-patterns/` | `.github/skills/ado-pipeline-patterns/` |
| failure-triage | `skills/failure-triage/` | `.github/skills/failure-triage/` |

---

## 7. Hook Considerations (Future Extension)

### What Hooks Do in Claude Code

qa-copilot uses 3 hook types for safety guardrails:

| Hook | Purpose | Claude Code Implementation |
|------|---------|---------------------------|
| `PreToolUse(Write\|Edit)` | Validate write locations | Prompt-based check |
| `PreToolUse(Read)` | Block sensitive file reads | Prompt-based check |
| `PreToolUse(Bash)` | Block destructive commands | Prompt-based check |
| `Stop` | Verify task completion | Prompt-based check |

### Copilot Limitations

Copilot does not expose equivalent hook events to extensions. Options:

1. **Accept degradation**: Rely on Copilot's built-in safety instead of custom hooks
2. **Prompt-based guards**: Include safety instructions directly in agent/command prompts
3. **VS Code extension**: Build custom extension with tool wrappers (complex)

### Recommended: Prompt-Based Guards

Add safety instructions directly to agent prompts:

```markdown
## Safety Guardrails

NEVER modify:
- Application source code (src/, app/, lib/)
- Configuration files (.env, secrets, credentials)
- Package files (package.json, pom.xml, *.csproj)

ONLY write to:
- qa-agent-output/ (reports, inventories)
- docs/generated/ (OpenAPI drafts)
- postman/ (collections, environments)
- ado/ (pipeline templates)

Always ask for confirmation before writing files.
```

### When Extension Would Be Needed

Consider building a VS Code extension if:
- You need hard enforcement (not just suggestions)
- You want audit logging of tool usage
- You need to integrate with enterprise security policies

---

## 8. Testing Checklist

### Setup Verification

- [ ] VS Code 1.95+ installed
- [ ] GitHub Copilot extension active
- [ ] Copilot Chat working
- [ ] `.github/` directory created in workspace

### Command Testing

For each command, verify:

- [ ] `/discover-endpoints` - Invocable via prompt file
- [ ] `/analyze-auth` - Invocable via prompt file
- [ ] `/analyze-traffic` - Accepts file input
- [ ] `/generate-collection` - Writes to correct location
- [ ] `/generate-pipeline` - Writes to correct location
- [ ] `/diagnose` - Processes Newman output

### Agent Testing

For each agent, verify:

- [ ] Agent responds to relevant queries
- [ ] Agent uses correct tools
- [ ] Output follows expected format
- [ ] Source references included

### Skill Testing

For each skill, verify:

- [ ] Skill loads in Copilot Chat
- [ ] Reference files accessible
- [ ] Framework patterns recognized

### Known Limitations

| Feature | Claude Code | Copilot | Workaround |
|---------|-------------|---------|------------|
| PreToolUse hooks | Enforced | Not available | Prompt guards |
| Sensitive file blocking | Automatic | Manual | Prompt instructions |
| Output location enforcement | Automatic | Manual | Prompt instructions |
| Multi-agent orchestration | Task tool | Not native | Sequential prompts |

---

## 9. Appendix

### Capability Matrix (Full)

| Feature | Claude Code | Copilot VS Code | Portability |
|---------|-------------|-----------------|-------------|
| Slash Commands | commands/*.md | .github/prompts/*.prompt.md | Full |
| Agents | agents/*.md | .github/agents/*.agent.md | Full |
| Skills | skills/*/SKILL.md | .github/skills/*/SKILL.md | Full |
| MCP Tools | .mcp.json | .vscode/mcp.json | Full |
| Multi-Agent Orchestration | Task tool (native) | Handoffs + orchestrator | Partial |
| Hooks (PreToolUse) | hooks.json | Extension code | Partial |
| Hooks (PostToolUse) | hooks.json | VS Code events | Partial |
| Hooks (SessionStart/End) | hooks.json | Extension lifecycle | Partial |
| Hooks (Stop/SubagentStop) | hooks.json | Not exposed | None |
| Tool Permissions | Allow/deny lists | Extension code | Partial |
| Secret Handling | Deny patterns | Not native | None |

### Troubleshooting

**Prompt files not recognized**
- Ensure files are in `.github/prompts/` directory
- Check file extension is `.prompt.md`
- Verify YAML frontmatter syntax

**Agents not appearing**
- Ensure files are in `.github/agents/` directory
- Check file extension is `.agent.md`
- Restart VS Code

**Skills not loading**
- Verify `SKILL.md` filename (case-sensitive)
- Check frontmatter has `name:` and `description:`
- Ensure `references/` files exist

**Tools not working**
- Verify tool names use Copilot format (lowercase)
- Check `mode: agent` is set for agentic prompts

### References

- [GitHub Copilot Chat Documentation](https://docs.github.com/en/copilot/github-copilot-chat)
- [VS Code Language Model API](https://code.visualstudio.com/api/references/vscode-api#lm)
- [Model Context Protocol](https://modelcontextprotocol.io/)
- [Claude Code Plugin System](https://code.claude.com/docs/en/plugins)

---

## Quick Start: Porting Steps

1. **Create directory structure**
   ```bash
   mkdir -p .github/prompts .github/agents .github/skills
   ```

2. **Port skills first** (lowest risk)
   ```bash
   cp -r qa-copilot/skills/* .github/skills/
   ```

3. **Port commands** (convert to .prompt.md)
   - Update frontmatter (tools, variables)
   - Replace `$ARGUMENTS` with `${input:name}`

4. **Port agents** (convert to .agent.md)
   - Remove `<example>` blocks
   - Add `mode: agent`
   - Lowercase tool names

5. **Add safety instructions to prompts**
   - Copy guardrail text from hooks to agent prompts

6. **Test each component**
   - Use Copilot Chat to invoke
   - Verify expected behavior

---

*Generated from qa-copilot Claude Code plugin analysis*
*Source documents: Portable Copilot Plugin Blueprint.md, compass_artifact...md, Executive Summary.pdf*
