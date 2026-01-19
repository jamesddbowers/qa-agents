# OAuth 2.0 Patterns

## Grant Types

### Client Credentials (Recommended for CI/CD)

Best for machine-to-machine authentication without user interaction.

**Flow**:
```
Client → Token Endpoint → Access Token
```

**Request**:
```http
POST /oauth/token HTTP/1.1
Content-Type: application/x-www-form-urlencoded

grant_type=client_credentials
&client_id=${CLIENT_ID}
&client_secret=${CLIENT_SECRET}
&scope=api.read api.write
```

**Response**:
```json
{
  "access_token": "eyJ...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "scope": "api.read api.write"
}
```

### Resource Owner Password (Legacy)

**Note**: Only use if client credentials not available. Requires user credentials.

**Request**:
```http
POST /oauth/token HTTP/1.1
Content-Type: application/x-www-form-urlencoded

grant_type=password
&username=${USERNAME}
&password=${PASSWORD}
&client_id=${CLIENT_ID}
&scope=api.read
```

### Refresh Token

Use to obtain new access token without re-authentication.

**Request**:
```http
POST /oauth/token HTTP/1.1
Content-Type: application/x-www-form-urlencoded

grant_type=refresh_token
&refresh_token=${REFRESH_TOKEN}
&client_id=${CLIENT_ID}
```

## Token Endpoint Discovery

Common token endpoint paths:
- `/oauth/token`
- `/oauth2/token`
- `/token`
- `/connect/token`
- `/.well-known/openid-configuration` (discover from here)

## Postman Pre-Request Script

```javascript
// Check if token exists and is not expired
const tokenExpiry = pm.environment.get('TOKEN_EXPIRY');
const accessToken = pm.environment.get('ACCESS_TOKEN');

if (!accessToken || !tokenExpiry || Date.now() > parseInt(tokenExpiry)) {
    // Token missing or expired, get new one
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
                { key: 'client_secret', value: pm.environment.get('CLIENT_SECRET') },
                { key: 'scope', value: pm.environment.get('SCOPE') || '' }
            ]
        }
    }, (err, res) => {
        if (err) {
            console.error('Token request failed:', err);
            return;
        }

        const jsonResponse = res.json();
        pm.environment.set('ACCESS_TOKEN', jsonResponse.access_token);

        // Set expiry (subtract 60s buffer)
        const expiresIn = (jsonResponse.expires_in || 3600) - 60;
        pm.environment.set('TOKEN_EXPIRY', Date.now() + (expiresIn * 1000));
    });
}
```

## Environment Variables Template

| Variable | Description | Example |
|----------|-------------|---------|
| AUTH_URL | OAuth server base URL | `https://auth.example.com` |
| CLIENT_ID | Application client ID | (from IdP) |
| CLIENT_SECRET | Application client secret | (from IdP) |
| SCOPE | Requested scopes | `api.read api.write` |
| ACCESS_TOKEN | Current access token | (set by script) |
| TOKEN_EXPIRY | Token expiry timestamp | (set by script) |

## Common OAuth Providers

### Standard OAuth 2.0
- Token endpoint: `/oauth/token`
- Authorize endpoint: `/oauth/authorize`

### Auth0
- Token endpoint: `https://{tenant}.auth0.com/oauth/token`
- Audience parameter required

### Okta
- Token endpoint: `https://{domain}/oauth2/default/v1/token`
- Uses `default` authorization server

### Azure AD
- See `azure-ad-patterns.md` for Microsoft-specific patterns
