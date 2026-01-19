# Claude Code Mastery V3 — Pattern Extraction

## Source: Claude Code Mastery V3

### Metadata

| Field | Value |
| ----- | ----- |
| **Source URL** | https://thedecipherist.github.io/claude-code-mastery |
| **GitHub Repo** | https://github.com/TheDecipherist/claude-code-mastery |
| **Type** | guide |
| **Date Found** | 2026-01-16 |
| **Author/Origin** | TheDecipherist (community compilation) |
| **License** | Not specified (public guide) |

### Summary

Comprehensive guide to Claude Code covering CLAUDE.md memory hierarchy, MCP servers, Skills/Commands, Hooks enforcement, LSP support, and context management. V3 added LSP coverage, merged Commands/Skills, expanded MCP directory, and community-contributed patterns.

### MVP Relevance

| MVP Step | Relevant? | Notes |
| -------- | --------- | ----- |
| 1. Endpoint Inventory | Yes | LSP for semantic code navigation, Skills structure |
| 2. Auth Discovery | Partial | Security gatekeeper patterns apply |
| 3. Telemetry/Prioritization | No | No specific telemetry patterns |
| 4. Tagging Conventions | Partial | Skills progressive disclosure pattern |
| 5. Postman Generation | No | No specific Postman patterns |
| 6. Test Data Strategy | Partial | Security patterns for test data handling |
| 7. ADO Pipelines | No | No specific ADO patterns |
| 8. Diagnostics/Triage | Partial | Hooks for enforcement, error handling |

---

## Part 1: Global CLAUDE.md as Security Gatekeeper

### Patterns Extracted

#### CLAUDE.md Memory Hierarchy

```text
| Level | Location | Purpose |
|-------|----------|---------|
| Enterprise | /etc/claude-code/CLAUDE.md | Org-wide policies |
| Global User | ~/.claude/CLAUDE.md | Your standards for ALL projects |
| Project | ./CLAUDE.md | Team-shared project instructions |
| Project Local | ./CLAUDE.local.md | Personal project overrides |
```

**Applied to qa-copilot:** Our `CLAUDE.md` is the Project level. Users may have Global rules that apply on top.

#### Security Gatekeeper Rules

```markdown
## NEVER EVER DO

These rules are ABSOLUTE:

### NEVER Publish Sensitive Data
- NEVER publish passwords, API keys, tokens to git/npm/docker
- Before ANY commit: verify no secrets included

### NEVER Commit .env Files
- NEVER commit `.env` to git
- ALWAYS verify `.env` is in `.gitignore`
```

**Applied to qa-copilot:** Added to CLAUDE.md. Critical since QA agents may handle auth tokens and test credentials.

#### Defense in Depth Model

| Layer | What | How |
|-------|------|-----|
| 1 | Behavioral rules | Global CLAUDE.md "NEVER" rules |
| 2 | Access control | Deny list in settings.json |
| 3 | Git safety | .gitignore |
| 4 | Hooks | Deterministic enforcement |

**Applied to qa-copilot:** We implement Layer 1 (CLAUDE.md rules) and Layer 4 (hooks.json). Users manage Layers 2-3.

#### Compounding Engineering Pattern

```text
Claude makes mistake → You fix it → You add rule to CLAUDE.md → Never happens again
```

**Applied to qa-copilot:** Document in workflow section. Mistakes during testing should become CLAUDE.md rules.

---

## Part 2: Project Scaffolding

### Patterns Extracted

#### Required Files for New Projects

```markdown
### Required Files
- `.env` — Environment variables (NEVER commit)
- `.env.example` — Template with placeholders
- `.gitignore` — Must include: .env, node_modules/, dist/
- `CLAUDE.md` — Project overview
```

**Applied to qa-copilot:** Not directly used, but useful for Phase 2+ when scaffolding new QA projects.

#### Required Structure

```text
project/
├── src/
├── tests/
├── docs/
├── .claude/skills/
└── scripts/
```

**Backlog item:** Create scaffolding template for QA test projects (Phase 2+).

