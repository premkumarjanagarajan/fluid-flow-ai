# Workspace Setup

Bootstrap a Fluid Flow Workspace from a multi-root VS Code workspace. Generates combined architecture views and the `ff-workspace.yaml` composition file.

## When to Run

- Triage classifies intent as **Workspace Setup**: no `ff-workspace.yaml` found AND workspace has multiple repos, OR user explicitly requests workspace setup
- Loaded by the orchestrator after the user selects **A** on the multi-repo detection prompt

## Flow

### 1. Read `.code-workspace`

Read the `.code-workspace` file in the workspace root. Extract the repo list from the `folders` array.

Store:
- `WORKSPACE_REPOS`: list of repo names and paths
- `WORKSPACE_NAME`: derived from the `.code-workspace` filename (e.g. `sportsbook` from `sportsbook.code-workspace`)

Present:

```
───────────────────────────────────────────────────
  WORKSPACE SETUP — Repository Discovery
───────────────────────────────────────────────────

  Workspace file: {filename}.code-workspace
  Repositories found: {N}

  {N}. {repo-name} — {path}
  ...

  A) Confirm and proceed
  B) Edit list (add/remove repos)
───────────────────────────────────────────────────
```

Wait for user approval via `primitives/human-gate.md`.

### 2. Shell Detection

Load `skills/shell-detection/shell-detection.md`. Store `SHELL_TYPE`. Same as Stage 0.

### 3. RE Output Location

Before running RE, ask the user where per-repo artifacts should be stored:

```
───────────────────────────────────────────────────
  WORKSPACE SETUP — RE Output Location
───────────────────────────────────────────────────

  Where should reverse engineering artifacts be stored?

  A) Both — per-repo artifacts in each repo +
     combined architecture in workspace (default)
     Best when you have write access to all repos.

  B) Workspace only — all RE artifacts centralised
     in the workspace repo
     Best when you don't own the target repos or
     want to keep them clean.

───────────────────────────────────────────────────
```

Store the choice as `RE_OUTPUT_MODE` (`both` or `workspace-only`).

If `ff-workspace.yaml` already exists and has an `re_output` field, use that value as default and skip the prompt.

### 4. Run RE Across All Repos

Load `skills/reverse-engineering/reverse-engineering.md` with `RE_OUTPUT_MODE`.

This runs the full RE flow:

**If `RE_OUTPUT_MODE = both`** (default):
- Per-repo subagents produce 11 artifacts each, written to `{repo}/reverse-engineering/`
- Combined architecture written to `reverse-engineering/` in the workspace repo

**If `RE_OUTPUT_MODE = workspace-only`**:
- Per-repo subagents produce 11 artifacts each, written to `reverse-engineering/{repo-name}/` **in the workspace repo**
- Combined architecture written to `reverse-engineering/` in the workspace repo
- No files are written inside the target repos

In both modes, the combined architecture subagent produces:
- `reverse-engineering/combined-architecture.md`
- `reverse-engineering/combined-c4.md`
- `reverse-engineering/reverse-engineering-timestamp.md`

Wait for user approval of RE results.

### 5. Generate `ff-workspace.yaml`

From RE findings, generate `ff-workspace.yaml` in the workspace root.

Include `re_output: both` or `re_output: workspace-only` based on the user's choice in Step 3. This persists the preference for future RE runs.

**Repositories** — for each repo:
- `name`: folder name from `.code-workspace`
- `path`: relative path from `.code-workspace`
- `type`: `application` (has runnable code), `shared` (contracts/schemas/libraries), `library` (internal packages)
- `language`: primary language(s) from `technology-stack.md`
- `team`: from CODEOWNERS file or GitHub API (if available). If neither: leave blank for human to fill
- `description`: first sentence from `business-overview.md`

**Teams** — collect unique teams from repo entries. Set `slack` to blank (human fills in).

**Governance** — set defaults based on knowledge-base-core:
- `iso27001: true` if `knowledge-base-core/security/iso27001-compliance.md` exists
- `iso9001: true` if `knowledge-base-core/quality/iso9001-quality-management.md` exists

### 6. Discover Shared Repos via GitHub MCP

**Skip if**: GitHub MCP server is not available (check MCP status from orchestrator).

For each repo in the workspace:
1. Query GitHub MCP: search for `.code-workspace` files or `ff-workspace.yaml` files in org `BetssonGroup` that reference this repo name
2. If found in other workspaces:
   - Set `shared: true` on the repo entry
   - Set `also_in: [list of other workspace names]`
   - Set `change_coordination: manual` (default strategy)
3. If GitHub MCP is not available: skip. Shared repos can be flagged manually later.

### 7. Present `ff-workspace.yaml` for Review

Present the generated file via `primitives/human-gate.md`:

```
───────────────────────────────────────────────────
  WORKSPACE SETUP — ff-workspace.yaml Review
───────────────────────────────────────────────────

  Generated workspace composition:
    - {N} repositories
    - {N} teams
    - {N} shared repos detected
    - Governance: {flags}

  The full ff-workspace.yaml is ready for review.

  A) Approve and save
  B) Request changes
  C) Redo generation
───────────────────────────────────────────────────
```

On **A**: write `ff-workspace.yaml` to the workspace root.

### 8. Done

Workspace setup is complete. Report:

```
══════════════════════════════════════════════════════════
  FLUID FLOW WORKSPACE READY
══════════════════════════════════════════════════════════

  Workspace: {WORKSPACE_NAME}
  Repos: {N}
  Combined architecture: reverse-engineering/combined-architecture.md
  Workspace file: ff-workspace.yaml

  Future requests will route through the standard
  orchestrator lifecycle (Stages 0-6) with full
  cross-repo awareness.
══════════════════════════════════════════════════════════
```

## Incremental Updates

When workspace setup is re-run (e.g. new repo added to `.code-workspace`):

1. Detect new/removed repos by comparing `.code-workspace` against existing `ff-workspace.yaml`
2. Run RE only for new repos (existing `reverse-engineering-timestamp.md` prevents re-run)
3. Re-run the combined architecture subagent to include new repos
4. Update `ff-workspace.yaml`:
   - Add new repo entries
   - Remove entries for repos no longer in `.code-workspace`
   - **Preserve human-edited fields**: `change_coordination`, `slack`, `governance`
5. Present diff for approval
