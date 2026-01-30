# Agent Architecture Plan

## Overview

29 agents organized across 5 phase groups, built in QA workflow order so each phase's outputs feed the next. Agents communicate through JSON files and markdown documents — not conversation context.

## Testing Methodology

**BDD (Behavior-Driven Development)** — All QA-created test cases use Given/When/Then. Covers: feature-level, integration, SIT, E2E, performance, accessibility. BDD scenarios are the source that feeds everything downstream. All test-case-generating agents output BDD format.

**TDD (Test-Driven Development)** — Developer-owned tests (unit, component, contract). TDD tests are informed by BDD scenarios. The unit-test-advisor agent recommends TDD-style tests derived from BDD acceptance criteria.

**BDD → TDD flow**: QA defines behaviors top-down, developers build to those specs bottom-up.

---

## Agent Chaining

```
Pre-Dev (repo analysis)
    │
    ├── repo-scanner ──┬── api-surface-extractor ──┐
    │                  ├── auth-flow-analyzer ─────┤
    │                  ├── data-model-mapper ──────┤── doc-generator ── gap-analyzer ── test-plan-scaffolder
    │                  └── dependency-tracer ──────┘
    │
    ▼
Dev (test creation)
    │
    ├── test-case-creator (BDD) ──┬── unit-test-advisor (TDD)
    │                             ├── component-test-generator
    │                             ├── api-contract-validator
    │                             └── test-data-planner
    │
    ▼
SIT (cross-service testing)
    │
    ├── postman-collection-builder ── newman-pipeline-builder
    ├── playwright-test-generator ── playwright-pipeline-builder
    ├── k6-scenario-builder
    ├── a11y-test-generator
    ├── traffic-prioritizer
    └── defect-manager
    │
    ▼
Release (preparation)
    │
    ├── regression-orchestrator
    ├── release-readiness-reporter
    └── release-notes-generator
    │
    ▼
Support (operations)
    │
    ├── production-validator
    ├── escape-defect-analyzer
    ├── metrics-collector
    ├── cross-repo-stitcher
    └── playbook-generator
```

---

## Pre-Dev Agents (8)

These run first against each repo to extract all possible information and produce the documentation foundation.

### repo-scanner

| Attribute | Value |
| --------- | ----- |
| Purpose | Deep repo analysis: framework, structure, modules, build system, dependencies |
| Inputs | Cloned repo |
| Outputs | `repo-profile.json` |
| Runs When | First agent for any new repo analysis |
| Dependencies | None — this is the foundation |

**Output schema** (`repo-profile.json`):
- Language(s) and versions
- Framework(s) detected (Spring Boot, ASP.NET Core, Express, etc.)
- Module/project structure
- Build system (Maven, Gradle, .NET SDK, npm, etc.)
- Dependency tree (direct and transitive)
- Test framework(s) in use
- CI/CD configuration detected

### api-surface-extractor

| Attribute | Value |
| --------- | ----- |
| Purpose | Find all endpoints, routes, controllers, middleware, parameters, response types |
| Inputs | Repo + `repo-profile.json` |
| Outputs | `endpoint-inventory.json` |
| Dependencies | repo-scanner |

**Output schema** (`endpoint-inventory.json`):
- Per endpoint: HTTP method, path, controller/handler, parameters (path, query, body), response type, auth requirements, middleware chain
- Grouped by controller/module

### auth-flow-analyzer

| Attribute | Value |
| --------- | ----- |
| Purpose | Identify auth mechanisms, token flows, session management, test auth strategy |
| Inputs | Repo + `endpoint-inventory.json` |
| Outputs | `auth-profile.json` |
| Dependencies | api-surface-extractor |

**Output schema** (`auth-profile.json`):
- Auth mechanism(s): JWT, OAuth2, API key, Azure AD, session-based, etc.
- Token acquisition flow (how to get a token without a browser)
- Scopes/roles detected
- Test auth strategy (how to authenticate in tests)

### data-model-mapper

| Attribute | Value |
| --------- | ----- |
| Purpose | Extract entities, relationships, schemas from ORM/SQL/migrations |
| Inputs | Repo + `repo-profile.json` |
| Outputs | `data-model.json` |
| Dependencies | repo-scanner |

