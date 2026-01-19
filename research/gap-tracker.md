# Gap Tracker

This document tracks gaps in the qa-copilot plugin coverage and what research is needed to fill them.

## Status Legend

- **Not Started**: No research or implementation yet
- **Research Needed**: Need external sources or documentation
- **In Progress**: Have some patterns, building out
- **Complete**: Ready for testing

---

## MVP Step 1: Endpoint Inventory

### Agents

| Component | Status | Gaps | Sources Needed |
| --------- | ------ | ---- | -------------- |
| `api-surface-extraction-agent` | Not Started | Full agent spec | API discovery agents, endpoint extraction prompts |
| `repo-discovery-agent` | Not Started | Full agent spec | Codebase analysis agents |

### Skills

| Component | Status | Gaps | Sources Needed |
| --------- | ------ | ---- | -------------- |
| `endpoint-discovery/SKILL.md` | Not Started | Core instructions | - |
| `endpoint-discovery/java-patterns.md` | Research Needed | Spring Boot, JAX-RS patterns | Spring Boot endpoint discovery examples |
| `endpoint-discovery/js-ts-patterns.md` | Research Needed | Express, NestJS patterns | Node.js API discovery examples |
| `endpoint-discovery/dotnet-patterns.md` | Research Needed | ASP.NET Core patterns | .NET API discovery examples |
| `endpoint-discovery/openapi-generation.md` | Research Needed | OpenAPI draft generation | OpenAPI generation tools/patterns |

### Commands

| Component | Status | Gaps |
| --------- | ------ | ---- |
| `discover-endpoints.md` | Not Started | Full command spec |
| `generate-openapi-draft.md` | Not Started | Full command spec |

---

## MVP Step 2: Auth Discovery

### Agents

| Component | Status | Gaps | Sources Needed |
| --------- | ------ | ---- | -------------- |
| `auth-access-discovery-agent` | Not Started | Full agent spec | Auth analysis agents |

### Skills

| Component | Status | Gaps | Sources Needed |
| --------- | ------ | ---- | -------------- |
| `auth-patterns/SKILL.md` | Not Started | Core instructions | - |
| `auth-patterns/oauth-patterns.md` | Research Needed | OAuth 2.0 flows | OAuth implementation guides |
| `auth-patterns/jwt-patterns.md` | Research Needed | JWT handling | JWT auth patterns |
| `auth-patterns/azure-ad-patterns.md` | Research Needed | Azure AD / Entra ID | Azure AD token acquisition docs |

### Commands

| Component | Status | Gaps |
| --------- | ------ | ---- |
| `analyze-auth.md` | Not Started | Full command spec |
| `generate-auth-helper.md` | Not Started | Full command spec |

---

## MVP Step 3: Telemetry/Prioritization

### Agents

| Component | Status | Gaps | Sources Needed |
| --------- | ------ | ---- | -------------- |
| `telemetry-prioritization-agent` | Not Started | Full agent spec | Telemetry analysis agents |

### Skills

| Component | Status | Gaps | Sources Needed |
| --------- | ------ | ---- | -------------- |
| `dynatrace-analysis/SKILL.md` | Not Started | Core instructions | - |
| `dynatrace-analysis/export-formats.md` | Research Needed | CSV/JSON export schemas | Dynatrace export documentation |
| `dynatrace-analysis/prioritization-algorithms.md` | Research Needed | Ranking algorithms | Prioritization methodology docs |

### Commands

| Component | Status | Gaps |
| --------- | ------ | ---- |
| `ingest-telemetry.md` | Not Started | Full command spec |
| `prioritize-endpoints.md` | Not Started | Full command spec |

---

## MVP Step 4: Tagging Conventions

### Agents

| Component | Status | Gaps | Sources Needed |
| --------- | ------ | ---- | -------------- |
| `tagging-composition-agent` | Not Started | Full agent spec | Test strategy agents |

### Skills

| Component | Status | Gaps | Sources Needed |
| --------- | ------ | ---- | -------------- |
| `test-suite-conventions/SKILL.md` | Not Started | Core instructions | - |
| `test-suite-conventions/tagging-standards.md` | Research Needed | Industry standards | Test tagging best practices |

### Commands

| Component | Status | Gaps |
| --------- | ------ | ---- |
| `define-tagging.md` | Not Started | Full command spec |
| `compose-smoke-set.md` | Not Started | Full command spec |

---

## MVP Step 5: Postman Generation

### Agents

| Component | Status | Gaps | Sources Needed |
| --------- | ------ | ---- | -------------- |
| `postman-authoring-agent` | Not Started | Full agent spec | Postman generation agents/prompts |

### Skills

