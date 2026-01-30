# HTTP Client Detection Patterns

## Glob Patterns for Locating HTTP Client Code

### Java — Spring Boot / JAX-RS
```
**/client/**/*.java
**/clients/**/*.java
**/integration/**/*.java
**/feign/**/*.java
**/gateway/**/*.java
**/proxy/**/*.java
**/external/**/*.java
**/config/**/*.java
```

### ASP.NET Core
```
**/HttpClients/**/*.cs
**/Clients/**/*.cs
**/Services/**/*.cs
**/Integration/**/*.cs
**/External/**/*.cs
**/Proxy/**/*.cs
**/Startup.cs
**/Program.cs
```

### Node.js
```
**/clients/**/*.{js,ts}
**/services/**/*.{js,ts}
**/integrations/**/*.{js,ts}
**/external/**/*.{js,ts}
**/api/**/*.{js,ts}
```

### Python
```
**/clients/**/*.py
**/services/**/*.py
**/integrations/**/*.py
**/external/**/*.py
**/api/**/*.py
```

---

## Grep Patterns by Framework

### Java — Spring Boot

**OpenFeign (declarative REST client)**:
```regex
@FeignClient\s*\(
@FeignClient
```
- Look for `name` and `url` attributes to identify target service
- Fallback/fallbackFactory indicates circuit breaker

**WebClient (reactive HTTP)**:
```regex
WebClient\.builder
WebClient\.create
\.baseUrl\s*\(
\.get\(\)\.uri\(
\.post\(\)\.uri\(
```

**RestTemplate (classic)**:
```regex
RestTemplate
restTemplate\.(get|post|put|delete|exchange|getForObject|postForEntity|getForEntity|patchForObject)
```

**Java 11+ HttpClient**:
```regex
HttpClient\.newHttpClient
HttpClient\.newBuilder
HttpRequest\.newBuilder
```

**Apache HttpClient**:
```regex
CloseableHttpClient
HttpClients\.createDefault
HttpGet|HttpPost|HttpPut|HttpDelete
```

**OkHttp**:
```regex
OkHttpClient
Request\.Builder
```

### ASP.NET Core

**IHttpClientFactory (recommended pattern)**:
```regex
AddHttpClient
IHttpClientFactory
\.CreateClient\s*\(
_httpClient\.(Get|Post|Put|Delete|Patch|Send)Async
```

**Typed HttpClient**:
```regex
services\.AddHttpClient<
HttpClient\s+_httpClient
```

**Refit (declarative REST)**:
```regex
\[Get\s*\("
\[Post\s*\("
\[Put\s*\("
\[Delete\s*\("
services\.AddRefitClient<
```

**RestSharp**:
```regex
RestClient
RestRequest
```

### Node.js

**axios**:
```regex
axios\.(get|post|put|delete|patch|request|create)\s*\(
axios\.defaults\.baseURL
```

**node-fetch / native fetch**:
```regex
fetch\s*\(
import.*from\s+['"]node-fetch['"]
```

**got**:
```regex
got\s*\(
got\.(get|post|put|delete|patch)
```

**NestJS HttpModule**:
```regex
HttpModule
HttpService
this\.httpService\.(get|post|put|delete|patch|axiosRef)
```

**superagent**:
```regex
superagent\.(get|post|put|delete|patch)
```

### Python

**requests**:
```regex
requests\.(get|post|put|delete|patch|head|options)\s*\(
requests\.Session\(\)
```

**httpx (async-capable)**:
```regex
httpx\.(get|post|put|delete|patch|AsyncClient|Client)
```

**aiohttp**:
```regex
aiohttp\.ClientSession
session\.(get|post|put|delete|patch)\s*\(
```

**urllib3**:
```regex
urllib3\.PoolManager
```

---

## Resilience Pattern Detection

### Circuit Breakers
```regex
@CircuitBreaker
Resilience4j|resilience4j
HystrixCommand|@HystrixCommand
Polly\.CircuitBreakerAsync|AddTransientHttpErrorPolicy
```

### Retry Policies
```regex
@Retry|@Retryable
RetryTemplate
\.retry\(|maxRetries|retryCount
AddTransientHttpErrorPolicy.*WaitAndRetryAsync
Polly\.Retry
```

### Fallbacks
```regex
fallback\s*=|fallbackMethod
fallbackFactory
\.onErrorResume|\.onErrorReturn
```

### Timeouts
```regex
\.timeout\(|connectTimeout|readTimeout
TimeoutException|TaskCanceledException
RequestConfig\.custom\(\)\.setConnectTimeout
```

---

## URL/Base URL Extraction

Look for how target service URLs are configured:

### Environment Variables / Config
```regex
\$\{.*\.url\}
\$\{.*\.base-url\}
\$\{.*_URL\}
\$\{.*_BASE_URL\}
@Value\s*\(\s*"\$\{
```

### Application Config
```regex
base-url:\s*
baseUrl:\s*
api\.url:\s*
service\.url:\s*
```

### ASP.NET Config
```regex
Configuration\[".*Url"\]
Configuration\.GetValue.*"Url"
Configuration\.GetSection.*"BaseUrl"
IOptions<.*Client.*Options>
```

### Node.js Config
```regex
process\.env\.\w*URL
process\.env\.\w*BASE
config\.(get|has)\s*\(\s*['"].*url
```

---

## Service Name Inference

Techniques for determining the target service name:
1. **Feign client name**: `@FeignClient(name = "user-service")` → service name is "user-service"
2. **Config key prefix**: `order-service.base-url` → service name is "order-service"
3. **URL path analysis**: Base URL ending in `/api/users` → likely "user-service"
4. **Environment variable name**: `PAYMENT_SERVICE_URL` → "payment-service"
5. **Class/file name**: `UserServiceClient.java` → "user-service"
6. **HTTP client registration**: `services.AddHttpClient<IOrderClient>()` → "order-service"
