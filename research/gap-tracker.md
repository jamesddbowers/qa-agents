# Gap Tracker

This document tracks gaps in the qa-copilot plugin coverage and what research is needed to fill them.

## Status Legend

- **Not Started**: No research or implementation yet
- **Research Needed**: Need external sources or documentation
- **Source Found**: Source identified, queued for extraction
- **In Progress**: Have some patterns, building out
- **Implemented**: Code created, ready for testing
- **Complete**: Tested and validated

---

## Current Implementation Status

| Component | Count | Status | Location |
|-----------|-------|--------|----------|
| Agents | 6 | Implemented | `qa-copilot/agents/` |
| Commands | 6 | Implemented | `qa-copilot/commands/` |
| Skills | 8 | Implemented | `qa-copilot/skills/` |
| Hooks | 4 | Implemented | `qa-copilot/hooks/hooks.json` |

### Implemented Components Detail

**Agents**:
- endpoint-discoverer (MVP Step 1)
- auth-analyzer (MVP Step 2)
- traffic-analyzer (MVP Step 3)
- collection-generator (MVP Step 5)
- pipeline-generator (MVP Step 7)
- diagnostics-agent (MVP Step 8)

**Commands**:
- /discover-endpoints (MVP Step 1)
- /analyze-auth (MVP Step 2)
- /analyze-traffic (MVP Step 3)
- /generate-collection (MVP Step 5)
- /generate-pipeline (MVP Step 7)
- /diagnose (MVP Step 8)

**Skills**:
- endpoint-discovery (MVP Step 1)
- auth-patterns (MVP Step 2)
- dynatrace-analysis (MVP Step 3)
- test-tagging (MVP Step 4)
- postman-generation (MVP Step 5)
- test-data-planning (MVP Step 6)
- ado-pipeline-patterns (MVP Step 7)
- failure-triage (MVP Step 8)

**Hooks**:
- PreToolUse: Write (validates safe output locations)
- PreToolUse: Read (blocks .env/secrets access)
- PreToolUse: Bash (blocks destructive commands)
- Stop: Final safety reminder

---

## Coverage Summary (Post Implementation)

| MVP Step | Primary Sources | Implementation Status |
|----------|-----------------|----------------------|
| Step 1 (Endpoint Inventory) | documate, logicscope | **Implemented** |
| Step 2 (Auth Discovery) | documate, backend-api-security-agents | **Implemented** |
| Step 3 (Telemetry/Prioritization) | claude-code-templates-components (dynatrace-expert.md) | **Implemented** |
| Step 4 (Tagging Conventions) | (derived from sources) | **Implemented** |
| Step 5 (Postman Generation) | documate (OpenAPI), api-testing-observability | **Implemented** |
| Step 6 (Test Data Strategy) | testforge, dataforge, api-testing-observability | **Implemented** |
| Step 7 (ADO Pipelines) | cicd-automation | **Implemented** |
| Step 8 (Diagnostics/Triage) | clauditor, backend-api-security-agents | **Implemented** |

---

## MVP Step 1: Endpoint Inventory

### Agents

| Component | Status | Gaps | Sources Found |
| --------- | ------ | ---- | ------------- |
| `api-surface-extraction-agent` | Source Found | Full agent spec | **documate** (endpoint discovery, Spring Boot, ASP.NET), **logicscope** (data flow tracing) |
| `repo-discovery-agent` | Source Found | Full agent spec | **documate** (framework detection), **backend-development** (api-design skill) |

### Skills

| Component | Status | Gaps | Sources Found |
| --------- | ------ | ---- | ------------- |
| `endpoint-discovery/SKILL.md` | Source Found | Core instructions | **documate** patterns |
| `endpoint-discovery/java-patterns.md` | Source Found | Spring Boot, JAX-RS patterns | **documate** (Spring Boot detection) |
| `endpoint-discovery/js-ts-patterns.md` | Source Found | Express, NestJS patterns | **documate** (TypeScript support) |
| `endpoint-discovery/dotnet-patterns.md` | Source Found | ASP.NET Core patterns | **documate** (ASP.NET detection) |
| `endpoint-discovery/openapi-generation.md` | Source Found | OpenAPI draft generation | **documate** (OpenAPI 3.0 generation), **documentation-generation** |

