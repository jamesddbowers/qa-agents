# Infrastructure Dependency Detection Patterns

## Database Connection Detection

### Glob Patterns
```
**/application.yml
**/application.properties
**/application-*.yml
**/appsettings.json
**/appsettings.*.json
**/.env.example
**/docker-compose.yml
**/docker-compose.*.yml
**/config/**/*.{yml,yaml,json,properties}
**/database/**/*.{sql,xml}
**/migrations/**/*
**/db/**/*
```

### Grep Patterns — Connection Configuration

**Java / Spring Boot**:
```regex
spring\.datasource\.url
spring\.datasource\.driver-class-name
spring\.r2dbc\.url
spring\.jpa\.database-platform
spring\.data\.mongodb\.uri
```

**ASP.NET Core**:
```regex
ConnectionStrings
"DefaultConnection"
UseSqlServer|UseNpgsql|UseSqlite|UseMySQL|UseInMemoryDatabase
```

**Node.js**:
```regex
DATABASE_URL
MONGO_URI|MONGODB_URI
mongoose\.connect
createConnection|createPool
new\s+Sequelize|TypeORM\.createConnection
PrismaClient
```

**Python**:
```regex
SQLALCHEMY_DATABASE_URI|DATABASE_URL
DATABASES\s*=\s*\{
django\.db\.backends
psycopg2|pymysql|sqlite3
MongoClient|motor\.motor_asyncio
```

### Database Type Inference

| Pattern | Database Type |
|---------|--------------|
| `jdbc:postgresql` / `UseNpgsql` / `psycopg2` | PostgreSQL |
| `jdbc:mysql` / `UseMySQL` / `pymysql` | MySQL |
| `jdbc:sqlserver` / `UseSqlServer` | SQL Server |
| `jdbc:oracle` / `ojdbc` | Oracle |
| `jdbc:h2` / `UseInMemoryDatabase` | H2 / In-Memory |
| `mongodb://` / `MongoClient` / `mongoose` | MongoDB |
| `jdbc:sqlite` / `UseSqlite` / `sqlite3` | SQLite |

---

## Caching Detection

### Grep Patterns

**Java — Spring Cache / Redis**:
```regex
spring\.redis\.(host|port|url)
spring\.cache\.type
@Cacheable|@CacheEvict|@CachePut|@EnableCaching
RedisTemplate
StringRedisTemplate
RedisCacheManager
lettuce|jedis
spring\.data\.redis
```

**ASP.NET Core**:
```regex
AddStackExchangeRedis
IDistributedCache
AddMemoryCache
IMemoryCache
AddResponseCaching
services\.AddDistributedMemoryCache
ConnectionMultiplexer
```

**Node.js**:
```regex
redis\.createClient|ioredis|new\s+Redis\(
createClient\s*\(\s*\{.*host
node-cache|NodeCache
lru-cache|LRUCache
```

**Python**:
```regex
redis\.Redis|aioredis|redis\.StrictRedis
django\.core\.cache
CACHES\s*=\s*\{
django_redis|pylibmc|pymemcache
```

### Cache Type Inference

| Pattern | Cache Type |
|---------|-----------|
| `spring.redis` / `AddStackExchangeRedis` / `redis.createClient` | Redis |
| `Memcached` / `pymemcache` / `pylibmc` | Memcached |
| `AddMemoryCache` / `IMemoryCache` / `@EnableCaching` with no Redis | In-Memory |
| `AddResponseCaching` | HTTP Response Cache |

---

## File Storage / Blob Storage Detection

### Grep Patterns

**AWS S3**:
```regex
AmazonS3|S3Client|@aws-sdk/client-s3
s3\.putObject|s3\.getObject|PutObjectCommand|GetObjectCommand
AWS_S3_BUCKET|S3_BUCKET
```

**Azure Blob Storage**:
```regex
BlobServiceClient|BlobContainerClient
Azure\.Storage\.Blobs
@azure/storage-blob
AZURE_STORAGE_CONNECTION_STRING
```

**Google Cloud Storage**:
```regex
@google-cloud/storage|Storage\(\)
google\.cloud\.storage
```

**MinIO / Local**:
```regex
MinioClient|Minio\(
multer|formidable
```

---

## Search Engine Detection

### Grep Patterns

**Elasticsearch**:
```regex
RestHighLevelClient|ElasticsearchClient
@Document\s*\(.*indexName
spring\.elasticsearch
@elastic/elasticsearch|Client\(\{.*node
elasticsearch-py|Elasticsearch\(
```

**Algolia**:
```regex
algoliasearch|algolia
```

**Solr**:
```regex
SolrClient|SolrQuery
spring\.data\.solr
```

---

## External Service SDK Detection

### Payment Providers
```regex
stripe|Stripe\.(Charge|PaymentIntent|Customer|api_key)
paypal|PayPal|braintree|Braintree
square|Square
adyen|Adyen
```

### Email / SMS / Notification
```regex
sendgrid|@sendgrid|SendGridClient
mailgun|Mailgun
SES|SesClient|@aws-sdk/client-ses
twilio|Twilio
firebase|Firebase|FCM
```

### Identity Providers
```regex
Auth0|auth0
Okta|okta
AzureAD|MicrosoftIdentity|AddMicrosoftIdentityWebApi
Keycloak|keycloak
```

### Cloud SDKs (General)
```regex
aws-sdk|@aws-sdk|AWSClientFactory
Azure\.|Microsoft\.Azure|@azure/
googleapis|@google-cloud|google\.cloud
```

---

## Docker / Infrastructure Composition

### docker-compose.yml Service Detection
```regex
services:
  \w+:
    image:\s*(.+)
    depends_on:
    ports:
    environment:
```

Common images that indicate infrastructure:
| Image Pattern | Infrastructure Type |
|--------------|-------------------|
| `postgres` / `mysql` / `mssql` / `mongo` | Database |
| `redis` | Cache / Message Broker |
| `rabbitmq` | Message Queue |
| `kafka` / `confluentinc` | Event Streaming |
| `elasticsearch` / `opensearch` | Search Engine |
| `localstack` | AWS Local Emulation |
| `azurite` | Azure Local Emulation |
| `mailhog` / `mailpit` | Email Testing |
| `wiremock` | HTTP Mock Server |

---

## Test Implications by Infrastructure Type

| Infrastructure | Test Implication |
|---------------|-----------------|
| External REST service | Mock with WireMock/Mountebank or stub |
| Database | Testcontainers or shared test DB |
| Redis cache | Testcontainers or embedded Redis |
| RabbitMQ | Testcontainers or embedded broker |
| Kafka | Testcontainers or embedded Kafka |
| S3 / Blob Storage | LocalStack / Azurite or mock |
| Elasticsearch | Testcontainers or embedded |
| External SaaS (Stripe, SendGrid) | SDK mocks or sandbox environments |
| Identity Provider | Mock token issuer or test tenant |
