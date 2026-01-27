# QA-Copilot Test Plan

**Version**: 1.0
**Created**: 2026-01-19
**Last Updated**: 2026-01-19
**Status**: In Progress

---

## Test Summary Dashboard

| Category | Total | Passed | Failed | Blocked | Not Run |
|----------|-------|--------|--------|---------|---------|
| Commands | 6 | 0 | 0 | 0 | 6 |
| Skills | 8 | 0 | 0 | 0 | 8 |
| Agents | 6 | 0 | 0 | 0 | 6 |
| Hooks | 4 | 0 | 0 | 0 | 4 |
| **TOTAL** | **24** | **0** | **0** | **0** | **24** |

---

## Defect Log

| ID | Test Case | Severity | Description | Status | Resolution | Fixed In |
|----|-----------|----------|-------------|--------|------------|----------|
| - | - | - | No defects logged yet | - | - | - |

**Severity Levels**: Critical, High, Medium, Low
**Status Values**: Open, In Progress, Fixed, Verified, Won't Fix

---

## Test Execution Log

| Date | Tester | Test Cases Run | Pass | Fail | Notes |
|------|--------|----------------|------|------|-------|
| - | - | - | - | - | Testing not yet started |

---

## Commands Test Cases (6)

### CMD-01: /discover-endpoints

| Field | Value |
|-------|-------|
| **Command** | `/discover-endpoints [path]` |
| **Description** | Discover API endpoints and build inventory |
| **Prerequisites** | A codebase with REST endpoints (Java/Spring, .NET, Node.js, or Python) |
| **Test Input** | Point at a sample codebase directory |
| **Expected Output** | - Endpoint inventory markdown file in `qa-agent-output/`<br>- Lists all discovered endpoints<br>- Shows HTTP methods, paths, and detected auth requirements<br>- Includes confidence levels |
| **Status** | ⬜ Not Run |
| **Result** | - |
| **Notes** | - |

---

### CMD-02: /analyze-auth

| Field | Value |
|-------|-------|
| **Command** | `/analyze-auth [path]` |
| **Description** | Analyze authentication patterns for API testing |
| **Prerequisites** | A codebase with authentication implementation |
| **Test Input** | Point at a sample codebase directory |
| **Expected Output** | - Auth analysis markdown in `qa-agent-output/`<br>- Identifies auth type (OAuth, JWT, API Key, etc.)<br>- Documents token acquisition approach<br>- Provides test configuration recommendations |
| **Status** | ⬜ Not Run |
| **Result** | - |
| **Notes** | - |

---

### CMD-03: /analyze-traffic

| Field | Value |
|-------|-------|
| **Command** | `/analyze-traffic [file]` |
| **Description** | Analyze API traffic data to prioritize test coverage |
| **Prerequisites** | Traffic data file (CSV or JSON from Dynatrace/APM) |
| **Test Input** | `test-fixtures/sample-traffic.csv` |
| **Expected Output** | - Traffic analysis with endpoint prioritization<br>- Identifies high-traffic endpoints<br>- Flags endpoints with high error rates<br>- Recommends smoke test candidates |
| **Status** | ⬜ Not Run |
| **Result** | - |
| **Notes** | - |

---

### CMD-04: /generate-collection

| Field | Value |
|-------|-------|
| **Command** | `/generate-collection [type: smoke\|regression\|full]` |
| **Description** | Generate a Postman collection for API testing |
| **Prerequisites** | Endpoint inventory exists (from CMD-01) |
| **Test Input** | `smoke` |
| **Expected Output** | - Postman collection JSON in `postman/`<br>- Valid Postman v2.1 format<br>- Includes test scripts with assertions<br>- Environment variable placeholders |
| **Status** | ⬜ Not Run |
| **Result** | - |
| **Notes** | - |

---

### CMD-05: /generate-pipeline

| Field | Value |
|-------|-------|
| **Command** | `/generate-pipeline [type: smoke\|regression\|scheduled]` |
| **Description** | Generate Azure DevOps pipeline for Newman test execution |
| **Prerequisites** | Postman collection exists (from CMD-04) |
| **Test Input** | `smoke` |
| **Expected Output** | - ADO YAML pipeline in `ado/`<br>- Valid Azure DevOps YAML syntax<br>- Newman execution configured<br>- Test result publishing configured<br>- Variable group references |
| **Status** | ⬜ Not Run |
| **Result** | - |
| **Notes** | - |

