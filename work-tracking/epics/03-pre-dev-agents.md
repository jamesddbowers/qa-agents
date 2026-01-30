# Epic 03: Pre-Dev Agents

## Objective

Build agents for repo analysis and documentation generation. These run first against each repo to extract all possible information and produce the documentation foundation.

## Relationships

- **QA Workflow Reference**: `docs/qa-workflow/02-pre-development.md` — defines the deliverables these agents must produce (test case documentation, early environment setup)
- **Agent Architecture**: `docs/agent-architecture.md` — section "Pre-Dev Agents" — defines each agent's inputs, outputs, schemas, and chaining
- **Upstream Epic**: Epic 02 (QA Workflow Doc) — completed; provides the "why" for each agent
- **Downstream Epic**: Epic 04 (Dev Agents) — consumes this epic's JSON outputs (repo-profile, endpoint-inventory, auth-profile, data-model, dependency-map, gap-report)
- **Existing qa-copilot agents to absorb**: `qa-copilot/agents/endpoint-discoverer.md` → api-surface-extractor; `qa-copilot/agents/auth-analyzer.md` → auth-flow-analyzer
- **Output Location**: `qa-sdlc-agents/agents/pre-dev/`

## Agents (8)

### Story 3.1: repo-scanner
- [x] Define agent purpose, inputs, outputs, triggering conditions
- [x] Acquire knowledge: framework detection patterns (Java/Spring, .NET, Node, Python)
- [x] Create references/ with framework-specific patterns
- [x] Define repo-profile.json output schema
- [x] Build agent .md
- [x] Test against real repo

### Story 3.2: api-surface-extractor
- [x] Define agent (consumes repo-profile.json)
- [x] Acquire knowledge: endpoint discovery patterns per framework
- [x] Create references/
- [x] Define endpoint-inventory.json output schema
- [x] Build agent .md
- [x] Test against real repo

### Story 3.3: auth-flow-analyzer
- [x] Define agent (consumes repo + endpoint-inventory)
- [x] Acquire knowledge: auth patterns (JWT, OAuth, API key, Azure AD)
- [x] Create references/
- [x] Define auth-profile.json output schema
- [x] Build agent .md
- [x] Test against real repo

### Story 3.4: data-model-mapper
- [x] Define agent (consumes repo + repo-profile)
- [x] Acquire knowledge: ORM patterns, SQL migrations, schema extraction
- [x] Create references/
- [x] Define data-model.json output schema
- [x] Build agent .md
- [x] Test against real repo

### Story 3.5: dependency-tracer
- [x] Define agent (consumes repo + repo-profile)
- [x] Acquire knowledge: inter-service call patterns, message queues, external APIs
- [x] Create references/
- [x] Define dependency-map.json output schema
- [x] Build agent .md
- [x] Test against real repo

### Story 3.6: doc-generator
- [x] Define agent (consumes all upstream outputs)
- [x] Acquire knowledge: Mermaid diagram syntax, architecture doc patterns
- [x] Create references/
- [x] Define output structure (architecture overview, sequence diagrams, flow diagrams)
- [x] Build agent .md
- [x] Test against real repo

### Story 3.7: gap-analyzer
- [x] Define agent (consumes repo + all upstream outputs)
- [x] Acquire knowledge: test coverage analysis, documentation completeness checks
- [x] Create references/
- [x] Define gap-report.json output schema
- [x] Build agent .md
- [x] Test against real repo

### Story 3.8: test-plan-scaffolder
- [x] Define agent (consumes endpoint-inventory + gap-report + data-model)
- [x] Acquire knowledge: ADO Test Plans API, feature-based test suite organization
- [x] Create references/ (including ADO Test Plans patterns)
- [x] Define output format (CSV/JSON for ADO import)
- [x] Build agent .md
- [x] Test against real repo

## Build Order
1. repo-scanner (first — foundation)
2. api-surface-extractor, auth-flow-analyzer, data-model-mapper, dependency-tracer (parallel)
3. doc-generator, gap-analyzer (consume upstream)
4. test-plan-scaffolder (last — needs gap-report + data-model)
