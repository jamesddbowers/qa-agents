---
description: Analyze API traffic data to prioritize test coverage
allowed-tools: Read, Grep, Glob
argument-hint: [traffic-data-file]
---

Analyze API traffic data (Dynatrace export or similar) to prioritize endpoints for smoke and regression testing.

**Traffic Data File**: $ARGUMENTS

If no file provided, look for traffic data files in common locations (qa-agent-output/, exports/, data/).

**Analysis Goals:**
1. Parse the traffic data format
2. Calculate endpoint priority based on traffic volume, error rates, and response times
3. Identify high-traffic critical path endpoints
4. Flag endpoints with elevated error rates
5. Note performance concerns (slow endpoints)
6. Generate smoke test and regression test candidate lists

**Output Requirements:**
- Write the analysis to `qa-agent-output/traffic-analysis.md`
- Include prioritized endpoint rankings
- Provide smoke test candidate list (top 10-20%)
- Provide regression test candidate list (top 40-60%)
- Note any data gaps or limitations

Before writing any files, ask for confirmation showing a preview of what will be generated.
