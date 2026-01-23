# JWT Patterns

## JWT Structure

```
Header.Payload.Signature

eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.
eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4ifQ.
SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
```

## Token Acquisition Patterns

### Direct JWT Issuance

Some APIs issue JWT directly without OAuth:

```http
POST /api/auth/login HTTP/1.1
Content-Type: application/json

{
  "username": "${USERNAME}",
  "password": "${PASSWORD}"
}
```

Response:
```json
{
  "token": "eyJ...",
  "refreshToken": "eyJ...",
  "expiresIn": 3600
}
```

### JWT from OAuth Token Endpoint

OAuth servers often return JWT as access token:

```http
POST /oauth/token HTTP/1.1
Content-Type: application/x-www-form-urlencoded

grant_type=client_credentials&client_id=...&client_secret=...
```

Response contains JWT:
```json
{
  "access_token": "eyJhbGciOiJSUzI1NiIs...",
  "token_type": "Bearer"
}
```

## Token Refresh Patterns

### Refresh Token Endpoint

```http
POST /api/auth/refresh HTTP/1.1
Content-Type: application/json

{
  "refreshToken": "${REFRESH_TOKEN}"
}
```

### Postman Pre-Request Script

```javascript
// JWT refresh pattern
const accessToken = pm.environment.get('ACCESS_TOKEN');
const tokenExpiry = pm.environment.get('TOKEN_EXPIRY');

// Check if token needs refresh
if (!accessToken || Date.now() > parseInt(tokenExpiry)) {
    const refreshToken = pm.environment.get('REFRESH_TOKEN');

    if (refreshToken) {
        // Use refresh token
        pm.sendRequest({
            url: pm.environment.get('BASE_URL') + '/api/auth/refresh',
            method: 'POST',
            header: { 'Content-Type': 'application/json' },
            body: {
                mode: 'raw',
                raw: JSON.stringify({ refreshToken: refreshToken })
            }
        }, (err, res) => {
            if (!err && res.code === 200) {
                const json = res.json();
                pm.environment.set('ACCESS_TOKEN', json.token);
                pm.environment.set('TOKEN_EXPIRY', Date.now() + (json.expiresIn * 1000));
            }
        });
    } else {
        // No refresh token, need full login
        pm.sendRequest({
            url: pm.environment.get('BASE_URL') + '/api/auth/login',
            method: 'POST',
            header: { 'Content-Type': 'application/json' },
            body: {
                mode: 'raw',
                raw: JSON.stringify({
                    username: pm.environment.get('USERNAME'),
                    password: pm.environment.get('PASSWORD')
                })
            }
        }, (err, res) => {
            if (!err && res.code === 200) {
                const json = res.json();
                pm.environment.set('ACCESS_TOKEN', json.token);
                pm.environment.set('REFRESH_TOKEN', json.refreshToken);
                pm.environment.set('TOKEN_EXPIRY', Date.now() + (json.expiresIn * 1000));
            }
        });
    }
}
```

## JWT in Requests

### Authorization Header (Standard)

```
Authorization: Bearer eyJhbGciOiJIUzI1NiIs...
```

Postman header:
```
Authorization: Bearer {{ACCESS_TOKEN}}
```

### Custom Header

Some APIs use custom headers:
```
X-Auth-Token: eyJhbGciOiJIUzI1NiIs...
X-JWT-Token: eyJhbGciOiJIUzI1NiIs...
```

### Cookie

```
Cookie: jwt=eyJhbGciOiJIUzI1NiIs...
```

## JWT Decoding (for debugging)

```javascript
// Postman test script to decode JWT
const token = pm.environment.get('ACCESS_TOKEN');
const parts = token.split('.');
const payload = JSON.parse(atob(parts[1]));

console.log('JWT Payload:', payload);
console.log('Expires:', new Date(payload.exp * 1000));
console.log('Subject:', payload.sub);
```

## Environment Variables

| Variable | Description |
|----------|-------------|
| BASE_URL | API base URL |
| USERNAME | Login username (if direct auth) |
| PASSWORD | Login password (if direct auth) |
| ACCESS_TOKEN | Current JWT |
| REFRESH_TOKEN | Refresh token |
| TOKEN_EXPIRY | Expiry timestamp (ms) |