**Output schema** (`data-model.json`):
- Entities with fields and types
- Relationships (one-to-many, many-to-many, etc.)
- ER diagram (Mermaid)
- Data dependencies between entities
- Migration history summary

### dependency-tracer

| Attribute | Value |
| --------- | ----- |
| Purpose | Map inter-service calls, external APIs, message queues, async flows |
| Inputs | Repo + `repo-profile.json` |
| Outputs | `dependency-map.json` |
| Dependencies | repo-scanner |

**Output schema** (`dependency-map.json`):
- Upstream services (what calls this service)
- Downstream services (what this service calls)
- External API integrations
- Message queue producers/consumers
- Async flow patterns

### doc-generator

| Attribute | Value |
| --------- | ----- |
| Purpose | Produce architecture docs, sequence diagrams, flow diagrams from all analysis outputs |
| Inputs | All upstream JSON outputs |
| Outputs | Markdown + Mermaid diagram files |
| Dependencies | api-surface-extractor, auth-flow-analyzer, data-model-mapper, dependency-tracer |

**Outputs**:
- Architecture overview document
- Sequence diagrams (Mermaid) for key flows
- Flow diagrams for data paths
- API documentation draft
- Component interaction diagram

### gap-analyzer

| Attribute | Value |
| --------- | ----- |
| Purpose | Compare what exists (tests, docs, coverage) vs what should exist |
| Inputs | Repo + all upstream JSON outputs |
| Outputs | `gap-report.json` |
| Dependencies | All Pre-Dev agents above |

**Output schema** (`gap-report.json`):
- Endpoints without tests
- Endpoints without documentation
- Untested auth flows
- Missing error handling tests
- Data paths without validation tests
- Coverage percentage estimates

### test-plan-scaffolder

| Attribute | Value |
| --------- | ----- |
| Purpose | Generate ADO Test Plan structure with test suites organized by feature |
| Inputs | `endpoint-inventory.json` + `gap-report.json` + `data-model.json` |
| Outputs | Test plan export (CSV/JSON for ADO import), feature-based test suite structure |
| Dependencies | gap-analyzer |

---

## Dev Agents (5)

Test creation and code quality agents. Consume Pre-Dev outputs and produce BDD test cases, TDD recommendations, and test data strategies.

### test-case-creator

| Attribute | Value |
| --------- | ----- |
| Purpose | Create detailed BDD test cases per feature with AC mapping, data setup, automation candidacy |
| Inputs | `endpoint-inventory.json`, `gap-report.json`, `data-model.json`, user stories |
| Outputs | BDD test case documents, ADO Test Plan entries |
| Dependencies | Pre-Dev outputs |
| Methodology | BDD (Given/When/Then) |

**Output per test case**: name, user story, specific AC, verification steps, pre-data setup, data config, setup/teardown, automation candidacy (new/update/manual-only)

### unit-test-advisor

| Attribute | Value |
| --------- | ----- |
| Purpose | Analyze code and suggest/generate unit tests for untested logic |
| Inputs | Repo, `gap-report.json`, BDD test cases from test-case-creator |
| Outputs | Unit test files (JUnit/Jest), coverage improvement plan |
| Dependencies | test-case-creator (BDD specs inform TDD recommendations) |
| Methodology | TDD |

### component-test-generator

| Attribute | Value |
| --------- | ----- |
| Purpose | Generate component/integration tests for individual services |
| Inputs | Repo, `endpoint-inventory.json`, `data-model.json` |
| Outputs | Component test files, mock configurations |
| Dependencies | Pre-Dev outputs |

### api-contract-validator

| Attribute | Value |
| --------- | ----- |
| Purpose | Validate API contracts against implementation, find drift |
| Inputs | `endpoint-inventory.json`, any existing OpenAPI specs |
| Outputs | Contract drift report, updated OpenAPI draft |
| Dependencies | api-surface-extractor |

### test-data-planner

| Attribute | Value |
| --------- | ----- |
| Purpose | Design test data strategy, seed scripts, fixture generation |
| Inputs | `data-model.json`, `endpoint-inventory.json` |
| Outputs | Test data plan, seed scripts, fixture files |
| Dependencies | data-model-mapper, api-surface-extractor |

