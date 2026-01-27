# VS Code GitHub Copilot Customization - Official Documentation Summary

> **Source**: Official VS Code Documentation (reviewed 2026-01-27)
> **URLs**: https://code.visualstudio.com/docs/copilot/customization/*

---

## Table of Contents

1. [Overview](#1-overview)
2. [Custom Instructions](#2-custom-instructions)
3. [Prompt Files](#3-prompt-files)
4. [Custom Agents](#4-custom-agents)
5. [Agent Skills](#5-agent-skills)
6. [Language Models](#6-language-models)
7. [MCP Servers](#7-mcp-servers)
8. [Quick Reference Tables](#8-quick-reference-tables)

---

## 1. Overview

VS Code provides six approaches to customize GitHub Copilot:

| Approach | Purpose | When to Use |
|----------|---------|-------------|
| **Custom Instructions** | Coding guidelines and standards | Project-wide conventions |
| **Agent Skills** | Specialized capability folders | Domain-specific tasks |
| **Prompt Files** | Reusable task prompts | Repetitive workflows |
| **Custom Agents** | Specialist AI personas | Planning, research, specialized roles |
| **Language Models** | Model selection | Task-specific optimization |
| **MCP Servers** | External tool integration | Databases, APIs, services |

### Recommended Implementation Order

1. Experiment with language models first
2. Establish basic guidelines via custom instructions
3. Automate repetitive tasks with prompt files
4. Extend capabilities with MCP servers
5. Build custom agents for specialized workflows

---

## 2. Custom Instructions

### File Types & Locations

| Type | Location | Auto-Apply |
|------|----------|------------|
| Workspace (single) | `.github/copilot-instructions.md` | Yes (with setting) |
| Conditional (multiple) | `.github/instructions/*.instructions.md` | Via `applyTo` glob |
| Multi-agent | `AGENTS.md` at workspace root | With setting |
| User profile | User settings directory | Across workspaces |

### Required Settings

```json
{
  "github.copilot.chat.codeGeneration.useInstructionFiles": true,
  "chat.useAgentsMdFile": true,
  "chat.useNestedAgentsMdFiles": true
}
```

### YAML Frontmatter Format

```yaml
---
name: "Display Name"
description: "Brief description of these instructions"
applyTo: "**/*.ts,**/*.tsx"
---
```

| Field | Required | Description |
|-------|----------|-------------|
| `name` | No | UI display name (defaults to filename) |
| `description` | No | Short explanation |
| `applyTo` | No | Glob patterns for auto-application |

### Example: General Coding Standards

```yaml
---
applyTo: "**"
---
# Project General Coding Standards

## Naming Conventions
- Use PascalCase for component names, interfaces, and type aliases
- Use camelCase for variables, functions, and methods
- Prefix private class members with underscore (_)
- Use ALL_CAPS for constants

## Error Handling
- Use try/catch blocks for async operations
- Implement proper error boundaries in React components
- Always log errors with contextual information
```

### Example: Language-Specific

```yaml
---
applyTo: "**/*.ts,**/*.tsx"
---
# TypeScript and React Guidelines

Apply the [general coding guidelines](./general-coding.instructions.md) to all code.

## TypeScript Guidelines
- Use TypeScript for all new code
- Follow functional programming principles where possible
- Use interfaces for data structures and type definitions
```

### Best Practices

- Keep instructions concise; each statement should stand alone
- Use multiple `*.instructions.md` files for task/language-specific guidance
- Store workspace instructions in version control
- Reference other files via Markdown links
- Use Markdown links to reference context (files, URLs)

---

## 3. Prompt Files

### Location & Extension

| Type | Location |
|------|----------|
| Workspace | `.github/prompts/*.prompt.md` |
| User | User profile directory |

### YAML Frontmatter Fields

```yaml
---
description: Brief explanation of the prompt's purpose
name: identifier-used-after-slash
argument-hint: Guidance text displayed in chat input
agent: 'ask' | 'edit' | 'agent' | custom-agent-name
model: GPT-4o | Claude Sonnet 4 | etc.
tools:
  - read
  - search
  - write
  - terminal
  - githubRepo
  - server-name/*
---
```

| Field | Required | Description |
|-------|----------|-------------|
| `description` | No | Explanation of prompt purpose |
| `name` | No | Identifier for `/name` invocation (defaults to filename) |
| `argument-hint` | No | Guidance text shown in chat input |
| `agent` | No | Agent to run: `ask`, `edit`, `agent`, or custom name |
| `model` | No | Specific model (uses picker selection if omitted) |
| `tools` | No | Array of available tools |

### Variable Syntax

| Variable Type | Syntax | Example |
|--------------|--------|---------|
| Workspace | `${workspaceFolder}` | Project root path |
| Selection | `${selection}`, `${selectedText}` | Editor selection |
| File | `${file}`, `${fileBasename}` | Current file info |
| Input | `${input:varName}` | User-provided value |
| Input with placeholder | `${input:varName:placeholder}` | With hint text |
| Tool reference | `#tool:toolName` | Reference a tool |

### Complete Example

```yaml
---
agent: 'agent'
model: GPT-4o
tools: ['githubRepo', 'search/codebase']
description: 'Generate a new React form component'
---
Your goal is to generate a new React form component based on the
templates in #tool:githubRepo contoso/react-templates.

Ask for the form name and fields if not provided.

Requirements:
* Use form design system components: [Form.md](../docs/design-system/Form.md)
* Use `react-hook-form` for form state management
* Always define TypeScript types for your form data
* Prefer *uncontrolled* components using register
```

### Invocation Methods

1. **Chat input**: Type `/` followed by prompt name
2. **Command palette**: Run "Chat: Run Prompt"
3. **Editor button**: Press play button in prompt file title

### Best Practices

- Explicitly state expected output format
- Include input/output examples
- Reference custom instructions via Markdown links
- Leverage built-in and input variables
- Test prompts using the editor's play button

---

## 4. Custom Agents

### Location & Extension

| Type | Location |
|------|----------|
| Workspace | `.github/agents/*.agent.md` |
| User | User profile directory |
| Legacy | `.chatmode.md` (auto-migrate available) |

### YAML Frontmatter Fields

```yaml
---
name: agent-identifier
description: What this agent does (shown as placeholder)
tools:
  - read
  - search
  - write
model: Claude Sonnet 4
infer: true
target: vscode | github-copilot
handoffs:
  - label: Button Label
    agent: target-agent-name
    prompt: Pre-filled prompt text
    send: false
mcp-servers:
  server-name:
    command: npx
    args: ["-y", "server-package"]
---
```

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Agent identifier |
| `description` | Yes | Shown as chat input placeholder |
| `tools` | No | Available tools array |
| `model` | No | Specific AI model |
| `infer` | No | Boolean enabling subagent (default: true) |
| `target` | No | Environment: `vscode` or `github-copilot` |
| `handoffs` | No | Workflow transitions to other agents |
| `mcp-servers` | No | MCP server configurations |

### Handoffs Configuration

```yaml
handoffs:
  - label: Start Implementation
    agent: implementation
    prompt: Now implement the plan outlined above.
    send: false
```

When `send: true`, the prompt automatically submits.

### Complete Example

```yaml
---
description: Generate an implementation plan for new features
name: Planner
tools: ['fetch', 'githubRepo', 'search', 'usages']
model: Claude Sonnet 4
handoffs:
  - label: Implement Plan
    agent: agent
    prompt: Implement the plan outlined above.
    send: false
---

# Planning Instructions

Your task is to generate an implementation plan for a new feature or refactoring.
Don't make any code edits, just generate a plan.

## Process
1. Analyze the request
2. Research existing code patterns
3. Propose implementation steps
4. Identify risks and dependencies
```

### Best Practices

- Restrict tools based on agent purpose
- Use handoffs for multi-step workflows
- Reference instruction files via Markdown links
- Define clear, task-appropriate guidelines

---

## 5. Agent Skills

### Location & Extension

| Type | Location |
|------|----------|
| Project (recommended) | `.github/skills/<skill-name>/SKILL.md` |
| Project (legacy) | `.claude/skills/<skill-name>/SKILL.md` |
| Personal (recommended) | `~/.copilot/skills/<skill-name>/SKILL.md` |
| Personal (legacy) | `~/.claude/skills/<skill-name>/SKILL.md` |

### Required Setting

```json
{
  "chat.useAgentSkills": true
}
```

### Directory Structure

```
.github/skills/
├── webapp-testing/
│   ├── SKILL.md
│   ├── test-template.js
│   └── examples/
└── github-actions-debugging/
    └── SKILL.md
```

### SKILL.md Format

```yaml
---
name: skill-identifier
description: What the skill does and when to use it
---

# Skill Title

Instructions and documentation here...
```

| Field | Required | Constraints |
|-------|----------|-------------|
| `name` | Yes | Lowercase with hyphens, max 64 chars |
| `description` | Yes | Include capabilities AND use cases, max 1024 chars |

### Complete Example

```yaml
---
name: webapp-testing
description: Guide for testing web applications using Playwright. Use this when asked to create or run browser-based tests, debug failing tests, or set up test infrastructure.
---

# Web Application Testing with Playwright

This skill helps you create and run browser-based tests.

## When to use this skill

Use when you need to:
- Create new Playwright tests for web applications
- Debug failing browser tests
- Set up test infrastructure for a new project

## Creating tests

1. Review the [test template](./test-template.js)
2. Identify the user flow to test
3. Create a new test file in `tests/`
4. Use Playwright's locators (prefer role-based selectors)
5. Add assertions to verify expected behavior

## Running tests

```bash
npx playwright test
npx playwright test --debug
```
```

### How Skills Load (Progressive Disclosure)

1. **Level 1 - Discovery**: Copilot reads `name` and `description` from frontmatter
2. **Level 2 - Instructions**: When matched, full `SKILL.md` body loads
3. **Level 3 - Resources**: Additional files load only when explicitly referenced

Skills activate automatically based on prompt relevance.

### Skills vs Instructions Comparison

| Aspect | Agent Skills | Custom Instructions |
|--------|--------------|-------------------|
| Purpose | Specialized workflows | Coding standards |
| Portability | Cross-platform (VS Code, CLI, agent) | VS Code/GitHub.com only |
| Content | Instructions, scripts, examples | Instructions only |
| Scope | Task-specific, on-demand | Always applied or via glob |
| Standard | Open standard (agentskills.io) | VS Code-specific |

---

## 6. Language Models

### Model Selection

- Use **model picker** in chat input field
- Auto-selection available (VS Code 1.104+): chooses optimal model while managing rate limits

### Auto Model Selection

Automatically selects between: Claude Sonnet 4, GPT-5, GPT-5 mini, and others based on:
- Model performance
- Rate limits
- Request multipliers

### Model Preferences

```yaml
# In prompt or agent frontmatter
model: GPT-4o
model: Claude Sonnet 4
model: o1
```

### Bring Your Own Key (BYOK)

- Custom OpenAI-compatible models (VS Code Insiders 1.104+)
- Built-in providers: OpenAI, Ollama
- Local compute capabilities
- Note: BYOK applies only to chat, not inline suggestions

---

## 7. MCP Servers

### Configuration Locations

| Scope | Location |
|-------|----------|
| Workspace | `.vscode/mcp.json` |
| User | User configuration directory |
| Dev Container | `devcontainer.json` under `customizations.vscode.mcp` |

### Required Setting

```json
{
  "chat.mcp.gallery.enabled": true
}
```

### JSON Format

```json
{
  "servers": {
    "server-name": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "package-name"],
      "env": {
        "API_KEY": "${input:api-key}"
      }
    }
  },
  "inputs": [
    {
      "type": "promptString",
      "id": "api-key",
      "description": "API Key",
      "password": true
    }
  ]
}
```

### Server Types

| Type | Use Case | Required Fields |
|------|----------|-----------------|
| `stdio` | Local command execution | `command`, `args` (optional) |
| `http` | Remote server | `url` |
| `sse` | Event streaming (legacy) | `url` |

### stdio Server Example

```json
{
  "servers": {
    "memory": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    }
  }
}
```

### HTTP Server Example

```json
{
  "servers": {
    "github-mcp": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp"
    }
  }
}
```

### Input Variables for Secrets

```json
{
  "inputs": [
    {
      "type": "promptString",
      "id": "perplexity-key",
      "description": "Perplexity API Key",
      "password": true
    }
  ],
  "servers": {
    "perplexity": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "server-perplexity-ask"],
      "env": {
        "PERPLEXITY_API_KEY": "${input:perplexity-key}"
      }
    }
  }
}
```

### Dev Container Configuration

```json
{
  "image": "mcr.microsoft.com/devcontainers/typescript-node:latest",
  "customizations": {
    "vscode": {
      "mcp": {
        "servers": {
          "playwright": {
            "command": "npx",
            "args": ["-y", "@microsoft/mcp-server-playwright"]
          }
        }
      }
    }
  }
}
```

### Best Practices

- Only add servers from trusted sources
- Use `.env` files instead of hardcoding credentials
- Use `${workspaceFolder}` for workspace paths
- Enable MCP server sync across devices
- Maximum 128 tools per chat request

---

## 8. Quick Reference Tables

### File Extensions & Locations

| Component | Extension | Location |
|-----------|-----------|----------|
| Custom Instructions (single) | `.md` | `.github/copilot-instructions.md` |
| Custom Instructions (multiple) | `.instructions.md` | `.github/instructions/` |
| Prompt Files | `.prompt.md` | `.github/prompts/` |
| Custom Agents | `.agent.md` | `.github/agents/` |
| Agent Skills | `SKILL.md` | `.github/skills/<name>/` |
| MCP Config | `.json` | `.vscode/mcp.json` |

### Required VS Code Settings

```json
{
  "github.copilot.chat.codeGeneration.useInstructionFiles": true,
  "chat.useAgentSkills": true,
  "chat.useAgentsMdFile": true,
  "chat.mcp.gallery.enabled": true
}
```

### Tool Names Reference

| Tool | Purpose |
|------|---------|
| `read` | Read files |
| `write` | Write files |
| `edit` | Edit files |
| `search` | Search codebase |
| `terminal` | Run terminal commands |
| `fetch` | HTTP requests |
| `githubRepo` | GitHub repository access |
| `usages` | Find symbol usages |
| `search/codebase` | Semantic code search |

### Frontmatter Quick Reference

**Prompt File:**
```yaml
---
description: What this prompt does
agent: 'agent'
tools: ['read', 'search']
---
```

**Agent File:**
```yaml
---
name: agent-name
description: What this agent does
tools: ['read', 'search']
---
```

**Skill File:**
```yaml
---
name: skill-name
description: What this skill does and when to use it
---
```

---

## Version Information

- **VS Code Minimum**: 1.102+
- **Documentation Source**: code.visualstudio.com/docs/copilot/customization
- **Last Reviewed**: 2026-01-27
