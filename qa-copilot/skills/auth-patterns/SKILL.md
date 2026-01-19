---
name: auth-patterns
description: Understand authentication mechanisms and configure non-browser token acquisition for API testing automation. Use when you need to analyze auth patterns, configure OAuth client credentials, obtain JWT tokens, set up API keys, configure service accounts for CI/CD, write Postman pre-request scripts for authentication, or support QA MVP Step 2. Supports OAuth 2.0, JWT, API keys, Basic auth, Azure AD, Auth0, and Okta.
---

# Auth Patterns

Analyze authentication implementations and configure non-interactive token acquisition for API testing.

## Security Rules

**CRITICAL**: Never output actual credentials, tokens, or secrets. Document environment variable NAMES but not VALUES. If secrets are found hardcoded in code, flag as a security issue but do NOT display the values.

## Quick Start

1. Identify authentication libraries and frameworks
2. Locate auth configuration files
3. Map authentication flows
4. Find service account or client credentials options
5. Document token acquisition endpoints
6. Generate environment variable templates

## Auth Pattern Detection

| Pattern | Detection Markers |
|---------|------------------|
| OAuth 2.0 | `oauth`, `client_id`, `client_secret`, `authorization_code` |
| JWT | `jsonwebtoken`, `jwt`, `bearer` |
| API Key | `api_key`, `x-api-key`, `apikey` |
| Basic Auth | `basic`, `authorization: basic` |
| Azure AD | `msal`, `azure-identity`, `aad` |
| Auth0 | `auth0`, `@auth0` |
| Okta | `okta`, `@okta` |

## Discovery Process

### Step 1: Identify Auth Libraries

Search for authentication dependencies:
- **Java**: Spring Security, JJWT, Nimbus JOSE
- **.NET**: Microsoft.Identity, IdentityServer
- **Node.js**: Passport.js, jsonwebtoken, express-jwt
- **Python**: PyJWT, authlib, python-jose

### Step 2: Locate Configuration

Look for auth configuration in:
- Environment variable references (document names only)
- Security configuration classes
- OAuth/OIDC provider settings
- Middleware setup files

### Step 3: Map Auth Flows

Identify available authentication flows. See references for detailed patterns:
- **OAuth 2.0**: See `references/oauth-patterns.md`
- **JWT**: See `references/jwt-patterns.md`
- **API Keys**: See `references/api-key-patterns.md`
- **Azure AD**: See `references/azure-ad-patterns.md`

### Step 4: Find Non-Interactive Options

For CI/CD automation, prioritize:
1. Client Credentials flow (OAuth 2.0)
2. Service account tokens
3. API keys
4. Machine-to-machine tokens

## Output Format

```markdown
## Authentication Analysis

### Summary
- Primary auth mechanism: [type]
- Non-interactive auth available: [Yes/No]
- Complexity for automation: [Low/Medium/High]

### Token Acquisition

**Recommended Approach**: [Method Name]

**Token Endpoint**: `[endpoint or env var reference]`
**Method**: POST
**Content-Type**: [type]

**Required Environment Variables**:
| Variable | Description |
|----------|-------------|
| AUTH_CLIENT_ID | OAuth client ID |
| AUTH_CLIENT_SECRET | OAuth client secret |
| AUTH_URL | Auth server base URL |

### Postman Configuration

**Pre-request Script**:
[Pattern for token acquisition]

**Environment Variables Needed**:
[List with descriptions]
```

## Common Patterns

### OAuth 2.0 Client Credentials

```javascript
// Postman pre-request script pattern
const tokenUrl = pm.environment.get('AUTH_URL') + '/oauth/token';

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
            { key: 'client_id', value: pm.environment.get('CLIENT_ID') },
            { key: 'client_secret', value: pm.environment.get('CLIENT_SECRET') }
        ]
    }
}, (err, res) => {
    pm.environment.set('ACCESS_TOKEN', res.json().access_token);
});
```

### Bearer Token Header

```javascript
// Set in request headers
Authorization: Bearer {{ACCESS_TOKEN}}
```

## Edge Cases

- **Browser-only auth**: Document limitation, recommend service account setup
- **No clear auth**: Note findings, suggest manual investigation
- **Multiple auth methods**: Document all, recommend simplest for automation
- **External IdP without client credentials**: Note limitation, suggest alternatives
- **Hardcoded secrets**: Flag as security issue, do NOT output values
