# Skill-Creator Evaluation

## Source Overview

| Field | Value |
|-------|-------|
| **Name** | skill-creator |
| **Type** | Official Anthropic Skill |
| **Source** | anthropics/skills (official repo) |
| **URL** | https://github.com/anthropics/skills/tree/main/skills/skill-creator |
| **Files** | 7 files (SKILL.md, LICENSE.txt, 2 references, 3 scripts) |
| **Total Lines** | ~880 lines |

## Structure

```
skill-creator/
├── SKILL.md                    # Core skill documentation (357 lines)
├── LICENSE.txt
├── references/
│   ├── output-patterns.md      # Template and examples patterns (83 lines)
│   └── workflows.md            # Sequential and conditional workflows (28 lines)
└── scripts/
    ├── init_skill.py           # Initialize new skill (304 lines)
    ├── package_skill.py        # Package skill for distribution (111 lines)
    └── quick_validate.py       # Validate skill structure (95 lines)
```

## MVP Alignment

| Step | Alignment | Notes |
|------|-----------|-------|
| ALL | CRITICAL | Foundation for building all skills in qa-copilot |

**Priority: CRITICAL** - Official Anthropic patterns for skill creation

---

## Complete Pattern Extraction

### 1. Skill Definition

> "Skills are modular, self-contained packages that extend Claude's capabilities by providing specialized knowledge, workflows, and tools. Think of them as 'onboarding guides' for specific domains or tasks—they transform Claude from a general-purpose agent into a specialized agent equipped with procedural knowledge that no model can fully possess."

**What Skills Provide:**
1. Specialized workflows - Multi-step procedures for specific domains
2. Tool integrations - Instructions for working with specific file formats or APIs
3. Domain expertise - Company-specific knowledge, schemas, business logic
4. Bundled resources - Scripts, references, and assets for complex and repetitive tasks

### 2. Core Principles

#### Context Efficiency
> "The context window is a public good. Skills share the context window with everything else Claude needs: system prompt, conversation history, other Skills' metadata, and the actual user request."

**Default assumption: Claude is already very smart.** Only add context Claude doesn't already have.

Challenge each piece of information:
- "Does Claude really need this explanation?"
- "Does this paragraph justify its token cost?"

**Prefer concise examples over verbose explanations.**

#### Degrees of Freedom

Match specificity to task fragility:

| Freedom Level | Use Case | Format |
|---------------|----------|--------|
| **High** | Multiple approaches valid, decisions depend on context, heuristics guide approach | Text-based instructions |
| **Medium** | Preferred pattern exists, some variation acceptable, configuration affects behavior | Pseudocode or scripts with parameters |
| **Low** | Operations fragile/error-prone, consistency critical, specific sequence required | Specific scripts, few parameters |

> "Think of Claude as exploring a path: a narrow bridge with cliffs needs specific guardrails (low freedom), while an open field allows many routes (high freedom)."

### 3. Skill Anatomy

```
skill-name/
├── SKILL.md (required)
│   ├── YAML frontmatter metadata (required)
│   │   ├── name: (required)
│   │   └── description: (required)
│   └── Markdown instructions (required)
└── Bundled Resources (optional)
    ├── scripts/          - Executable code (Python/Bash/etc.)
    ├── references/       - Documentation loaded into context as needed
    └── assets/           - Files used in output (templates, icons, fonts, etc.)
```

#### SKILL.md Components

| Component | Purpose |
|-----------|---------|
| **Frontmatter (YAML)** | `name` and `description` fields - ONLY fields that Claude reads to determine when skill gets used |
| **Body (Markdown)** | Instructions and guidance - Only loaded AFTER skill triggers |

**Critical**: Description in frontmatter is the PRIMARY TRIGGERING MECHANISM.

#### Bundled Resources

| Folder | Purpose | When to Use |
|--------|---------|-------------|
| `scripts/` | Executable code for deterministic reliability | Same code rewritten repeatedly, deterministic reliability needed |
| `references/` | Documentation loaded into context as needed | Detailed documentation, schemas, API docs, domain knowledge |
| `assets/` | Files used in output (not loaded into context) | Templates, images, boilerplate code, fonts |

