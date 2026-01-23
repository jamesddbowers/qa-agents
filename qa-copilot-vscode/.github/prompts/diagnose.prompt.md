---
mode: agent
description: Diagnose and triage API test failures
tools:
  - read
  - search
variables:
  - name: results
    description: Path to test results file or folder
    default: ""
---

Analyze test results to diagnose failures and provide remediation recommendations.

**Results Location**: ${input:results}

If no location provided, look for results in common locations:
- `results/`
- `qa-agent-output/results/`
- `TestResults/`
- `test-fixtures/` (for sample data)
- Recent JUnit XML files

## Supported Formats

- Newman JUnit XML output
- Newman JSON output
- Newman CLI output (text)
- Azure DevOps test results

## Diagnosis Goals

1. Parse test results and identify all failures
2. Categorize failures by type:
   - **Auth failures** - 401, 403, token issues
   - **Data failures** - Missing/invalid test data
   - **Server errors** - 500, timeout, connection issues
   - **Assertion failures** - Response validation issues
3. Identify patterns across failures
4. Distinguish between test issues and actual API bugs
5. Provide specific remediation recommendations
6. Flag flaky tests if historical data available

## Output Format

Display diagnosis report directly with:
- Severity assessment (Critical / High / Medium / Low)
- Failure counts by category
- Priority actions list
- Specific fixes with code examples where applicable

For each failure category, explain:
- What likely caused it
- How to investigate further
- Specific steps to fix

## No File Output Required

Diagnosis results are displayed directly - no file write needed unless user requests saving the report.
