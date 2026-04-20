---
name: retrospective
description: Performs a critical retrospective of the completed workflow and generates improvement backlog items.
execution: inline
scope: shared
version: 1.0
last-updated: 2026-04-20
---

# Workflow Retrospective

Perform a critical retrospective analysis of the workflow conversation that just completed. Generate a feature-level retrospective and concrete improvement backlog items that propose specific edits to knowledge-base files, primitives, templates, and workflow configuration.

This is the **continuous improvement engine** of Fluid Flow — every workflow execution generates data that feeds back into making the framework better.

---

## When to Run

Run **after** a workflow completes (orchestrator Stage 7 finishes), ideally in the **same chat session** where the workflow ran. The AI's conversational context is the primary data source.

The orchestrator Stage 7 will recommend this skill as a follow-up after commit/PR.

---

## Prerequisites

1. **Same chat session** (preferred): Full conversation context available from the workflow execution. If this is a new session, offer degraded mode (audit-only analysis).
2. **Initiative directory exists**: `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/` with `metadata/audit.md` and `metadata/state.md`.
3. **Workflow has completed**: Check `metadata/state.md` — the workflow should have reached its final stage. If still in progress, warn and ask whether to proceed with a partial retrospective.

---

## Execution

### Step 1: Gather Context

Load all available data sources:

**From conversation** (preferred):
- Full interaction history: questions asked, decisions made, blockers encountered, rework cycles

**From initiative artifacts**:
- `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/metadata/audit.md` — structured interaction log
- `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/metadata/state.md` — stage progression
- `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/metadata/analytics.md` — timing and metrics (if exists)
- All artefacts in `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/`

### Step 2: 8-Dimension Analysis

Analyse the workflow execution across these dimensions. For each, assign a rating (Strong / Adequate / Needs Improvement / Weak) and provide specific evidence.

| # | Dimension | What to Assess |
|---|-----------|----------------|
| 1 | **Specification Quality** | Was the spec clear enough? How many clarifications were needed? Did ambiguities cause downstream rework? |
| 2 | **Planning Effectiveness** | Did the plan accurately predict the work? Were there surprise tasks or missing components? |
| 3 | **Task Decomposition** | Were tasks at the right granularity? Were dependencies accurate? Did parallelization opportunities get used? |
| 4 | **Implementation Efficiency** | How many iterations per task? Were there blocked tasks? Test failures? Code rework? |
| 5 | **Human-AI Collaboration** | Were human gates effective? Was the AI asking the right questions? Were decisions made at the right level? |
| 6 | **Quality Assurance** | Did checklists catch real issues? Were VAPT findings actionable? Was the analysis step useful? |
| 7 | **Knowledge Base Adequacy** | Were constitution rules relevant? Did security policies apply? Were any missing? |
| 8 | **Workflow Fitness** | Was the chosen workflow (fast-track vs comprehensive) appropriate? Were any steps unnecessary or missing? |

### Step 3: Generate Improvement Items

For each finding rated "Needs Improvement" or "Weak", generate a concrete improvement item:

```markdown
| ID | Dimension | Priority | Description | Target File | Proposed Change |
|----|-----------|----------|-------------|-------------|-----------------|
| IMP-001 | Spec Quality | High | Spec template missing data retention section | templates/spec-template.md | Add "## Data Retention" section |
```

Priority levels:
- **Critical**: Caused workflow failure or major rework
- **High**: Caused significant inefficiency or missed quality issue
- **Medium**: Room for improvement, not blocking
- **Low**: Nice-to-have refinement

### Step 4: Write Outputs

1. **Retrospective report** at `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/retrospective.md`:
   - Summary (overall workflow health rating)
   - Dimension ratings table
   - Detailed findings per dimension
   - Metrics (total duration, rework cycles, human gates triggered, etc.)

2. **Improvement backlog** at `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/improvement-backlog.md`:
   - Table of all improvement items with ID, dimension, priority, description, target file, proposed change
   - Grouped by priority

### Step 5: Present Summary

Show the user:
- Overall workflow health (1-5 scale)
- Top 3 improvement items
- Paths to retrospective and improvement backlog files
- Ask: "Would you like me to apply any of these improvements to the framework?"

---

## Degraded Mode (Different Chat Session)

If no workflow conversation context is available:

```
## Limited Retrospective Mode

This appears to be a new chat session. The retrospective will be based on:
- metadata/audit.md (structured interaction log)
- metadata/state.md (stage progression)
- Generated artifacts

This produces less detailed analysis. For best results, run the retrospective
in the same chat session where the workflow completed.

Proceed with limited retrospective?
```

If confirmed:
- Execute Steps 1-5 using only audit trail and artifacts
- Mark the retrospective as `**Mode**: Limited (audit-only)` in the output
- Skip dimensions that require conversation context (Human-AI Collaboration will be partial)
