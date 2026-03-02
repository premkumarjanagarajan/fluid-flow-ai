# Change Risk Report (Standalone Command)

# This command is a STANDALONE entry point — it can be run independently of the main workflow.
# Use it to regenerate a risk report after changes, or to generate a delta report.
# The feature branch and directory already exist at specs/{BRANCH_NAME}/.
# state.md and audit.md already exist in the feature directory.

## Purpose

Generate or regenerate a structured change risk report for CAB reviewers. This command supports two modes:

1. **Full Report**: Analyses the complete `git diff main...HEAD` with all available lifecycle context. Use when generating the report for the first time or regenerating after significant changes.
2. **Delta Report**: Analyses only changes made since the last risk report was generated. Use when minor changes were made after the initial report (e.g., code review feedback, bug fixes).

---

## MANDATORY: Shared Memory Loading
**CRITICAL**: At command start, load the shared memory manifest and follow ALL instructions within it:
- Load `../memory/load-shared-memory.md` -- resolve and load every file listed, using paths relative to the manifest's location

## MANDATORY: State and Audit Logging
- Read and update `specs/{BRANCH_NAME}/state.md` with stage progress at start and completion of this command
- Append to `specs/{BRANCH_NAME}/audit.md` with user inputs and AI responses using ISO 8601 timestamps
- Use the same verbatim logging rules: capture COMPLETE RAW INPUT, never summarize
- ALWAYS append/edit audit.md, NEVER completely overwrite it

---

## Pre-Requisites

Before executing, verify:

1. **Feature directory exists**: `specs/{BRANCH_NAME}/` must exist with `audit.md` and `state.md`
2. **Git diff is available**: The current branch must have commits ahead of the base branch

### Resolving BRANCH_NAME

If BRANCH_NAME is not provided or available from conversation context:
1. Check current git branch: run `git branch --show-current`
2. If on a feature branch (matches `###-*` pattern), use that as BRANCH_NAME
3. If not on a feature branch, list recent feature directories in `specs/` and ask the user to confirm

---

## Execution

### Step 1: Determine Report Mode

Check if a previous risk report exists at `specs/{BRANCH_NAME}/operations/risk-report.md`.

**If no previous report exists**:
- Default to **Full Report** mode

**If a previous report exists**:
- Present the choice to the user:

```markdown
## Risk Report Mode

A previous risk report exists for this feature.

**1. Full Report** — Regenerate the complete risk report from scratch.
   Use when: significant changes were made, or you want a fresh analysis.

**2. Delta Report** — Analyse only changes since the last report.
   Use when: minor fixes or review feedback was applied.

Please reply with **1** or **2**.
```

- **Wait for User Response**: Do NOT proceed until the user has made their choice

### Step 2: Log Report Start

Append to `specs/{BRANCH_NAME}/audit.md`:

```markdown
## Change Risk Report - Start
**Timestamp**: [ISO timestamp]
**AI Response**: "Starting change risk report generation ({Full/Delta} mode) for {BRANCH_NAME}"
**Context**: Change Risk Report

---
```

### Step 3: Obtain the Diff

**Full Report mode**:
```bash
git diff main...HEAD
```

**Delta Report mode**:
1. Read the previous report at `specs/{BRANCH_NAME}/operations/risk-report.md`
2. Extract the `**Generated**` timestamp
3. Find the commit closest to that timestamp:
   ```bash
   git log --before="{timestamp}" --format="%H" -1
   ```
4. Diff from that commit to HEAD:
   ```bash
   git diff {commit}...HEAD
   ```
5. If the delta diff is empty, inform the user: "No changes detected since the last risk report. The existing report is still current."

### Step 4: Execute Risk Report Generation

1. **Analytics: Record stage start**: Follow Step 1 of `../stages/analytics-step-update.md` with `STAGE_NAME = Risk Report`
2. Load and execute all instructions from `../stages/risk-report.md`
3. The stage file handles:
   - Gathering lifecycle context from `specs/{BRANCH_NAME}/`
   - Analysing the diff
   - Generating the report at `specs/{BRANCH_NAME}/operations/risk-report.md`
   - Presenting the summary

For **Delta Reports**, add a section at the top of the report:

```markdown
## Delta Report Context

**Previous Report**: [timestamp of previous report]
**Changes Since**: [commit range]
**Scope**: Only changes since the previous report are analysed below.
**Previous Risk Level**: [from previous report]

> For the complete risk analysis, refer to the previous full report or regenerate using `/fluid-flow.risk-report` in Full Report mode.
```

### Step 5: Log Report Completion

Append to `specs/{BRANCH_NAME}/audit.md`:

```markdown
## Change Risk Report - Complete
**Timestamp**: [ISO timestamp]
**AI Response**: "Change risk report generated ({Full/Delta} mode). Risk Level: {LEVEL}, Recommendation: {REC}"
**Context**: Change Risk Report
**Summary**:
- Report: specs/{BRANCH_NAME}/operations/risk-report.md
- Mode: {Full / Delta}
- Risk Level: {LEVEL}
- CAB Recommendation: {RECOMMENDATION}
- AI Confidence: {SCORE}/100

---
```

**Analytics: Record stage completion**: Follow Step 2 of `../stages/analytics-step-update.md` with `STAGE_NAME = Risk Report`

---

## Prompts Logging Requirements
- **MANDATORY**: Log EVERY user input (prompts, questions, responses) with timestamp in audit.md
- **MANDATORY**: Capture user's COMPLETE RAW INPUT exactly as provided (never summarize)
- **CRITICAL**: ALWAYS append changes to EDIT audit.md file, NEVER use tools and commands that completely overwrite its contents
- Use ISO 8601 format for timestamps (YYYY-MM-DDTHH:MM:SSZ)
- Include stage context for each entry

### Correct Tool Usage for audit.md

✅ CORRECT:

1. Read the audit.md file
2. Append/Edit the file to make changes

❌ WRONG:

1. Read the audit.md file
2. Completely overwrite the audit.md with the contents of what you read, plus the new changes you want to add to it
