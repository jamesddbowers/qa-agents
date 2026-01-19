# Future Phases Backlog

This document archives patterns and research items that are not part of MVP but should be preserved for later phases.

## Phase 2: Playwright Framework Consolidation

**Goal:** Harden Playwright as the single long-term framework for API + UI testing, while retaining Newman smoke tests as fast deploy gates.

### Agents Needed

| Agent | Purpose | Research Items |
| ----- | ------- | -------------- |
| `playwright-framework-agent` | Assess and harden existing Playwright setup | Playwright best practices, fixture patterns |
| `postman-to-playwright-forklift-agent` | Convert Postman API tests to Playwright | Migration patterns, assertion mapping |

### Skills Needed

| Skill | Purpose | Research Items |
| ----- | ------- | -------------- |
| `playwright-framework-patterns` | Config, fixtures, reporters, tagging | Playwright documentation |
| `api-test-migration` | Postman → Playwright conversion | - |

### MCP Integration

| Server | Purpose |
| ------ | ------- |
| Playwright MCP | Browser automation, E2E testing |

### Archived Patterns

(Add non-MVP patterns extracted from research here)

---

## Phase 3: Developer Enablement (Unit + Component Testing)

**Goal:** Move quality left by enabling teams to catch defects earlier and reduce E2E reliance.

### Agents Needed

| Agent | Purpose | Research Items |
| ----- | ------- | -------------- |
| `dev-testing-enablement-agent` | Identify unit test gaps, recommend component tests | Unit testing best practices by stack |

### Skills Needed

| Skill | Purpose | Research Items |
| ----- | ------- | -------------- |
| `unit-test-patterns` | Stack-specific unit testing guidance | Java/JUnit, .NET/xUnit, TS/Jest |
| `component-test-patterns` | Service-level component testing | Testcontainers, in-memory DBs |

### Archived Patterns

(Add non-MVP patterns extracted from research here)

---

## Phase 4: UI End-to-End Rationalization

**Goal:** Create UI E2E tests only where they add value beyond unit/component/API coverage.

### Agents Needed

| Agent | Purpose | Research Items |
| ----- | ------- | -------------- |
| `e2e-rationalization-agent` | Analyze coverage, identify true gaps | Test pyramid analysis |

### Skills Needed

| Skill | Purpose | Research Items |
| ----- | ------- | -------------- |
| `e2e-strategy` | Critical journey identification | - |
| `redundancy-analysis` | Identify tests covered at lower levels | - |

### Archived Patterns

(Add non-MVP patterns extracted from research here)

---

## Phase 5: k6 Performance Testing

**Goal:** Build performance tests grounded in real production patterns using Dynatrace telemetry.

### Agents Needed

| Agent | Purpose | Research Items |
| ----- | ------- | -------------- |
| `k6-performance-agent` | Generate k6 scenarios, estimate sizing | k6 scripting patterns |

### Skills Needed

| Skill | Purpose | Research Items |
| ----- | ------- | -------------- |
| `k6-scenario-patterns` | Load profiles, scripts | k6 documentation |
| `performance-extrapolation` | Interpret non-prod results | Performance testing methodologies |

### MCP Integration

| Server | Purpose |
| ------ | ------- |
| (TBD) | Performance data collection |

### Archived Patterns

(Add non-MVP patterns extracted from research here)

---

## Copilot Adaptation (Cross-Phase)

**Goal:** After each phase's Claude Code implementation is stable, create GitHub Copilot compatible versions.

### Research Needed

| Item | Purpose |
| ---- | ------- |
| Copilot custom instructions format | Understand how to adapt skills |
| Copilot slash commands | Map from Claude Code commands |
| Copilot agents (if available) | Map from Claude Code agents |

### Mapping Template

```text
Claude Code Component → Copilot Equivalent
------------------------------------------
Skill SKILL.md         → Custom Instructions / .github/copilot-instructions.md
Command .md            → Copilot Slash Command (if available)
Agent .md              → Copilot Agent (if available)
Hooks                  → (No direct equivalent - document alternative)
```

### Archived Patterns

(Add Copilot-specific patterns discovered during research here)

---

## Generic Archived Patterns

Patterns that don't fit a specific phase but may be useful later:

| Pattern | Source | Potential Use | Date Added |
| ------- | ------ | ------------- | ---------- |
| | | | |

---

*Last Updated: 2026-01-16*
