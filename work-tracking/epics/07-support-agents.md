# Epic 07: Support Agents

## Objective

Build agents for post-release validation, escape analysis, metrics collection, cross-repo documentation stitching, and playbook generation.

## Relationships

- **QA Workflow References**:
  - `docs/qa-workflow/06-post-release.md` — defines post-release deliverables (defect logs, issue resolutions), rollback philosophy, deployment verification process, priority-based response windows
  - `docs/qa-workflow/07-continuous-feedback.md` — defines continuous improvement deliverables (feedback, playbooks), retro process, metrics QA tracks, feedback loop routing
  - `docs/qa-workflow/09-playbook-concept.md` — defines the per-service playbook structure, lifecycle, and audience that the playbook-generator agent must produce
- **Agent Architecture**: `docs/agent-architecture.md` — section "Support Agents" — defines each agent's inputs, outputs
- **Upstream Epic**: Epic 06 (Release Agents) — consumes release notes, readiness reports, regression results
- **Downstream**: Feeds back into the SDLC — escape-defect-analyzer creates new test cases that feed Pre-Dev/Dev phases; metrics-collector trends inform process adjustments; playbooks are living documents updated each release
- **Output Location**: `qa-sdlc-agents/agents/support/`

## Agents (5)

### Story 7.1: production-validator
- [ ] Define agent (consumes Postman smoke collection, environment config)
- [ ] Acquire knowledge: post-deployment validation patterns, smoke test strategies
- [ ] Create references/
- [ ] Define output format (production validation script + results)
- [ ] Build agent .md
- [ ] Test

### Story 7.2: escape-defect-analyzer
- [ ] Define agent (consumes defect details, gap-report, test coverage data)
- [ ] Acquire knowledge: root cause analysis patterns, escape categorization
- [ ] Create references/ (rca-patterns.md, escape-categories.md)
- [ ] Define output format (RCA report, test gap updates, new test cases)
- [ ] Build agent .md
- [ ] Test

### Story 7.3: metrics-collector
- [ ] Define agent (consumes all test results over time)
- [ ] Acquire knowledge: QA metrics (defect density, test coverage, escape rate, automation ROI)
- [ ] Create references/ (metrics-definitions.md, dashboard-patterns.md)
- [ ] Define output format (metrics dashboard data, trend reports)
- [ ] Build agent .md
- [ ] Test

### Story 7.4: cross-repo-stitcher
- [ ] Define agent (consumes multiple repo doc-generator outputs)
- [ ] Acquire knowledge: system architecture documentation, cross-service diagrams
- [ ] Create references/
- [ ] Define output format (system architecture doc, cross-service sequence diagrams, full API catalog)
- [ ] Build agent .md
- [ ] Test

### Story 7.5: playbook-generator
- [ ] Define agent (consumes doc-generator outputs, release notes, defect logs)
- [ ] Acquire knowledge: operational playbook patterns, runbook structures
- [ ] Create references/ (playbook-template.md, troubleshooting-patterns.md)
- [ ] Define output format (per-service playbook with dependencies, configs, APIs, troubleshooting, known issues)
- [ ] Build agent .md
- [ ] Test

## Build Order
Can be built in parallel, though cross-repo-stitcher benefits from having production-validator and escape-defect-analyzer done first.
