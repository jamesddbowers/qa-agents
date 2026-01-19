# [Source Name] - README Evaluation

**Evaluation Date**: YYYY-MM-DD
**Evaluator**: [Your name or "Claude"]
**Source Location**: `research/sources/possible-sources-to-utilize/[source-name]/`

---

## 1. Source Metadata

| Field | Value |
|-------|-------|
| Source Name | |
| Source Type | Agent / Plugin / Skill / Guide / Tool / Other |
| Repository URL | |
| License | |
| Last Updated | |
| Tech Stack | Java/Spring, .NET, TypeScript, Python, Other |

---

## 2. Quick Summary

[1-3 paragraph overview of what this source does and what problems it solves]

---

## 3. QA Applicability Assessment

| Criterion | Rating | Notes |
|-----------|--------|-------|
| QA Focus | QA-Specific / Adaptable / General Dev / Not Relevant | [Brief explanation] |
| API Testing Relevance | High / Medium / Low | [Why?] |
| Tech Stack Match | Full Match / Partial / No Match | [Which stacks: Java/Spring, .NET, TypeScript?] |
| CI/CD Integration | Yes / Mentioned / No | [ADO, GitHub Actions, other?] |

---

## 4. MVP Step Relevance

Check which of the 8 MVP steps this source could support:

| MVP Step | Relevant? | Potential Contribution |
|----------|-----------|------------------------|
| 1. Endpoint Inventory | ☐ Yes ☐ No | [What patterns/techniques?] |
| 2. Auth Discovery | ☐ Yes ☐ No | [What patterns/techniques?] |
| 3. Telemetry/Prioritization | ☐ Yes ☐ No | [What patterns/techniques?] |
| 4. Tagging Conventions | ☐ Yes ☐ No | [What patterns/techniques?] |
| 5. Postman Generation | ☐ Yes ☐ No | [What patterns/techniques?] |
| 6. Test Data Strategy | ☐ Yes ☐ No | [What patterns/techniques?] |
| 7. ADO Pipelines | ☐ Yes ☐ No | [What patterns/techniques?] |
| 8. Diagnostics/Triage | ☐ Yes ☐ No | [What patterns/techniques?] |

**Summary**: Supports [X] of 8 MVP steps

---

## 5. Agent/Skill/Command Potential

### Potential Agents

- [List any agents this could help build, e.g., "API Surface Extraction Agent"]
- [Include brief note on what patterns it provides]

### Potential Skills

- [List any skills this could help create]
- [Progressive disclosure opportunities?]

### Potential Commands

- [List any user-invocable commands this could enable]

### Key Patterns Identified

1. [Pattern 1, e.g., "Endpoint discovery via AST parsing"]
2. [Pattern 2, e.g., "OAuth token flow automation"]
3. [Pattern 3, etc.]

---

## 6. Human-in-the-Loop Alignment

| Criterion | Assessment | Notes |
|-----------|------------|-------|
| Respects read-only principle? | ☐ Yes ☐ No ☐ Adaptable | [Does it modify source code?] |
| Permission-seeking behavior? | ☐ Yes ☐ No ☐ Unclear | [Does it ask before actions?] |
| Safe output locations? | ☐ Yes ☐ No ☐ N/A | [Where does it write?] |
| Confidence/explainability? | ☐ Strong ☐ Weak ☐ None | [Source pointers, confidence levels?] |

**Red Flags**: [Any violations of qa-copilot guardrails?]

---

## 7. Priority Recommendation

**Priority**: ☐ High ☐ Medium ☐ Low

**Justification**:

[Explain why this priority based on:

- Addresses high-priority gaps from gap-tracker.md?
- Unique patterns not available elsewhere?
- Quality of patterns (clear, actionable, transferable)?
- Alignment with Phase 1 MVP goals?]

**Decision**: ☐ Extract Fully ☐ Archive for Later Phase ☐ Discard

---

## 8. Questions/Uncertainties

[List any questions that would need to be answered during full extraction:

- Unclear aspects of the approach
- Potential adaptation challenges
- Missing information needed]

---

## 9. Next Actions

- [ ] Add to source-priority-index.md
- [ ] Request full repo if High priority
- [ ] Archive README if Low priority
- [ ] Follow up on questions if Medium priority

---

**Notes**: [Any additional observations]
