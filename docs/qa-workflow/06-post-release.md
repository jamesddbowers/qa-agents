# Post-Release Sub-Phase (Support Phase)

## Phase Purpose

The release has been deployed to production. This phase covers deployment verification, production monitoring, incident response, and the opinionated rollback strategy that protects teams and users.

## Deliverables

| Deliverable | Fundamental Collaborations |
| ----------- | -------------------------- |
| Post-release defect logs and issue resolutions | Developers, SRE, DevOps, Support |

## QA Actions

| QA Action | Spans Across (Roles) | Description |
| --------- | -------------------- | ----------- |
| Production Monitoring | DevOps, SRE, Support | QA has access to monitor production — not primary responsibility, but available as-needed. QA knows expected vs unexpected behavior from release notes. Direct communication line with DevOps/SRE/Support. |
| Incident Resolution | Developers, Support | When issues are found, QA provides context on expected behavior, helps validate fixes. |
| Post-Mortem Reviews | Developers, SRE, Release Mgmt | QA participates in reviews to identify improvements for future releases. |

## Deployment Verification Process

After the release is deployed:

### Step 1: Deployment Checklist Verification

- Everything deployed exactly per release notes
- **Checked twice** — verified that all artifacts, configurations, and infrastructure are set up as documented
- If the checklist fails (something wasn't deployed correctly), the **deployment team** stays on to fix it — that's their problem

### Step 2: Post-Deployment Validation

- Run the production verification plan (from Release Notes)
- QA-driven tip-of-pyramid checks
- Verify features work from a user perspective
- Confirm configurations are applied correctly

### Step 3: Priority-Based Issue Response

If issues are found after verified deployment:

| Priority | Criteria | Response Window | Action |
| -------- | -------- | --------------- | ------ |
| **Critical** | System down, major UI section broken (e.g., entire navigation doesn't populate) | **5 minutes** | If not resolved in 5 min → automatic rollback. No questions, no concerns. |
| **Lower** | Cosmetic issues, non-breaking problems (e.g., inverted image, minor display issue) | **30 minutes** | On-the-fly RCA. If window collapses without resolution → rollback. |

## Rollback Philosophy (Opinionated)

This is a core principle of this QA workflow:

### The Rule

**When the rollback window collapses, everybody says goodbye.**

- No late-night heroics
- No keeping SRE/support/DevOps on calls for the development team's problem
- Protect users and data first — roll back fast
- The responsible team follows up **next business day** with fresh eyes, full information, and rested people

### The Process

1. Release is deployed
2. Deployment checklist verified (twice)
3. Post-deployment validation runs
4. If issues found → priority determines response window
5. If response window collapses → **automatic rollback**
6. RCA is triggered and sent to the development team
7. Development team follows up next business day or next release cycle
8. Fresh teams, full understanding, no running around like chickens

### Why This Matters

- **Don't punish support teams, SREs, and DevOps** for development mistakes
- Roll back fast, protect users and data
- Give the responsible team time and clarity to fix it right
- No people on late at night who don't have to be there
- Forces teams to get releases right the first time (maturity driver)
- More professional, more mature, forces accountability

### Accountability

If the deployment was set up correctly (checklist verified twice) but there's still a code issue:

- That's on the development team
- They have the RCA to work from
- They re-release with the fix in the next cycle
- Performance review territory if it's a pattern — but not a firing offense for a single incident
- The team learns and matures from it

### Configuration Rollback

Part of the rollback strategy includes:
- What configurations need to be reset
- What database migrations need to be reversed (if any)
- What feature flags need to be toggled
- This is documented in the Release Notes before deployment

## Post-Mortem Process

After any significant production incident:

- **Production monitoring** watches for critical issues or defects after release
- **Incident resolution** involves QA working with support teams and developers
- **Post-mortem reviews** identify improvements for future releases
- Findings feed into the Continuous Feedback & Improvement phase

## What Feeds Into This Phase

- Release Notes (including production verification plan, rollback strategy)
- Signed release package
- Deployment checklist
- Production monitoring tools and dashboards

## What This Phase Produces for Next Phase

- Post-release defect logs
- Incident resolution records
- Post-mortem findings
- Production behavior data (what worked, what didn't)
- Input for Continuous Feedback & Improvement