---

## SIT/E2E/Perf/A11y Agents (8)

Cross-service testing agents. Consume Dev outputs and produce automation for shared QA environments.

### postman-collection-builder

| Attribute | Value |
| --------- | ----- |
| Purpose | Generate Postman collections for API integration testing |
| Inputs | `endpoint-inventory.json`, `auth-profile.json`, test data plan |
| Outputs | Postman collection JSON, environment files |
| Tool Knowledge | Postman collection schema, pre/post scripts, variable chaining, Newman CLI |

### playwright-test-generator

| Attribute | Value |
| --------- | ----- |
| Purpose | Generate Playwright tests for UI and API |
| Inputs | `endpoint-inventory.json`, `auth-profile.json`, `gap-report.json`, BDD test cases |
| Outputs | `.spec.ts` files following BDD scenarios |
| Tool Knowledge | Playwright best practices, page objects, API testing, fixtures, test isolation |

### k6-scenario-builder

| Attribute | Value |
| --------- | ----- |
| Purpose | Generate k6 performance test scripts from API inventory + traffic data |
| Inputs | `endpoint-inventory.json`, Dynatrace data, `auth-profile.json` |
| Outputs | k6 scripts, threshold configs |
| Tool Knowledge | k6 best practices, scripting patterns, thresholds, load profiles |

### a11y-test-generator

| Attribute | Value |
| --------- | ----- |
| Purpose | Generate accessibility test configurations |
| Inputs | Frontend repo, `endpoint-inventory.json` |
| Outputs | a11y test scripts, axe-core configs |
| Tool Knowledge | axe-core rule sets, WCAG mapping, Playwright integration |

### newman-pipeline-builder

| Attribute | Value |
| --------- | ----- |
| Purpose | Generate ADO pipeline YAML for Newman execution |
| Inputs | Postman collection, ADO context |
| Outputs | ADO YAML pipeline templates |
| Tool Knowledge | ADO pipeline YAML, Newman tasks, variable groups, reporting |

### playwright-pipeline-builder

| Attribute | Value |
| --------- | ----- |
| Purpose | Generate ADO pipeline YAML for Playwright execution |
| Inputs | Playwright tests, ADO context |
| Outputs | ADO YAML pipeline templates |
| Tool Knowledge | ADO pipeline YAML, Playwright CI config, Docker/container strategies |

### traffic-prioritizer

| Attribute | Value |
| --------- | ----- |
| Purpose | Rank endpoints by production traffic for test prioritization |
| Inputs | Dynatrace CSV/JSON exports, `endpoint-inventory.json` |
| Outputs | Prioritized endpoint list with smoke/regression tags |

### defect-manager

| Attribute | Value |
| --------- | ----- |
| Purpose | Track defects, statuses, priorities, coordinate with PO/BA |
| Inputs | Test execution results, defect reports |
| Outputs | Defect logs, status reports |

---

## Release Agents (3)

### regression-orchestrator

| Attribute | Value |
| --------- | ----- |
| Purpose | Orchestrate full regression suite execution and reporting |
| Inputs | All test suites, pipeline configs |
| Outputs | Execution plan, aggregated results |

### release-readiness-reporter

| Attribute | Value |
| --------- | ----- |
| Purpose | Generate go/no-go report with all phase references |
| Inputs | All test results, `gap-report.json`, defect logs |
| Outputs | Release readiness report with phase references, defect status summary |

### release-notes-generator

| Attribute | Value |
| --------- | ----- |
| Purpose | Compile release notes from all inputs |
| Inputs | All phase outputs, defect validation, readiness report |
| Outputs | Release notes (SRE section, DevOps section, Support section, rollback strategy, production verification plan, known defects) |

---

## Support Agents (5)

### production-validator

| Attribute | Value |
| --------- | ----- |
| Purpose | Generate smoke tests for post-deployment validation |
| Inputs | Postman smoke collection, environment config |
| Outputs | Production validation script + results |

### escape-defect-analyzer

| Attribute | Value |
| --------- | ----- |
| Purpose | Analyze production defects that escaped testing |
| Inputs | Defect details, `gap-report.json`, test coverage data |
| Outputs | Root cause analysis, test gap updates, new test cases |

