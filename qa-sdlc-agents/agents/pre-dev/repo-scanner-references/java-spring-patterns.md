# Java / Spring Boot Detection Patterns

## Build System Detection

### Maven
- **Marker file**: `pom.xml`
- **Multi-module**: Parent `pom.xml` with `<modules>` element
- **Version extraction**: `<java.version>`, `<maven.compiler.source>`, `<spring-boot.version>`
- **Build command**: `mvn clean install` (or `./mvnw` if wrapper present)

### Gradle
- **Marker files**: `build.gradle` or `build.gradle.kts`
- **Multi-module**: `settings.gradle` with `include` statements
- **Version extraction**: `sourceCompatibility`, `java.toolchain.languageVersion`
- **Build command**: `gradle build` (or `./gradlew` if wrapper present)

## Framework Detection

### Spring Boot
- **Dependencies**: `spring-boot-starter-*` in pom.xml or build.gradle
- **Annotations**: `@SpringBootApplication`, `@RestController`, `@Service`, `@Repository`
- **Config files**: `application.yml`, `application.properties`, `application-{profile}.yml`
- **Version**: `spring-boot-starter-parent` version or `spring-boot.version` property

### JAX-RS (Jersey, RESTEasy)
- **Dependencies**: `javax.ws.rs-api`, `jersey-server`, `resteasy-jaxrs`
- **Annotations**: `@Path`, `@GET`, `@POST`, `@Produces`, `@Consumes`
- **Config**: `web.xml` or `Application` subclass with `@ApplicationPath`

## QA-Relevant Dependencies

### Security
| Dependency | Implication |
|-----------|-------------|
| `spring-boot-starter-security` | Spring Security — auth-flow-analyzer needed |
| `spring-security-oauth2-client` | OAuth2 client flow present |
| `spring-security-oauth2-resource-server` | JWT/OAuth2 resource server |
| `io.jsonwebtoken:jjwt` | Direct JWT handling |
| `com.auth0:java-jwt` | Auth0 JWT library |

### Database / ORM
| Dependency | Implication |
|-----------|-------------|
| `spring-boot-starter-data-jpa` | JPA/Hibernate — data-model-mapper needed |
| `spring-boot-starter-data-jdbc` | Spring Data JDBC |
| `mybatis-spring-boot-starter` | MyBatis ORM |
| `flyway-core` | Flyway migrations present |
| `liquibase-core` | Liquibase migrations present |

### Messaging / Async
| Dependency | Implication |
|-----------|-------------|
| `spring-boot-starter-amqp` | RabbitMQ — dependency-tracer needed |
| `spring-kafka` | Kafka messaging |
| `spring-boot-starter-activemq` | ActiveMQ |
| `spring-cloud-stream` | Spring Cloud Stream |

### HTTP Clients (inter-service)
| Dependency | Implication |
|-----------|-------------|
| `spring-cloud-starter-openfeign` | Feign HTTP client — dependency-tracer needed |
| `spring-boot-starter-webflux` | WebClient (reactive HTTP) |
| `org.apache.httpcomponents:httpclient` | Apache HttpClient |
| `com.squareup.okhttp3:okhttp` | OkHttp client |

### Test Frameworks
| Dependency | Type |
|-----------|------|
| `spring-boot-starter-test` | Includes JUnit 5, Mockito, AssertJ |
| `junit-jupiter` | JUnit 5 |
| `mockito-core` | Mocking framework |
| `org.testcontainers` | Container-based integration tests |
| `com.github.tomakehurst:wiremock` | HTTP mock server |
| `io.rest-assured:rest-assured` | REST API testing |

## Project Structure Patterns

### Standard Spring Boot
```
src/
  main/
    java/com/example/service/
      Application.java
      controller/
      service/
      repository/
      model/
      config/
    resources/
      application.yml
      application-dev.yml
  test/
    java/com/example/service/
```

### Multi-Module Spring Boot
```
parent/
  pom.xml (parent POM with <modules>)
  api/
    pom.xml
    src/main/java/.../controller/
  core/
    pom.xml
    src/main/java/.../service/
  persistence/
    pom.xml
    src/main/java/.../repository/
```

## CI/CD Signals
- `azure-pipelines.yml` → Azure DevOps
- `.github/workflows/*.yml` → GitHub Actions
- `Jenkinsfile` → Jenkins
- `Dockerfile` / `docker-compose.yml` → containerized deployment
