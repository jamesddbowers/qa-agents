# Pre-Development Sub-Phase (Implementation Phase)

## Phase Purpose

After intake is complete and user stories are ready, QA prepares for the development cycle. This is where test planning happens at a high level — identifying what will be tested, how, and what environments and tools are needed. The test plan created here stays with the user story throughout the entire process.

## Deliverables

| Deliverable | Fundamental Collaborations |
| ----------- | -------------------------- |
| Test case documentation | Developers |
| Early test environment setup and configuration | DevOps, Developers |

## QA Actions

| QA Action | Spans Across (Roles) | Description |
| --------- | -------------------- | ----------- |
| Test Plan Creation | BA, PO, Developers | Creates test plans and test cases. Bridges across Scrum Master row visually in the workflow diagram but SM is not directly involved in creation — they may facilitate. |
| Test Approach Definition | PO, Developers | Defines which test types apply, tooling, scope. Spreads between PO and Developers. |
| Collaborate with Developers | Developers | Technical alignment on testability, data needs, environment concerns. |

## Test Plan Details

The test plan at this stage is **high-level** — not fully detailed. That comes in the Development sub-phase. At this point, the test plan includes:

- **Likely test targets**: Which features, flows, and edge cases will be tested
- **Automation candidates**: What will likely need new automation or updates to existing automation
- **Databases involved**: Which data stores the feature interacts with
- **Code touched**: Which services, modules, or components are affected
- **Test approach**: Types of testing needed (API, UI, performance, accessibility)
- **Flows and edge cases**: High-level scenarios, not step-by-step yet

This test plan **stays with the user story throughout the process**. It gets refined in the Development sub-phase with detailed test cases, specific data setups, and automation specifications.

## Environment Setup

QA collaborates with DevOps and Developers to ensure:

- Test environments are provisioned and configured
- Infrastructure dependencies are identified early
- Any special configuration (feature flags, test data, external service mocks) is planned
- CI/CD pipeline stubs are in place for test execution

## What Feeds Into This Phase

- Intake phase outputs: user stories with acceptance criteria
- Existing repo analysis (from Pre-Dev agents): endpoint inventories, data models, auth profiles, dependency maps

## What This Phase Produces for Next Phase

- Test plan attached to user story
- Test approach definition
- Environment readiness
- Initial test case shells (to be detailed in Development)
