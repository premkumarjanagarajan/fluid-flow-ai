---
name: completion
description: Orchestrates the post-implementation completion sequence — VAPT, risk report, reverse engineering update, analytics, commit, PR, and retrospective.
execution: inline
scope: shared
version: 1.0
last-updated: 2026-04-21
---

# Completion

Runs the full post-implementation completion sequence after the last step of a workflow. Coordinates all finishing primitives, generates commit and PR artifacts, enforces a single human gate over all outputs, and only then executes the actual commit and push.

---

## When to Run

After the **last step of any workflow** completes — except workflows with `domain: product` in their frontmatter (e.g. `product-buddy`). Product-oriented workflows do not touch source code directly and therefore skip this skill entirely.

The orchestrator calls this skill instead of executing Stage 4 inline.

---

## Skip If

- The active workflow has `domain: product` in its YAML frontmatter
- The user explicitly declines the completion sequence

---

## Prerequisites

- All workflow steps are complete (final phase gate passed)
- `INITIATIVE_NAME`, `DEPT_FF_PATH`, `FF_CORE_PATH` session variables are set
- `SOURCE_REPOS[]` has at least one entry
- `IS_BROWNFIELD` flag is set (from ff-init)

---

## Execution

### Step 1 — Evaluation Pause

After the last workflow step finishes, do **not** immediately enter completion. Present a pause to let the user review and adjust the implementation:

```
───────────────────────────────────────────────────
  IMPLEMENTATION COMPLETE — REVIEW BEFORE CLOSING
───────────────────────────────────────────────────

  All workflow steps have been executed.

  Before entering the completion phase, please review
  the implementation changes (additions, modifications,
  and removals in the source code).

  Take your time — adjust anything you need.
  When you're satisfied, confirm to proceed.

───────────────────────────────────────────────────
```

Use the IDE question tool to present the options:
- **A**: Proceed to completion
- **B**: I need to make adjustments (the agent waits and loops back when the user is ready)

Do **not** proceed until the user selects **A**.

---

### Step 2 — Pre-flight Summary

Once the user confirms, present a brief summary of what the completion phase will execute:

```
───────────────────────────────────────────────────
  COMPLETION PHASE — PRE-FLIGHT
───────────────────────────────────────────────────

  The following will run in sequence:

  Batch 1 (parallel):
    • VAPT — Vulnerability assessment & penetration testing
    • Risk Report — Change risk report for CAB reviewers
    • Reverse Engineering Update — Refresh project docs (brownfield only)
    • Analytics Reconciliation — Finalise timing and metrics

  Batch 2 (parallel):
    • Commit artifact — Conventional commit message & summary
    • PR artifact — Pull request description & metadata

  Then:
    → Human Gate — Review ALL generated artifacts before execution
    → Commit & Push — Only after your approval
    → Retrospective (optional)

───────────────────────────────────────────────────
```

Adjust the summary dynamically:
- If **not brownfield**, omit the "Reverse Engineering Update" line
- If VAPT depth will be Lite, note it

Use the IDE question tool:
- **A**: Start completion
- **B**: Cancel (return to implementation)

Wait for **A** before proceeding.

---

### Step 3 — Batch 1: Assessment & Reconciliation

Execute the following **in parallel** (all four are independent):

1. **VAPT**: Load `primitives/vapt.md`. Launch the VAPT subagent. Capture the verdict.
2. **Risk Report**: Load `primitives/risk-report.md`. Generate the report at `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/operations/risk-report.md`.
3. **Reverse Engineering Update** (brownfield only): Load `skills/reverse-engineering/reverse-engineering.md`. Refresh project-level documentation with the new changes. Update the **Commit** and **Branch** fields in `reverse-engineering-timestamp.md` to the current HEAD, and append a new entry to the Update History.
4. **Analytics Reconciliation**: Load `primitives/analytics.md`. Finalise initiative-level timing and metrics.

**Important**: If VAPT returns Critical or High findings, note them but do **not** halt here. The human gate in Step 5 will surface all findings together for a single review.

