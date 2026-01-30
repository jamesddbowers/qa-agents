# .NET / ASP.NET Core Detection Patterns

## Build System Detection

### .NET SDK
- **Marker files**: `*.csproj`, `*.sln`
- **Multi-project**: `.sln` file referencing multiple `.csproj` files
- **Version extraction**: `<TargetFramework>net8.0</TargetFramework>` in .csproj
- **Build command**: `dotnet build` / `dotnet publish`

## Framework Detection

### ASP.NET Core (Minimal API)
- **Dependencies**: `Microsoft.AspNetCore.*` in .csproj
- **Markers**: `WebApplication.CreateBuilder()`, `app.MapGet()`, `app.MapPost()`
- **Config files**: `appsettings.json`, `appsettings.{Environment}.json`

### ASP.NET Core (Controller-based)
- **Annotations**: `[ApiController]`, `[HttpGet]`, `[HttpPost]`, `[Route]`
- **Base class**: `: ControllerBase` or `: Controller`
- **Startup**: `Program.cs` with `builder.Services.AddControllers()`

### ASP.NET Core (MVC)
- **Markers**: `builder.Services.AddControllersWithViews()`
- **Structure**: `Controllers/`, `Views/`, `Models/` directories

## QA-Relevant Dependencies

### Security
| Package | Implication |
|---------|-------------|
| `Microsoft.AspNetCore.Authentication.JwtBearer` | JWT auth — auth-flow-analyzer needed |
| `Microsoft.AspNetCore.Authentication.OpenIdConnect` | OIDC auth flow |
| `Microsoft.Identity.Web` | Azure AD / Entra ID integration |
| `IdentityServer4` or `Duende.IdentityServer` | Self-hosted identity provider |

### Database / ORM
| Package | Implication |
|---------|-------------|
| `Microsoft.EntityFrameworkCore` | EF Core — data-model-mapper needed |
| `Microsoft.EntityFrameworkCore.SqlServer` | SQL Server target |
| `Npgsql.EntityFrameworkCore.PostgreSQL` | PostgreSQL target |
| `Dapper` | Micro ORM (no migrations, manual SQL) |
| `FluentMigrator` | Migration framework |

### Messaging / Async
| Package | Implication |
|---------|-------------|
| `MassTransit` | Message bus abstraction — dependency-tracer needed |
| `RabbitMQ.Client` | Direct RabbitMQ |
| `Azure.Messaging.ServiceBus` | Azure Service Bus |
| `Confluent.Kafka` | Kafka client |

### HTTP Clients (inter-service)
| Package | Implication |
|---------|-------------|
| `Microsoft.Extensions.Http` | IHttpClientFactory — dependency-tracer needed |
| `Refit` | Type-safe REST client |
| `RestSharp` | REST client library |

### Test Frameworks
| Package | Type |
|---------|------|
| `xunit` | xUnit test framework |
| `NUnit` | NUnit test framework |
| `MSTest.TestFramework` | MSTest |
| `Moq` | Mocking framework |
| `NSubstitute` | Mocking framework |
| `FluentAssertions` | Assertion library |
| `Microsoft.AspNetCore.Mvc.Testing` | Integration test host |
| `WireMock.Net` | HTTP mock server |
| `Testcontainers` | Container-based tests |

## Project Structure Patterns

### Standard ASP.NET Core
```
MyService/
  MyService.csproj
  Program.cs
  Controllers/
  Models/
  Services/
  Data/
  appsettings.json
  Properties/launchSettings.json
```

### Clean Architecture
```
MyService.sln
src/
  MyService.Api/           (Controllers, DTOs)
  MyService.Application/   (Use cases, interfaces)
  MyService.Domain/        (Entities, value objects)
  MyService.Infrastructure/(EF Core, external services)
tests/
  MyService.UnitTests/
  MyService.IntegrationTests/
```

## CI/CD Signals
- `azure-pipelines.yml` → Azure DevOps
- `.github/workflows/*.yml` → GitHub Actions
- `Dockerfile` with `dotnet publish` → containerized
- `global.json` → pinned SDK version
