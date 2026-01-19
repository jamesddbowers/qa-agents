# Source Priority Index

**Purpose**: This document tracks README evaluations and prioritization decisions for external sources before committing to full extraction.

**Last Updated**: 2026-01-19

---

## Evaluation Status Summary

| Status | Count |
|--------|-------|
| Not Yet Reviewed | 0 |
| Evaluated | 36 |
| Queued for Extraction | 9 |
| Partially Extracted | 2 |
| Archived | 12 |

**Priority Distribution**:

- CRITICAL: 4 (2 extracted, 2 queued)
- HIGH: 7
- MEDIUM: 13
- LOW: 12

---

## Extraction Progress

| Source | Components Extracted | Remaining | Status |
|--------|---------------------|-----------|--------|
| **plugin-dev** | Agents (frontmatter, examples), Commands (YAML frontmatter), Hooks (PreToolUse, PostToolUse, Stop) | N/A | **Partially Extracted** |
| **skill-creator** | SKILL.md patterns (YAML frontmatter, progressive disclosure, references/ structure) | N/A | **Extracted** |

### Implementation Results

Based on plugin-dev and skill-creator extraction, the following qa-copilot components were created:

- **6 agents** with proper frontmatter and `<example>` blocks for triggering
- **6 commands** with YAML frontmatter and argument handling
- **8 skills** following SKILL.md patterns with references/ folders
- **4 hooks** (PreToolUse for Write/Read/Bash, Stop hook)

---

## CRITICAL Priority Sources

**Criteria**: Directly solves MVP blocking issues, must extract immediately

| Source Name | Type | MVP Steps | Key Patterns | Status |
|-------------|------|-----------|--------------|--------|
| **plugin-dev** | Official Plugin Dev Kit | ALL | Plugin structure, agent frontmatter, hooks, commands, skills | **EXTRACTED** |
| **skill-creator** | Official Anthropic Skill | ALL | SKILL.md structure, progressive disclosure, output/workflow patterns, context efficiency | **EXTRACTED** |
| **documate** | Full Plugin | 1, 2, 5 | Endpoint discovery (Spring Boot, ASP.NET), OpenAPI 3.0 generation, framework detection | Queued for Extraction |
| **claude-code-templates-components** | Agent Collection | 3, 8 | **dynatrace-expert.md** - Complete DQL reference, endpoint prioritization, observability patterns | Queued for Extraction |

### Extraction Priority Notes

1. ~~**plugin-dev** + **skill-creator**~~: ✅ **COMPLETE** - Patterns extracted and applied to create 6 agents, 6 commands, 8 skills, 4 hooks
2. **documate**: Solves Step 1 (endpoint inventory) AND provides OpenAPI generation patterns
3. **claude-code-templates-components**: The 851-line dynatrace-expert.md solves Step 3 completely

---

## HIGH Priority Sources

**Criteria**: Addresses specific MVP steps, high-quality patterns, should extract soon

| Source Name | Type | MVP Steps | Key Patterns | Status |
|-------------|------|-----------|--------------|--------|
| **clauditor** | Full Plugin | 8 | Diagnostics, failure triage, severity categorization, Java security patterns | Queued for Extraction |
| **testforge** | Full Plugin | 6 | Test categorization, AAA pattern, factory patterns for test data | Queued for Extraction |
| **api-testing-observability** | Full Plugin | 5, 6 | Dynamic data generation with Faker, scenario management, mock server patterns | Queued for Extraction |
| **logicscope** | Full Plugin | 1, 6 | Data flow tracing, domain/entity discovery, lifecycle state machine | Queued for Extraction |
| **dataforge** | Full Plugin | 6 | Schema generation from samples, type inference, validation patterns | Queued for Extraction |
| **backend-api-security-agents** | Agent Files | 2, 8 | OAuth/JWT/OIDC patterns, API security checklist, observability (mentions Dynatrace) | Queued for Extraction |
| **cicd-automation** | Skill/Agent Collection | 7 | Azure DevOps YAML, approval gates, post-deployment verification | Queued for Extraction |

### MVP Step Coverage Summary

| MVP Step | Primary Source | Supporting Sources |
|----------|----------------|-------------------|
| Step 1 (Endpoint Inventory) | **documate** | logicscope, backend-development |
| Step 2 (Auth Patterns) | **documate**, backend-api-security-agents | developer-essentials |
| Step 3 (Dynatrace) | **claude-code-templates-components** | backend-api-security-agents |
| Step 4 (Tagging) | (Derive from other sources) | - |
| Step 5 (Postman Collections) | **documate** (via OpenAPI) | api-testing-observability |
| Step 6 (Test Data) | **testforge**, dataforge | api-testing-observability, logicscope |
| Step 7 (ADO Pipelines) | **cicd-automation** | (need Newman-specific patterns) |
| Step 8 (Diagnostics) | **clauditor** | backend-api-security-agents |