### Commands

| Component | Status | Gaps |
| --------- | ------ | ---- |
| `discover-endpoints.md` | Source Found | Full command spec |
| `generate-openapi-draft.md` | Source Found | Full command spec |

---

## MVP Step 2: Auth Discovery

### Agents

| Component | Status | Gaps | Sources Found |
| --------- | ------ | ---- | ------------- |
| `auth-access-discovery-agent` | Source Found | Full agent spec | **backend-api-security-agents** (OAuth/JWT/OIDC patterns) |

### Skills

| Component | Status | Gaps | Sources Found |
| --------- | ------ | ---- | ------------- |
| `auth-patterns/SKILL.md` | Source Found | Core instructions | **backend-api-security-agents** |
| `auth-patterns/oauth-patterns.md` | Source Found | OAuth 2.0 flows | **backend-api-security-agents** (OAuth patterns) |
| `auth-patterns/jwt-patterns.md` | Source Found | JWT handling | **backend-api-security-agents** (JWT patterns) |
| `auth-patterns/azure-ad-patterns.md` | Partial | Azure AD / Entra ID | Need Azure AD-specific docs |

### Commands

| Component | Status | Gaps |
| --------- | ------ | ---- |
| `analyze-auth.md` | Source Found | Full command spec |
| `generate-auth-helper.md` | Source Found | Full command spec |

---

## MVP Step 3: Telemetry/Prioritization

### Agents

| Component | Status | Gaps | Sources Found |
| --------- | ------ | ---- | ------------- |
| `telemetry-prioritization-agent` | Source Found | Full agent spec | **claude-code-templates-components/dynatrace-expert.md** (851 lines, complete DQL reference) |

### Skills

| Component | Status | Gaps | Sources Found |
| --------- | ------ | ---- | ------------- |
| `dynatrace-analysis/SKILL.md` | Source Found | Core instructions | **dynatrace-expert.md** |
| `dynatrace-analysis/export-formats.md` | Source Found | CSV/JSON export schemas | **dynatrace-expert.md** (DQL query patterns, golden signals) |
| `dynatrace-analysis/prioritization-algorithms.md` | Source Found | Ranking algorithms | **dynatrace-expert.md** (P95, error rate, throughput prioritization) |

### Commands

| Component | Status | Gaps |
| --------- | ------ | ---- |
| `ingest-telemetry.md` | Source Found | Full command spec |
| `prioritize-endpoints.md` | Source Found | Full command spec |

**Key Finding**: dynatrace-expert.md provides complete DQL query reference including:
- Golden signals queries (P95 response time, error rate, throughput)
- Service dependency mapping
- SLO monitoring patterns
- Entity relationship queries

---

## MVP Step 4: Tagging Conventions

### Agents

| Component | Status | Gaps | Sources Found |
| --------- | ------ | ---- | ------------- |
| `tagging-composition-agent` | Research Needed | Full agent spec | (derive from testforge, api-testing-observability patterns) |

### Skills

| Component | Status | Gaps | Sources Found |
| --------- | ------ | ---- | ------------- |
| `test-suite-conventions/SKILL.md` | Research Needed | Core instructions | - |
| `test-suite-conventions/tagging-standards.md` | Research Needed | Industry standards | Need official Postman tagging docs |

### Commands

| Component | Status | Gaps |
| --------- | ------ | ---- |
| `define-tagging.md` | Research Needed | Full command spec |
| `compose-smoke-set.md` | Research Needed | Full command spec |

**Note**: No direct source found. Can derive patterns from testforge (test categorization) and api-testing-observability (scenario management).

---

## MVP Step 5: Postman Generation

### Agents

| Component | Status | Gaps | Sources Found |
| --------- | ------ | ---- | ------------- |
| `postman-authoring-agent` | Partial | Full agent spec | **documate** (OpenAPI → Postman), **api-testing-observability** (test generation) |

### Skills

