# Epic 05: SIT/E2E/Perf/A11y Agents

## Objective

Build agents for cross-service integration testing, E2E UI testing, performance testing, accessibility testing, and pipeline generation. These consume dev-phase outputs and produce automation that runs in shared QA environments.

## Relationships

- **QA Workflow Reference**: `docs/qa-workflow/04-sit-e2e-perf-a11y.md` — defines the deliverables (SIT/E2E results, perf/a11y reports, defect logs), cross-team environment context, defect management with PO/BA, mobile API edge testing
- **Agent Architecture**: `docs/agent-architecture.md` — section "SIT/E2E/Perf/A11y Agents" — defines each agent's inputs, outputs, and tool knowledge requirements
- **Upstream Epic**: Epic 04 (Dev Agents) — must be complete; these agents consume BDD test cases, test data plans, and feature-level automation outputs. The dev-phase test cases determine what needs SIT/E2E/perf/a11y coverage (pyramid feeds upward).
- **Downstream Epic**: Epic 06 (Release Agents) — consumes test results, pipeline configs, and defect logs from this epic
- **Existing qa-copilot agents to absorb**: `qa-copilot/agents/traffic-analyzer.md` → traffic-prioritizer; `qa-copilot/agents/collection-generator.md` → postman-collection-builder; `qa-copilot/agents/pipeline-generator.md` → newman-pipeline-builder; `qa-copilot/agents/diagnostics-agent.md` → defect-manager
- **Output Location**: `qa-sdlc-agents/agents/sit/`
- **Tool Knowledge Required**: Playwright, k6, Postman/Newman, axe-core — each needs official doc extraction into `qa-sdlc-agents/skills/` references

## Agents (8)

### Story 5.1: postman-collection-builder
- [ ] Define agent (consumes endpoint-inventory, auth-profile, test-data-plan)
- [ ] Acquire knowledge: Postman collection schema, pre/post scripts, variable chaining, Newman CLI
- [ ] Create references/ (collection-patterns.md, chaining-patterns.md, cli-reference.md)
- [ ] Define output format (Postman collection JSON, environment files)
- [ ] Build agent .md
- [ ] Test against real repo

### Story 5.2: playwright-test-generator
- [ ] Define agent (consumes endpoint-inventory, auth-profile, gap-report, BDD test cases)
- [ ] Acquire knowledge: Playwright best practices, page objects, API testing, fixtures, test isolation
- [ ] Create references/ (best-practices.md, api-testing-patterns.md, page-object-patterns.md, ci-integration.md)
- [ ] Define output format (.spec.ts files following BDD scenarios)
- [ ] Build agent .md
- [ ] Test against real repo

### Story 5.3: k6-scenario-builder
- [ ] Define agent (consumes endpoint-inventory, Dynatrace data, auth-profile)
- [ ] Acquire knowledge: k6 best practices, scripting patterns, thresholds, load profiles
- [ ] Create references/ (best-practices.md, scripting-patterns.md, threshold-strategies.md)
- [ ] Define output format (k6 scripts, threshold configs)
- [ ] Build agent .md
- [ ] Test against real repo

### Story 5.4: a11y-test-generator
- [ ] Define agent (consumes frontend repo, endpoint-inventory)
- [ ] Acquire knowledge: axe-core rule sets, WCAG mapping, Playwright integration
- [ ] Create references/ (axe-core-rules.md, wcag-mapping.md, playwright-a11y.md)
- [ ] Define output format (a11y test scripts, configs)
- [ ] Build agent .md
- [ ] Test against real repo

### Story 5.5: newman-pipeline-builder
- [ ] Define agent (consumes Postman collection, ADO context)
- [ ] Acquire knowledge: ADO pipeline YAML, Newman tasks, variable groups, reporting
- [ ] Create references/ (newman-tasks.md, reporting-patterns.md, variable-groups.md)
- [ ] Define output format (ADO YAML pipeline)
- [ ] Build agent .md
- [ ] Test

### Story 5.6: playwright-pipeline-builder
- [ ] Define agent (consumes Playwright tests, ADO context)
- [ ] Acquire knowledge: ADO pipeline YAML for Playwright, Docker/container strategies
- [ ] Create references/
- [ ] Define output format (ADO YAML pipeline)
- [ ] Build agent .md
- [ ] Test

### Story 5.7: traffic-prioritizer
- [ ] Define agent (consumes Dynatrace CSV/JSON exports, endpoint-inventory)
- [ ] Acquire knowledge: traffic analysis patterns, smoke/regression tagging strategies
- [ ] Create references/ (prioritization.md, tagging-conventions.md)
- [ ] Define output format (prioritized endpoint list with tags)
- [ ] Build agent .md
- [ ] Test

### Story 5.8: defect-manager
- [ ] Define agent (consumes test results, defect reports)
- [ ] Acquire knowledge: defect lifecycle, ADO work items, triage patterns
- [ ] Create references/ (defect-lifecycle.md, triage-patterns.md)
- [ ] Define output format (defect logs, status reports)
- [ ] Build agent .md
- [ ] Test

## Build Order
1. postman-collection-builder, playwright-test-generator (first — core test generation)
2. k6-scenario-builder, a11y-test-generator (parallel)
3. newman-pipeline-builder, playwright-pipeline-builder (consume test outputs)
4. traffic-prioritizer, defect-manager (supplementary)

## Tool Knowledge Acquisition
Playwright, k6, Postman/Newman, and axe-core each need official doc extraction into file-based references. User and Claude collaborate on this per Story.
