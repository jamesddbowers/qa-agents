# Plugin-Dev Evaluation

## Source Overview

| Field | Value |
|-------|-------|
| **Name** | plugin-dev |
| **Type** | Plugin Development Toolkit |
| **Version** | 0.1.0 |
| **Author** | Daisy Hollman (daisy@anthropic.com) |
| **Source** | anthropics/claude-code official plugins |
| **License** | MIT |

## Purpose

Comprehensive toolkit for developing Claude Code plugins with expert guidance on hooks, MCP integration, plugin structure, and marketplace publishing. Contains 7 specialized skills.

## Structure Analysis

```
plugin-dev/
├── .claude-plugin/
│   └── plugin.json
├── commands/
│   └── create-plugin.md          # /plugin-dev:create-plugin
├── agents/
│   ├── agent-creator.md          # AI-assisted agent generation
│   ├── plugin-validator.md       # Plugin validation
│   └── skill-reviewer.md         # Skill quality review
└── skills/
    ├── hook-development/
    │   ├── SKILL.md (713 lines)
    │   ├── references/
    │   ├── examples/
    │   └── scripts/
    ├── mcp-integration/
    │   ├── SKILL.md
    │   └── references/
    ├── plugin-structure/
    │   ├── SKILL.md (477 lines)
    │   └── references/
    ├── plugin-settings/
    │   ├── SKILL.md
    │   ├── references/
    │   └── scripts/
    ├── command-development/
    │   ├── SKILL.md (835 lines)
    │   └── references/
    ├── agent-development/
    │   ├── SKILL.md (416 lines)
    │   ├── references/
    │   └── examples/
    └── skill-development/
        ├── SKILL.md (638 lines)
        └── references/
```

## Component Analysis

### Skills (7 total)

| Skill | Purpose | SKILL.md Size | Key Patterns |
|-------|---------|---------------|--------------|
| hook-development | Event-driven automation | 713 lines | Prompt-based hooks, command hooks, PreToolUse/PostToolUse/Stop patterns |
| mcp-integration | MCP server config | - | stdio/SSE/HTTP servers, OAuth, ${CLAUDE_PLUGIN_ROOT} |
| plugin-structure | Directory layout | 477 lines | plugin.json manifest, auto-discovery, component organization |
| plugin-settings | Configuration patterns | - | .local.md files, YAML frontmatter parsing |
| command-development | Slash commands | 835 lines | $ARGUMENTS, $1/$2, @file references, !`bash` execution |
| agent-development | Subagent creation | 416 lines | <example> blocks for triggering, system prompt design |
| skill-development | Skill creation | 638 lines | Progressive disclosure, trigger phrases, imperative style |

### Agents (3 total)

| Agent | Purpose |
|-------|---------|
| agent-creator | AI-assisted agent generation using Claude Code's prompt |
| plugin-validator | Validate plugin structure and configuration |
| skill-reviewer | Review skill quality and best practices |

### Commands (1 total)

| Command | Purpose |
|---------|---------|
| /plugin-dev:create-plugin | Guided 8-phase plugin creation workflow |

## MVP Alignment

| MVP Step | Alignment | Notes |
|----------|-----------|-------|
| Step 1: Endpoint inventory | INDIRECT | Plugin structure for organizing agents |
| Step 2: Auth patterns | INDIRECT | MCP integration for external services |
| Step 3: Dynatrace ingest | INDIRECT | Plugin settings for configuration |
| Step 4: Tagging conventions | INDIRECT | Command patterns for workflows |
| Step 5: Postman collections | INDIRECT | Agent patterns for generation tasks |
| Step 6: Test data plan | INDIRECT | Skill patterns for knowledge domains |
| Step 7: ADO pipelines | INDIRECT | Command/hook patterns |
| Step 8: Diagnostics | INDIRECT | Agent patterns for analysis tasks |

**Overall Alignment**: CRITICAL - Foundation for building qa-copilot plugin itself

## Extractable Patterns

### 1. Plugin Directory Structure (CRITICAL)
```
plugin-name/
├── .claude-plugin/
│   └── plugin.json          # Required: Plugin manifest
├── commands/                 # Slash commands (.md files)
├── agents/                   # Subagent definitions (.md files)
├── skills/                   # Agent skills (subdirectories)
│   └── skill-name/
│       └── SKILL.md         # Required for each skill
├── hooks/
│   └── hooks.json           # Event handler configuration
├── .mcp.json                # MCP server definitions
└── scripts/                 # Helper scripts and utilities
```

### 2. Agent Frontmatter Pattern (CRITICAL)
```yaml
---
name: agent-identifier
description: Use this agent when [conditions]. Examples:

<example>
Context: [Situation description]
user: "[User request]"
assistant: "[How assistant should respond]"
<commentary>
[Why this agent should be triggered]
</commentary>
</example>

model: inherit
color: blue
tools: ["Read", "Write", "Grep"]
---

You are [agent role description]...
```

### 3. Command Frontmatter Pattern
```yaml
---
description: Command description
allowed-tools: Read, Grep, Bash(git:*)
model: sonnet
argument-hint: [arg1] [arg2]
---

Review @$1 for issues...
```

### 4. Dynamic Argument Patterns
- `$ARGUMENTS` - All arguments as single string
- `$1`, `$2`, `$3` - Positional arguments
- `@$1` - File reference from argument
- `!`bash command`` - Inline bash execution

