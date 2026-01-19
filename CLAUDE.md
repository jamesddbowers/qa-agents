# QA Automation Agents Project

## Project Overview

This project builds **qa-copilot**, a Claude Code plugin providing QA automation agents for API integration testing. The agents operate as VS Code co-pilot assistants with human-in-the-loop guardrails.

## Mission

Create a suite of QA automation agents that:

1. Analyze codebases to discover API endpoints, auth patterns, and data dependencies
2. Generate Postman collections for smoke and regression testing
3. Create Azure DevOps pipeline templates for Newman execution
4. Provide diagnostics and failure triage capabilities
5. Never act autonomously — always ask permission before running commands or writing files

## Plugin Name

`qa-copilot`

## Current Phase

**Phase 1 MVP**: API integration testing with Postman + Newman in Azure DevOps

## Architecture Principles (Claude Code Mastery V3)

### CLAUDE.md Hierarchy

- **Global** (`~/.claude/CLAUDE.md`): Security policies, credentials
- **Project** (`./CLAUDE.md`): This file — QA automation context
- **Local** (`./CLAUDE.local.md`): Personal overrides (gitignored)

### Key Patterns

1. **Skills & Commands Merged**: Use `.claude/skills/*/SKILL.md` structure
2. **Progressive Disclosure**: Load content in stages to optimize tokens
3. **Hooks = Enforcement**: CLAUDE.md rules are suggestions; hooks always execute
4. **Single-Purpose Agents**: Design for focused tasks (39% performance drop when mixing topics)
5. **Defense in Depth**: Behavioral rules → Access control → Git safety → Hooks

### Foundational Pattern Sources (MUST USE)

When building qa-copilot components, reference these CRITICAL sources:

| Component Type | Reference Source | Location | Key Patterns |
|----------------|------------------|----------|--------------|
| **Plugin structure** | plugin-dev | `research/sources/possible-sources-to-utilize/plugin-dev/` | plugin.json, agents/, commands/, hooks/, skills/ organization |
| **Skills (SKILL.md)** | skill-creator | `research/sources/possible-sources-to-utilize/skill-creator/` | YAML frontmatter, progressive disclosure, references/ organization |
| **Agents** | plugin-dev | Same as above | Agent frontmatter with `<example>` blocks for triggering |
| **Commands** | plugin-dev | Same as above | YAML frontmatter, argument handling |
| **Hooks** | plugin-dev | Same as above | hooks.json structure, PreToolUse/PostToolUse patterns |

**Skill Creation Rules** (from skill-creator):
- Frontmatter `description` is the PRIMARY TRIGGERING MECHANISM - include all "when to use" info there
- Keep SKILL.md body under 500 lines - move details to `references/` folder
- Use domain-based organization for tech-stack variations (java-patterns.md, dotnet-patterns.md, etc.)
- Prefer concise examples over verbose explanations
- Match freedom level to task fragility (low freedom = specific scripts for fragile operations)

### MCP Status

- **Phase 1 (MVP)**: No MCP connections — agents consume files/exports only
- **Phase 2+**: Playwright MCP, Context7, potentially others

## MVP Scope (8 Steps)

1. Build endpoint inventory from code
2. Solve authentication without browser
3. Ingest Dynatrace exports and prioritize endpoints
4. Define smoke vs regression tagging conventions
5. Generate Postman collections (smoke + regression)
6. Create test data plan + seeding strategy
7. Generate Azure DevOps pipeline templates
8. Build diagnostics + failure triage workflows

## Target Tech Stacks

- **Backend**: Java (Spring Boot, JAX-RS), potentially .NET (ASP.NET Core)
- **Frontend**: HTML, JavaScript, CSS, TypeScript
- **CI/CD**: Azure DevOps YAML pipelines
- **Testing**: Postman/Newman (Phase 1), Playwright (Phase 2+), k6 (Phase 5)

## Operating Guardrails

1. **Read-only by default** — No edits to app source code
2. **Human-in-the-loop** — Ask permission before running commands or writing files
3. **Safe output locations** — Write only to designated folders:
   - `/qa-agent-output/` — Reports, inventories, diagrams
   - `/docs/generated/` — OpenAPI drafts
   - `/postman/` — Collections and environments
   - `/ado/` — Pipeline templates
4. **Explainability** — Every inference includes source pointers and confidence levels
5. **No pushing** — Agents generate commit/PR notes but never push code

## NEVER EVER DO (Security Gatekeeper)

These rules are **ABSOLUTE** — no exceptions:

### NEVER Publish Sensitive Data

- NEVER publish passwords, API keys, tokens, or secrets to git/npm/docker
- Before ANY commit: verify no secrets are included
- NEVER output secrets in suggestions, code comments, or documentation