| Component | Status | Gaps | Sources Found |
| --------- | ------ | ---- | ------------- |
| `postman-generation/SKILL.md` | Partial | Core instructions | **api-testing-observability** patterns |
| `postman-generation/collection-schema.md` | Research Needed | Postman v2.1 schema | **Need official Postman schema docs** |
| `postman-generation/assertion-patterns.md` | Source Found | pm.test, pm.expect | **api-testing-observability** (assertion patterns) |
| `postman-generation/chaining-patterns.md` | Source Found | Variable extraction | **api-testing-observability** (scenario management) |

### Commands

| Component | Status | Gaps |
| --------- | ------ | ---- |
| `generate-postman.md` | Partial | Full command spec |
| `validate-collection.md` | Research Needed | Full command spec |

**Gap**: Postman Collection v2.1 schema reference not found in sources. Need official Postman documentation.

---

## MVP Step 6: Test Data Strategy

### Agents

| Component | Status | Gaps | Sources Found |
| --------- | ------ | ---- | ------------- |
| `data-model-dependency-agent` | Source Found | Full agent spec | **logicscope** (data flow tracing, entity discovery) |
| `test-data-seeding-agent` | Source Found | Full agent spec | **testforge** (test data factory), **dataforge** (schema generation) |

### Skills

| Component | Status | Gaps | Sources Found |
| --------- | ------ | ---- | ------------- |
| `test-data-strategy/SKILL.md` | Source Found | Core instructions | **testforge**, **dataforge** |
| `test-data-strategy/seeding-patterns.md` | Source Found | API seeding approaches | **api-testing-observability** (Faker patterns), **dataforge** (type inference) |
| `test-data-strategy/cleanup-patterns.md` | Partial | Teardown strategies | **testforge** (AAA pattern) |

### Commands

| Component | Status | Gaps |
| --------- | ------ | ---- |
| `analyze-data-deps.md` | Source Found | Full command spec |
| `generate-seed-collection.md` | Source Found | Full command spec |

---

## MVP Step 7: ADO Pipelines

### Agents

| Component | Status | Gaps | Sources Found |
| --------- | ------ | ---- | ------------- |
| `ado-pipeline-agent` | Partial | Full agent spec | **cicd-automation** (Azure DevOps YAML, approval gates) |

### Skills

| Component | Status | Gaps | Sources Found |
| --------- | ------ | ---- | ------------- |
| `ado-pipeline-patterns/SKILL.md` | Partial | Core instructions | **cicd-automation** |
| `ado-pipeline-patterns/newman-tasks.md` | Research Needed | Newman ADO config | **Need Newman + ADO integration docs** |
| `ado-pipeline-patterns/reporting-patterns.md` | Research Needed | JUnit/HTML publishing | **Need ADO test result publishing docs** |

### Commands

| Component | Status | Gaps |
| --------- | ------ | ---- |
| `generate-pipeline.md` | Partial | Full command spec |
| `validate-pipeline.md` | Research Needed | Full command spec |

**Gaps Remaining**:
- Newman task configuration in ADO (not found in sources)
- Test result publishing to ADO (not found in sources)
- ADO variable groups for environments (not found in sources)

---

## MVP Step 8: Diagnostics/Triage

### Agents

| Component | Status | Gaps | Sources Found |
| --------- | ------ | ---- | ------------- |
| `diagnostics-triage-agent` | Source Found | Full agent spec | **clauditor** (diagnostics, failure triage, severity categorization) |

### Skills

| Component | Status | Gaps | Sources Found |
| --------- | ------ | ---- | ------------- |
| `failure-triage/SKILL.md` | Source Found | Core instructions | **clauditor** |
| `failure-triage/classification-matrix.md` | Source Found | Failure taxonomy | **clauditor** (severity categorization), **backend-api-security-agents** |
| `failure-triage/repro-generation.md` | Source Found | Repro step patterns | **clauditor** patterns |

### Commands

| Component | Status | Gaps |
| --------- | ------ | ---- |
| `triage-failure.md` | Source Found | Full command spec |
| `generate-repro.md` | Source Found | Full command spec |

---

## Research Priorities (Updated)

### Remaining Gaps (Require External Docs)

| Gap | Status | Action Needed |
|-----|--------|---------------|
| Postman Collection v2.1 Schema | NOT FOUND | Add official Postman schema docs as source |
| Newman ADO Task Config | NOT FOUND | Add Newman/Postman CLI docs for ADO integration |
| ADO Test Result Publishing | NOT FOUND | Add Azure DevOps publishing task docs |
| ADO Variable Groups | NOT FOUND | Add Azure DevOps variable group docs |
| Azure AD/Entra Token Patterns | PARTIAL | Add Azure identity docs |