**Reference best practices:**
- Keep SKILL.md lean by moving detailed info to references
- If files >10k words, include grep search patterns in SKILL.md
- Information should live in EITHER SKILL.md OR references, not both

### 4. What NOT to Include

A skill should only contain essential files. Do NOT create:
- README.md
- INSTALLATION_GUIDE.md
- QUICK_REFERENCE.md
- CHANGELOG.md
- Any auxiliary documentation

> "The skill should only contain the information needed for an AI agent to do the job at hand."

### 5. Progressive Disclosure (3-Level Loading)

| Level | Content | Size Limit | Load Condition |
|-------|---------|------------|----------------|
| 1. Metadata | name + description | ~100 words | Always in context |
| 2. SKILL.md body | Instructions | <5k words / <500 lines | When skill triggers |
| 3. Bundled resources | Scripts, references, assets | Unlimited | As needed by Claude |

#### Progressive Disclosure Patterns

**Pattern 1: High-level guide with references**
```markdown
# PDF Processing

## Quick start
Extract text with pdfplumber:
[code example]

## Advanced features
- **Form filling**: See [FORMS.md](FORMS.md) for complete guide
- **API reference**: See [REFERENCE.md](REFERENCE.md) for all methods
```

**Pattern 2: Domain-specific organization**
```
bigquery-skill/
├── SKILL.md (overview and navigation)
└── reference/
    ├── finance.md (revenue, billing metrics)
    ├── sales.md (opportunities, pipeline)
    └── product.md (API usage, features)
```
When user asks about sales, Claude only reads sales.md.

**Pattern 3: Conditional details**
```markdown
## Creating documents
Use docx-js for new documents. See [DOCX-JS.md](DOCX-JS.md).

## Editing documents
For simple edits, modify the XML directly.
**For tracked changes**: See [REDLINING.md](REDLINING.md)
```

**Important guidelines:**
- **Avoid deeply nested references** - Keep references one level deep from SKILL.md
- **Structure longer reference files** - For files >100 lines, include TOC at top

### 6. Skill Creation Process (6 Steps)

1. **Understand** - Gather concrete examples of how skill will be used
2. **Plan** - Identify reusable resources (scripts, references, assets)
3. **Initialize** - Run `init_skill.py <skill-name> --path <output-directory>`
4. **Edit** - Implement resources and write SKILL.md
5. **Package** - Run `package_skill.py <path/to/skill-folder>`
6. **Iterate** - Refine based on real usage

### 7. Frontmatter Specification

**Required fields only:**
```yaml
---
name: skill-name
description: Complete explanation of what the skill does and when to use it
---
```

**Validation rules (from quick_validate.py):**
- `name`: Hyphen-case (lowercase letters, digits, hyphens), max 64 chars
- `description`: Max 1024 chars, no angle brackets (`<` or `>`)
- Allowed properties: `name`, `description`, `license`, `allowed-tools`, `metadata`

**Critical for description:**
- This is the PRIMARY TRIGGERING MECHANISM
- Include both what the skill does AND specific triggers/contexts
- Include ALL "when to use" information HERE - not in body
- Body is only loaded after triggering, so "When to Use This Skill" sections in body are not helpful

**Example description:**
> "Comprehensive document creation, editing, and analysis with support for tracked changes, comments, formatting preservation, and text extraction. Use when Claude needs to work with professional documents (.docx files) for: (1) Creating new documents, (2) Modifying or editing content, (3) Working with tracked changes, (4) Adding comments, or any other document tasks"

### 8. Writing Guidelines

- **Always use imperative/infinitive form**
- Include triggering context in frontmatter description, not body
- Keep references one level deep from SKILL.md
- Avoid auxiliary documentation
- Delete unused template files after initialization

---

## Output Patterns (from references/output-patterns.md)

### Template Pattern

**For strict requirements:**
```markdown
## Report structure

ALWAYS use this exact template structure:

# [Analysis Title]

## Executive summary
[One-paragraph overview of key findings]

## Key findings
- Finding 1 with supporting data
...
```

**For flexible guidance:**
```markdown
## Report structure

Here is a sensible default format, but use your best judgment:
...
Adjust sections as needed for the specific analysis type.
```

