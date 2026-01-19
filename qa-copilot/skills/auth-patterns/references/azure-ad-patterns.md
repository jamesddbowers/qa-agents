# Azure AD / Entra ID Patterns

## Overview

Azure AD (now Microsoft Entra ID) is Microsoft's identity platform. For API testing automation, use the **Client Credentials** flow with an App Registration.

## App Registration Setup

### Required Configuration

1. Register application in Azure Portal
2. Note the following values:
   - **Tenant ID** (Directory ID)
   - **Client ID** (Application ID)
   - **Client Secret** (create under Certificates & secrets)

3. Configure API Permissions:
   - Add required permissions for target API
   - Grant admin consent if required

## Token Endpoints

### V2.0 Endpoint (Recommended)

```
https://login.microsoftonline.com/{tenant-id}/oauth2/v2.0/token
```

### V1.0 Endpoint (Legacy)

```
https://login.microsoftonline.com/{tenant-id}/oauth2/token
```

## Client Credentials Flow

### Token Request

```http
POST https://login.microsoftonline.com/{tenant-id}/oauth2/v2.0/token HTTP/1.1
Content-Type: application/x-www-form-urlencoded

grant_type=client_credentials
&client_id={client-id}
&client_secret={client-secret}
&scope={scope}
```

### Scope Format

For Microsoft Graph:
```
https://graph.microsoft.com/.default
```

For custom API:
```
api://{api-client-id}/.default
```

### Response

```json
{
  "token_type": "Bearer",
  "expires_in": 3599,
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIs..."
}
```

## Postman Pre-Request Script

```javascript
// Azure AD Client Credentials Flow
const tenantId = pm.environment.get('AZURE_TENANT_ID');
const clientId = pm.environment.get('AZURE_CLIENT_ID');
const clientSecret = pm.environment.get('AZURE_CLIENT_SECRET');
const scope = pm.environment.get('AZURE_SCOPE');

// Check if token exists and is valid
const tokenExpiry = pm.environment.get('TOKEN_EXPIRY');
const accessToken = pm.environment.get('ACCESS_TOKEN');

if (!accessToken || !tokenExpiry || Date.now() > parseInt(tokenExpiry)) {
    const tokenUrl = `https://login.microsoftonline.com/${tenantId}/oauth2/v2.0/token`;

    pm.sendRequest({
        url: tokenUrl,
        method: 'POST',
        header: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: {
            mode: 'urlencoded',
            urlencoded: [
                { key: 'grant_type', value: 'client_credentials' },
                { key: 'client_id', value: clientId },
                { key: 'client_secret', value: clientSecret },
                { key: 'scope', value: scope }
            ]
        }
    }, (err, res) => {
        if (err) {
            console.error('Azure AD token request failed:', err);
            return;
        }

        const response = res.json();

        if (response.access_token) {
            pm.environment.set('ACCESS_TOKEN', response.access_token);
            // Set expiry with 60s buffer
            const expiresIn = (response.expires_in || 3600) - 60;
            pm.environment.set('TOKEN_EXPIRY', Date.now() + (expiresIn * 1000));
        } else {
            console.error('Azure AD error:', response.error_description);
        }
    });
}
```

## Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| AZURE_TENANT_ID | Azure AD tenant ID | `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` |
| AZURE_CLIENT_ID | App registration client ID | `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` |
| AZURE_CLIENT_SECRET | App registration secret | (secret value) |
| AZURE_SCOPE | API scope | `api://app-id/.default` |
| ACCESS_TOKEN | Current token | (set by script) |
| TOKEN_EXPIRY | Expiry timestamp | (set by script) |

## Azure DevOps Integration

### Variable Groups

Store Azure AD credentials in Variable Groups:

```yaml
variables:
  - group: azure-ad-test-credentials
  # Contains: AZURE_TENANT_ID, AZURE_CLIENT_ID, AZURE_CLIENT_SECRET
```

### Newman Execution

```yaml
- script: |
    newman run collection.json \
      -e environment.json \
      --env-var "AZURE_TENANT_ID=$(AZURE_TENANT_ID)" \
      --env-var "AZURE_CLIENT_ID=$(AZURE_CLIENT_ID)" \
      --env-var "AZURE_CLIENT_SECRET=$(AZURE_CLIENT_SECRET)" \
      --env-var "AZURE_SCOPE=$(AZURE_SCOPE)"
  displayName: 'Run API Tests'
```

## Managed Identity (Advanced)

For Azure-hosted test runners, use Managed Identity instead of client secrets:

```javascript
// Not applicable for Postman/Newman
// Use Azure SDK in custom test runners
```

## Troubleshooting

### Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| `AADSTS700016` | App not found | Verify client ID |
| `AADSTS7000215` | Invalid secret | Check client secret value |
| `AADSTS65001` | No consent | Grant admin consent |
| `AADSTS700024` | Wrong tenant | Verify tenant ID |

### Token Validation

Decode JWT to verify claims:
```javascript
const token = pm.environment.get('ACCESS_TOKEN');
const payload = JSON.parse(atob(token.split('.')[1]));
console.log('Audience:', payload.aud);
console.log('Issuer:', payload.iss);
console.log('Expires:', new Date(payload.exp * 1000));
```
