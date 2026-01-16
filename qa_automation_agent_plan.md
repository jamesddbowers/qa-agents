# QA Automation Agent Plan (VS Code Co-Pilot Style)

> **Context:** This plan describes a set of *human-in-the-loop* assistants (agents/skills) designed to run **inside VS Code** against repos that are **already cloned locally**.  
> The agents are **not fully autonomous**: they **analyze**, **propose**, and **generate artifacts**, but **ask permission before running commands or writing files**, and **never push code**.  
> Primary near-term outcome: **API integration testing automation** using **Postman + Newman CLI** in **Azure DevOps (ADO)** pipelines.

---

## Operating Principles (Guardrails)

1. **Read-only by default**
   - “Read/analyze repo” means **no edits** to app source code.
2. **Human-in-the-loop for any action**
   - Before **running a command**: propose the command + purpose → request approval.
   - Before **writing a file**: propose filename/path + contents outline → request approval.
   - Before **modifying existing files**: produce a diff/patch → request approval.
3. **Safe output locations**
   - Prefer writing only to designated folders (example):
     - `/qa-agent-output/` (reports, inventories, diagrams)
     - `/docs/generated/` (OpenAPI drafts, system diagrams)
     - `/tests/generated/` or `/postman/` (collections/environments)
4. **Explainability + confidence**
   - Every inference (endpoint, auth, schema, data dependency) includes:
     - **Source pointers** (file paths/classes/routes)
     - **Confidence level** (High/Medium/Low)
5. **No repo access assumptions**
   - Repos are already local; agents do not handle cloning/pulling.
   - Agents do not handle pushing/PR creation, but **do** generate **commit/PR notes**.

---

## Agent Suite Overview (Capabilities as “Skills” inside VS Code)

### A. Discovery & Understanding Agents (Foundation)
- **Repo Discovery Agent**
  - Identifies service/module boundaries, entrypoints, frameworks, configs.
  - Produces a map of how the system is structured from code signals.
- **API Surface Extraction Agent**
  - Builds a complete endpoint inventory from routes/controllers/middleware.
  - Optionally generates an OpenAPI draft from code.
- **Auth & Access Discovery Agent**
  - Determines auth mechanism(s), token acquisition paths, scopes/claims/cookies.
  - Produces a non-browser “token recipe” usable for API tests.
- **Data Model & Dependency Agent**
  - Infers entities/relationships from ORM models, SQL strings, migrations if present.
  - Maps endpoint → data dependencies → setup/teardown strategy.

### B. Automation Build Agents (Postman/Newman + CI/CD)
- **Postman Collection Authoring Agent**
  - Generates collections for prioritized endpoints with assertions & chaining.
- **Test Data/Seeding Agent**
  - Generates seed/setup/teardown flows (prefer “seed via API”).
  - Namespaces test data per run to reduce collisions in chaotic environments.
- **Tagging & Suite Composition Agent**
  - Applies conventions for `smoke`, `regression`, `critical`, `high-volume`, `high-error`.
  - Creates smallest viable “Smoke Set” and evolving regression suites.
- **ADO Pipeline/Runner Agent**
  - Generates Azure DevOps YAML templates for Newman runs and reporting outputs.
- **Diagnostics & Triage Agent**
  - Classifies failures (product vs env vs data vs auth vs test).
  - Generates reproduction steps and links trace IDs when available.

### C. Observability & Prioritization Agents (Dynatrace-driven)
- **Telemetry Ingestion & Prioritization Agent**
  - Consumes exported Dynatrace data (CSV/JSON) to rank endpoints:
    - volume, errors, latency, criticality
  - Merges telemetry findings with code-derived endpoint inventory.
- **Executive Reporting Agent**
  - Generates director-friendly summaries and slide-deck-ready bullets.
  - Produces CSVs and concise narratives to defend priorities.

### D. Framework Evolution Agents (Playwright API + UI + beyond)
- **Playwright Framework Assessment & Hardening Agent**
  - Reviews existing Playwright “hello world,” identifies structural gaps.
  - Proposes refactors for robustness (config, reporting, fixtures, tagging).
