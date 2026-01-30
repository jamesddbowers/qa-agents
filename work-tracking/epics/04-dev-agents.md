# Epic 04: Dev Agents

## Objective

Build agents for test creation and code quality during the development sub-phase. These consume pre-dev outputs and produce BDD test cases, TDD unit test recommendations, and test data strategies.

## Relationships

- **QA Workflow Reference**: `docs/qa-workflow/03-development.md` — defines the deliverables (continuous test reports, defect tracking, ADO Test Plan entries, feature-level automation), test case structure, BDD format, manual-first verification, and defect iteration loop
- **Agent Architecture**: `docs/agent-architecture.md` — section "Dev Agents" — defines each agent's inputs, outputs, and BDD/TDD methodology
- **Upstream Epic**: Epic 03 (Pre-Dev Agents) — must be complete; these agents consume `endpoint-inventory.json`, `gap-report.json`, `data-model.json`, `auth-profile.json`
- **Downstream Epic**: Epic 05 (SIT Agents) — consumes BDD test cases, test data plans, and automation outputs from this epic to determine what SIT/E2E/perf/a11y tests to add
- **Output Location**: `qa-sdlc-agents/agents/dev/`
- **Key Methodology**: BDD (Given/When/Then) for QA-owned tests, TDD for developer-owned tests informed by BDD specs

## Agents (5)

### Story 4.1: test-case-creator
- [ ] Define agent (consumes endpoint-inventory, gap-report, data-model, user stories)
- [ ] Acquire knowledge: BDD patterns (Given/When/Then), test case structure, ADO Test Plans
- [ ] Create references/ (bdd-patterns.md, test-case-template.md)
- [ ] Define output format (BDD test cases with: name, user story, AC, steps, data setup, automation candidacy)
- [ ] Build agent .md
- [ ] Test against real repo

### Story 4.2: unit-test-advisor
- [ ] Define agent (consumes repo, gap-report, BDD test cases from test-case-creator)
- [ ] Acquire knowledge: TDD patterns, JUnit/Jest patterns, coverage analysis
- [ ] Create references/ (tdd-patterns.md, java-unit-patterns.md, js-unit-patterns.md)
- [ ] Define output format (unit test files + coverage improvement plan)
- [ ] Build agent .md
- [ ] Test against real repo

### Story 4.3: component-test-generator
- [ ] Define agent (consumes repo, endpoint-inventory, data-model)
- [ ] Acquire knowledge: component testing patterns, mock strategies, test containers
- [ ] Create references/
- [ ] Define output format (component test files + mock configs)
- [ ] Build agent .md
- [ ] Test against real repo

### Story 4.4: api-contract-validator
- [ ] Define agent (consumes endpoint-inventory, any OpenAPI specs)
- [ ] Acquire knowledge: contract testing (Pact, OpenAPI validation), API drift detection
- [ ] Create references/
- [ ] Define output format (contract drift report, updated OpenAPI draft)
- [ ] Build agent .md
- [ ] Test against real repo

### Story 4.5: test-data-planner
- [ ] Define agent (consumes data-model, endpoint-inventory)
- [ ] Acquire knowledge: test data strategies, seed scripts, fixture generation, cleanup
- [ ] Create references/ (seeding-patterns.md, faker-patterns.md, cleanup-strategies.md)
- [ ] Define output format (test data plan, seed scripts, fixture files)
- [ ] Build agent .md
- [ ] Test against real repo

## Build Order
1. test-case-creator (first — BDD specs inform everything else)
2. unit-test-advisor, component-test-generator, api-contract-validator, test-data-planner (parallel after 4.1)

## Testing Methodology
- test-case-creator outputs BDD format (Given/When/Then) — QA-owned
- unit-test-advisor outputs TDD recommendations — developer-owned, informed by BDD specs
- BDD → TDD: feature specs define behaviors, developers use those to drive unit/component tests
