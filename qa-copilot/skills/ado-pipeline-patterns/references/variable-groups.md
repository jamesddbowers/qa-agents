# Azure DevOps Variable Groups

## Overview

Variable Groups store reusable variables and secrets for pipelines.

Location: Pipelines → Library → Variable groups

## Creating Variable Groups

### Via Azure DevOps UI

1. Navigate to Pipelines → Library
2. Click "+ Variable group"
3. Name the group (e.g., `qa-api-secrets`)
4. Add variables
5. Mark sensitive variables as secrets (lock icon)
6. Save

### Via Azure CLI

```bash
az pipelines variable-group create \
  --name "qa-api-secrets" \
  --variables CLIENT_ID=abc123 \
  --authorize true \
  --org https://dev.azure.com/org \
  --project "Project Name"

# Add secret variable
az pipelines variable-group variable create \
  --group-id 1 \
  --name CLIENT_SECRET \
  --value "secret-value" \
  --secret true
```

## Recommended Variable Groups

### qa-api-secrets

| Variable | Type | Description |
|----------|------|-------------|
| CLIENT_ID | Plain | OAuth client ID |
| CLIENT_SECRET | Secret | OAuth client secret |
| API_KEY | Secret | API key (if used) |

### qa-environments

| Variable | Type | Description |
|----------|------|-------------|
| BASE_URL | Plain | API base URL |
| AUTH_URL | Plain | Auth server URL |
| DB_CONNECTION | Secret | Database connection (if needed) |

### qa-config

| Variable | Type | Description |
|----------|------|-------------|
| COLLECTION_NAME | Plain | Postman collection file |
| TIMEOUT | Plain | Request timeout (ms) |
| RETRY_COUNT | Plain | Retry attempts |

## Pipeline Integration

### Reference Single Group

```yaml
variables:
  - group: qa-api-secrets
```

### Reference Multiple Groups

```yaml
variables:
  - group: qa-api-secrets
  - group: qa-environments
  - name: LOCAL_VAR
    value: 'local-value'
```

### Stage-Level Variables

```yaml
stages:
  - stage: Dev
    variables:
      - group: qa-dev-secrets
    jobs:
      - job: Test
        steps:
          - script: echo $(CLIENT_ID)

  - stage: Staging
    variables:
      - group: qa-staging-secrets
```

## Using Variables in Newman

### Direct Reference

```yaml
- script: |
    newman run collection.json \
      --env-var "clientId=$(CLIENT_ID)" \
      --env-var "clientSecret=$(CLIENT_SECRET)"
```

### Secret Variables

Secret variables must be explicitly mapped:

```yaml
- script: |
    newman run collection.json \
      --env-var "clientSecret=$CLIENT_SECRET"
  env:
    CLIENT_SECRET: $(CLIENT_SECRET)
```

## Security Best Practices

### 1. Mark Secrets as Secrets

```yaml
# DO: Secret variable (masked in logs)
CLIENT_SECRET: $(CLIENT_SECRET)  # Shows as ***

# DON'T: Plain variable with secret
CLIENT_SECRET: "actual-secret"  # Visible in logs!
```

### 2. Limit Access

- Set "Pipeline permissions" to specific pipelines
- Use approval gates for production secrets

### 3. Rotate Secrets

- Regularly update secret values
- Use expiring credentials where possible

### 4. Never Echo Secrets

```yaml
# BAD - Will expose secret
- script: echo $(CLIENT_SECRET)

# GOOD - Use in command without echoing
- script: newman run collection.json --env-var "secret=$(CLIENT_SECRET)"
```

## Environment-Specific Groups

### Pattern: One Group Per Environment

```
qa-dev-secrets
qa-staging-secrets
qa-prod-secrets
```

### Pipeline Selection

```yaml
variables:
  - ${{ if eq(variables['Build.SourceBranch'], 'refs/heads/main') }}:
    - group: qa-prod-secrets
  - ${{ if ne(variables['Build.SourceBranch'], 'refs/heads/main') }}:
    - group: qa-dev-secrets
```

## Key Vault Integration

For enterprise security, link to Azure Key Vault:

1. Create Key Vault in Azure
2. Add secrets to Key Vault
3. In Variable Group, select "Link secrets from Azure Key Vault"
4. Select Key Vault and secrets to include

### Pipeline Usage (Same as Regular)

```yaml
variables:
  - group: qa-keyvault-linked
```

## Troubleshooting

### Variable Not Found

- Check group is linked to pipeline
- Verify variable name (case-sensitive)
- Ensure pipeline has permission to access group

### Secret Not Passing to Script

- Map secret explicitly via `env:` block
- Check for typos in variable name

### Permission Denied

- Grant pipeline access in Library → Variable group → Pipeline permissions