- **Postman → Playwright API Forklift Agent**
  - Converts most Postman API tests into Playwright API tests.
  - Keeps Newman smoke tests as fast gate checks.
- **Dev Testing Enablement Agent**
  - Plans and scaffolds unit/component test strategies for developers.
- **E2E Rationalization Agent**
  - Ensures UI tests exist only where they add value beyond unit/component/API.
- **k6 Performance Testing Agent**
  - Generates k6 scenarios based on API inventory + production telemetry patterns.
  - Helps estimate environment requirements and extrapolate results.

---

# Phase 1 (MVP): API Integration Testing Automation (Postman + Newman on ADO)

> **Goal (60 days max):** Automated **API integration testing** executed via **Newman CLI in Azure DevOps pipelines**, prioritizing top endpoints and establishing reliable smoke gates.  
> **Near-term target:** automate the **highest-priority ~50%** of production-used endpoints (by volume + error impact), with a **Smoke Set v1** delivered early.

## 1. MVP Step Order (What we must enable first)

### 1) Build endpoint inventory from code (Repo → Endpoint Catalog)
**Purpose:** establish “what exists” before trying to test it.

**Agent(s):** API Surface Extraction Agent + Repo Discovery Agent  
**Outputs:**
- `qa-agent-output/api-catalog.md`
- `qa-agent-output/api-catalog.json`
- `docs/generated/openapi-draft.yaml` (partial is acceptable; confidence annotated)

**Acceptance signals:**
- Methods/paths listed with source pointers and service/module ownership hints.

---

### 2) Solve authentication without browser token harvesting
**Purpose:** enable pure API testing.

**Agent(s):** Auth & Access Discovery Agent  
**Outputs:**
- `qa-agent-output/auth-playbook.md`
- `postman/auth-helper.postman_collection.json` (token fetch + env set)
- `postman/environments/<env>.template.postman_environment.json` (no secrets)

**Acceptance signals:**
- A documented, repeatable token acquisition workflow suitable for CI.

---

### 3) Ingest Dynatrace exports and prioritize endpoints (don’t boil the ocean)
**Purpose:** prove what matters and focus on critical usage + failures.

**Agent(s):** Telemetry Ingestion & Prioritization Agent  
**Inputs (manual export):**
- Dynatrace exports (CSV/JSON) containing endpoint volume/errors/latency.
- Optional: trace sample details, sanitized payload examples.

**Outputs:**
- `qa-agent-output/priority-report.md`
- `qa-agent-output/priority-report.csv`
- `qa-agent-output/smoke-set-v1.md` (criteria + endpoint list + rationale)

**Acceptance signals:**
- Ranked list merged with code-inventory, highlighting “top volume” and “top error.”

---

### 4) Define Smoke vs Regression tagging conventions (API-only)
**Purpose:** create shared language and pipeline gates.

**Agent(s):** Tagging & Suite Composition Agent  
**Outputs:**
- `qa-agent-output/test-suite-conventions.md`
- Tagging rules, plus initial Smoke and Regression suite composition.

**Acceptance signals:**
- Clear criteria for smoke tests (fast, deterministic, critical path).
- Clear criteria for regression (broader, slower, deeper assertions).

---

### 5) Generate Postman collections for Smoke Set v1 + Regression v1
**Purpose:** produce runnable automation artifacts now.

**Agent(s):** Postman Collection Authoring Agent  
**Outputs (examples):**
- `postman/collections/smoke.postman_collection.json`
- `postman/collections/regression.postman_collection.json`
- Optional per-service collections for modular ownership.

**Minimum test design expectations:**
- Status code assertions
- Basic schema/shape checks (even if inferred)
- Chaining where necessary (create → use ID → verify)
- Deterministic naming/namespace patterns

---

### 6) Test data plan + seeding strategy to survive chaotic environments
**Purpose:** reduce flake and increase confidence.

**Agent(s):** Data Model & Dependency Agent + Test Data/Seeding Agent  
**Outputs:**
- `qa-agent-output/test-data-plan.md`
- `postman/collections/seed-setup.postman_collection.json`
- `postman/collections/teardown.postman_collection.json` (where feasible)

