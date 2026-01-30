# Playbook Concept

## What Is a Playbook?

A playbook is a **per-service living document** that serves as the operational knowledge base for SRE, DevOps, and Support teams. It captures everything needed to support a service in production — from dependencies and configurations to troubleshooting steps and known issues.

Think of it as "tribal knowledge made written." Instead of relying on people who happen to know how a service works, the playbook makes that knowledge explicit, maintainable, and accessible to anyone who needs to support the service.

## Example

The **Cart Service** would have its own playbook containing:
- What the Cart Service depends on (upstream and downstream)
- Its configurations and environment variables
- Its API endpoints and expected behaviors
- How to smoke test it
- Common issues and how to resolve them
- Known defects and workarounds

## Playbook Structure

### Service Identity

- Service name and owner team
- Repository location
- Technology stack
- Deployment target (environment, infrastructure)

### Dependencies

- **Upstream**: What services call this service
- **Downstream**: What services this service calls
- **External**: Third-party APIs, databases, message queues
- **Infrastructure**: Load balancers, caches, CDN, etc.

### Configurations

- Environment variables and their purposes
- Feature flags and their states
- Database connection details (not secrets — just which databases, which schemas)
- External service URLs and credentials references (pointing to vault, not actual secrets)

### APIs

- Endpoint inventory (from agent outputs)
- Expected request/response formats
- Authentication requirements
- Rate limits or throttling rules

### Smoke Test Procedures

- Steps to verify the service is healthy after deployment
- Key endpoints to hit and expected responses
- Health check URLs
- Quick functional checks

### Troubleshooting Guide

Decision-tree format:

```
IF: Users report cart items disappearing
THEN: Check Redis cache TTL settings
  IF: TTL is correct
  THEN: Check Cart Service logs for eviction errors
  IF: Logs show connection timeouts
  THEN: Verify Redis cluster health via monitoring dashboard
```

### Known Issues

- Tied to defect tickets in Azure DevOps
- Current workarounds for each
- Whether it's "expected behavior" (with explanation) or a tracked defect
- Updated as defects are fixed — workarounds removed, notes updated
- Example: "Browser cache causes stale data display after update — instruct user to hard refresh. Tracked as DEF-1234, low priority."

### Common User Issues

- Frequent support requests and their resolutions
- Browser-specific issues
- Data-related issues (cache, stale data, etc.)
- Whether each is expected behavior or a defect being tracked

## Playbook Lifecycle

### Creation

- Initially populated by agents during repo analysis (Pre-Dev phase)
- doc-generator and playbook-generator agents produce the first draft
- Cross-repo-stitcher adds system-level context

### Updates

- **Each release**: Release notes feed into the playbook. New endpoints, configurations, features are added.
- **After incidents**: New troubleshooting steps discovered during Post-Release are documented.
- **After defect fixes**: Known issues section updated — workarounds removed, notes clarified.
- **After support interactions**: Common user issues expanded based on real support tickets.

### Review

- Reviewed during Continuous Feedback & Improvement phase
- Accuracy verified against current production state
- Stale information removed or updated

## Who Uses the Playbook

| Audience | Usage |
| -------- | ----- |
| **SRE teams** | Primary users. Need technical details for deployment, monitoring, incident response. |
| **DevOps teams** | Infrastructure verification, configuration management, pipeline support. |
| **Support teams** | User-facing issue resolution, workaround guidance, escalation procedures. |
| **QA teams** | Reference for expected behavior, test data strategies, environment understanding. |
| **New team members** | Onboarding — understand how the service works without asking everyone. |

## Playbook vs Release Notes

| Aspect | Playbook | Release Notes |
| ------ | -------- | ------------- |
| Scope | Everything about a service (cumulative) | What changed in this release |
| Audience | SRE, DevOps, Support (operational) | All stakeholders (informational) |
| Lifecycle | Living document, updated continuously | Per-release, snapshot in time |
| Purpose | "How do I support this in production?" | "What's new and how do we deploy it?" |

Release notes **feed into** the playbook — each release adds to the cumulative knowledge base.

## Agent Support

The following agents contribute to playbook creation and maintenance:

- **doc-generator** (Pre-Dev): Initial architecture docs and API documentation
- **playbook-generator** (Support): Creates and updates playbook structure
- **cross-repo-stitcher** (Support): Adds cross-service context and dependencies
- **release-notes-generator** (Release): Provides per-release updates to feed into playbooks
