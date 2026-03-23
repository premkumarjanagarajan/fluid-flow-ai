---
phase: construction
steps: 4
---

# Phase 2: Construction

Goal: generate tasks, optionally create JIRA issues, generate quality checklists, and implement the approved plan.

KB note: `ai-governance/content-validation.md` applies to all generated code. `security/*.md` should be pre-loaded if the feature handles user data or authentication.

## Step Chain

1. Load `1-tasks/1-tasks.md` -- generate ordered task breakdown from plan and spec
2. Load `2-tasks-to-issues/2-tasks-to-issues.md` -- create JIRA issues from tasks (optional, skip if no JIRA)
3. Load `3-checklist/3-checklist.md` -- generate quality checklists (optional, skip unless user requests)
4. Load `4-implement/4-implement.md` -- execute the implementation plan

## Phase Gate

User must confirm the implementation is complete and passes validation before the orchestrator's Stage 7 (Completion) runs.

Present:
- **A**: Approve and proceed to Completion
- **B**: Request changes (loops back to implementation step)
