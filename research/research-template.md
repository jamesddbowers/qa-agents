# Research Source Template

Use this template to catalog each external source (agent, plugin, prompt, skill) that is analyzed.

---

## Source: [Name]

### Metadata

| Field | Value |
| ----- | ----- |
| **Source URL** | |
| **Type** | (agent / skill / command / prompt / plugin / guide) |
| **Date Found** | YYYY-MM-DD |
| **Author/Origin** | |
| **License** | |

### Summary

Brief description of what this source does and its intended use case.

### MVP Relevance

| MVP Step | Relevant? | Notes |
| -------- | --------- | ----- |
| 1. Endpoint Inventory | Yes/No | |
| 2. Auth Discovery | Yes/No | |
| 3. Telemetry/Prioritization | Yes/No | |
| 4. Tagging Conventions | Yes/No | |
| 5. Postman Generation | Yes/No | |
| 6. Test Data Strategy | Yes/No | |
| 7. ADO Pipelines | Yes/No | |
| 8. Diagnostics/Triage | Yes/No | |

### Patterns Extracted

#### Prompts/Instructions

```markdown
<!-- Copy relevant prompt patterns here -->
```

#### Tool Usage Patterns

- Tools used:
- Tool restrictions:
- Interesting patterns:

#### Output Formats

- Output files generated:
- Schema/structure notes:

#### Confidence/Explainability Approach

How does this source handle confidence levels and source pointers?

### Integration Decisions

| Decision | Applied To | Notes |
| -------- | ---------- | ----- |
| | | |

### Backlog Items

Patterns not relevant to MVP but useful for later phases:

| Pattern | Future Phase | Notes |
| ------- | ------------ | ----- |
| | | |

### Raw Content Archive

Location: `research/sources/[source-name]/`

---

## Example Entry

## Source: awesome-qa-agent

### Metadata

| Field | Value |
| ----- | ----- |
| **Source URL** | https://github.com/example/awesome-qa-agent |
| **Type** | agent |
| **Date Found** | 2026-01-16 |
| **Author/Origin** | Example Corp |
| **License** | MIT |

### Summary

An agent that discovers API endpoints in Spring Boot applications and generates OpenAPI specs.

### MVP Relevance

| MVP Step | Relevant? | Notes |
| -------- | --------- | ----- |
| 1. Endpoint Inventory | Yes | Core functionality matches |
| 2. Auth Discovery | Partial | Has basic auth detection |
| 3. Telemetry/Prioritization | No | |
| 4. Tagging Conventions | No | |
| 5. Postman Generation | No | |
| 6. Test Data Strategy | No | |
| 7. ADO Pipelines | No | |
| 8. Diagnostics/Triage | No | |

### Patterns Extracted

#### Prompts/Instructions

```markdown
When analyzing a Spring Boot application:
1. Search for @RestController and @Controller annotations
2. Extract @RequestMapping, @GetMapping, @PostMapping paths
3. Note @PathVariable and @RequestParam parameters
4. Check for @PreAuthorize security annotations
```

#### Tool Usage Patterns

- Tools used: Read, Grep, Glob
- Tool restrictions: Read-only, no Bash
- Interesting patterns: Uses Glob to find all Java files first, then Grep for annotations

#### Output Formats

- Output files: `api-inventory.json`, `api-inventory.md`
- Schema: `{endpoints: [{method, path, controller, params, auth}]}`

### Integration Decisions

| Decision | Applied To | Notes |
| -------- | ---------- | ----- |
| Use annotation-based search | endpoint-discovery skill | Adapt for our confidence levels |
| JSON + MD dual output | api-catalog outputs | Good pattern to follow |

### Backlog Items

| Pattern | Future Phase | Notes |
| ------- | ------------ | ----- |
| GraphQL schema parsing | Phase 2+ | Not MVP priority |
