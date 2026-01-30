# Epic 02: QA Workflow Reference Document

## Objective

Capture the full SDLC QA workflow as a multi-file markdown reference in `docs/qa-workflow/`. This is the foundational document that all agents are built against.

**Source**: Based on `QA Workflow.png` and detailed conversation capturing the user's 15+ years of QA process design.

## Relationships

- **Upstream**: None — this is the foundational reference
- **Downstream**: Every agent epic (03–07) references these docs to understand what deliverables each agent must produce and where in the SDLC each agent operates
- **Architecture**: `docs/agent-architecture.md` maps agents to the deliverables defined in these docs
- **Deliverables Index**: `docs/qa-workflow/10-deliverables-index.md` is the master cross-reference between deliverables and agents

## Tasks

- [x] `docs/qa-workflow/00-overview.md` — Mission, phases, test pyramid, tooling, maturity context
- [x] `docs/qa-workflow/01-intake.md` — Intake phase (stub, out of scope for agents)
- [x] `docs/qa-workflow/02-pre-development.md` — Pre-Dev deliverables, QA actions, role spans
- [x] `docs/qa-workflow/03-development.md` — Dev deliverables, WIP testing, test case structure, BDD format
- [x] `docs/qa-workflow/04-sit-e2e-perf-a11y.md` — SIT/E2E/Perf/A11y deliverables, cross-team environment, defect mgmt
- [x] `docs/qa-workflow/05-final-release-prep.md` — Release readiness, sign-off, release notes, defect validation
- [x] `docs/qa-workflow/06-post-release.md` — Rollback strategy, production monitoring, incident resolution
- [x] `docs/qa-workflow/07-continuous-feedback.md` — Metrics, process adjustments, retros, feedback loops
- [x] `docs/qa-workflow/08-role-interaction-grid.md` — Role × phase matrix
- [x] `docs/qa-workflow/09-playbook-concept.md` — Per-service playbook template and lifecycle
- [x] `docs/qa-workflow/10-deliverables-index.md` — Master deliverable table with agent mappings