---

### CMD-06: /diagnose

| Field | Value |
|-------|-------|
| **Command** | `/diagnose [results-file-or-folder]` |
| **Description** | Diagnose and triage API test failures |
| **Prerequisites** | Newman test results (JSON or JUnit XML) |
| **Test Input** | `test-fixtures/newman-failure-output.json` |
| **Expected Output** | - Failure classification (auth, server error, assertion, etc.)<br>- Root cause analysis<br>- Remediation recommendations<br>- Priority ranking of issues |
| **Status** | ⬜ Not Run |
| **Result** | - |
| **Notes** | - |

---

## Skills Test Cases (8)

### SKL-01: endpoint-discovery

| Field | Value |
|-------|-------|
| **Skill** | endpoint-discovery |
| **Trigger Phrase** | "How do I find REST endpoints in Spring Boot?" |
| **Expected Behavior** | - Loads endpoint-discovery skill<br>- Provides Java/Spring patterns (@RestController, @RequestMapping)<br>- May reference `references/java-patterns.md` |
| **Status** | ⬜ Not Run |
| **Result** | - |
| **Notes** | - |

---

### SKL-02: auth-patterns

| Field | Value |
|-------|-------|
| **Skill** | auth-patterns |
| **Trigger Phrase** | "What OAuth flow should I use for API testing?" |
| **Expected Behavior** | - Loads auth-patterns skill<br>- Explains client_credentials flow for machine-to-machine<br>- Provides token acquisition patterns |
| **Status** | ⬜ Not Run |
| **Result** | - |
| **Notes** | - |

---

### SKL-03: dynatrace-analysis

| Field | Value |
|-------|-------|
| **Skill** | dynatrace-analysis |
| **Trigger Phrase** | "How do I prioritize endpoints from Dynatrace data?" |
| **Expected Behavior** | - Loads dynatrace-analysis skill<br>- Provides DQL query patterns<br>- Explains prioritization based on traffic, errors, latency |
| **Status** | ⬜ Not Run |
| **Result** | - |
| **Notes** | - |

---

### SKL-04: test-tagging

| Field | Value |
|-------|-------|
| **Skill** | test-tagging |
| **Trigger Phrase** | "How should I tag smoke vs regression tests?" |
| **Expected Behavior** | - Loads test-tagging skill<br>- Explains tagging conventions<br>- Describes smoke vs regression criteria |
| **Status** | ⬜ Not Run |
| **Result** | - |
| **Notes** | - |

---

### SKL-05: postman-generation

| Field | Value |
|-------|-------|
| **Skill** | postman-generation |
| **Trigger Phrase** | "What assertions should I add to Postman tests?" |
| **Expected Behavior** | - Loads postman-generation skill<br>- Provides pm.test() and pm.expect() patterns<br>- Shows status code, schema, and response validation examples |
| **Status** | ⬜ Not Run |
| **Result** | - |
| **Notes** | - |

---

### SKL-06: test-data-planning

| Field | Value |
|-------|-------|
| **Skill** | test-data-planning |
| **Trigger Phrase** | "How do I seed test data for API tests?" |
| **Expected Behavior** | - Loads test-data-planning skill<br>- Explains seeding strategies (API, DB, fixtures)<br>- Provides Faker patterns for dynamic data |
| **Status** | ⬜ Not Run |
| **Result** | - |
| **Notes** | - |

---

### SKL-07: ado-pipeline-patterns

| Field | Value |
|-------|-------|
| **Skill** | ado-pipeline-patterns |
| **Trigger Phrase** | "How do I run Newman in Azure DevOps?" |
| **Expected Behavior** | - Loads ado-pipeline-patterns skill<br>- Provides Newman task YAML patterns<br>- Shows test result publishing configuration |
| **Status** | ⬜ Not Run |
| **Result** | - |
| **Notes** | - |

---

### SKL-08: failure-triage

