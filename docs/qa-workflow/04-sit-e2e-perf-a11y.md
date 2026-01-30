# SIT, E2E, Performance, Accessibility Testing Sub-Phase (Implementation Phase)

## Phase Purpose

After individual teams complete feature-level testing in their dev environments, code is promoted to a shared QA environment where multiple teams' code is merged. This phase verifies that services work together correctly. It is the **middle tier of the test pyramid** — fewer tests than the Development phase, but broader scope covering cross-service integration, end-to-end user flows, performance, and accessibility.

## Environment Context

This phase runs in a **separate QA environment** where multiple teams' code is merged:

- Example: If a group has Search, Cart Service, and Store Locator teams, and only Search and Cart had new releases this sprint — both get promoted to the shared QA environment where Store Locator code also exists
- The merged environment tests that all services play nice together
- Each team individually passed their feature-level testing in dev before promotion

## Deliverables

| Deliverable | Fundamental Collaborations |
| ----------- | -------------------------- |
| SIT and end-to-end test results | Developers, DevOps, SRE |
| Reports on accessibility and performance testing | SRE, Developers, DevOps |
| Defect logs with statuses and priorities | Developers, DevOps, PO, BA, SRE |

### Additional Deliverables

These are produced within this phase as the test pyramid expands upward from Development:

- **New system integration tests** added based on feature-level test cases from Development
- **New end-to-end tests** added or updated based on new features
- **Performance tests** added, updated, or removed based on feature changes
- **Accessibility tests** added, updated, or removed based on UI changes

All of these are driven by the feature-level test cases created in the Development phase. The Development phase test cases inform what needs SIT/E2E/perf/a11y coverage at this level.

## QA Actions

| QA Action | Spans Across (Roles) | Description |
| --------- | -------------------- | ----------- |
| SIT Coordination | Developers, DevOps | Organize cross-team integration testing. Multiple teams' codebases merged into shared QA environment. Verify services work together. |
| End-to-End Testing | Developers | Functional E2E from user perspective across integrated services. Mid-pyramid — less scope than dev phase. **Playwright runs here.** |
| Performance Testing | Developers, DevOps | Cross-service performance testing with k6. **Must happen every release at this level.** Bulk of cross-service perf testing lives here. |
| Accessibility Testing | Developers | Automated a11y checks (axe-core via Playwright) against integrated environment. |
| Defect Management | Developers, PO, BA, DevOps | Track and manage defects for resolution and retesting. Iteration back to Development phase for fixes. PO/BA verify what is actually a defect vs expected behavior, and whether to fix now or backlog. |
| DevOps Collaboration | DevOps | Smoke testing environments, verifying infrastructure, deployment correctness, pipeline setup. Currently a separate team — explicit coordination required. |
| Mobile API Edge Testing | Developers, DevOps | If backend services compose to serve a mobile app, verify those API responses are correct. Not testing through the mobile app itself — just hitting the endpoints mobile depends on and verifying correct responses. |

## Defect Management Details

Defect management at this level extends beyond just developers:

- **Developers**: Fix the defects
- **Product Owners and Business Analysts**: Verify what is actually a defect and what is not. Decide whether to fix now, defer to backlog, or accept as expected behavior.
- **DevOps**: Help diagnose environment-related issues vs actual code defects
- **SRE**: Assist with infrastructure or configuration concerns

When a defect is found at this level, there is an **iteration back to the Development phase**:

```
SIT finds issue → Defect created → Routed to owning team →
    Team fixes in dev → Re-runs feature-level tests →
        Re-promotes to QA environment → SIT retests
```

## DevOps Collaboration Details

Across the Development, SIT/E2E/Perf/A11y, and Final Release Prep phases, DevOps collaboration is critical for:

- **Smoke testing** to verify environments look correct before running full test suites
- **Infrastructure verification** — everything deployed correctly, configurations applied
- **Pipeline setup** for test execution (Newman, Playwright, k6 pipelines)
- **Deployment correctness** — the right artifacts in the right environments

Currently, DevOps is a **separate team** in this organization. When the org matures, this coordination would be baked into delivery teams. For now, explicit handoffs and communication are required.

## Performance Testing at This Level

- This is where the **bulk of cross-service performance testing** happens
- k6 scripts test services working together under load
- **Must happen every release** — this is non-negotiable at SIT level
- At the Development level, performance testing is per-service (lighter, faster)
- At Final Release Prep, performance testing is full-app but less frequent (monthly)
- Each NFR has its own mini-pyramid with the bulk at Development, mid-tier at SIT

## Mobile API Edge Testing

If backend services compose to serve a mobile application:

- Verify that backend APIs return correct responses when services are integrated
- Not testing through the actual mobile app — just hitting endpoints the mobile app depends on
- Confirms that service composition doesn't break mobile-specific data contracts
- This is edge testing: "if you hit these particular APIs for this mobile reason, do you get the right information back?"

## What Feeds Into This Phase

- Development phase outputs: completed feature-level test cases, feature automation, defect reports
- Feature-level test cases determine what SIT/E2E/perf/a11y tests should be added or updated
- Pre-Dev outputs: test plan, endpoint inventory, dependency maps (for cross-service understanding)

## What This Phase Produces for Next Phase

- SIT/E2E test results proving cross-service integration works
- Performance test results with baselines and thresholds
- Accessibility compliance reports
- Defect logs with resolution status
- Confidence that the team group's code works together
- Input for Final Release Prep: which regression tests to run, known issues to carry forward
