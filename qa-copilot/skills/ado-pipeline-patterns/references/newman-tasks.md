# Newman Task Configuration

## Installation Options

### Global Install

```yaml
- script: npm install -g newman
  displayName: 'Install Newman'
```

### With Reporters

```yaml
- script: |
    npm install -g newman \
      newman-reporter-htmlextra \
      newman-reporter-junitfull \
      newman-reporter-teamcity
  displayName: 'Install Newman with Reporters'
```

### From package.json

```yaml
- script: npm ci
  displayName: 'Install Dependencies'
# package.json includes newman as devDependency
# Run with: npx newman run ...
```

## Newman Command Options

### Basic Execution

```bash
newman run collection.json
```

### With Environment

```bash
newman run collection.json -e environment.json
```

### Environment Variable Override

```bash
newman run collection.json \
  --env-var "baseUrl=https://api.example.com" \
  --env-var "apiKey=$API_KEY"
```

### Folder Filtering

```bash
# Run specific folder
newman run collection.json --folder "smoke"

# Run multiple folders
newman run collection.json --folder "auth" --folder "users"
```

### Reporter Configuration

```bash
newman run collection.json \
  --reporters cli,junit,htmlextra \
  --reporter-junit-export results/junit.xml \
  --reporter-htmlextra-export results/report.html
```

### Iteration and Delay

```bash
newman run collection.json \
  --iteration-count 3 \
  --delay-request 100
```

### Timeout Settings

```bash
newman run collection.json \
  --timeout-request 30000 \
  --timeout-script 10000
```

### SSL and Certificates

```bash
newman run collection.json \
  --insecure \
  --ssl-client-cert cert.pem \
  --ssl-client-key key.pem
```

## Complete Pipeline Step

```yaml
- script: |
    newman run postman/$(COLLECTION_NAME).postman_collection.json \
      -e postman/$(ENVIRONMENT).postman_environment.json \
      --folder "$(TEST_FOLDER)" \
      --env-var "baseUrl=$(BASE_URL)" \
      --env-var "clientId=$(CLIENT_ID)" \
      --env-var "clientSecret=$(CLIENT_SECRET)" \
      --reporters cli,junitfull,htmlextra \
      --reporter-junitfull-export $(Build.ArtifactStagingDirectory)/results/junit.xml \
      --reporter-htmlextra-export $(Build.ArtifactStagingDirectory)/results/report.html \
      --reporter-htmlextra-title "API Test Report" \
      --timeout-request 30000 \
      --delay-request 100
  displayName: 'Run Newman Tests'
  env:
    CLIENT_SECRET: $(CLIENT_SECRET)  # Map secret variable
```

## Error Handling

### Continue on Failure (for reporting)

```yaml
- script: newman run collection.json || true
  displayName: 'Run Tests (allow failure)'

- task: PublishTestResults@2
  condition: always()  # Run even if newman fails
```

### Retry on Failure

```yaml
- script: |
    newman run collection.json || \
    newman run collection.json --folder "failed-retry"
  displayName: 'Run Tests with Retry'
```

## Parallel Execution

### Multiple Collections

```yaml
jobs:
  - job: UserTests
    steps:
      - script: newman run users-collection.json
  - job: OrderTests
    steps:
      - script: newman run orders-collection.json
```

### Matrix Strategy

```yaml
strategy:
  matrix:
    Smoke:
      FOLDER: smoke
    Auth:
      FOLDER: auth
    Users:
      FOLDER: users

steps:
  - script: newman run collection.json --folder $(FOLDER)
```

## Data Files

### CSV Data

```bash
newman run collection.json -d data.csv
```

### JSON Data

```bash
newman run collection.json -d data.json
```

### Pipeline with Data

```yaml
- script: |
    newman run collection.json \
      -d testdata/users.csv \
      --iteration-count 10
  displayName: 'Run Data-Driven Tests'
```
