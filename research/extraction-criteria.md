# Extraction Criteria

This document defines what to extract from each type of external source when analyzing for qa-copilot integration.

## By Source Type

### Agents

**Always Extract:**

- System prompt / persona definition
- Tool restrictions (allowed/disallowed tools)
- Permission mode (if specified)
- Decision logic (when to delegate, when to act)
- Output format specifications

**Extract If Present:**

- Multi-step workflow patterns
- Error handling approaches
- Fallback behaviors
- Integration with other agents

### Skills

**Always Extract:**

- SKILL.md frontmatter (name, description, allowed-tools)
- Core instructions (the main guidance)
- Trigger phrases (what activates the skill)
- Progressive disclosure structure (how content is staged)

**Extract If Present:**

- Reference file patterns (how they structure supporting docs)
- Script helpers
- Example usage patterns

### Commands

**Always Extract:**

- Frontmatter (description, argument-hint, allowed-tools, model)
- Argument handling patterns ($ARGUMENTS, $1, $2, etc.)
- Output expectations

**Extract If Present:**

- Multi-step execution patterns
- User interaction patterns
- Error messaging

### Prompts (Standalone)

**Always Extract:**

- Core instruction structure
- Variable placeholders
- Output format requirements
- Confidence/explainability patterns

**Extract If Present:**

- Chain-of-thought guidance
- Verification steps
- Edge case handling

### Plugins (Full)

**Always Extract:**

- plugin.json structure
- Directory organization
- Component relationships (how agents/skills/commands interact)
- Hook configurations

**Extract If Present:**

- MCP server configurations
- Settings patterns
- README documentation style

### Guides/Documentation

**Always Extract:**

- Best practices and anti-patterns
- Configuration examples
- Architecture patterns

**Extract If Present:**

- Troubleshooting guidance
- Performance optimization tips
- Security considerations

## By MVP Step

### Step 1: Endpoint Inventory

**Priority Extractions:**

- Java annotation patterns (Spring Boot, JAX-RS)
- TypeScript/JavaScript route patterns (Express, Fastify, NestJS)
- .NET attribute patterns (ASP.NET Core)
- OpenAPI generation approaches
- Confidence scoring methodologies

### Step 2: Auth Discovery

**Priority Extractions:**

- OAuth 2.0 flow detection patterns
- JWT handling patterns
- Azure AD / Entra ID integration patterns
- Postman pre-request script templates for auth
- Token refresh strategies

### Step 3: Telemetry/Prioritization

**Priority Extractions:**

- Dynatrace export format specifications
- Metric parsing patterns (volume, errors, latency)
- Prioritization algorithms
- Report generation templates

### Step 4: Tagging Conventions

**Priority Extractions:**

- Smoke test criteria definitions
- Regression test scoping patterns
- Postman/Newman tag filtering syntax
- Suite composition logic

### Step 5: Postman Generation

**Priority Extractions:**

- Postman Collection v2.1 schema patterns
- Assertion templates (pm.test, pm.expect)
- Request chaining patterns
- Environment variable management
- Pre-request script templates

### Step 6: Test Data Strategy

**Priority Extractions:**

- API-based seeding patterns
- Namespace/isolation strategies
- Cleanup/teardown approaches
- Data dependency mapping

### Step 7: ADO Pipelines

**Priority Extractions:**

- Azure DevOps YAML schema patterns
- Newman task configurations
- JUnit/HTML report publishing
- Pipeline variable management
- Stage/job/step organization

### Step 8: Diagnostics/Triage

**Priority Extractions:**

- Failure classification taxonomies (auth/data/env/product/test)
- Reproduction step generation patterns
- Trace ID correlation approaches
- Newman output parsing

## Quality Criteria

### Must Have

- [ ] Clear, actionable instructions
- [ ] Explicit tool usage (not vague)
- [ ] Defined output format
- [ ] Applicable to our tech stack (Java, .NET, TS)

### Nice to Have

- [ ] Confidence level methodology
- [ ] Source pointer patterns
- [ ] Error handling guidance
- [ ] Progressive disclosure structure

### Red Flags (Don't Extract)

- Overly generic instructions that could apply to anything
- Hardcoded values specific to another project
- Deprecated API patterns
- Patterns that violate our human-in-the-loop guardrails

## Integration Checklist

After extraction, verify:

- [ ] Pattern fits qa-copilot's operating principles
- [ ] No conflicts with existing patterns
- [ ] Clear mapping to specific agent/skill/command
- [ ] Documented in research-template.md
- [ ] Non-MVP items archived to backlog/
