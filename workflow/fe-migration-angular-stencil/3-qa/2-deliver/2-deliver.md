---
step: deliver
subagent: false
---

## Inputs

- All approved code + tests + stories (committed per group during 2-implement)
- `JIRA_KEY`, `WIDGET_NAME` (from 1-specify)

## Guidance

### 1. Planning Artifact Cleanup (mandatory before push)

The following files are agent-only artifacts and must **never appear in the PR**:

- `initiatives/{INITIATIVE_NAME}/artefacts/1.6-migration-context.md`
- `initiatives/{INITIATIVE_NAME}/artefacts/1.6-implementation-plan.md`
- Any `docs/{WIDGET_NAME}/angular-analysis-report.md` in the target repo

Check whether any were accidentally committed. If so, `git rm` them and commit the removal:

```bash
git rm {files} && git commit -m "chore({WIDGET_NAME}): remove migration planning artifacts"
```

If they are untracked (the normal case when groups used explicit staging), simply delete them from disk.

**Files that SHOULD be committed** (permanent artifacts):
- `docs/{WIDGET_NAME}/architecture.md`
- `docs/{WIDGET_NAME}/main-acceptance-criteria.md` (if produced by prior JIRA Epic workflow)

### 2. Verify Commits

All implementation groups should already have local commits from the group-based implementation cycle. Verify the commit history is clean and each group has its own commit:

| Group | Expected commit scope |
|---|---|
| 1 | `feat({WIDGET_NAME}): contracts & scaffold — {description}` |
| 2 | `feat({WIDGET_NAME}): component — root widget` |
| 3+ | `feat({WIDGET_NAME}): component — {child-name}` |
| N-1 | `feat({WIDGET_NAME}): tests — unit tests for all components` |
| N | `feat({WIDGET_NAME}): stories — Storybook stories and mocks` |

If any commit needs adjustment (e.g. the docs commit for architecture.md), create it now.

### 3. Push

Push branch to origin.

### 4. Handoff to Orchestrator

After push, control returns to the orchestrator's Stage 6 (Completion) which handles PR creation and risk report.

## Outputs

- Clean commit history on feature branch (one commit per group)
- Planning artifacts removed (not in PR)
- Branch pushed to origin

## Gate

STOP — present commit plan to user and wait for approval before executing push.