**Preferred patterns (ranked):**
1. Seed via API (create prerequisites with setup calls)
2. Namespace every test run (unique identifiers)
3. Cleanup via API (delete created entities)
4. DB seeding only when governance allows and is safe

---

### 7) Azure DevOps pipeline templates for Newman runs + reporting
**Purpose:** CI/CD execution becomes consistent and repeatable.

**Agent(s):** ADO Pipeline/Runner Agent  
**Outputs:**
- `ado/azure-pipelines-smoke.yml` (runs on deploy, per environment)
- `ado/azure-pipelines-regression.yml` (nightly or pre-release gate)
- `qa-agent-output/newman-runner-config.md`

**Acceptance signals:**
- Standard reports produced (JUnit/XML/HTML as your org supports)
- Clear failures in pipeline logs with next-step guidance

---

### 8) Diagnostics + failure triage workflows (keep maintenance low)
**Purpose:** speed up triage and avoid “automation abandonment.”

**Agent(s):** Diagnostics & Triage Agent  
**Outputs:**
- `qa-agent-output/triage-playbook.md`
- Optional: `qa-agent-output/failure-classification.md` template

**Acceptance signals:**
- Failures classified into: auth/data/env/product/test
- Repro steps generated (curl/Postman steps), with trace ID hooks

---

## 2. MVP Definition of Done
- Endpoint inventory exists and is repeatable (code-derived).
- Authentication is solvable without UI token scraping.
- Dynatrace-informed prioritization produces a justified Smoke Set v1.
- Postman collections exist for Smoke + Regression, runnable locally and in CI.
- Newman runs in ADO pipelines with readable reports.
- A test-data strategy exists to reduce flake in ephemeral environments.
- Agents remain human-controlled with explicit approval gates.

---

## 3. MVP “Commit / PR Notes” Requirement (Human-owned Git actions)
Agents must generate:
- **Change summary** (what files added/updated and why)
- **How to run locally**
- **CI behavior**
- **Known limitations / TODOs**
- A suggested **commit message** and **PR description** template

Example output file:
- `qa-agent-output/commit-and-pr-notes.md`

---

# Phase 2: Consolidate Robust API Testing in Playwright (Keep Newman for Smoke)

> **Goal:** Hardening Playwright as the single long-term framework for **API + UI**, while retaining **Newman smoke tests** as fast deploy gates.

## 1) Harden the existing Playwright framework (robust base)
**Agent(s):** Playwright Framework Assessment & Hardening Agent  
**Outputs:**
- `qa-agent-output/playwright-framework-assessment.md`
- Proposed structural changes (config, fixtures, reporters, tagging, retries policy)
- CI pipeline recommendations for Playwright runs (ADO templates)

**Key robustness expectations:**
- Standard project structure (tests, fixtures, configs)
- Environment configuration pattern (per env)
- Reporting + artifacts (screenshots/traces for E2E; API logs for API)
- Tagging aligned with Smoke/Regression strategy

## 2) Forklift *most* Postman API tests to Playwright API tests
**Agent(s):** Postman → Playwright API Forklift Agent  
**Outputs:**
- `playwright/tests/api/...` generated tests
- Shared request helpers (auth, base URL, headers)
- Equivalent assertions + improved capabilities where relevant

**Important exception:**
- **Keep Smoke tests in Postman/Newman**
  - Fast, simple, minimal dependencies
  - Runs on every deploy to validate environment readiness

## 3) Single “quality control plane” vision (API + UI under Playwright)
- Long-term: Playwright becomes primary framework for:
  - API regression (richer fixtures/config/reporting)
  - UI E2E testing
- Newman remains a thin **smoke-gate** layer.

---

# Phase 3: Developer Enablement — Unit + Component Testing Strategy

> **Goal:** Move quality left by enabling teams to catch defects earlier and reduce E2E reliance.

## Capabilities
**Agent(s):** Dev Testing Enablement Agent + Repo Discovery Agent  
**Outputs:**
- `qa-agent-output/unit-test-gap-analysis.md`
- `qa-agent-output/component-test-plan.md`
- Templates and recommendations per stack (Java/.NET/TS)

