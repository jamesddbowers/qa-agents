# Node.js & Python Detection Patterns

## Node.js

### Build System Detection
- **Marker file**: `package.json`
- **Package manager**: `package-lock.json` (npm), `yarn.lock` (yarn), `pnpm-lock.yaml` (pnpm)
- **Mono-repo**: `lerna.json`, `nx.json`, or `workspaces` field in `package.json`
- **TypeScript**: `tsconfig.json` present
- **Build command**: `scripts.build` in `package.json`

### Framework Detection

#### Express
- **Dependency**: `express` in package.json
- **Markers**: `app.get(`, `app.post(`, `router.get(`, `express()`
- **Middleware**: `app.use(` chains

#### NestJS
- **Dependencies**: `@nestjs/core`, `@nestjs/common`
- **Markers**: `@Controller()`, `@Get()`, `@Post()`, `@Injectable()`
- **Config**: `nest-cli.json`

#### Fastify
- **Dependency**: `fastify`
- **Markers**: `fastify.get(`, `fastify.register(`

#### Next.js
- **Dependency**: `next`
- **Markers**: `pages/api/` or `app/api/` directories
- **Config**: `next.config.js`

### QA-Relevant Dependencies

| Dependency | Implication |
|-----------|-------------|
| `passport`, `passport-jwt` | Auth middleware — auth-flow-analyzer needed |
| `jsonwebtoken`, `jose` | JWT handling |
| `sequelize`, `typeorm`, `prisma` | ORM — data-model-mapper needed |
| `mongoose` | MongoDB ODM — data-model-mapper needed |
| `amqplib` | RabbitMQ — dependency-tracer needed |
| `kafkajs` | Kafka — dependency-tracer needed |
| `axios`, `node-fetch`, `got` | HTTP client — dependency-tracer needed |
| `bull`, `bullmq` | Job queue — async flow |

### Test Frameworks
| Dependency | Type |
|-----------|------|
| `jest` | Test framework + assertions |
| `mocha` | Test framework |
| `vitest` | Vite-native test framework |
| `supertest` | HTTP integration testing |
| `nock` | HTTP mocking |
| `sinon` | Mocking/stubbing |
| `playwright`, `@playwright/test` | E2E testing |
| `cypress` | E2E testing |

### Project Structure (Express)
```
src/
  app.js / app.ts
  routes/
  controllers/
  middleware/
  models/
  services/
  config/
test/ or __tests__/
```

### Project Structure (NestJS)
```
src/
  app.module.ts
  main.ts
  users/
    users.controller.ts
    users.service.ts
    users.module.ts
    dto/
    entities/
test/
  app.e2e-spec.ts
```

---

## Python

### Build System Detection
- **Marker files**: `requirements.txt`, `pyproject.toml`, `setup.py`, `setup.cfg`, `Pipfile`
- **Virtual env**: `venv/`, `.venv/`, `Pipfile.lock`
- **Version**: `python_requires` in setup.py/pyproject.toml, or `runtime.txt`
- **Build command**: `pip install -r requirements.txt` or `poetry install`

### Framework Detection

#### FastAPI
- **Dependency**: `fastapi` in requirements
- **Markers**: `@app.get(`, `@app.post(`, `FastAPI()`, type hints with Pydantic models
- **ASGI**: `uvicorn` as server

#### Django / Django REST Framework
- **Dependencies**: `django`, `djangorestframework`
- **Markers**: `urls.py`, `views.py`, `models.py`, `settings.py`
- **Config**: `INSTALLED_APPS`, `ROOT_URLCONF`

#### Flask
- **Dependency**: `flask`
- **Markers**: `@app.route(`, `Flask(__name__)`
- **Blueprints**: `Blueprint(` registrations

### QA-Relevant Dependencies

| Dependency | Implication |
|-----------|-------------|
| `python-jose`, `PyJWT` | JWT handling — auth-flow-analyzer needed |
| `authlib` | OAuth library |
| `sqlalchemy`, `django.db` | ORM — data-model-mapper needed |
| `alembic` | SQLAlchemy migrations |
| `celery` | Task queue — dependency-tracer needed |
| `pika` | RabbitMQ client |
| `httpx`, `requests`, `aiohttp` | HTTP client — dependency-tracer needed |

### Test Frameworks
| Dependency | Type |
|-----------|------|
| `pytest` | Test framework |
| `unittest` | Built-in test framework |
| `pytest-django` | Django test integration |
| `factory_boy` | Test data factories |
| `responses`, `httpretty` | HTTP mocking |
| `pytest-asyncio` | Async test support |

### Project Structure (FastAPI)
```
app/
  main.py
  routers/
  models/
  schemas/
  services/
  dependencies/
tests/
```

### Project Structure (Django)
```
project/
  settings.py
  urls.py
  wsgi.py
app_name/
  models.py
  views.py
  urls.py
  serializers.py
  tests/
manage.py
```