### Resolved by Source Evaluation

| Former Gap | Resolved By |
|------------|-------------|
| API endpoint discovery patterns | documate, logicscope |
| Auth flow patterns | backend-api-security-agents |
| Dynatrace export formats | dynatrace-expert.md (complete!) |
| Failure classification | clauditor |
| Test data strategies | testforge, dataforge, api-testing-observability |
| OpenAPI generation | documate, documentation-generation |

---

## Sources Catalog

### Evaluation Pipeline

For sources currently being evaluated:

- **Stage 1 (README evaluation)**: Complete - 36 sources evaluated
- **Stage 2 (Prioritization)**: Complete - See [source-priority-index.md](source-priority-index.md)
- **Stage 3 (Full extraction)**: Pending - 11 sources queued

### Sources Queued for Extraction (Priority Order)

| # | Source | Priority | MVP Steps | Key Patterns |
|---|--------|----------|-----------|--------------|
| 1 | plugin-dev + skill-creator | CRITICAL | ALL | Plugin structure + SKILL.md patterns (extract together) |
| 2 | documate | CRITICAL | 1, 2, 5 | Endpoint discovery, OpenAPI |
| 3 | claude-code-templates-components | CRITICAL | 3, 8 | dynatrace-expert.md |
| 4 | clauditor | HIGH | 8 | Diagnostics, triage |
| 5 | testforge | HIGH | 6 | Test categorization, factories |
| 6 | cicd-automation | HIGH | 7 | Azure DevOps YAML |
| 7 | backend-api-security-agents | HIGH | 2, 8 | OAuth/JWT/OIDC |
| 8 | api-testing-observability | HIGH | 5, 6 | Test generation, Faker |
| 9 | logicscope | HIGH | 1, 6 | Data flow, entity discovery |
| 10 | dataforge | HIGH | 6 | Schema generation |

### Fully Extracted Sources

| Source | Date Added | MVP Steps Covered | Status | Location |
| ------ | ---------- | ----------------- | ------ | -------- |
| Claude Code Mastery V3 | 2026-01-16 | Architecture patterns | Integrated | `sources/claude-code-mastery-v3-extraction.md` |
| (Additional sources will be added here after Stage 3 extraction) | | | | |

---

## Baseline Patterns from Claude Code Mastery V3

The following patterns from the guide are now integrated as baseline for all components:

### Architecture Patterns (All Components)

| Pattern | Applied To | Extraction Doc Reference |
| ------- | ---------- | ------------------------ |
| CLAUDE.md memory hierarchy | Project structure | Part 1 |
| Security gatekeeper rules | CLAUDE.md, hooks | Part 1 |
| Defense in depth model | Architecture | Part 1 |
| Progressive disclosure | Skills structure | Part 5 |
| Single-purpose chats | Workflow guidance | Part 6 |
| Hook enforcement | hooks.json | Part 7 |

### Technical Patterns (Specific Steps)

| Pattern | MVP Step | Notes |
| ------- | -------- | ----- |
| LSP semantic navigation | Step 1 (Endpoint Inventory) | 900x faster codebase navigation for annotation detection |
| Skills YAML frontmatter | All skills | Standard format for all SKILL.md files |
| Prompt-based hooks | Step 8 (Diagnostics) | PreToolUse validation pattern |

### Patterns Deferred to Backlog

| Pattern | Target Phase | Notes |
| ------- | ------------ | ----- |
| Playwright MCP | Phase 2 | E2E testing integration |
| Context7 MCP | Phase 2+ | Live documentation |
| Project scaffolding template | Phase 2+ | QA test project template |
| Python hook scripts | Phase 1.1 | Stricter enforcement (block-secrets.py) |

**Full extraction document:** [claude-code-mastery-v3-extraction.md](sources/claude-code-mastery-v3-extraction.md)

---

*Last Updated: 2026-01-19*
*36 Sources Evaluated | 11 Queued for Extraction | 4 Gaps Remaining*
