# QA Workflow Overview

## QA Philosophy

QA is not a gate at the end of development. QA runs **in parallel** with all other teams throughout the entire SDLC. While intake teams, developers, DevOps, SREs, and support teams execute their own workflows, QA has its own track that runs alongside — plugging in at specific points, collaborating with specific roles, and producing specific deliverables at each phase.

This document captures what QA should be doing, when, with whom, and what they should produce.

## Maturity Context

This workflow targets **Level 3 out of 5** on a QA maturity scale:

| Level | Description |
| ----- | ----------- |
| 1 | No QA process, ad-hoc testing |
| 2 | Basic manual testing, some test cases |
| **3** | **Standard operating procedure: structured QA across SDLC, automation, documented processes (THIS LEVEL)** |
| 4 | Advanced automation, embedded QA in delivery teams, CI/CD integrated testing |
| 5 | Full automation, AI-assisted QA, delivery teams own all testing, SRE/support may be automated |

## Organizational Context

- DevOps is a **separate team** (not embedded with developers) — explicit coordination required
- No existing QA processes — building from scratch
- No meaningful architectural documentation exists
- Repos are the source of truth ("the Bible")
- Dynatrace reports supplement repo analysis
- User stories in Azure DevOps (some lost from Jira migration)
- Feature-based test organization (not story-based, since historical stories are incomplete)

## Phase Map

```
┌─────────────────┐   ┌──────────────────────────────────────────────────────────────┐   ┌──────────────────────────────────┐
│  INTAKE PHASE    │   │                    IMPLEMENTATION PHASE                       │   │         SUPPORT PHASE             │
│                  │   │                                                                │   │                                  │
│  Intake          │──▶│  Pre-Dev ──▶ Development ──▶ SIT/E2E/Perf/A11y ──▶ Final     │──▶│  Post-Release ──▶ Continuous      │
│                  │   │                                                    Release    │   │                   Feedback &      │
│                  │   │                                                    Prep       │   │                   Improvement     │
└─────────────────┘   └──────────────────────────────────────────────────────────────┘   └──────────────────────────────────┘
         ▲                                                                                              │
         └──────────────────────────────────────────────────────────────────────────────────────────────┘
                                              Feedback Loop (short circuit to Implementation or full loop to Intake)
```

## Test Pyramid Mapped to Phases

Each phase corresponds to a level of the test pyramid. The bulk of testing happens at the base (Development), with progressively fewer but broader tests as you move up.

```
                    ╱╲
                   ╱  ╲           Final Release Prep
                  ╱ UI ╲          Happy path only, full domain
                 ╱ E2E  ╲        Playwright (minimal suite)
                ╱────────╲
               ╱ SIT/E2E/ ╲      SIT, E2E, Perf, A11y Phase
              ╱  Perf/A11y  ╲     Cross-team integration
             ╱   Mid-tier    ╲    Playwright, k6, axe-core
            ╱────────────────╲
           ╱   Development    ╲    Development Phase
          ╱  Feature testing   ╲   Per-team, per-feature
         ╱  API smoke, fast    ╲   Postman/Newman, fast k6
        ╱  perf, manual verify  ╲  No Playwright here (too heavy for org maturity)
       ╱────────────────────────╲
      ╱   Unit/Component/Contract ╲   Developer-owned (TDD)
     ╱   (not QA agent scope —     ╲  Must be complete before QA touches it
    ╱     devs own this level)      ╲
   ╱────────────────────────────────╲
```

**Each NFR has its own mini-pyramid:**
- Performance testing: bulk at Dev (per-service), mid at SIT (cross-service), minimal at Final Release (monthly full-app)
- Accessibility testing: similar distribution
- The pyramid applies separately to functional and non-functional requirements

## Tooling Matrix

| Tool | Phase(s) Used | Purpose |
| ---- | ------------- | ------- |
| Postman/Newman CLI | Development, SIT | API smoke testing, discovery, initial integration testing. Long-term: smoke tests only. |
| Playwright (UI) | SIT/E2E, Final Release | UI end-to-end testing. NOT used in Development phase (too heavy for org maturity). |
| Playwright (API) | SIT | API integration testing (long-term migration from Postman for non-smoke tests). Monorepo with UI tests. |
| k6 | Development, SIT, Final Release (monthly) | Performance testing. Separate repo. |
| axe-core (via Playwright) | SIT | Accessibility testing, WCAG compliance. |
| Azure DevOps Test Plans | All phases | Test case management, feature-based organization. |
| Azure DevOps Pipelines | Development, SIT, Final Release | CI/CD for test execution (Newman, Playwright, k6). |
| Dynatrace | Pre-Dev, SIT | Traffic analysis for test prioritization. |

## Testing Methodology

- **BDD (Behavior-Driven Development)** — All QA-created test cases use Given/When/Then format. This is the source that feeds everything downstream.
- **TDD (Test-Driven Development)** — Developer-owned tests (unit, component, contract). Informed by BDD scenarios.
- **BDD → TDD flow**: QA defines expected behaviors top-down, developers build to those specs bottom-up. The two reinforce each other.

## Document Index

| File | Contents |
| ---- | -------- |
| [01-intake.md](01-intake.md) | Intake phase (stub — agents out of scope for now) |
| [02-pre-development.md](02-pre-development.md) | Pre-Development sub-phase |
| [03-development.md](03-development.md) | Development sub-phase |
| [04-sit-e2e-perf-a11y.md](04-sit-e2e-perf-a11y.md) | SIT/E2E/Performance/Accessibility sub-phase |
| [05-final-release-prep.md](05-final-release-prep.md) | Final Release Prep sub-phase |
| [06-post-release.md](06-post-release.md) | Post-Release sub-phase |
| [07-continuous-feedback.md](07-continuous-feedback.md) | Continuous Feedback & Improvement sub-phase |
| [08-role-interaction-grid.md](08-role-interaction-grid.md) | Role × Phase interaction matrix |
| [09-playbook-concept.md](09-playbook-concept.md) | Per-service operational playbook concept |
| [10-deliverables-index.md](10-deliverables-index.md) | Master deliverable table with agent mappings |
