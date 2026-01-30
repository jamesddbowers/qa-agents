# Development Sub-Phase (Implementation Phase)

## Phase Purpose

This is where the bulk of QA work happens. While developers build features, QA works **in parallel** — creating detailed test cases, building automation, manually verifying features, and providing continuous feedback. By the time a developer finishes a feature, QA should already have tests ready. This is the base of the test pyramid — the majority of all testing happens here.

## Deliverables

| Deliverable | Fundamental Collaborations |
| ----------- | -------------------------- |
| Continuous test reports for in-progress features | Developers, Scrum Masters |
| Defect tracking and communication | Developers, Scrum Masters |
| Test cases in Azure DevOps Test Plans | Developers, PO, BA (review) |
| Feature-level test automation | Developers |

## QA Actions

| QA Action | Spans Across (Roles) | Description |
| --------- | -------------------- | ----------- |
| Work-in-Progress Testing | Developers | As soon as a dev pulls a story, QA starts building. Takes the pre-dev test plan and breaks it into detailed test cases. Creates new automation, updates existing automation for changed features, extends tests where scope grew. By code-complete, tests already exist. |
| Update Test Cases | Developers | Both automation code and documentation. New features get new test cases. Modified features get updated test case docs. Keep the test case repository in Azure DevOps Test Plans accurate. |
| Test Case Review | Developers, PO, BA | Team reviews test cases to verify they make sense. PO/BA confirm scope — "that's too much" or "that's exactly right." Developers can build to match these tests. |
| Manual Verification | Developers | Before running automation, manually verify the feature works. Confirm expected behavior first. Don't waste cycles debugging whether automation or feature is broken. |
| Provide Feedback | Developers | Continuous feedback loop. Defects found → fixed → retested within dev environment before promotion. |

## Test Case Structure

Each test case created in this phase includes:

| Field | Description |
| ----- | ----------- |
| Test Case Name | Descriptive name for the test |
| Associated User Story | Link to the user story in Azure DevOps |
| Specific Acceptance Criteria | Which AC this test case specifically validates |
| Verification Steps | Bullet points of what will be verified (not a full automation walkthrough — just what's being checked) |
| Pre-Data Setup | What data needs to exist before the test runs |
| Data Configuration | What data will be used and how it's assembled |
| Setup/Teardown | Environment and data preparation/cleanup procedures |
| Automation Candidacy | Marked as: **New Test** (new automation needed) or **Update to Existing** (existing automation needs modification) or **Manual Only** (no automation) |

## Test Case Review Process

1. QA creates test cases with the structure above
2. Test cases are presented to the team for review
3. **Developers** verify: "Yes, those test cases make sense for what we're building"
4. **PO and BA** verify: "Yes, that's the right scope — not too much, not too little"
5. Developers can then build according to these tests (the tests define expected behavior)
6. Not every test case will be an automation candidate — but clear AC tied to the user story likely should be automated

## BDD Format

All test cases use **Given/When/Then** format (BDD):

```gherkin
Feature: [Feature Name]

  Scenario: [Scenario Name]
    Given [precondition/setup]
    And [additional precondition]
    When [action taken]
    And [additional action]
    Then [expected outcome]
    And [additional verification]
```

This BDD format feeds into:
- Manual test execution (the steps are human-readable)
- Automation implementation (the structure maps to test code)
- TDD for developers (BDD scenarios inform what unit/component tests are needed)

## Manual-First Verification

Before throwing features at automation:

1. **Manually verify** the feature works as expected
2. **Confirm** expected behavior matches acceptance criteria
3. **Then** run automation against the code under test
4. **If automation fails but manual passes**: the automation has a bug — fix the automation
5. **If automation catches something manual missed**: it's a defect in the feature or AC — create a defect
6. **Determine**: is it the application under test or the automation itself? Route accordingly.

This prevents wasting cycles debugging two sets of code simultaneously.

## Defect Iteration Loop

Within the Development sub-phase, there is an iteration cycle:

```
QA finds issue → Defect created → Developer fixes → QA retests → Pass/Fail
                                                              ↓
                                                    If fail → back to developer
                                                    If pass → feature promoted
```

All defects must be resolved (or explicitly deferred with justification) before the feature is promoted to the next phase.

## What Does NOT Run Here

- **Playwright** — Too heavy for the organization's current maturity level. Not appropriate for per-feature testing in the dev environment.
- **Full regression** — Only feature-level testing. Full regression happens later.
- **Cross-service integration** — That's the SIT phase. Here we test features in isolation within their own service/repo.

## What DOES Run Here

- **Postman/Newman CLI** — Fast API smoke tests for the feature's endpoints
- **k6 (lightweight)** — Possibly fast performance tests per individual service (cost-conscious decision)
- **Manual testing** — Feature verification before automation
- **Unit/Component/Contract tests** — Developer-owned (TDD), must be complete before QA touches the feature
- **Feature-level automation** — New or updated automation per the test case review

## Developer-Owned Testing (Must Be Complete)

Before QA begins feature-level testing, developers must have completed:
- Unit tests (TDD)
- Component tests
- Contract tests
- Their own code reviews and quality gates

QA does not own these — but QA validates that they exist and pass (via the unit-test-advisor agent recommendations).

## What Feeds Into This Phase

- Pre-Development outputs: test plan, test approach, environment setup, initial test case shells
- Repo analysis outputs: endpoint inventory, data model, auth profile, dependency map, gap report

## What This Phase Produces for Next Phase

- Completed feature-level test cases in Azure DevOps Test Plans
- Feature-level automation (Postman/Newman collections, possibly fast k6 scripts)
- Test results and defect reports
- Information on what SIT/E2E/Perf/A11y tests should be added or updated (pyramid feeds upward)
- Confidence that individual features work correctly in isolation
