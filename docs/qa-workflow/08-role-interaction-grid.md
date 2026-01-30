# Role Interaction Grid

## Purpose

This grid shows where QA interacts with each role across all phases and sub-phases. QA runs in parallel with all teams — this documents the specific touchpoints.

## QA × Role × Phase Matrix

| Role | Intake | Pre-Dev | Development | SIT/E2E/Perf/A11y | Final Release Prep | Post-Release | Continuous Feedback |
| ---- | ------ | ------- | ----------- | ------------------ | ------------------ | ------------ | ------------------- |
| **Intake Team** | Understand Requirements | — | — | — | — | — | — |
| **Business Analyst** | Understand Requirements, Identify Risks, Test Strategy Input | Test Plan Creation | Test Case Review | Defect Management | Defect Validation | — | — |
| **Product Owner** | Understand Requirements, Identify Risks, Test Strategy Input | Test Plan Creation, Test Approach Definition | Test Case Review | Defect Management | Sign-off, Release Notes, Defect Validation | — | Continuous Collaboration |
| **Scrum Master** | — | — | Test Reports, Defect Communication | — | — | — | Review Metrics, Process Adjustments, Continuous Collaboration |
| **Developers** | — | Test Plan Creation, Test Approach Definition, Collaboration | WIP Testing, Update Test Cases, Test Case Review, Manual Verification, Feedback | SIT Coordination, E2E, Performance, Accessibility, Defect Mgmt, Mobile API | Final Regression, Release Readiness, Release Notes, Defect Validation | Incident Resolution | Process Adjustments |
| **DevOps** | — | Environment Setup | — | SIT Coordination, Performance, Env Verification, Smoke Testing | Final Regression, Release Readiness, Release Notes | Production Monitoring | Process Adjustments, Continuous Collaboration, Playbook Maintenance |
| **SRE** | — | — | — | Performance/A11y Reports, Defect Logs | — | Production Monitoring | Review Metrics, Continuous Collaboration, Playbook Maintenance |
| **Release Management** | — | — | — | — | Release Readiness, Sign-off | Post-Mortem Reviews | — |
| **Support Team** | — | — | — | — | Release Notes | Production Monitoring, Incident Resolution | Playbook Maintenance |

## Key Observations

1. **Developers** have the most QA interaction — they're involved in every Implementation sub-phase
2. **PO and BA** are critical at the bookends: Intake (defining what to test) and Release Prep (validating defects, signing off)
3. **DevOps** engagement increases as code moves through environments (Pre-Dev setup → SIT verification → Release deployment)
4. **SRE** primarily engages in later phases (SIT performance, Post-Release monitoring, Continuous Feedback metrics)
5. **Support Team** only appears in Release Prep (learning features) and Post-Release/Continuous (operational use)
6. **Scrum Masters** facilitate — they appear in Development (reports/communication) and Continuous Feedback (metrics/process)
7. **Intake Team** only appears in Intake — they vet ideas before they enter the pipeline

## Interaction Intensity

| Phase | Interaction Intensity | Key Partners |
| ----- | -------------------- | ------------ |
| Intake | Low (meetings-based) | PO, BA, Intake Team |
| Pre-Development | Medium (planning) | Developers, DevOps, PO, BA |
| Development | **High** (daily collaboration) | Developers, PO, BA |
| SIT/E2E/Perf/A11y | High (cross-team coordination) | Developers, DevOps, SRE, PO, BA |
| Final Release Prep | Medium-High (evidence gathering) | Release Mgmt, DevOps, Developers, PO |
| Post-Release | Low-Medium (as-needed) | DevOps, SRE, Support, Developers |
| Continuous Feedback | Medium (retros, metrics) | SM, SRE, DevOps, PO |