---

## MEDIUM Priority Sources

**Criteria**: Useful patterns but not blocking, may address supplementary needs

| Source Name | Type | MVP Steps | Key Patterns | Notes |
|-------------|------|-----------|--------------|-------|
| compound-engineering | Full Plugin | General | Real-world multi-agent plugin, review agents, skill creation | Architecture reference |
| test-driven-development | Skill | 6 | Red-Green-Refactor cycle, verification checklist | TDD methodology |
| developer-essentials | Skills Collection | 2 | auth-implementation-patterns skill | Check for auth patterns |
| backend-development | Full Plugin | 1 | api-design skill | Check for endpoint patterns |
| documentation-generation | Full Plugin | 1, 5 | openapi-spec-generation skill | OpenAPI generation |
| tdd-workflows | Agents/Commands | 6 | TDD workflow commands | Workflow patterns |
| security-guidance | Plugin with Hooks | General | Security hooks examples | Guardrail patterns |
| application-performance | Agents/Command | 3, 8 | observability-engineer agent | Check for patterns |
| agent-sdk-dev | Official Plugin | General | Verifier report format, interactive commands | Pattern reference |
| pr-review-toolkit | Full Plugin | General | Agent triggering with examples, confidence scoring | Pattern reference |
| code-review | Full Plugin | General | Multi-agent parallel, false positive filtering | Architecture reference |
| unit-testing | Agents/Command | 6 | Test generation patterns | Different focus (unit vs API) |
| tdd-workflows | Agents/Commands | 6 | Red-Green-Refactor commands | Workflow patterns |

---

## LOW Priority / Archive

**Criteria**: Not relevant to MVP, Phase 2+ features, or different focus

| Source Name | Type | Why Low | Future Phase |
|-------------|------|---------|--------------|
| code-simplifier | Single Agent | Code refactoring, not QA | - |
| claude-flow-plugin | Enterprise Plugin | Over-engineered (150+ commands), GitHub-only | - |
| webapp-testing | Skill | Playwright/browser testing | Phase 2+ |
| accessibility-compliance | Plugin | Accessibility testing | - |
| agent-browser | Full Project | Browser automation | Phase 2+ |
| agent-orchestration | Agents/Commands | Basic orchestration | - |
| codebase-cleanup | Agents/Commands | Code cleanup | - |
| code-documentation | Agents/Commands | Documentation | - |
| performance-testing-review | Agents/Commands | Performance review | Phase 5 (k6) |
| reverse-engineering | Agents/Skills | Binary/malware analysis | - |
| security-compliance | Agent/Command | Security compliance | - |
| security-scanning | Full Plugin | Security scanning | - |

---

## Extraction Order

Based on MVP step blocking and value:

### Immediate Extraction (Block MVP)

1. ~~**plugin-dev** + **skill-creator**~~ ✅ **COMPLETE** → Created qa-copilot foundation (6 agents, 6 commands, 8 skills, 4 hooks)
2. **documate** → Step 1 (endpoints) + Step 5 (OpenAPI) - **NEXT**
3. **claude-code-templates-components/dynatrace-expert.md** → Step 3 (Dynatrace)

### Second Wave (High Value)

4. **clauditor** → Step 8 (diagnostics)
5. **testforge** → Step 6 (test strategy)
6. **cicd-automation** → Step 7 (Azure DevOps)
7. **backend-api-security-agents** → Step 2 (auth patterns)

### Third Wave (Supporting)

8. **api-testing-observability** → Step 5, 6 (test generation)
9. **logicscope** → Step 1, 6 (data flow)
10. **dataforge** → Step 6 (test data)

---

## Gaps Still Requiring Research

After all 35 evaluations:

| Gap | Status | Best Source | Notes |
|-----|--------|-------------|-------|
| Newman pipeline patterns | PARTIAL | cicd-automation | Has ADO but not Newman-specific |
| Postman schema reference | NOT FOUND | None | Need official Postman docs |
| Test result publishing to ADO | NOT FOUND | None | Need ADO-specific patterns |
| ADO variable groups | NOT FOUND | None | Need ADO-specific patterns |

### Actions Needed

1. **Newman in ADO**: Add Postman/Newman official docs as source
2. **ADO Test Results**: Reference Azure DevOps documentation
3. **Postman Collection Schema**: Reference Postman official schema

---

## Source Type Statistics

| Type | Count |
|------|-------|
| Full Plugins | 12 |
| Plugin Dev Kits | 2 |
| Official Anthropic Skills | 1 |
| Agent Collections | 5 |
| Skills Collections | 6 |
| Agents + Commands | 10 |

---

*Last Updated: 2026-01-19*
*Total Sources Evaluated: 36*
