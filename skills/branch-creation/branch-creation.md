---
name: branch-creation
description: Creates Git branches following the configured naming convention and template.
execution: inline
scope: shared
version: 1.0
last-updated: 2026-04-20
---

# Branch Creation

Creates a Git branch in the source repository following the naming convention defined in `templates/branch-template.md`.

---

## When to Run

- A workflow step requires creating a new branch (e.g. before committing artefacts)
- The orchestrator triage identifies a JIRA ticket and needs a working branch
- The user explicitly asks to create a branch for a task

---

## Prerequisites

- `SOURCE_REPOS[]` — at least one source repo path (from ff-init)
- `SHELL_TYPE` — bash or powershell (from ff-init)
- A JIRA ticket key or short description for the branch name

---

## Naming Convention

Pattern: `{type}/{jira-ticket}-{short-description}`

| Part | Description |
|------|-------------|
| **type** | `feature/`, `fix/`, `bug/`, `chore/`, `refactor/`, `docs/` |
| **jira-ticket** | JIRA ticket ID (e.g. `DIT-179`). Omit if no ticket. |
| **short-description** | 2–4 word kebab-case summary |

Examples:
- `feature/DIT-179-budget-stage5`
- `fix/GXD-1732-header-alignment`
- `chore/update-dependencies`

---

## Execution

### Step 1 — Determine branch name

1. If a JIRA ticket key is available, extract it.
2. Ask the user for the branch type if not already known from context.
3. Generate the short description from the ticket title or user input (kebab-case, 2–4 words).
4. Assemble the full branch name using the pattern above.
5. Confirm the branch name with the user before creating.

### Step 2 — Create the branch

Switch to the target source repo and create the branch from the current HEAD:

**Bash:**
```bash
cd "$REPO_PATH" && git checkout -b "{branch-name}"
```

**PowerShell:**
```powershell
Push-Location $REPO_PATH; git checkout -b "{branch-name}"; Pop-Location
```

### Step 3 — Confirm

Report the created branch name and current repo path back to the caller.

---

## Outputs

| Output | Description |
|--------|-------------|
| Branch name | The full branch name that was created |
| Repo path | The source repo where the branch was created |
