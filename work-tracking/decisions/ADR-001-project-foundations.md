# ADR-001: Project Foundation Decisions

**Date**: 2026-01-30
**Status**: Accepted

## Decisions Made

### 1. Testing Methodology: BDD + TDD

**Decision**: All QA-created test cases use BDD (Given/When/Then). Developer-owned tests use TDD informed by BDD specs.

**Rationale**: BDD provides human-readable test cases that PO/BA can review and validate. TDD at unit/component level is informed by BDD feature specs, creating a top-down → bottom-up reinforcement loop.

**Impact**: test-case-creator agent outputs BDD format. unit-test-advisor agent recommends TDD patterns derived from BDD acceptance criteria. All agents downstream consume BDD scenarios.

**References**: `docs/qa-workflow/03-development.md` (BDD format section), `docs/agent-architecture.md` (Testing Methodology section)

### 2. Phase 0 / Phase 1 Approach

**Decision**: Phase 0 (current) builds all agents with full instructions, templates, and file-based references using LLM inference. Phase 1 (future) adds Python scripts for reproducible outputs.

**Rationale**: Get correctness first, optimize later. Avoids premature optimization and lets us validate patterns before scripting them.

**Impact**: No Python scripts in Phase 0. All agent outputs are LLM-generated following reference documentation. Phase 1 is explicitly deferred.

**References**: `docs/agent-architecture.md` (Phased Approach section)

### 3. Separate Plugin: qa-sdlc-agents

**Decision**: Create a new `qa-sdlc-agents` plugin rather than expanding `qa-copilot`.

**Rationale**: qa-copilot is a validated Phase 1 MVP focused on API testing. The full SDLC suite is a much broader scope. Keeping them separate avoids breaking validated work. The 6 existing qa-copilot agents will be absorbed (refactored and extended) into qa-sdlc-agents.

**Impact**: Two plugin directories coexist. Existing qa-copilot skills/references are starting points for new agents.

**References**: `docs/agent-architecture.md` (Relationship to Existing qa-copilot section)

### 4. File-Based Agent Communication

**Decision**: Agents communicate through JSON files and markdown documents, not conversation context.

**Rationale**: Context windows are limited. JSON intermediates allow agents to run in separate sessions. Cross-repo-stitcher can consume outputs from multiple repo runs without needing all repos in one session.

**Impact**: Each agent defines its output schema (repo-profile.json, endpoint-inventory.json, etc.). Agents read predecessor outputs from disk.

**References**: `docs/agent-architecture.md` (Agent Chaining section), individual agent schemas in Pre-Dev Agents section

### 5. Tool Knowledge as File-Based References

**Decision**: Each tool (Playwright, k6, Postman/Newman, axe-core) gets file-based reference documentation extracted from official docs. Not using Context7 or MCP in Phase 0.

**Rationale**: File-based references are deterministic and version-controlled. They serve as the "North Star" ensuring reproducible output. Context7 or similar can be added in Phase 1 for dynamic doc lookup.

**Impact**: `qa-sdlc-agents/skills/` has per-tool folders with `references/` subdirectories. User and Claude collaborate on knowledge acquisition for each tool.

**References**: `docs/agent-architecture.md` (Tool-Specific Knowledge Bases section)

### 6. Feature-Based Test Organization

**Decision**: Test cases organized by feature, not by user story.

**Rationale**: Historical user stories are incomplete (Jira decommissioned, not fully ported to ADO). Features are the stable unit. Stories can be linked to features as they're created.

**Impact**: ADO Test Plan structure is feature-based. test-plan-scaffolder outputs feature-based test suites. Stories are linked to features as a secondary association.

**References**: `docs/qa-workflow/03-development.md`, `docs/qa-workflow/00-overview.md` (Organizational Context)

### 7. QA Workflow Build Order = Agent Build Order

**Decision**: Agents are built in the same order as the QA workflow phases: Pre-Dev → Dev → SIT → Release → Support.

**Rationale**: Each phase's agents consume the previous phase's outputs. Building in order means each agent has real predecessor outputs to test against. Also ensures the user can start using agents as soon as the first phase is complete, rather than waiting for all 29.

**Impact**: Epic numbering (03–07) matches workflow order. Each epic's Relationships section documents upstream/downstream dependencies.

**References**: `docs/agent-architecture.md` (Build Order section), all epic files (Relationships sections)

### 8. Collaborative Agent Build Process

**Decision**: For each agent, user and Claude collaborate through: define → acquire knowledge → create references → build → test → iterate.

**Rationale**: The user has domain expertise (QA processes, organizational context) while Claude has technical implementation capabilities. Neither can build these agents alone — the user ensures agents produce the right outputs for real organizational needs.

**Impact**: Each Story in the epic files follows this 6-step process. Knowledge acquisition is an explicit task, not assumed.

**References**: `docs/agent-architecture.md` (Agent Build Process section)