### Examples Pattern

Provide input/output pairs to clarify desired style:
```markdown
## Commit message format

**Example 1:**
Input: Added user authentication with JWT tokens
Output:
feat(auth): implement JWT-based authentication
Add login endpoint and token validation middleware
```

> "Examples help Claude understand the desired style and level of detail more clearly than descriptions alone."

---

## Workflow Patterns (from references/workflows.md)

### Sequential Workflows
```markdown
Filling a PDF form involves these steps:

1. Analyze the form (run analyze_form.py)
2. Create field mapping (edit fields.json)
3. Validate mapping (run validate_fields.py)
4. Fill the form (run fill_form.py)
5. Verify output (run verify_output.py)
```

### Conditional Workflows
```markdown
1. Determine the modification type:
   **Creating new content?** → Follow "Creation workflow" below
   **Editing existing content?** → Follow "Editing workflow" below

2. Creation workflow: [steps]
3. Editing workflow: [steps]
```

---

## Scripts Reference

### init_skill.py
- Creates skill directory with template SKILL.md
- Generates `scripts/`, `references/`, `assets/` with example files
- Template includes TODO placeholders and structure guidance
- **4 structure patterns**: Workflow-Based, Task-Based, Reference/Guidelines, Capabilities-Based

### quick_validate.py
- Validates YAML frontmatter format
- Checks name conventions (hyphen-case, max 64 chars)
- Checks description constraints (max 1024 chars, no angle brackets)
- Validates allowed properties

### package_skill.py
- Runs validation first
- Creates `.skill` file (zip format with .skill extension)
- Preserves directory structure

---

## Application to qa-copilot

### Skills to Build Using These Patterns

| Skill | Structure Pattern | References Needed |
|-------|-------------------|-------------------|
| `endpoint-discovery` | Domain-based (java-patterns.md, dotnet-patterns.md, js-ts-patterns.md) | Framework-specific patterns |
| `auth-patterns` | Domain-based (oauth.md, jwt.md, azure-ad.md) | Auth flow documentation |
| `dynatrace-analysis` | Task-Based (ingest, prioritize, query) | DQL reference |
| `postman-generation` | Workflow-Based (analyze → generate → validate) | Collection schema |
| `test-data-strategy` | Workflow-Based (discover → plan → seed → cleanup) | Faker patterns |
| `ado-pipeline-patterns` | Task-Based (newman, reporting, variables) | ADO YAML reference |
| `failure-triage` | Conditional (by failure type) | Classification matrix |

### Key Takeaways for qa-copilot Skills

1. **Frontmatter descriptions must include triggering context** for all 8 MVP steps
2. **Use domain-based organization** for tech-stack variations (Java/Spring, .NET, TypeScript)
3. **Keep SKILL.md under 500 lines** - move details to references/
4. **Include examples over explanations** - show expected outputs
5. **Match freedom level to task fragility** - Postman schema = low freedom, endpoint discovery = high freedom

---

## Relationship to plugin-dev

| Aspect | plugin-dev | skill-creator |
|--------|------------|---------------|
| Scope | Full plugin structure | Skill-specific patterns |
| Coverage | Agents, commands, hooks, skills | Skills only (deep dive) |
| Focus | Plugin.json, component organization | SKILL.md structure, progressive disclosure |
| Origin | Claude Code plugin system | Anthropic skills framework |

**Recommendation**: Extract both together as foundation:
- **plugin-dev** for overall qa-copilot plugin structure
- **skill-creator** for building individual skills within the plugin

---

## Summary

The skill-creator skill is the **official Anthropic reference** for building skills. With ~880 lines of comprehensive guidance, it provides:

1. **Canonical SKILL.md structure** with YAML frontmatter
2. **Progressive disclosure design** (3-level loading system)
3. **Context efficiency principles** for token management
4. **Degrees of freedom framework** for balancing flexibility vs. determinism
5. **Output patterns** (templates, examples)
6. **Workflow patterns** (sequential, conditional)
7. **Validation rules** and packaging workflow
8. **Anti-patterns** (what NOT to include)

This source is **CRITICAL** for building qa-copilot skills correctly and should be extracted alongside plugin-dev as the foundation layer.