| Field | Value |
|-------|-------|
| **Skill** | failure-triage |
| **Trigger Phrase** | "How do I classify a 401 test failure?" |
| **Expected Behavior** | - Loads failure-triage skill<br>- Provides classification matrix (auth, server, client, assertion)<br>- Explains 401 specifically as auth failure with remediation |
| **Status** | ⬜ Not Run |
| **Result** | - |
| **Notes** | - |

---

## Agents Test Cases (6)

### AGT-01: endpoint-discoverer

| Field | Value |
|-------|-------|
| **Agent** | endpoint-discoverer |
| **Trigger Scenario** | "Help me discover all API endpoints in this project" |
| **Expected Behavior** | - Agent activates (may see cyan color indicator)<br>- Analyzes codebase using Read, Grep, Glob tools<br>- Produces endpoint inventory in `qa-agent-output/`<br>- Asks permission before writing |
| **Status** | ⬜ Not Run |
| **Result** | - |
| **Notes** | - |

---

### AGT-02: auth-analyzer

| Field | Value |
|-------|-------|
| **Agent** | auth-analyzer |
| **Trigger Scenario** | "Analyze the authentication in this codebase for QA testing" |
| **Expected Behavior** | - Agent activates (yellow color)<br>- Searches for auth configuration and middleware<br>- Documents auth patterns for testing<br>- Provides token acquisition recommendations |
| **Status** | ⬜ Not Run |
| **Result** | - |
| **Notes** | - |

---

### AGT-03: traffic-analyzer

| Field | Value |
|-------|-------|
| **Agent** | traffic-analyzer |
| **Trigger Scenario** | "I have a Dynatrace export, help me prioritize which endpoints to test" |
| **Expected Behavior** | - Agent activates (magenta color)<br>- Reads traffic data file<br>- Ranks endpoints by importance<br>- Suggests smoke test candidates |
| **Status** | ⬜ Not Run |
| **Result** | - |
| **Notes** | - |

---

### AGT-04: collection-generator

| Field | Value |
|-------|-------|
| **Agent** | collection-generator |
| **Trigger Scenario** | "Generate a Postman collection for smoke testing based on the endpoints we found" |
| **Expected Behavior** | - Agent activates (green color)<br>- Reads endpoint inventory<br>- Creates Postman collection with test scripts<br>- Asks permission before writing to `postman/` |
| **Status** | ⬜ Not Run |
| **Result** | - |
| **Notes** | - |

---

### AGT-05: pipeline-generator

| Field | Value |
|-------|-------|
| **Agent** | pipeline-generator |
| **Trigger Scenario** | "Create an Azure DevOps pipeline to run our Newman tests" |
| **Expected Behavior** | - Agent activates (blue color)<br>- Creates ADO YAML pipeline<br>- Configures Newman execution and reporting<br>- Asks permission before writing to `ado/` |
| **Status** | ⬜ Not Run |
| **Result** | - |
| **Notes** | - |

---

### AGT-06: diagnostics-agent

| Field | Value |
|-------|-------|
| **Agent** | diagnostics-agent |
| **Trigger Scenario** | "My Newman tests are failing, help me diagnose and fix them" |
| **Expected Behavior** | - Agent activates (red color)<br>- Reads failure output<br>- Classifies failures by type<br>- Provides remediation steps |
| **Status** | ⬜ Not Run |
| **Result** | - |
| **Notes** | - |

---

## Hooks Test Cases (4)

### HK-01: PreToolUse:Write

| Field | Value |
|-------|-------|
| **Hook** | PreToolUse (Write\|Edit) |
| **Trigger Action** | Attempt to write a file to an unauthorized location (e.g., `src/app.js`) |
| **Expected Behavior** | - Hook activates<br>- Prompts/warns about non-allowed location<br>- May block or require confirmation |
| **Status** | ⬜ Not Run |
| **Result** | - |
| **Notes** | - |

---

### HK-02: PreToolUse:Read

| Field | Value |
|-------|-------|
| **Hook** | PreToolUse (Read) |
| **Trigger Action** | Attempt to read a sensitive file (e.g., `.env` or `secrets.json`) |
| **Expected Behavior** | - Hook activates<br>- Prompts for confirmation before reading<br>- Warns about sensitive file access |
| **Status** | ⬜ Not Run |
| **Result** | - |
| **Notes** | - |

