# Project Status

Last updated: 2026-01-30
Current focus: Epic 3 (Pre-Dev Agents) built and verified. All 8 agents complete with references, schemas, and quality audit passed.

## Project Scope

Full SDLC QA Automation Agents — building agents that support QA processes across the entire software development lifecycle, from pre-development through post-release support.

## Key Reference Documents

| Document | Purpose | Location |
| -------- | ------- | -------- |
| QA Workflow Reference (10 files) | Foundational QA process — all phases, deliverables, QA actions, role interactions | `docs/qa-workflow/` (start with `00-overview.md`) |
| Agent Architecture | All 29 agents, inputs/outputs, chaining, BDD/TDD methodology, tool knowledge bases, build process | `docs/agent-architecture.md` |
| Architecture Decisions | Key decisions and rationale (BDD/TDD, phasing, tool choices, build order) | `work-tracking/decisions/ADR-001-project-foundations.md` |
| Approved Plan | Original approved execution plan | `.claude/plans/snug-hatching-haven.md` |
| QA Workflow Diagram | Visual workflow diagram (source for qa-workflow docs) | `QA Workflow.png` |
| User Notes | Ongoing enhancement ideas and future work | `my-notes.txt` |

## Epic Dependency Chain

Epics must be completed in order — each builds on the previous:

```text
Epic 02 (QA Workflow Doc) ✅
    → Epic 03 (Pre-Dev Agents) — produces JSON outputs consumed by all downstream
        → Epic 04 (Dev Agents) — produces BDD test cases, test data plans
            → Epic 05 (SIT Agents) — produces cross-service automation, pipeline configs
                → Epic 06 (Release Agents) — produces readiness reports, release notes
                    → Epic 07 (Support Agents) — produces playbooks, metrics, escape analysis
```

## Epics

| # | Epic | Status | Progress |
|---|------|--------|----------|
| 1 | Infrastructure (folders, CLAUDE.md, tracking) | ✅ Complete | 7/7 |
| 2 | QA Workflow Reference Doc | ✅ Complete | 10/10 |
| 3 | Pre-Dev Agents | ✅ Complete | 8/8 |
| 4 | Dev Agents | ⬜ Not Started | 0/5 |
| 5 | SIT/E2E/Perf/A11y Agents | ⬜ Not Started | 0/8 |
| 6 | Release Agents | ⬜ Not Started | 0/3 |
| 7 | Support Agents | ⬜ Not Started | 0/5 |

## Phases

- **Phase 0 (Current):** Build all agents with full instructions, templates, file-based references. Focus on correctness.
- **Phase 1 (Future):** Efficiency iteration — Python scripts for reproducible outputs, optimize slow/inconsistent parts.

## Next Actions

1. Begin Epic 4: Dev Agents (test-case-creator, test-data-planner, code-quality-scanner, automation-generator, wip-test-runner)
2. For each agent: define → acquire tool knowledge → create references → build → test → iterate
3. Dev agents consume pre-dev JSON outputs (repo-profile, endpoint-inventory, auth-profile, data-model, dependency-map, gap-report, test-plan-scaffold)

## Context Loading Rules

| Task Type | Read These Files |
|-----------|-----------------|
| Any session start | CLAUDE.md + work-tracking/STATUS.md |
| Writing QA workflow docs | + docs/qa-workflow/00-overview.md + the specific phase file |
| Building agents | + docs/agent-architecture.md + the specific epic file + relevant qa-workflow phase file |
| Working on infrastructure | + work-tracking/epics/01-infrastructure.md |
