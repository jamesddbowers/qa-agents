# Test Reporting Patterns

## Built-in Reporters

### CLI Reporter

Default console output, always enabled.

```bash
newman run collection.json --reporters cli
```

### JSON Reporter

```bash
newman run collection.json \
  --reporters json \
  --reporter-json-export results.json
```

## Third-Party Reporters

### JUnit Reporter

Standard for CI/CD integration.

**Install**:
```bash
npm install -g newman-reporter-junitfull
```

**Usage**:
```bash
newman run collection.json \
  --reporters junitfull \
  --reporter-junitfull-export junit.xml
```

### HTML Extra Reporter

Rich HTML reports with charts.

**Install**:
```bash
npm install -g newman-reporter-htmlextra
```

**Usage**:
```bash
newman run collection.json \
  --reporters htmlextra \
  --reporter-htmlextra-export report.html \
  --reporter-htmlextra-title "API Test Report" \
  --reporter-htmlextra-darkTheme
```

**Options**:
```bash
--reporter-htmlextra-title "Report Title"
--reporter-htmlextra-darkTheme
--reporter-htmlextra-showEnvironmentData
--reporter-htmlextra-skipSensitiveData
--reporter-htmlextra-logs
```

## Azure DevOps Integration

### Publish JUnit Results

```yaml
- task: PublishTestResults@2
  inputs:
    testResultsFormat: 'JUnit'
    testResultsFiles: '**/junit.xml'
    searchFolder: '$(Build.ArtifactStagingDirectory)'
    testRunTitle: 'API Tests - $(Build.BuildNumber)'
    failTaskOnFailedTests: true
    publishRunAttachments: true
  condition: always()
  displayName: 'Publish Test Results'
```

### Publish HTML as Artifact

```yaml
- publish: $(Build.ArtifactStagingDirectory)/report.html
  artifact: TestReport
  condition: always()
  displayName: 'Publish HTML Report'
```

### Publish to Wiki (Advanced)

```yaml
- task: WikiUpdaterTask@2
  inputs:
    repo: 'project/_wiki/wikis/project.wiki'
    filename: 'test-reports/$(Build.BuildNumber).md'
    contents: |
      # Test Report $(Build.BuildNumber)
      [View HTML Report]($(System.TeamFoundationCollectionUri)$(System.TeamProject)/_build/results?buildId=$(Build.BuildId)&view=artifacts)
```

## Multiple Reporters

```bash
newman run collection.json \
  --reporters cli,junitfull,htmlextra \
  --reporter-junitfull-export results/junit.xml \
  --reporter-htmlextra-export results/report.html
```

## Report Storage

### Directory Structure

```
$(Build.ArtifactStagingDirectory)/
├── results/
│   ├── junit.xml
│   └── report.html
└── logs/
    └── newman.log
```

### Artifact Publishing

```yaml
- task: PublishBuildArtifacts@1
  inputs:
    pathToPublish: '$(Build.ArtifactStagingDirectory)/results'
    artifactName: 'TestResults'
  condition: always()
```

## Result Analysis

### JUnit XML Structure

```xml
<testsuite name="Collection Name" tests="10" failures="1" errors="0">
  <testcase name="Request Name" time="0.5">
    <failure message="Expected 200, got 500">...</failure>
  </testcase>
</testsuite>
```

### ADO Test Results View

Published JUnit results appear in:
- Build Summary → Tests tab
- Test Plans → Runs

### Trend Analysis

Enable test analytics in ADO:
- Project Settings → Pipelines → Test Management
- View pass rate trends over time

## Custom Reporting

### Post-Processing Script

```yaml
- script: |
    node scripts/parse-results.js results/junit.xml
  displayName: 'Analyze Results'
```

### Slack/Teams Notification

```yaml
- script: |
    PASSED=$(grep -o 'tests="[0-9]*"' junit.xml | grep -o '[0-9]*')
    FAILED=$(grep -o 'failures="[0-9]*"' junit.xml | grep -o '[0-9]*')
    curl -X POST $(SLACK_WEBHOOK) \
      -d "{\"text\": \"Tests: $PASSED passed, $FAILED failed\"}"
  condition: always()
```
