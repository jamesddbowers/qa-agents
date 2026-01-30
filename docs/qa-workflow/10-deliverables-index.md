# Deliverables Index

## Master Table

Every deliverable produced across the QA workflow, organized by phase.

### Intake Phase

| Deliverable | Fundamental Collaborations | Agent(s) | Template |
| ----------- | -------------------------- | -------- | -------- |
| Detailed and precise user stories | PO, BA | (out of scope) | TBD |
| Testable acceptance criteria | PO, BA | (out of scope) | TBD |

### Pre-Development Sub-Phase

| Deliverable | Fundamental Collaborations | Agent(s) | Template |
| ----------- | -------------------------- | -------- | -------- |
| Test case documentation | Developers | test-plan-scaffolder | TBD |
| Early test environment setup/config | DevOps, Developers | (manual + DevOps collab) | TBD |
| Repo profile (framework, structure, deps) | — | repo-scanner | repo-profile.json schema |
| Endpoint inventory | — | api-surface-extractor | endpoint-inventory.json schema |
| Auth profile | — | auth-flow-analyzer | auth-profile.json schema |
| Data model documentation | — | data-model-mapper | data-model.json schema |
| Dependency map | — | dependency-tracer | dependency-map.json schema |
| Architecture docs, sequence/flow diagrams | — | doc-generator | Mermaid templates |
| Gap report | — | gap-analyzer | gap-report.json schema |
| ADO Test Plan structure | — | test-plan-scaffolder | ADO export format |

### Development Sub-Phase

| Deliverable | Fundamental Collaborations | Agent(s) | Template |
| ----------- | -------------------------- | -------- | -------- |
| Continuous test reports | Developers, SM | (generated from test execution) | TBD |
| Defect tracking and communication | Developers, SM | defect-manager | TBD |
| Test cases in ADO Test Plans (BDD) | Developers, PO, BA (review) | test-case-creator | BDD template |
| Feature-level test automation | Developers | postman-collection-builder, component-test-generator | Per-tool patterns |
| Unit test recommendations (TDD) | Developers | unit-test-advisor | TDD patterns |
| Component test files | Developers | component-test-generator | Per-framework |
| API contract validation | Developers | api-contract-validator | OpenAPI draft |
| Test data plan and seed scripts | Developers | test-data-planner | Seed script templates |

### SIT/E2E/Performance/Accessibility Sub-Phase

| Deliverable | Fundamental Collaborations | Agent(s) | Template |
| ----------- | -------------------------- | -------- | -------- |
| SIT and E2E test results | Developers, DevOps, SRE | (generated from test execution) | TBD |
| Performance testing reports | SRE, Developers, DevOps | k6-scenario-builder | k6 report format |
| Accessibility testing reports | Developers | a11y-test-generator | axe-core report format |
| Defect logs with statuses/priorities | Developers, DevOps, PO, BA, SRE | defect-manager | TBD |
| New/updated SIT tests | Developers, DevOps | postman-collection-builder, playwright-test-generator | Per-tool patterns |
| New/updated E2E tests | Developers | playwright-test-generator | Playwright patterns |
| New/updated performance tests | Developers, DevOps | k6-scenario-builder | k6 patterns |
| New/updated accessibility tests | Developers | a11y-test-generator | axe-core patterns |
| Postman collections | — | postman-collection-builder | Collection JSON schema |
| Playwright test specs | — | playwright-test-generator | .spec.ts patterns |
| k6 scripts | — | k6-scenario-builder | k6 script patterns |
| Newman pipeline YAML | DevOps | newman-pipeline-builder | ADO YAML template |
| Playwright pipeline YAML | DevOps | playwright-pipeline-builder | ADO YAML template |
| Prioritized endpoint list | — | traffic-prioritizer | Tagged endpoint format |

### Final Release Prep Sub-Phase

| Deliverable | Fundamental Collaborations | Agent(s) | Template |
| ----------- | -------------------------- | -------- | -------- |
| Release Readiness Report | Release Mgrs, DevOps, Developers | release-readiness-reporter | TBD |
| Sign-off on release package | Release Mgrs, PO | (manual process) | Checklist TBD |
| Release Notes | PO, Developers, SRE, DevOps, Support | release-notes-generator | TBD |
| Defect Validation summary | Developers, PO, BA | defect-manager | TBD |
| Final regression results | Developers, DevOps | regression-orchestrator | TBD |

### Post-Release Sub-Phase

| Deliverable | Fundamental Collaborations | Agent(s) | Template |
| ----------- | -------------------------- | -------- | -------- |
| Post-release defect logs | Developers, SRE, DevOps, Support | defect-manager | TBD |
| Issue resolution records | Developers, Support | (manual + defect-manager) | TBD |
| Post-mortem findings | Developers, SRE, Release Mgmt | escape-defect-analyzer | RCA template TBD |
| Production validation results | DevOps, SRE | production-validator | Validation script output |

### Continuous Feedback & Improvement Sub-Phase

| Deliverable | Fundamental Collaborations | Agent(s) | Template |
| ----------- | -------------------------- | -------- | -------- |
| Feedback and improvement suggestions | All teams | (retro process) | TBD |
| Per-service playbooks | SRE, DevOps, Support | playbook-generator | Playbook template |
| QA metrics reports | SM, SRE | metrics-collector | Dashboard format TBD |
| Cross-service documentation | — | cross-repo-stitcher | System doc template |

## Summary Statistics

| Phase | Deliverable Count | Agent-Produced | Manual/Hybrid |
| ----- | ----------------- | -------------- | ------------- |
| Intake | 2 | 0 | 2 |
| Pre-Development | 10 | 8 | 2 |
| Development | 8 | 6 | 2 |
| SIT/E2E/Perf/A11y | 14 | 12 | 2 |
| Final Release Prep | 5 | 3 | 2 |
| Post-Release | 4 | 2 | 2 |
| Continuous Feedback | 4 | 3 | 1 |
| **Total** | **47** | **34** | **13** |
