# Final Release Prep Sub-Phase (Implementation Phase)

## Phase Purpose

This is the **top of the test pyramid**. Every team's code for the entire domain (e.g., all of walgreens.com) is in one environment. Final regression testing verifies that core user workflows work across the entire platform. By this point, the bulk of testing is done — you're just making sure everything plays nice together at the highest level from a user's perspective.

## Deliverables

| Deliverable | Fundamental Collaborations |
| ----------- | -------------------------- |
| Release Readiness Report | Release Managers, DevOps, Developers |
| Sign-off on the release package | Release Managers, PO |
| Release Notes | PO, Developers, SRE, DevOps, Support Team |
| Defect Validation | Developers, PO, BA |

## QA Actions

| QA Action | Spans Across (Roles) | Description |
| --------- | -------------------- | ----------- |
| Final Regression Testing | Developers, DevOps | Top of pyramid. Full domain in one environment. Happy path positive and negative scenarios. Minimal test count — just core user workflows. Mobile API verification may also run here. |
| Defect Validation | Developers, PO, BA | Confirm all critical/high defects are resolved. Document deferred defects with justification. |
| Release Readiness Report | Release Managers, DevOps, Developers | Compile evidence, references, proof of testing across all phases. |
| Release Notes Creation | PO, Developers, SRE, DevOps, Support | Comprehensive release documentation. |
| Release Package Sign-off | Release Managers, PO | Final verification that tested code = deployed code. |

## Final Regression Testing

This is **not** a full re-test of everything. It's the tip of the pyramid:

- **Happy path** positive and negative scenarios only
- **Minimal test count** — you're testing core user-perspective workflows
- **Confidence is inherited** from earlier phases: Development phase covered the bulk, SIT covered cross-service integration
- You're verifying that from a **UI perspective and user perspective**, the application works
- **Mobile API verification** may also run here for services backing the mobile app
- **Performance testing** at this level is not every release — maybe monthly for the full application

## Release Readiness Report

The Release Readiness Report verifies that everything that needed to be done was done:

### Contents

- **References to test reports** from every phase:
  - Unit test reports from Development phase
  - Feature-level test results from Development phase
  - SIT/E2E results from SIT phase
  - Performance/accessibility reports from SIT phase
  - Final regression results from this phase
- **Defect status** for this release:
  - What was found and fixed
  - What was found and deferred (with justification)
  - Ongoing known bugs per team/feature set — shown every release so teams can't forget them
- Does not go into detail per item — provides references and proof

### Presentation

- Presented in a **1-2 hour team meeting**
- Each team speaks to their features
- Confirms testing was done
- Answers questions from supporting teams (SRE, DevOps, Support)

### Ongoing Known Bug Tracking

Every release, the report shows:
- How long known bugs have been open
- That they are acknowledged
- Gives business/product visibility and incentive to prioritize fixes
- "We made the choice not to fix this, but we are doing this" — keeps accountability visible

## Sign-Off on Release Package

Verifies the **code that was tested is the code being deployed**:

- Right branches, right feature branches merged to main
- Everything that passed final regression is in the package
- **Verified twice** — the code matches what was tested
- No surprises between what was tested and what ships

## Release Notes

The release notes are a comprehensive document with sections for different audiences:

### SRE Section

- New configurations that need to be set
- New API endpoints
- Dependencies (upstream/downstream changes)
- Technical details needed to deploy and support
- Any infrastructure changes

### DevOps Section

- Infrastructure requirements
- Deployment verification checklist
- Final check items

### Support Team Section

- How new features work from a user perspective
- What's new, changed, or updated
- How users interact with it
- Enables support to **practice supporting** before release rather than figuring it out after

### Rollback Strategy

- Clearly defined rollback targets
- What configurations need to be reset if rollback occurs
- Automated rollback triggers where possible

### Production Verification Plan

- QA-driven, tip-of-pyramid checks to verify correct deployment
- Not full regression — feature-level, high-level E2E verification
- Confirms: correct deployment, correct configurations, correct packages, features work from user perspective

### Known Defects

- All defects found during development of this feature set, called out
- Fixed defects with verification status
- Deferred defects with justification
- Carried forward each release — accountability never disappears

## Defect Validation

| Category | Description |
| -------- | ----------- |
| Fixed and Verified | Defects found during dev/SIT, fixed, and confirmed resolved |
| Deferred (Known) | Defects not fixed — explicitly marked with justification, PO/BA sign-off |
| Production Bugs (Ongoing) | Previously reported production bugs, status shown per team/feature set |

Every release forces teams to acknowledge: "We chose not to fix this." This keeps defects visible and creates incentive to address them.

## What Feeds Into This Phase

- SIT/E2E/Perf/A11y results proving cross-service integration
- All feature-level test results from Development
- Defect logs with resolution status
- Endpoint inventories, architecture docs, dependency maps

## What This Phase Produces for Next Phase

- Release Readiness Report (evidence package)
- Signed release package
- Release Notes (SRE, DevOps, Support, rollback, verification plan)
- Defect validation summary
- Production verification plan (used in Post-Release)
