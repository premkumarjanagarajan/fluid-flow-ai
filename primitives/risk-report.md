# Change Risk Report

Generate a structured change risk report for CAB reviewers. This primitive runs during the orchestrator's Stage 7 (Completion), after VAPT passes its human gate.

## Modes

| Mode | When to use | Diff source |
|------|-------------|-------------|
| **Full Report** | First time, or regenerating after significant changes | `git diff main...HEAD` |
| **Delta Report** | Minor changes after the initial report (review feedback, bug fixes) | Diff from last report's commit to HEAD |

## Prerequisites

- Implementation is complete (Construction phase gate passed)
- VAPT has passed its human gate
- `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/` exists with metadata and artefacts

## Execution

### 1. Determine Report Mode

Check if a previous report exists at `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/operations/risk-report.md`.

- **No previous report**: default to Full Report
- **Previous report exists**: present the choice:

  ```
  ## Risk Report Mode

  A previous risk report exists for this feature.

  1. Full Report — Regenerate from scratch
  2. Delta Report — Analyse only changes since the last report

  Reply with 1 or 2.
  ```

  Wait for user response.

### 2. Obtain the Diff

**Full Report**:
```bash
git diff main...HEAD
```

**Delta Report**:
1. Read the previous report and extract the `**Generated**` timestamp
2. Find the commit closest to that timestamp:
   ```bash
   git log --before="{timestamp}" --format="%H" -1
   ```
3. Diff from that commit to HEAD:
   ```bash
   git diff {commit}...HEAD
   ```
4. If the delta diff is empty: "No changes detected since the last risk report. The existing report is still current." -- stop.

### 3. Load Lifecycle Context

Gather all available context from the initiative:
- `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/spec.md`
- `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/plan.md`
- `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/tasks.md`
- `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/security/vapt-report.md` (if exists)
- `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/metadata/audit.md`

### 4. Generate the Report

Create the directory `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/operations/` if it does not exist.

Generate at: `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/operations/risk-report.md`

Report structure:

```markdown
# Change Risk Report: {INITIATIVE_NAME}

## Header
- Initiative, Branch, Date, Mode (Full/Delta), Assessor (AI)

## Executive Summary
- Overall Risk Level: Critical / High / Medium / Low
- Total files changed, lines added/removed
- Key risk narrative (2-3 sentences)

## Change Classification
- Type: Feature / Bug Fix / Refactor / Infrastructure / Config
- Scope: Isolated / Cross-cutting / Platform-wide
- Data impact: None / Read-only / Read-write / Schema change

## Risk Analysis
- Complexity risk (cyclomatic complexity delta, new dependencies)
- Integration risk (API changes, contract breaks, downstream impact)
- Security risk (auth changes, data handling, VAPT findings summary)
- Operational risk (deployment steps, rollback complexity, monitoring gaps)
- Data risk (migration needed, data loss potential, backup requirements)

## Files Changed Summary
- Table of changed files grouped by risk level

## Lifecycle Traceability
- Requirements coverage (spec -> plan -> tasks -> code)
- Gaps or drift identified

## CAB Recommendation
- Risk Level: [LEVEL]
- Recommendation: Approve / Approve with conditions / Reject
- Conditions (if any)

## AI Confidence
- Score: [0-100]
- Factors affecting confidence
```

For **Delta Reports**, prepend:

```markdown
## Delta Report Context
- Previous Report: [timestamp]
- Changes Since: [commit range]
- Previous Risk Level: [from previous report]
```

### 5. Present Summary

Show the user:
- Overall risk level
- CAB recommendation
- Report file path
- Offer to attach to PR (if PR creation follows)

## Error Handling

- **No git diff available**: Warn user, generate report from lifecycle context only
- **Missing lifecycle artifacts**: Generate partial report, note gaps in AI Confidence section
