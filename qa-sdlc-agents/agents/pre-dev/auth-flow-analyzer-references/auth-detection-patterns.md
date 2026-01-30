# Auth Detection Patterns by Framework

## Spring Boot / Spring Security

### Configuration File Locations
```
**/SecurityConfig*.java
**/WebSecurityConfig*.java
**/security/**/*.java
**/config/*Security*.java
**/config/*Auth*.java
```

### Grep Patterns
```regex
@EnableWebSecurity
@EnableMethodSecurity
@EnableGlobalMethodSecurity
SecurityFilterChain
WebSecurityConfigurerAdapter
@PreAuthorize
@Secured
@RolesAllowed
```

### OAuth2 Resource Server Detection
```regex
spring\.security\.oauth2\.resourceserver
.oauth2ResourceServer\(
JwtDecoder
BearerTokenAuthenticationFilter
```

### OAuth2 Client Detection
```regex
spring\.security\.oauth2\.client
.oauth2Login\(
.oauth2Client\(
ClientRegistration
```

### Config Properties (application.yml / application.properties)
```
spring.security.oauth2.client.registration.*
spring.security.oauth2.client.provider.*
spring.security.oauth2.resourceserver.jwt.issuer-uri
spring.security.oauth2.resourceserver.jwt.jwk-set-uri
```

---

## ASP.NET Core

### Configuration File Locations
```
**/Program.cs
**/Startup.cs
**/appsettings.json
**/appsettings.*.json
```

### Grep Patterns
```regex
AddAuthentication
AddJwtBearer
AddOpenIdConnect
AddMicrosoftIdentityWebApi
AddAuthorization
\[Authorize\]
\[AllowAnonymous\]
RequireAuthorization
```

### Azure AD / Entra ID Detection
```regex
AzureAd
Microsoft\.Identity\.Web
AddMicrosoftIdentityWebApi
AddMicrosoftIdentityWebApp
```

### Config Properties (appsettings.json)
```json
{
  "AzureAd": {
    "Instance": "...",
    "TenantId": "...",
    "ClientId": "...",
    "Audience": "..."
  }
}
```

---

## Node.js / Express

### Configuration File Locations
```
**/passport*.{js,ts}
**/auth/**/*.{js,ts}
**/middleware/auth*.{js,ts}
**/config/auth*.{js,ts}
```

### Grep Patterns
```regex
passport\.use\(
passport\.authenticate\(
jwt\.sign\(
jwt\.verify\(
jsonwebtoken
express-jwt
passport-jwt
JwtStrategy
```

### Environment Variable Patterns
```regex
JWT_SECRET
JWT_PRIVATE_KEY
AUTH_SECRET
TOKEN_EXPIRY
OAUTH_CLIENT_ID
OAUTH_CLIENT_SECRET
```

---

## NestJS

### Configuration File Locations
```
**/*.guard.{js,ts}
**/*.strategy.{js,ts}
**/auth/**/*.{js,ts}
```

### Grep Patterns
```regex
@UseGuards\(
JwtAuthGuard
RolesGuard
AuthGuard
JwtStrategy
PassportStrategy
JwtModule\.register
```

---

## Python / FastAPI

### Configuration File Locations
```
**/auth/**/*.py
**/security/**/*.py
**/dependencies/**/*.py
**/core/security*.py
```

### Grep Patterns
```regex
OAuth2PasswordBearer
HTTPBearer
Depends\(.*current_user
security_scheme
jwt\.decode
jwt\.encode
```

---

## Python / Django REST Framework

### Configuration File Locations
```
**/settings.py
**/settings/**/*.py
**/authentication*.py
```

### Grep Patterns
```regex
DEFAULT_AUTHENTICATION_CLASSES
TokenAuthentication
JWTAuthentication
SessionAuthentication
IsAuthenticated
IsAdminUser
permission_classes
```

---

## OAuth2 Grant Types — Test Suitability

| Grant Type | Non-Interactive | Test Suitability | Notes |
|-----------|----------------|------------------|-------|
| Client Credentials | Yes | Best | Machine-to-machine, no user context |
| Resource Owner Password | Yes | Good | Requires test user credentials |
| Authorization Code | No | Poor | Requires browser redirect |
| Authorization Code + PKCE | No | Poor | Requires browser redirect |
| Implicit | No | Poor | Deprecated, requires browser |
| Device Code | Partial | Fair | Requires one-time user approval |

### Recommended Test Approaches by Auth Type

**OAuth2 (Azure AD, Auth0, Okta)**:
1. Prefer Client Credentials grant with a test service principal
2. Fallback: Resource Owner Password grant with test user (if supported)
3. Last resort: Pre-generated long-lived token for dev/test environments

**JWT (self-issued)**:
1. Use the application's token endpoint with test credentials
2. If no token endpoint, look for test token generation utilities

**API Key**:
1. Provision a test API key via admin endpoint or config
2. Store as pipeline secret variable

**Session/Cookie**:
1. POST to login endpoint, capture session cookie
2. Reuse cookie across requests in collection

---

## Postman Pre-Request Script Patterns

### OAuth2 Client Credentials
```javascript
// Pattern only — uses environment variables, no hardcoded secrets
const tokenUrl = pm.environment.get('AUTH_TOKEN_URL');
const clientId = pm.environment.get('AUTH_CLIENT_ID');
const clientSecret = pm.environment.get('AUTH_CLIENT_SECRET');
const scope = pm.environment.get('AUTH_SCOPE');

pm.sendRequest({
    url: tokenUrl,
    method: 'POST',
    header: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: {
        mode: 'urlencoded',
        urlencoded: [
            { key: 'grant_type', value: 'client_credentials' },
            { key: 'client_id', value: clientId },
            { key: 'client_secret', value: clientSecret },
            { key: 'scope', value: scope }
        ]
    }
}, function (err, res) {
    if (!err) {
        pm.environment.set('access_token', res.json().access_token);
    }
});
```

### Basic Auth
```javascript
// Pattern only
const username = pm.environment.get('AUTH_USERNAME');
const password = pm.environment.get('AUTH_PASSWORD');
const encoded = btoa(username + ':' + password);
pm.request.headers.add({ key: 'Authorization', value: 'Basic ' + encoded });
```

### API Key
```javascript
// Pattern only
const apiKey = pm.environment.get('API_KEY');
pm.request.headers.add({ key: 'X-API-Key', value: apiKey });
```
