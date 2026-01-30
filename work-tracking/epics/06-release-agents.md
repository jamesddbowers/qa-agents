# Epic 06: Release Agents

## Objective

Build agents for final release preparation — regression orchestration, release readiness reporting, and release notes generation.

## Relationships

- **QA Workflow Reference**: `docs/qa-workflow/05-final-release-prep.md` — defines the deliverables (Release Readiness Report, sign-off on release package, Release Notes with SRE/DevOps/Support sections and rollback strategy, Defect Validation)
- **Agent Architecture**: `docs/agent-architecture.md` — section "Release Agents" — defines each agent's inputs, outputs
- **Upstream Epic**: Epic 05 (SIT Agents) — must be complete; these agents consume all test results, pipeline configs, and defect logs from SIT and earlier phases
- **Downstream Epic**: Epic 07 (Support Agents) — consumes release notes, readiness reports, and regression results for post-release validation and playbook generation
- **Output Location**: `qa-sdlc-agents/agents/release/`

## Agents (3)

### Story 6.1: regression-orchestrator
- [ ] Define agent (consumes all test suites, pipeline configs)
- [ ] Acquire knowledge: regression strategy, test selection, execution planning
- [ ] Create references/
- [ ] Define output format (execution plan, aggregated results)
- [ ] Build agent .md
- [ ] Test

### Story 6.2: release-readiness-reporter
- [ ] Define agent (consumes all test results, gap-report, defect logs)
- [ ] Acquire knowledge: go/no-go criteria, readiness report templates
- [ ] Create references/ (readiness-template.md, go-no-go-criteria.md)
- [ ] Define output format (release readiness report with phase references, defect status)
- [ ] Build agent .md
- [ ] Test

### Story 6.3: release-notes-generator
- [ ] Define agent (consumes all phase outputs, defect validation, readiness report)
- [ ] Acquire knowledge: release notes structure (SRE, DevOps, Support sections), rollback documentation
- [ ] Create references/ (release-notes-template.md, rollback-checklist.md)
- [ ] Define output format (release notes with: SRE technical details, DevOps infra, Support user-facing, rollback strategy, production verification plan, known defects)
- [ ] Build agent .md
- [ ] Test

## Build Order
Sequential: regression-orchestrator → release-readiness-reporter → release-notes-generator