---

### HK-03: PreToolUse:Bash

| Field | Value |
|-------|-------|
| **Hook** | PreToolUse (Bash) |
| **Trigger Action** | Attempt to run a destructive command (e.g., something with `rm -rf`) |
| **Expected Behavior** | - Hook activates<br>- Blocks or warns about destructive command<br>- May require explicit confirmation |
| **Status** | ⬜ Not Run |
| **Result** | - |
| **Notes** | - |

---

### HK-04: Stop

| Field | Value |
|-------|-------|
| **Hook** | Stop |
| **Trigger Action** | Complete a QA-related task |
| **Expected Behavior** | - Hook activates at task completion<br>- Reminds about secret safety<br>- Verifies no credentials in output |
| **Status** | ⬜ Not Run |
| **Result** | - |
| **Notes** | - |

---

## VS Code GitHub Copilot Version (qa-copilot-vscode)

The `qa-copilot-vscode/` folder contains a port of qa-copilot to VS Code GitHub Copilot format.

### VS Code Prerequisites

- VS Code 1.102+ (for full agent and skill support)
- GitHub Copilot extension with active subscription
- Enable these settings:

```json
{
  "github.copilot.chat.codeGeneration.useInstructionFiles": true,
  "chat.promptFiles": true
}
```

### VS Code File Formats (Corrected 2026-01-27)

| Component | Format | Key Fields |
|-----------|--------|------------|
| Prompts | `.github/prompts/*.prompt.md` | `agent: 'agent'` (NOT `mode: agent`) |
| Agents | `.github/agents/*.agent.md` | NO `mode` field |
| Skills | `.github/skills/*/SKILL.md` | `name`, `description`, references |
| Custom Instructions | `.github/copilot-instructions.md` | Project-wide guidelines |

### VS Code Invocation

| Component | How to Invoke |
|-----------|---------------|
| Prompts | `/prompt-name` in chat |
| Agents | `@agent-name` in chat |
| Skills | Loaded automatically based on context |

---

## Test Data & Fixtures

### Required Test Fixtures

| Fixture | Location | Status | Description |
|---------|----------|--------|-------------|
| Sample API Codebase | User-provided | ⬜ User to provide | REST API code for endpoint discovery |
| Sample Traffic Data | `test-fixtures/sample-traffic.csv` | ✅ Created | Dynatrace-style traffic export (22 endpoints) |
| Newman Failure Output | `test-fixtures/newman-failure-output.json` | ✅ Created | Sample test failures (4 failures: 401, 500, assertion, timeout) |

---

## Testing Workflow

### How to Execute Tests

1. **Start a new Claude Code session** (or use current one with plugin loaded)
2. **Verify plugin is loaded**: Type `/` and confirm qa-copilot commands appear
3. **Run each test case** following the test input specified
4. **Capture output** and provide it for verification
5. **Update test status** in this document:
   - ✅ Passed
   - ❌ Failed (log defect)
   - ⏸️ Blocked (document blocker)
   - ⬜ Not Run

### Defect Workflow

1. When a test fails, log it in the **Defect Log** section
2. Assign a severity (Critical/High/Medium/Low)
3. Fix the defect
4. Re-run the test
5. Update defect status to "Fixed" then "Verified"

---

## Session Continuity

If you start a new Claude session:

1. This file (`QA-COPILOT-TEST-PLAN.md`) contains current test status
2. `CLAUDE.md` has been updated with testing phase info
3. Review the **Test Summary Dashboard** to see progress
4. Check **Defect Log** for any open issues
5. Continue with next "Not Run" test case

---

## Verification Criteria

### Pass Criteria
- All 24 test cases executed
- No Critical or High severity defects open
- Plugin functions correctly in new sessions

### Overall Test Completion
- [ ] All Commands tested (6/6)
- [ ] All Skills tested (8/8)
- [ ] All Agents tested (6/6)
- [ ] All Hooks tested (4/4)
- [ ] All defects resolved
- [ ] Plugin verified in new session