## Expectations
- Identify where unit tests are missing or mis-scoped
- Recommend component tests where services touch DB/external deps
- Identify seams for mocking/fakes and stable test data patterns

## Relationship to API tests
- Maintain Postman smoke gates across envs (dev/QA/stage as appropriate)
- Use component tests to reduce brittle integration surface where possible

---

# Phase 4: UI End-to-End (Playwright) — Rationalize and Fill True Gaps

> **Goal:** Create UI E2E tests only where they add value beyond unit/component/API coverage.

## Capabilities
**Agent(s):** E2E Rationalization Agent + Playwright Framework Agent  
**Outputs:**
- `qa-agent-output/ui-e2e-test-strategy.md`
- E2E inventory: existing tests, redundancy analysis, recommended removals/additions
- New E2E tests only for critical journeys and true integration gaps

## Guardrail
- If a defect can be reliably covered at unit/component/API level, do that first.

---

# Phase 5: Performance Testing with k6 (Can start in parallel after Phase 1)

> **Goal:** Build performance tests grounded in real production patterns using Dynatrace telemetry.

## Capabilities
**Agent(s):** k6 Performance Testing Agent + Telemetry Agent  
**Inputs:**
- Endpoint inventory + prioritized flows
- Dynatrace latency/throughput/error patterns (exported)
- Any available environment sizing info (CPU/mem hints, if accessible)

**Outputs:**
- `k6/scenarios/...` (load profiles and scripts)
- `qa-agent-output/perf-test-plan.md`
- `qa-agent-output/environment-sizing-notes.md`
- `qa-agent-output/extrapolation-model.md` (how to interpret non-prod results)

## Notes
- A truly production-like environment may be unavailable; agent helps:
  - choose realistic target loads
  - run at scaled percentages
  - extrapolate and communicate risk

---

# Full-Scale Capability Checklist (Everything Discussed)

## P0/P1 Core (Must-have early)
- Code-derived endpoint inventory + OpenAPI draft
- Auth discovery + non-browser token workflows
- Dynatrace-driven prioritization merged with code inventory
- Postman collections generation (smoke/regression)
- Test data seeding strategy and artifacts
- ADO pipeline templates for Newman + reporting
- Triage workflows and failure classification
- Commit/PR notes generation for human Git workflows

## Expanded (Sustaining & Scaling)
- Contract drift detection (inventory diffs, OpenAPI diffs)
- Flake detection and stabilization recommendations
- Coverage reporting by endpoint usage and incident pain
- Director-ready reporting summaries

## Long-term (Unified quality platform)
- Playwright framework hardening (API + UI)
- Postman → Playwright API forklift (keep Newman smoke)
- Unit/component testing enablement
- UI E2E rationalization based on lower-level coverage
- k6 performance testing grounded in telemetry

---

## Appendix: Suggested Folder Layout (Optional)
```
/qa-agent-output/
  api-catalog.md
  api-catalog.json
  auth-playbook.md
  priority-report.md
  priority-report.csv
  smoke-set-v1.md
  test-suite-conventions.md
  test-data-plan.md
  newman-runner-config.md
  playwright-framework-assessment.md
  commit-and-pr-notes.md

/docs/generated/
  openapi-draft.yaml

/postman/
  /collections/
    smoke.postman_collection.json
    regression.postman_collection.json
    seed-setup.postman_collection.json
    teardown.postman_collection.json
    auth-helper.postman_collection.json
  /environments/
    dev.template.postman_environment.json
    qa.template.postman_environment.json
    stage.template.postman_environment.json

/ado/
  azure-pipelines-smoke.yml
  azure-pipelines-regression.yml

/playwright/
  (phase 2+)
```

---

## Appendix: “Agent Approval Prompts” (Examples)

- **Before running a command**
  - “I plan to run: `npm test` to detect existing test harnesses. OK to proceed?”
- **Before writing a file**
  - “I plan to write `qa-agent-output/api-catalog.md` with endpoint inventory and source pointers. OK?”
- **Before modifying an existing file**
  - “I found improvements to `azure-pipelines.yml`. Here is a diff. OK to apply?”

---

*Last updated:* 2026-01-16