| Component | Status | Gaps | Sources Needed |
| --------- | ------ | ---- | -------------- |
| `postman-generation/SKILL.md` | Not Started | Core instructions | - |
| `postman-generation/collection-schema.md` | Research Needed | Postman v2.1 schema | Postman schema docs |
| `postman-generation/assertion-patterns.md` | Research Needed | pm.test, pm.expect | Postman scripting guides |
| `postman-generation/chaining-patterns.md` | Research Needed | Variable extraction | Postman workflow examples |

### Commands

| Component | Status | Gaps |
| --------- | ------ | ---- |
| `generate-postman.md` | Not Started | Full command spec |
| `validate-collection.md` | Not Started | Full command spec |

---

## MVP Step 6: Test Data Strategy

### Agents

| Component | Status | Gaps | Sources Needed |
| --------- | ------ | ---- | -------------- |
| `data-model-dependency-agent` | Not Started | Full agent spec | Data analysis agents |
| `test-data-seeding-agent` | Not Started | Full agent spec | Test data management agents |

### Skills

| Component | Status | Gaps | Sources Needed |
| --------- | ------ | ---- | -------------- |
| `test-data-strategy/SKILL.md` | Not Started | Core instructions | - |
| `test-data-strategy/seeding-patterns.md` | Research Needed | API seeding approaches | Test data best practices |
| `test-data-strategy/cleanup-patterns.md` | Research Needed | Teardown strategies | - |

### Commands

| Component | Status | Gaps |
| --------- | ------ | ---- |
| `analyze-data-deps.md` | Not Started | Full command spec |
| `generate-seed-collection.md` | Not Started | Full command spec |

---

## MVP Step 7: ADO Pipelines

### Agents

| Component | Status | Gaps | Sources Needed |
| --------- | ------ | ---- | -------------- |
| `ado-pipeline-agent` | Not Started | Full agent spec | CI/CD agents |

### Skills

| Component | Status | Gaps | Sources Needed |
| --------- | ------ | ---- | -------------- |
| `ado-pipeline-patterns/SKILL.md` | Not Started | Core instructions | - |
| `ado-pipeline-patterns/newman-tasks.md` | Research Needed | Newman ADO config | Newman + ADO integration docs |
| `ado-pipeline-patterns/reporting-patterns.md` | Research Needed | JUnit/HTML publishing | ADO reporting docs |

### Commands

| Component | Status | Gaps |
| --------- | ------ | ---- |
| `generate-pipeline.md` | Not Started | Full command spec |
| `validate-pipeline.md` | Not Started | Full command spec |

---

## MVP Step 8: Diagnostics/Triage

### Agents

| Component | Status | Gaps | Sources Needed |
| --------- | ------ | ---- | -------------- |
| `diagnostics-triage-agent` | Not Started | Full agent spec | Debugging/triage agents |

### Skills

| Component | Status | Gaps | Sources Needed |
| --------- | ------ | ---- | -------------- |
| `failure-triage/SKILL.md` | Not Started | Core instructions | - |
| `failure-triage/classification-matrix.md` | Research Needed | Failure taxonomy | Failure analysis methodologies |
| `failure-triage/repro-generation.md` | Research Needed | Repro step patterns | - |

### Commands

| Component | Status | Gaps |
| --------- | ------ | ---- |
| `triage-failure.md` | Not Started | Full command spec |
| `generate-repro.md` | Not Started | Full command spec |

---

## Research Priorities

### High Priority (Blocks Multiple Components)

1. **API endpoint discovery patterns** — Blocks Step 1 entirely
2. **Postman collection schema** — Blocks Step 5 entirely
3. **ADO YAML patterns** — Blocks Step 7 entirely

### Medium Priority

4. **Auth flow patterns** — Blocks Step 2
5. **Dynatrace export formats** — Blocks Step 3
6. **Failure classification** — Blocks Step 8

### Lower Priority (Can Build Incrementally)

7. **Tagging conventions** — Can start with basic patterns
8. **Test data strategies** — Can start with basic API seeding

---

## Sources Catalog

### Evaluation Pipeline

For sources currently being evaluated:

- **Stage 1 (README evaluation)**: See individual evaluations in `sources/possible-sources-to-utilize/[source-name]/evaluation.md`
- **Stage 2 (Prioritization)**: See consolidated rankings in [source-priority-index.md](source-priority-index.md)
- **Stage 3 (Full extraction)**: Documented below after extraction is complete

### Fully Extracted Sources

| Source | Date Added | MVP Steps Covered | Status | Location |
| ------ | ---------- | ----------------- | ------ | -------- |
| Claude Code Mastery V3 | 2026-01-16 | Architecture patterns | Integrated | `sources/claude-code-mastery-v3-extraction.md` |
| (Additional sources will be added here after Stage 3 extraction) | | | | |

**Note**: The staged research workflow (README → Priority → Full Extract) ensures we focus extraction efforts on highest-value sources. See CLAUDE.md Workflow section for details.

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

*Last Updated: 2026-01-16*