### 5. Hook Configuration Pattern
```json
{
  "description": "Optional description",
  "hooks": {
    "PreToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{
        "type": "prompt",
        "prompt": "Validate file write safety..."
      }]
    }]
  }
}
```

### 6. Progressive Disclosure Pattern
```
Metadata (always loaded) → SKILL.md body (when triggered) → references/ (as needed)
```

Target word counts:
- Frontmatter: ~100 words
- SKILL.md body: 1,500-2,000 words
- references/: Unlimited (loaded on demand)

### 7. Skill Trigger Description Pattern
```yaml
description: This skill should be used when the user asks to "specific phrase 1", "specific phrase 2", "specific phrase 3". Include exact phrases users would say.
```

### 8. Writing Style Standards
- **Commands**: Instructions FOR Claude, not messages TO user
- **Agent descriptions**: Third person ("This agent should be used when...")
- **SKILL.md body**: Imperative/infinitive form ("Configure X", "Validate Y")
- **Never**: Second person ("You should...")

### 9. Hook Event Types
| Event | When | Use For |
|-------|------|---------|
| PreToolUse | Before tool | Validation, modification |
| PostToolUse | After tool | Feedback, logging |
| UserPromptSubmit | User input | Context, validation |
| Stop | Agent stopping | Completeness check |
| SubagentStop | Subagent done | Task validation |
| SessionStart | Session begins | Context loading |
| SessionEnd | Session ends | Cleanup, logging |
| PreCompact | Before compact | Preserve context |
| Notification | User notified | Logging |

### 10. ${CLAUDE_PLUGIN_ROOT} Usage
- ALWAYS use for portable paths
- Available in hooks, commands, scripts
- Resolves to plugin installation directory

## Tech Stack Compatibility

| Stack | Compatibility | Notes |
|-------|---------------|-------|
| Java/Spring Boot | N/A | Plugin structure is language-agnostic |
| .NET/ASP.NET | N/A | Plugin structure is language-agnostic |
| TypeScript | YES | Example scripts could use Node |
| Azure DevOps | N/A | Plugin patterns for CI/CD commands |

## Human-in-the-Loop Alignment

| Guardrail | Addressed | Pattern |
|-----------|-----------|---------|
| Read-only by default | YES | allowed-tools restricts tool access |
| Ask permission | YES | PreToolUse hooks for validation |
| Safe output locations | YES | Hook validation patterns |
| Explainability | YES | systemMessage in hook output |
| No pushing | YES | Hook can block destructive actions |

## Quality Assessment

| Criterion | Score | Notes |
|-----------|-------|-------|
| Documentation completeness | 10/10 | Comprehensive, well-organized |
| Code examples | 10/10 | Multiple working examples per skill |
| Reusability | 10/10 | Direct patterns for qa-copilot |
| Maintenance | 10/10 | Official Anthropic source |
| MVP relevance | CRITICAL | Foundation for plugin development |

## Key Insights

1. **Official Patterns**: This is THE authoritative source for Claude Code plugin development
2. **Progressive Disclosure**: Critical pattern to keep context lean while providing depth
3. **Triggering via <example> blocks**: Key to reliable agent activation
4. **Hook Types**: Prompt-based (LLM reasoning) vs Command (deterministic) - choose appropriately
5. **Tool Restriction**: Use `allowed-tools` and `tools` fields to limit agent capabilities
6. **Validation Utilities**: Scripts for validating hooks, agents, skills

## Recommended Extractions

### High Priority (Use Immediately)
1. Plugin directory structure template
2. Agent frontmatter format with <example> blocks
3. Command frontmatter with argument patterns
4. Progressive disclosure organizational pattern
5. Writing style standards

### Medium Priority (Reference)
1. Hook configuration patterns
2. MCP integration patterns
3. Skill development workflow
4. Validation utility patterns

### Low Priority (Phase 2+)
1. MCP server authentication
2. Plugin marketplace publishing

## Priority Recommendation

**Priority: CRITICAL**

**Justification**: This is the official Anthropic plugin development toolkit. It defines the patterns and structures we MUST follow for qa-copilot. Every agent, command, skill, and hook in our plugin should follow these patterns exactly.

**Action**: Use as PRIMARY REFERENCE throughout qa-copilot development. Extract all patterns into local templates.

## Gap Coverage

| Research Gap | Covered | How |
|--------------|---------|-----|
| Plugin architecture | YES | Complete structure in plugin-structure skill |
| Agent triggering | YES | <example> blocks in agent-development skill |
| Command patterns | YES | Comprehensive in command-development skill |
| Hook patterns | YES | Complete in hook-development skill |
| Skill patterns | YES | Progressive disclosure in skill-development skill |
| Validation patterns | YES | Utilities in scripts/ directories |

## Comparison Notes

- **vs pr-review-toolkit**: Plugin-dev is the reference; pr-review-toolkit demonstrates application
- **vs code-review**: Plugin-dev is foundation; code-review shows multi-agent patterns
- **vs documate/clauditor/testforge**: These use patterns defined in plugin-dev

## Summary

Plugin-dev is the CRITICAL foundation source for building qa-copilot. It provides:
- Official plugin directory structure
- Agent, command, skill, and hook patterns
- Writing style standards
- Progressive disclosure methodology
- Validation utilities

This source should be referenced throughout development and its patterns followed exactly.