---

## Part 3: MCP Servers

### Patterns Extracted

#### When NOT to Use MCP

| Use Case | MCP Overhead | Alternative |
|----------|--------------|-------------|
| Trello tasks | High | CLI tool (`trello-cli`) |
| Simple HTTP calls | Overkill | `curl` via Bash |
| One-off queries | Wasteful | Direct command |

**Rule of thumb:** If calling MCP tool once per session, CLI is more efficient. MCP shines for *repeated* tool use.

**Applied to qa-copilot:** Phase 1 uses no MCP (file-based only). This validates our approach — agents consume exports rather than live connections.

#### MCP Server Directory

**Core Development:**

| Server | Purpose | Install |
|--------|---------|---------|
| Context7 | Live docs for any library | `claude mcp add context7 -- npx -y @upstash/context7-mcp@latest` |
| GitHub | PRs, issues, CI/CD | `claude mcp add github -- npx -y @modelcontextprotocol/server-github` |
| Filesystem | Advanced file operations | `claude mcp add filesystem -- npx -y @modelcontextprotocol/server-filesystem` |
| Sequential Thinking | Structured problem-solving | `claude mcp add sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking` |

**Browser & Testing:**

| Server | Purpose | Install |
|--------|---------|---------|
| Playwright | E2E testing, scraping | `claude mcp add playwright -- npx -y @anthropic-ai/playwright-mcp` |
| Browser MCP | Use logged-in Chrome | browsermcp.io |
| Brave Search | Privacy-first search | `claude mcp add brave -- npx -y @anthropic-ai/brave-search-mcp` |

**Backlog item:** Playwright MCP for Phase 2. Document full MCP directory in plan.

---

## Part 4: Context7 — Live Documentation

### Patterns Extracted

#### Usage Pattern

```text
You: "Using context7, show me the Next.js 15 cache API"
Claude: *fetches current docs* → accurate, up-to-date code
```

**Applied to qa-copilot:** Useful for Phase 2+ when building Playwright skills. Context7 can provide up-to-date Playwright API docs.

---

## Part 5: Skills (Commands Merged)

### Patterns Extracted

#### Skills Structure

| Old Location | New Location |
|--------------|--------------|
| `~/.claude/commands/review.md` | `~/.claude/skills/review/SKILL.md` |

**Key Difference:**
- **Slash commands** (`/review`) — Explicit user invocation
- **Skills** — Claude triggers automatically based on context

#### SKILL.md Format

```markdown
---
name: review
description: Review code for bugs and security issues
---

# Code Review Skill

When reviewing code:
1. Check for security vulnerabilities
2. Look for performance issues
3. Verify error handling
```

**Applied to qa-copilot:** All skills follow this format. Already implemented in our structure.

#### Progressive Disclosure

1. **Startup**: Only name/description loaded
2. **Triggered**: Full SKILL.md content loaded
3. **As needed**: Additional resources loaded

**Rule of thumb:** If instructions apply to <20% of conversations, make it a skill instead of CLAUDE.md.

**Applied to qa-copilot:** Our skills use sub-files (e.g., `java-patterns.md`, `dotnet-patterns.md`) for progressive disclosure. Only load stack-specific patterns when needed.

---

## Part 6: Single-Purpose Chats

### Patterns Extracted

#### Performance Research