### metrics-collector

| Attribute | Value |
| --------- | ----- |
| Purpose | Aggregate QA metrics across repos and releases |
| Inputs | All test results over time |
| Outputs | Metrics dashboard data, trend reports |

### cross-repo-stitcher

| Attribute | Value |
| --------- | ----- |
| Purpose | Combine per-repo documentation into system-level views |
| Inputs | Multiple repo doc-generator outputs |
| Outputs | System architecture doc, cross-service sequence diagrams, full API catalog |

### playbook-generator

| Attribute | Value |
| --------- | ----- |
| Purpose | Create/update per-service operational playbooks |
| Inputs | doc-generator outputs, release notes, defect logs |
| Outputs | Per-service playbook (dependencies, configs, APIs, troubleshooting, known issues) |

---

## Tool-Specific Knowledge Bases

Each agent that generates automation has file-based reference docs from official best practices. Built collaboratively — user and agent define what's needed, acquire it, structure it.

```
qa-sdlc-agents/skills/
├── playwright/
│   ├── SKILL.md
│   └── references/
│       ├── best-practices.md
│       ├── api-testing-patterns.md
│       ├── page-object-patterns.md
│       └── ci-integration.md
├── k6/
│   ├── SKILL.md
│   └── references/
│       ├── best-practices.md
│       ├── scripting-patterns.md
│       └── threshold-strategies.md
├── postman-newman/
│   ├── SKILL.md
│   └── references/
│       ├── collection-patterns.md
│       ├── chaining-patterns.md
│       └── cli-reference.md
└── testing-practices/
    ├── SKILL.md
    └── references/
        ├── bdd-patterns.md
        ├── tdd-patterns.md
        ├── test-pyramid.md
        └── test-design-techniques.md
```

These are the **North Star** for each agent. Every output must align with these references. They ensure reproducibility.

---

## Agent Build Process (Collaborative)

For each agent:

1. **Define** — User and Claude define purpose, inputs, outputs, triggering conditions
2. **Acquire Knowledge** — Pull official docs, best practices. File-based initially (Context7 or similar later)
3. **Create References** — Structure into `references/` folder
4. **Build Agent** — Create agent .md with frontmatter, skills, templates, prompts referencing the knowledge base
5. **Test** — Run against a real repo
6. **Iterate** — Refine based on results

---

## Phased Approach

**Phase 0 (Current — MVP):** Build all agents with full instructions, templates, file-based references. LLM inference generates outputs following reference documentation. Focus: correctness and completeness.

**Phase 1 (Efficiency Iteration):** After Phase 0 is validated:
- Identify repetitive operations that can be scripted (Python)
- Create Python scripts for deterministic outputs (JSON schema generation, ADO import formatting, collection assembly)
- Agents invoke scripts for deterministic parts, use LLM for judgment-heavy parts
- Measure and optimize

---

## Relationship to Existing qa-copilot

The 6 existing qa-copilot agents are absorbed:

| Existing Agent | New Agent |
| -------------- | --------- |
| endpoint-discoverer | api-surface-extractor |
| auth-analyzer | auth-flow-analyzer |
| traffic-analyzer | traffic-prioritizer |
| collection-generator | postman-collection-builder |
| pipeline-generator | newman-pipeline-builder |
| diagnostics-agent | defect-manager |

Existing skills and reference docs become starting points for new agent skills.

---

## Build Order

Agents are built in QA workflow order:

1. **Pre-Dev** — repo-scanner first, then parallel (api-surface-extractor, auth-flow-analyzer, data-model-mapper, dependency-tracer), then doc-generator, gap-analyzer, test-plan-scaffolder
2. **Dev** — test-case-creator first (BDD specs inform everything), then parallel (unit-test-advisor, component-test-generator, api-contract-validator, test-data-planner)
3. **SIT** — postman-collection-builder and playwright-test-generator first, then k6/a11y, then pipelines, then traffic-prioritizer/defect-manager
4. **Release** — regression-orchestrator → release-readiness-reporter → release-notes-generator
5. **Support** — all can run in parallel, though cross-repo-stitcher benefits from others being done first
