# Conflict Detection

Compare active initiatives to detect contract, file, and data flow conflicts before construction begins.

## When to Run

After any workflow's planning phase produces `initiatives/{INITIATIVE_NAME}/target-repos.md`, before construction begins. Called by the orchestrator at Stage 5 via the conflict detection hook.

## Skip If

- Single-repo mode (no `ff-workspace.yaml`)
- No `target-repos.md` exists for the current initiative

## Context Isolation

Conflict detection runs as the **`.github/agents/conflict-detection.agent.md`** subagent. This agent inherits the model selected in the IDE's model picker. It has a focused context window:

| Loaded | NOT Loaded |
|--------|-----------|
| `ff-workspace.yaml` | Per-repo RE artifacts |
| `reverse-engineering/combined-architecture.md` | `knowledge-base-core/` |
| All active `initiatives/*/target-repos.md` | Repository codebases |
| Current initiative's `target-repos.md` | `combined-c4.md` |

This follows the workspace loading strategy in `knowledge-base-core/manifest.md` § Workspace Artifacts.

## Subagent Announcement

Before running, announce:

```
───────────────────────────────────────
  SUBAGENT LAUNCHED
  Type: conflict-detection
  Purpose: Check active initiatives for conflicts
───────────────────────────────────────
```

On completion, announce:

```
───────────────────────────────────────
  SUBAGENT COMPLETE
  Type: conflict-detection
  Result: {CLEAR / N conflicts found}
───────────────────────────────────────
```

## Algorithm

### 1. Load Context

Read the following files (and ONLY these files):
- `ff-workspace.yaml` — repo list, shared repo flags, `also_in` lists
- `reverse-engineering/combined-architecture.md` — cross-repo relationships, data flows, API contracts
- `initiatives/{INITIATIVE_NAME}/target-repos.md` — current initiative's target repos and planned changes

### 2. Scan Active Initiatives

Scan `initiatives/` for all active initiatives:
- Read each `metadata/state.md`
- Filter to initiatives where status is NOT `Completed`
- For each active initiative, check if `target-repos.md` exists

### 3. Detect Conflicts

For each active initiative that has a `target-repos.md`:

**a. File Overlap** — same repos targeted?
- Compare repo lists between current and active initiatives
- If overlapping repos: compare `Files affected` sections for overlapping directories or files
- Severity: **HIGH** if same files/directories, **LOW** if same repo but different areas

**b. Data Flow Conflicts** — same data flows modified?
- Read `combined-architecture.md` data flow tables (events, API calls, shared libraries)
- Check if both initiatives modify the same event, endpoint, or shared schema
- Severity: **BLOCKING** if same schema or API endpoint modified by both

**c. API Conflicts** — same APIs modified?
- Read per-repo `api-documentation.md` for repos in both initiatives
- Check for overlapping endpoint modifications
- Severity: **BLOCKING** if same endpoint modified

**d. Shared Repo Check** — `shared: true` repos in `ff-workspace.yaml`
- If the current initiative modifies a shared repo: emit **CROSS-CONTEXT** warning
- Include the `also_in` list from `ff-workspace.yaml`

### 4. Severity Classification

| Severity | Condition | Action |
|----------|-----------|--------|
| **BLOCKING** | Same schema or API modified by two active initiatives | Must resolve before construction |
| **HIGH** | Same files targeted in the same repo | Coordinate implementation order |
| **MEDIUM** | Upstream data flow change affecting downstream active initiative | Notify downstream team |
| **CROSS-CONTEXT** | Shared repo modified, other workspaces may be affected | Warn developer, require manual check |
| **LOW** | Same repo targeted but different areas | Informational only |

### 5. Generate Conflict Report

Write `initiatives/{INITIATIVE_NAME}/artefacts/conflict-report.md`:

```markdown
# Conflict Report

**Initiative**: {INITIATIVE_NAME}
**Date**: {ISO_TIMESTAMP}
**Status**: {CLEAR / CONFLICTS FOUND}

## Summary

- BLOCKING: {count}
- HIGH: {count}
- MEDIUM: {count}
- CROSS-CONTEXT: {count}
- LOW: {count}

## Conflicts

### [{SEVERITY}] {conflict-title}

- **This initiative**: {what this initiative plans to do}
- **Conflicting initiative**: {name} (status: {status})
- **Overlap**: {specific files, schemas, or endpoints}
- **Recommended action**: {resolution guidance}

{Repeat for each conflict.}

## Cross-Context Warnings

### CROSS-CONTEXT WARNING: {shared-repo-name}

This initiative modifies `{shared-repo-name}`, which is also used by:
- {workspace-name-1}
- {workspace-name-2}

**Required action**: Check with teams in those workspaces before proceeding.

[ ] Confirmed — no conflicting work in other workspaces
[ ] Conflicting work found — coordination plan: _______________

## No Conflicts

{If no conflicts detected: "No conflicts detected against {N} active initiatives."}
```

### 6. Present via Human Gate

Present the conflict report via `primitives/human-gate.md`.

For **BLOCKING** or **CROSS-CONTEXT** severity:
- The human gate **MUST NOT** be skipped
- The developer must acknowledge and resolve before construction proceeds
- For CROSS-CONTEXT: the checkbox acknowledgement in the report must be completed

For **HIGH** or **MEDIUM** severity:
- Present for awareness
- Developer may proceed after acknowledgement

For **LOW** only or no conflicts:
- Present for awareness
- Standard human gate applies

```
───────────────────────────────────────────────────
  CONFLICT DETECTION — {INITIATIVE_NAME}
───────────────────────────────────────────────────

  Status: {CLEAR / CONFLICTS FOUND}

  BLOCKING: {count}
  HIGH: {count}
  MEDIUM: {count}
  CROSS-CONTEXT: {count}
  LOW: {count}

  Full report: initiatives/{INITIATIVE_NAME}/artefacts/conflict-report.md

  A) Approve and proceed to construction
  B) Review conflicts (opens report)
  C) Pause — resolve conflicts first
───────────────────────────────────────────────────
```
