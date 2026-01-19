---
description: Diagnose and triage API test failures
allowed-tools: Read, Grep, Glob
argument-hint: [results-file-or-folder]
---

Analyze test results to diagnose failures and provide remediation recommendations.

**Results Location**: $ARGUMENTS

If no location provided, look for results in common locations:
- `results/`
- `qa-agent-output/results/`
- `TestResults/`
- Recent JUnit XML files

**Supported Formats:**
- Newman JUnit XML output
- Newman CLI output (text)
- Azure DevOps test results

**Diagnosis Goals:**
1. Parse test results and identify all failures
2. Categorize failures by type (auth, data, server, timeout, assertion)
3. Identify patterns across failures
4. Distinguish between test issues and actual API bugs
5. Provide specific remediation recommendations
6. Flag flaky tests if historical data available

**Output:**
- Display diagnosis report directly (no file write needed for diagnostics)
- Include severity assessment
- Provide priority actions list
- Suggest specific fixes with code examples where applicable

For each failure category, explain:
- What likely caused it
- How to investigate further
- Specific steps to fix
