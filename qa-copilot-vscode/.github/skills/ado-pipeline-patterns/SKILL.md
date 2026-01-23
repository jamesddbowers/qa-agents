---
name: ado-pipeline-patterns
description: Generate Azure DevOps YAML pipelines for Newman test execution. Use when you need to create ADO pipelines, configure Newman in CI/CD, publish test results to Azure DevOps, set up variable groups for secrets, configure scheduled test runs, or support QA MVP Step 7. Covers smoke and regression pipeline patterns with JUnit and HTML reporting.
---

# ADO Pipeline Patterns

Generate Azure DevOps YAML pipelines for running Newman API tests.

## Quick Start

1. Choose pipeline type (smoke/regression/scheduled)
2. Configure Newman execution
3. Set up test result publishing
4. Configure variable groups for secrets
5. Add artifact publishing for reports

## Pipeline Types

| Type | Trigger | Use Case | Duration |
|------|---------|----------|----------|
| Smoke | CI (on PR/push) | Quick validation | < 2 min |
| Regression | Manual/Scheduled | Full coverage | < 30 min |
| Scheduled | Cron | Nightly/Weekly | Any |

## Basic Pipeline Structure

```yaml
trigger:
  branches:
    include:
      - main

pool:
  vmImage: 'ubuntu-latest'

variables:
  - group: qa-api-secrets

stages:
  - stage: Test
    jobs:
      - job: RunNewman
        steps:
          - task: NodeTool@0
            inputs:
              versionSpec: '18.x'
          - script: npm install -g newman
          - script: newman run collection.json
          - task: PublishTestResults@2
```

## Newman Configuration

See `references/newman-tasks.md` for detailed patterns.

### Installation

```yaml
- script: npm install -g newman newman-reporter-htmlextra newman-reporter-junitfull
  displayName: 'Install Newman and Reporters'
```

### Execution

```yaml
- script: |
    newman run postman/collection.json \
      -e postman/environment.json \
      --folder "smoke" \
      --env-var "baseUrl=$(BASE_URL)" \
      --env-var "clientId=$(CLIENT_ID)" \
      --env-var "clientSecret=$(CLIENT_SECRET)" \
      --reporters cli,junitfull,htmlextra \
      --reporter-junitfull-export $(Build.ArtifactStagingDirectory)/junit.xml \
      --reporter-htmlextra-export $(Build.ArtifactStagingDirectory)/report.html
  displayName: 'Run Newman Tests'
```

## Test Result Publishing

See `references/reporting-patterns.md` for reporter options.

### JUnit Results

```yaml
- task: PublishTestResults@2
  inputs:
    testResultsFormat: 'JUnit'
    testResultsFiles: '**/junit.xml'
    failTaskOnFailedTests: true
  condition: always()
  displayName: 'Publish Test Results'
```

### HTML Report Artifact

```yaml
- publish: $(Build.ArtifactStagingDirectory)
  artifact: TestReports
  condition: always()
  displayName: 'Publish HTML Report'
```

## Variable Groups

See `references/variable-groups.md` for secret management.

### Required Groups

| Group | Variables | Purpose |
|-------|-----------|---------|
| qa-api-secrets | CLIENT_ID, CLIENT_SECRET | Auth credentials |
| qa-environments | BASE_URL, AUTH_URL | Environment URLs |

### Usage in Pipeline

```yaml
variables:
  - group: qa-api-secrets
  - group: qa-environments
```

## Pipeline Templates

### Smoke Test Pipeline

```yaml
trigger:
  branches:
    include:
      - main
      - feature/*

pool:
  vmImage: 'ubuntu-latest'

variables:
  - group: qa-api-secrets
  - group: qa-environments

stages:
  - stage: SmokeTests
    displayName: 'API Smoke Tests'
    jobs:
      - job: RunSmoke
        steps:
          - task: NodeTool@0
            inputs:
              versionSpec: '18.x'
          - script: npm install -g newman newman-reporter-junitfull
          - script: |
              newman run postman/collection.json \
                --folder smoke \
                --env-var "baseUrl=$(BASE_URL)" \
                --reporters cli,junitfull \
                --reporter-junitfull-export results/junit.xml
          - task: PublishTestResults@2
            inputs:
              testResultsFormat: 'JUnit'
              testResultsFiles: 'results/junit.xml'
              failTaskOnFailedTests: true
            condition: always()
```

### Scheduled Regression Pipeline

```yaml
trigger: none

schedules:
  - cron: '0 2 * * *'
    displayName: 'Nightly Regression'
    branches:
      include:
        - main
    always: true

pool:
  vmImage: 'ubuntu-latest'

# ... (full regression with all folders)
```

## Output Format

Generated pipeline files go to `ado/` folder:
```
ado/
├── newman-smoke.yml
├── newman-regression.yml
└── newman-scheduled.yml
```
