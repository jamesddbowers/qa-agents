# Continuous Feedback & Improvement Sub-Phase (Support Phase)

## Phase Purpose

After the release dust settles, this phase drives improvement. QA analyzes metrics, facilitates retros, maintains playbooks, and ensures lessons learned feed back into the process — either short-circuiting to the Implementation phase for quick fixes or looping all the way back to Intake for re-prioritization.

## Deliverables

| Deliverable | Fundamental Collaborations |
| ----------- | -------------------------- |
| General feedback and suggestions for improvements | All teams |
| Playbooks (per service/application) | SRE, DevOps, Support |

## QA Actions

| QA Action | Spans Across (Roles) | Description |
| --------- | -------------------- | ----------- |
| Review Metrics | Scrum Masters, SRE | Analyzes defect density, test coverage, and release quality to drive improvements |
| Process Adjustments | Scrum Masters, Developers, DevOps | Recommends adjustments to reduce gaps between development and testing |
| Continuous Collaboration | PO, Scrum Masters, DevOps, SRE | Fosters ongoing collaboration between intake, development, and support teams for smoother releases |
| Playbook Maintenance | SRE, DevOps, Support | Keep per-service playbooks current with each release, incident, and defect resolution |

## Post-Release Retro Process

- Held **next business day** after release — everyone rested and clear-headed
- Discuss what went well, what didn't
- Each team interacts with their DevOps, SRE, and Support counterparts
- **Support team** may not attend (24/7 obligations) — Scrum Master can speak on their behalf with provided notes
- Same for SRE if needed
- Teams build action items from findings
- Can be part of regular retros or an immediate ad-hoc retro after a significant release or incident

## Metrics QA Tracks

| Metric | Purpose |
| ------ | ------- |
| Defect density | How many defects per feature/release — trending up or down? |
| Test coverage | What percentage of features/endpoints/flows have automated tests? |
| Release quality | How clean were releases? How many rollbacks? How many post-release defects? |
| Escape rate | How many defects made it to production that should have been caught earlier? |
| Automation ROI | Is automation catching things? Is it worth the investment? |

## Feedback Loop Routing

| Situation | Route |
| --------- | ----- |
| Quick fix needed (bug, minor enhancement) | **Short circuit to Implementation phase** — goes directly to Development |
| New feature or significant change needed | **Full loop back to Intake phase** — re-prioritization, planning, full cycle |
| Process improvement identified | Implemented within the team, documented in retro action items |
| Infrastructure/environment issue | Routed to DevOps, tracked separately |

## Playbook Maintenance

See [09-playbook-concept.md](09-playbook-concept.md) for full playbook details. In this phase, playbooks are:

- Updated with learnings from the release
- Updated with any new troubleshooting steps discovered during Post-Release
- Updated as defects are fixed (remove workarounds, update known issues)
- Reviewed for accuracy against current production state

## What Feeds Into This Phase

- Post-Release outputs: defect logs, incident records, post-mortem findings
- All phase test results (for metrics analysis)
- Team feedback and retro outputs

## What This Phase Produces

- Process improvement recommendations
- Updated playbooks
- Metrics reports and trend analysis
- Feedback routed to appropriate phase (Implementation or Intake)
- Action items for teams
