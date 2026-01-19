# API Key Patterns

## API Key Locations

### Header-Based (Recommended)

```http
GET /api/resource HTTP/1.1
X-API-Key: ${API_KEY}
```

Common header names:
- `X-API-Key`
- `X-Api-Key`
- `Api-Key`
- `Authorization: ApiKey ${API_KEY}`

### Query Parameter

```http
GET /api/resource?api_key=${API_KEY} HTTP/1.1
```

**Note**: Less secure, may be logged in server access logs.

### Basic Auth Style

```http
GET /api/resource HTTP/1.1
Authorization: Basic ${BASE64_API_KEY}
```

Where `BASE64_API_KEY` = base64(`api_key:` or `:api_key` or `api_key:api_key`)

## Postman Configuration

### Header-Based

Set in request headers:
```
X-API-Key: {{API_KEY}}
```

Or in collection-level authorization:
- Type: API Key
- Key: X-API-Key
- Value: {{API_KEY}}
- Add to: Header

### Pre-Request Script (if key rotation needed)

```javascript
// Simple API key - no rotation
// Just ensure API_KEY environment variable is set

const apiKey = pm.environment.get('API_KEY');
if (!apiKey) {
    console.error('API_KEY environment variable not set');
    throw new Error('Missing API_KEY');
}
```

### API Key with Secret

Some APIs require both key and secret:

```javascript
// HMAC signature pattern
const crypto = require('crypto-js');

const apiKey = pm.environment.get('API_KEY');
const apiSecret = pm.environment.get('API_SECRET');
const timestamp = Date.now().toString();
const payload = timestamp + pm.request.method + pm.request.url.getPath();

const signature = crypto.HmacSHA256(payload, apiSecret).toString(crypto.enc.Hex);

pm.request.headers.add({ key: 'X-API-Key', value: apiKey });
pm.request.headers.add({ key: 'X-Timestamp', value: timestamp });
pm.request.headers.add({ key: 'X-Signature', value: signature });
```

## Environment Variables

| Variable | Description |
|----------|-------------|
| API_KEY | Primary API key |
| API_SECRET | API secret (if required) |
| BASE_URL | API base URL |

## API Key Detection Patterns

### In Code

```bash
# Common patterns in configuration
grep -rn "api.key\|apiKey\|API_KEY\|x-api-key" --include="*.properties" --include="*.yml" --include="*.json" src/
```

### In Headers

Look for middleware/filter checking:
- `X-API-Key` header
- `Authorization` header with non-Bearer prefix
- Query parameter validation

## Security Considerations

### For CI/CD

1. Store API key in Azure DevOps Variable Groups (secret)
2. Pass to Newman via environment variable
3. Never commit API keys to source control

### Newman Example

```bash
newman run collection.json \
  --env-var "API_KEY=$API_KEY" \
  --env-var "BASE_URL=$BASE_URL"
```

## Multiple API Key Levels

Some APIs have tiered keys:

| Key Type | Use Case | Rate Limit |
|----------|----------|------------|
| Development | Testing | Low |
| Production | Live traffic | High |
| Admin | Management APIs | Varies |

Document which key type is needed for testing.