From [LLMs Get Lost In Multi-Turn](https://arxiv.org/pdf/2505.06120):
> "An average **39% performance drop** when instructions are delivered across multiple turns."

From [Chroma Research on context rot](https://research.trychroma.com/context-rot):
> "As tokens in the context window increase, the model's ability to accurately recall information decreases."

#### The Golden Rule

> **"One Task, One Chat"**

| Scenario | Action |
|----------|--------|
| New feature | New chat |
| Bug fix (unrelated) | `/clear` then new task |
| Research vs implementation | Separate chats |
| 20+ turns elapsed | Start fresh |

**Applied to qa-copilot:** Added to CLAUDE.md with context management table. Each MVP step should be a separate chat.

---

## Part 7: Hooks — Deterministic Enforcement

### Patterns Extracted

#### Critical Difference

| Mechanism | Type | Reliability |
|-----------|------|-------------|
| CLAUDE.md rules | Suggestion | Can be overridden |
| **Hooks** | **Enforcement** | Always executes |

#### Hook Events

| Event | When | Use Case |
|-------|------|----------|
| `PreToolUse` | Before tool executes | Block dangerous ops |
| `PostToolUse` | After tool completes | Run linters |
| `Stop` | Claude finishes turn | Quality gates |

#### Hook Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Allow operation |
| 1 | Error (shown to user) |
| **2** | **Block operation, tell Claude why** |

#### Example: Block Secrets Access

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Read|Edit|Write",
        "hooks": [{
          "type": "command",
          "command": "python3 ~/.claude/hooks/block-secrets.py"
        }]
      }
    ]
  }
}
```

```python
#!/usr/bin/env python3
import json, sys
from pathlib import Path

SENSITIVE = {'.env', '.env.local', 'secrets.json', 'id_rsa'}

data = json.load(sys.stdin)
file_path = data.get('tool_input', {}).get('file_path', '')

if Path(file_path).name in SENSITIVE:
    print(f"BLOCKED: Access to {file_path} denied.", file=sys.stderr)
    sys.exit(2)  # Exit 2 = block and feed stderr to Claude

sys.exit(0)
```

**Applied to qa-copilot:** Our hooks.json uses prompt-based hooks (simpler). Consider adding Python script hooks for stricter enforcement.

**Backlog item:** Add example `block-secrets.py` hook script to `qa-copilot/hooks/`.

---

## Part 8: LSP — IDE-Level Code Intelligence

### Patterns Extracted

#### LSP Capabilities

| Capability | What It Does |
|------------|--------------|
| **Go to Definition** | Jump to where any symbol is defined |
| **Find References** | See everywhere a function is used |
| **Hover** | Get type signatures and docs |
| **Diagnostics** | Real-time error detection |
| **Document Symbols** | List all symbols in a file |

#### Performance Impact

**Before LSP:** Text-based search (grep, ripgrep) — slow, imprecise
**With LSP:** Semantic understanding — 900x faster (50ms vs 45 seconds)

#### Supported Languages

Python, TypeScript, Go, Rust, Java, C/C++, C#, PHP, Kotlin, Ruby, HTML/CSS

**Applied to qa-copilot:** Critical for endpoint discovery agents. LSP enables semantic understanding of Spring Boot annotations, ASP.NET attributes, Express routes. Document in endpoint-discovery skill.

---

## Integration Decisions Summary

| Decision | Applied To | Notes |
| -------- | ---------- | ----- |
| Security gatekeeper rules | CLAUDE.md | "NEVER EVER DO" section added |
| /clear guidance | CLAUDE.md | Context management table added |
| Defense in depth model | Architecture | Layer 1 (rules) + Layer 4 (hooks) implemented |
| Progressive disclosure | Skills structure | Use sub-files for stack-specific patterns |
| Single-purpose chats | Workflow guidance | Added to CLAUDE.md |
| Hook enforcement pattern | hooks.json | Prompt-based hooks implemented |
| LSP for code navigation | Endpoint discovery | Leverage for semantic annotation detection |

---

## Backlog Items

| Pattern | Future Phase | Notes |
| ------- | ------------ | ----- |
| Project scaffolding template | Phase 2+ | QA test project template |
| Playwright MCP integration | Phase 2 | E2E testing |
| Context7 for Playwright docs | Phase 2 | Live API documentation |
| Python hook scripts | Phase 1.1 | Stricter block-secrets enforcement |
| Dotfiles sync pattern | Cross-phase | For team ~/.claude consistency |

---

## Raw Source Archive

- **Original guide**: `research/sources/complete-guide-to-claude-code-v3.md`
- **GitHub templates**: https://github.com/TheDecipherist/claude-code-mastery

---

*Extracted: 2026-01-16*