### NEVER Commit .env Files

- NEVER commit `.env`, `.env.local`, `secrets.json`, or credential files to git
- ALWAYS verify `.env` is in `.gitignore`
- Use `.env.example` with placeholders instead

### NEVER Access Sensitive Files Without Permission

- NEVER read `.env`, `secrets.json`, `id_rsa`, or credential files without explicit user approval
- If you need auth info for testing, ask the user to provide it explicitly

### NEVER Run Destructive Commands

- NEVER run `rm -rf`, `drop database`, or other destructive commands without confirmation
- NEVER modify production configurations
- NEVER push to main/master without explicit instruction

### Why This Matters

[Research shows](https://www.knostic.ai/blog/claude-loads-secrets-without-permission) Claude Code can automatically read `.env` files without explicit permission. These rules create a behavioral gatekeeper — even if access exists, we won't output secrets.

## Directory Structure

```text
qa-agents/                          # This repo
├── CLAUDE.md                       # This file
├── qa_automation_agent_plan.md     # Original strategic plan
├── qa-copilot/                     # The plugin
│   ├── .claude-plugin/
│   │   └── plugin.json
│   ├── commands/
│   ├── agents/
│   ├── skills/
│   ├── hooks/
│   └── README.md
├── research/                       # Research framework
│   ├── research-template.md        # Full source documentation template (Stage 3)
│   ├── readme-evaluation-template.md  # Lightweight README analysis template (Stage 1)
│   ├── extraction-criteria.md      # Extraction guidelines by source type
│   ├── gap-tracker.md             # Coverage gaps and research priorities
│   ├── source-priority-index.md   # README analysis and priority rankings (Stage 2)
│   └── sources/
│       ├── possible-sources-to-utilize/  # Stage 1: README staging area
│       │   ├── [source-name-1]/
│       │   │   ├── README.md      # Original README from source
│       │   │   └── evaluation.md  # Analysis using readme-evaluation-template.md
│       │   ├── [source-name-2]/
│       │   │   ├── README.md
│       │   │   └── evaluation.md
│       │   └── ...
│       ├── complete-guide-to-claude-code-v3.md  # Stage 3: Fully extracted sources
│       └── claude-code-mastery-v3-extraction.md
└── backlog/                        # Future phase patterns
    └── future-phases.md
```

## Workflow

### Research-First Approach

The project uses a **staged research workflow** to efficiently evaluate and extract patterns from external sources:

#### Stage 1: README Collection & Evaluation

1. **User adds README files** to `research/sources/possible-sources-to-utilize/[source-name]/README.md`
   - This is a lightweight staging area for initial evaluation
   - README files provide enough context to assess value before committing to full extraction

2. **Create README evaluation** using `research/readme-evaluation-template.md`
   - Assess QA relevance and applicability to our tech stacks (Java/Spring, .NET, TypeScript)
   - Identify which MVP steps (1-8) the source could support
   - Recognize potential agent/skill/command patterns
   - Check alignment with human-in-the-loop guardrails
   - Make initial priority recommendation (High/Medium/Low)

3. **Document findings** in individual evaluation files
   - Save as `research/sources/possible-sources-to-utilize/[source-name]/evaluation.md`
   - Use the template to ensure consistency

#### Stage 2: Prioritization & Planning

1. **Review all README evaluations** collectively
   - Compare sources against each other
   - Identify which sources address high-priority research gaps from `gap-tracker.md`

2. **Update source-priority-index.md** with rankings
   - Organize sources into High/Medium/Low priority tiers
   - Provide justification for each ranking
   - Identify which sources to request in full, in what order

3. **Create extraction plan**
   - Determine next sources to fully extract
   - Identify questions that need answering
   - Map extraction priorities to MVP step gaps

#### Stage 3: Full Extraction & Integration

Once a source is prioritized and requested in full:

1. **User provides full repo/file cluster** for the prioritized source
2. **Use research-template.md** for comprehensive documentation
3. **Apply extraction-criteria.md** guidelines by source type
4. **Extract patterns** and integrate into agents/skills/commands
5. **Update gap-tracker.md** to mark research complete
6. **Archive non-MVP patterns** to `backlog/future-phases.md`
7. **Build/update agents** iteratively as research accumulates

#### Quick Reference

- **Stage 1 Template**: `research/readme-evaluation-template.md` (lightweight)
- **Stage 3 Template**: `research/research-template.md` (comprehensive)
- **Priority Tracking**: `research/source-priority-index.md` (living document)
- **Gap Tracking**: `research/gap-tracker.md` (coverage status)
- **Extraction Guidelines**: `research/extraction-criteria.md` (what to extract)

### Iteration Cycle

1. **Theoretical Build**: Create agents based on best practices and research
2. **User Testing**: User tests against real repos in separate instance
3. **Feedback**: User reports findings back to this project
4. **Iterate**: Refine agents based on feedback

### Multi-Platform Strategy

This project has a **two-phase approach** with a research sub-phase:

#### Phase 1: Claude Code Plugin (CURRENT)

Build qa-copilot as a fully functional Claude Code plugin first:
- Get the plugin structure, agents, skills, commands, and hooks working correctly
- Test against real repositories
- Iterate based on feedback
- This becomes the "reference implementation"

**Why Claude Code first?**
- Well-documented plugin system (plugin-dev, skill-creator sources)
- Faster iteration cycle for testing patterns
- Creates working patterns we can then port

#### Phase 1.5: Copilot Research (REQUIRED BEFORE PHASE 2)

Before porting to other platforms, conduct in-depth research on:

| Platform | Research Needed |
|----------|-----------------|
| **GitHub Copilot** | Custom instructions, workspace agents, chat participants API |
| **VS Code Extensions** | Extension API, language server protocol, webview panels |
| **ChatGPT** | Custom GPTs, Actions, conversation starters |
| **Gemini** | Gems, extensions, API patterns |

**Research Questions:**
1. What is the equivalent of a "skill" in each platform?
2. How do agents/commands map to each platform's interaction model?
3. What are the limitations vs Claude Code plugins?
4. Can we create a common abstraction layer?

**Output**: Document mapping patterns in `research/copilot-migration/` (to be created)

#### Phase 2: Multi-Platform Port

After research is complete:
1. Create platform-specific versions in dedicated directories:
   - `copilot/` — GitHub Copilot / VS Code
   - `chatgpt/` — Custom GPT versions
   - `gemini/` — Gemini equivalents (if applicable)
2. Document the mapping from Claude Code → each platform
3. Test and iterate on each platform version

**Note**: Phase 1.5 research can happen in parallel with Phase 1 testing, or after Claude Code version is stable. Decision point: after MVP Steps 1-8 are working.

## Key References

### Primary Guide

- [Claude Code Mastery V3](https://thedecipherist.github.io/claude-code-mastery/) — Core reference for this project
- [GitHub: TheDecipherist/claude-code-mastery](https://github.com/TheDecipherist/claude-code-mastery) — Templates, hooks, skills
- Local copy: `research/sources/complete-guide-to-claude-code-v3.md`

### Official Anthropic Documentation

- [Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)
- [Effective Context Engineering](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- [Model Context Protocol](https://www.anthropic.com/news/model-context-protocol)
- [Agent Skills](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills)
- [Claude Code Plugins Docs](https://code.claude.com/docs/en/plugins)

### Research Papers

- [LLMs Get Lost In Multi-Turn](https://arxiv.org/pdf/2505.06120) — 39% performance drop when mixing topics
- [Context Rot Research](https://research.trychroma.com/context-rot) — Token window degradation

### Security Resources

- [Claude loads secrets without permission](https://www.knostic.ai/blog/claude-loads-secrets-without-permission)
- [Claude Code Security Best Practices](https://www.backslash.security/blog/claude-code-security-best-practices)

### Tools & Patterns

- [plugin-dev:create-plugin](https://github.com/anthropics/claude-code/tree/main/plugins/plugin-dev)
- [awesome-mcp-servers](https://github.com/punkpeye/awesome-mcp-servers) — 76k+ stars
- [mcpservers.org](https://mcpservers.org) — Searchable MCP directory
- [Compound Engineering](https://every.to/chain-of-thought/compound-engineering-how-every-codes-with-agents)
- [Claude Code Hooks Guardrails](https://paddo.dev/blog/claude-code-hooks-guardrails/)

## Session Quick Start

When starting a new session:

1. Review this file for project context
2. Check research status:
   - `research/source-priority-index.md` - Sources being evaluated and their priorities
   - `research/gap-tracker.md` - Current coverage gaps and what's needed
3. Check the plan file for detailed task breakdown
4. Continue where the previous session left off

### Context Management

**Use `/clear` liberally** — Research shows a [39% performance drop](https://arxiv.org/pdf/2505.06120) when mixing topics. Clear context between unrelated tasks:

| Scenario | Action |
| -------- | ------ |
| New feature/task | New chat or `/clear` |
| Switching MVP steps | `/clear` then start fresh |
| 20+ turns elapsed | Start fresh |
| Research vs implementation | Separate chats |

**One Task, One Chat** — Keep chats focused on single purposes for best results.
