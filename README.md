# qa-agents

QA Automation Agents for API Integration Testing — A Claude Code Plugin Project

## Overview

This project builds **qa-copilot**, a Claude Code plugin providing human-in-the-loop QA automation agents. These agents analyze codebases, generate test collections, create CI/CD pipelines, and provide diagnostics — all while asking permission before taking actions.

## Current Status

**Phase 1 MVP**: API integration testing with Postman + Newman in Azure DevOps

## Quick Start

```bash
# Install the plugin (once agents are built)
claude plugin add ./qa-copilot

# Example commands
/qa-copilot:discover-endpoints
/qa-copilot:generate-postman
/qa-copilot:generate-pipeline
```

## Project Structure

```text
qa-agents/
├── CLAUDE.md                    # Project context for Claude sessions
├── qa_automation_agent_plan.md  # Strategic roadmap
├── qa-copilot/                  # The Claude Code plugin
│   ├── .claude-plugin/
│   │   └── plugin.json
│   ├── commands/                # Slash commands
│   ├── agents/                  # Specialized agents
│   ├── skills/                  # Domain knowledge
│   └── hooks/                   # Enforcement hooks
├── research/                    # Research framework
│   ├── research-template.md     # Template for cataloging sources
│   ├── extraction-criteria.md   # What to extract
│   ├── gap-tracker.md           # Current gaps and priorities
│   └── sources/                 # Archived source references
└── backlog/                     # Future phase patterns
    └── future-phases.md
```

## MVP Scope (8 Steps)

1. **Build endpoint inventory from code** — Discover APIs from Java/.NET/TS codebases
2. **Solve auth without browser** — Enable pure API testing with token workflows
3. **Ingest Dynatrace exports** — Prioritize endpoints by real-world usage
4. **Define tagging conventions** — Smoke vs regression test classification
5. **Generate Postman collections** — Create runnable test suites
6. **Test data strategy** — Seeding and cleanup for reliable tests
7. **ADO pipeline templates** — Newman execution in Azure DevOps
8. **Diagnostics + triage** — Classify and debug test failures

## Operating Principles

- **Read-only by default** — Agents analyze but don't modify app code
- **Human-in-the-loop** — Always ask permission before actions
- **Explainability** — Every inference includes source pointers and confidence
- **No pushing** — Generate commit/PR notes but never push code

## Target Tech Stacks

- **Backend**: Java (Spring Boot), .NET (ASP.NET Core)
- **Frontend**: HTML, JavaScript, TypeScript
- **CI/CD**: Azure DevOps
- **Testing**: Postman/Newman (Phase 1), Playwright (Phase 2+)

## Roadmap

| Phase | Focus | Status |
| ----- | ----- | ------ |
| 1 | Postman + Newman + ADO | In Progress |
| 2 | Playwright consolidation | Planned |
| 3 | Developer enablement | Planned |
| 4 | UI E2E rationalization | Planned |
| 5 | k6 performance testing | Planned |

## Development Approach

This project uses a **research-first** approach:

1. Gather external QA agent/plugin sources
2. Analyze and extract useful patterns
3. Build agents iteratively based on research
4. Test against real repos, iterate based on feedback

See [CLAUDE.md](CLAUDE.md) for full development context.

## References

### Primary Guide

This project follows patterns from **Claude Code Mastery V3** — a comprehensive guide to Claude Code best practices:

- [Claude Code Mastery V3](https://thedecipherist.github.io/claude-code-mastery/) — Core reference guide
- [GitHub: TheDecipherist/claude-code-mastery](https://github.com/TheDecipherist/claude-code-mastery) — Templates, hooks, skills
- Local copy: [research/sources/complete-guide-to-claude-code-v3.md](research/sources/complete-guide-to-claude-code-v3.md)

### Official Anthropic Documentation

- [Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)
- [Effective Context Engineering](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- [Model Context Protocol](https://www.anthropic.com/news/model-context-protocol)
- [Agent Skills](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills)
- [Claude Code Plugins Docs](https://code.claude.com/docs/en/plugins)

### Research Papers

- [LLMs Get Lost In Multi-Turn](https://arxiv.org/pdf/2505.06120) — 39% performance drop research
- [Context Rot Research](https://research.trychroma.com/context-rot) — Token window degradation

### Security Resources

- [Claude loads secrets without permission](https://www.knostic.ai/blog/claude-loads-secrets-without-permission)
- [Claude Code Security Best Practices](https://www.backslash.security/blog/claude-code-security-best-practices)

### Tools & Patterns

- [awesome-mcp-servers](https://github.com/punkpeye/awesome-mcp-servers) — 76k+ stars, MCP server directory
- [mcpservers.org](https://mcpservers.org) — Searchable MCP directory
- [Compound Engineering](https://every.to/chain-of-thought/compound-engineering-how-every-codes-with-agents)
- [Claude Code Hooks Guardrails](https://paddo.dev/blog/claude-code-hooks-guardrails/)

### Project Files

- [CLAUDE.md](CLAUDE.md) — Full development context
- [Original Strategic Plan](qa_automation_agent_plan.md)

## License

MIT