Collect all outputs:
- VAPT verdict (PASS / FINDINGS + severity counts)
- Risk report path and overall risk level
- RE update confirmation (if brownfield)
- Analytics confirmation

---

### Step 4 — Batch 2: Commit & PR Artifacts

Execute in parallel:

1. **Commit artifact**: Load `skills/completion/commit.md`. Resolve the commit template (enterprise KB → local KB → fallback), then generate the conventional commit message and change summary at `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/operations/commit.md`.
2. **PR artifact**: Load `skills/completion/pr.md`. Resolve the PR template (enterprise KB → local KB → fallback), then generate the pull request description and metadata at `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/operations/pr.md`.

---

### Step 5 — Consolidated Human Gate

Present **all** generated artifacts in a single human gate for review. This is the only gate in the completion sequence — the user validates everything at once.

```
───────────────────────────────────────────────────
  HUMAN GATE — COMPLETION ARTIFACTS
───────────────────────────────────────────────────

  Review all completion artifacts before commit & push.

  Security:
    {VAPT verdict summary — or "Skipped (no source changes)" if N/A}
    Report: {path to vapt-report.md, if generated}

  Operations:
    Risk Report: {path} — Overall Risk: {level}
    Commit: {path to commit.md}
    PR: {path to pr.md}

  Documentation:
    Reverse Engineering: {Updated / Skipped (greenfield)}
    Analytics: Updated

  ─────────────────────────────────────────────────

  VAPT Critical findings: {count}
  VAPT High findings: {count}

  {If Critical > 0:}
  ⚠ Critical findings require resolution or explicit risk
    acceptance before proceeding.

  {If High > 0:}
  ⚠ High findings detected — review recommended.

  ─────────────────────────────────────────────────

  A) Approve all — commit & push
  B) Adjust artifacts (provide feedback)
  C) Remediate VAPT findings first
───────────────────────────────────────────────────
```

**On A (Approve)**:
- Proceed to Step 6 (commit and push).

**On B (Adjust)**:
- Read the user's feedback.
- Re-generate the affected artifact(s).
- Present the gate again.

**On C (Remediate VAPT)**:
- Return to implementation to fix VAPT findings.
- After fixes, re-run Batch 1 (VAPT only, or all if the user changed significant code).
- Re-generate Batch 2 artifacts (commit/PR will reflect the remediation).
- Present the gate again.

---

### Step 6 — Commit & Push

Only after the user selects **A** in the human gate:

1. **Read** `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/operations/commit.md` — extract the conventional commit message.
2. **Stage** all changes in the source repo(s) and the department fluid-flow repo.
3. **Commit** using the conventional commit message from the artifact.
4. **Push** the branch to remote.
5. **Create PR** using the metadata from `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/operations/pr.md`.
6. **Attach** the risk report to the PR description or as a comment.
7. **Present** the PR link to the user.

```
───────────────────────────────────────────────────
  COMMITTED & PR CREATED
───────────────────────────────────────────────────

  Commit: {short SHA} — {commit message}
  Branch: {branch-name}
  PR: {PR URL}

  Risk report attached to PR.
───────────────────────────────────────────────────
```

---

### Step 7 — Retrospective (Optional)

After commit and push, suggest the retrospective:

```
───────────────────────────────────────────────────
  WORKFLOW COMPLETE
───────────────────────────────────────────────────

  Run a workflow retrospective for continuous improvement?
  Load skills/retrospective/retrospective.md to analyse
  this workflow execution and generate improvement items.

  A) Yes, run retrospective
  B) No, skip
───────────────────────────────────────────────────
```

If the user selects **A**, load `skills/retrospective/retrospective.md` and execute it.
If **B**, the workflow is complete.

---

## Error Handling

- **Git push fails**: Present the error, offer to retry or let the user fix manually.
- **PR creation fails** (MCP unavailable): Generate the PR body from the artifact and instruct the user to create the PR manually. Present the full PR body for copy-paste.
- **VAPT subagent fails**: Log the failure, skip the VAPT section in the human gate, note "VAPT: Failed — manual review recommended".
- **Partial artifact failure**: Present the gate with available artifacts, clearly mark which ones failed and why.
