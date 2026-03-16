# Workspace Setup

Bootstrap a Fluid Flow Workspace from a multi-root VS Code workspace. Generates combined architecture views and the `ff-workspace.yaml` composition file.

## When to Run

- **Entry A**: Triage classifies intent as **Workspace Setup (multi-repo)**: no `ff-workspace.yaml` found AND workspace has multiple repos
- **Entry B**: Triage classifies intent as **Workspace Creation (empty folder)**: no `ff-workspace.yaml` found AND no source code AND user requests workspace creation
- Loaded by the orchestrator after user selection

## Flow

### 0. Determine Entry Mode

Check which entry path triggered this skill:

- **Entry A** (multi-repo detected): repos already exist in `.code-workspace`. Proceed to Step 1A.
- **Entry B** (empty folder, catalog-guided): repos need to be cloned. The orchestrator has already handled domain/repo selection and cloning. Proceed to Step 1B.

### 1A. Read `.code-workspace` (Entry A only)

Read the `.code-workspace` file in the workspace root. Extract the repo list from the `folders` array. This is the **only time** `.code-workspace` is used — once `ff-workspace.yaml` is generated, it becomes the source of truth for all subsequent operations.

### 1B. Read Cloned Repos (Entry B only)

The orchestrator has already cloned repos as sibling directories and generated a `.code-workspace` file. Read it to get the repo list. The workspace name was set by the orchestrator from the folder name or user input.

For both entry modes, store:
- `WORKSPACE_REPOS`: list of repo names and paths
- `WORKSPACE_NAME`: derived from the `.code-workspace` filename or folder name

Present:

```
───────────────────────────────────────────────────
  WORKSPACE SETUP — Repository Discovery
───────────────────────────────────────────────────

  Workspace file: {filename}.code-workspace
  Repositories found: {N}

  {N}. {repo-name} — {path}
  ...

───────────────────────────────────────────────────
```

Then present a multi-choice question using the IDE question tool (Cursor: `AskQuestion` / VS Code: `vscode_askQuestions`):
- **A**: Confirm and proceed
- **B**: Edit list (add/remove repos)

> **Tool note**: `vscode_askQuestions` and `AskQuestion` are deferred tools. You **must** load them via `tool_search_tool_regex` before calling them.

### 2. Shell Detection

Load `skills/shell-detection/shell-detection.md`. Store `SHELL_TYPE`. Same as Stage 0.

### 3. RE Mode

Before running RE, ask the user how much reverse engineering to perform:

```
───────────────────────────────────────────────────
  WORKSPACE SETUP — Reverse Engineering Mode
───────────────────────────────────────────────────

  How should reverse engineering be run?

  A) Full — per-repo RE (11 artifacts per repo)
     + combined architecture in workspace (default)
     Gives the deepest analysis per repo. Writes
     artifacts into each repo's directory.

  B) Combined only — just the combined architecture
     view saved in the workspace repo
     Faster. No per-repo artifacts. The AI reads
     each repo's code directly to produce the
     combined cross-repo architecture view.

───────────────────────────────────────────────────
```

Present using the IDE question tool (Cursor: `AskQuestion` / VS Code: `vscode_askQuestions`):
- **A**: Full (default)
- **B**: Combined only

Store the choice as `RE_MODE` (`full` or `combined-only`).

If `ff-workspace.yaml` already exists and has an `re_mode` field, use that value as default and skip the prompt.

### 4. Run RE Across All Repos

Load `skills/reverse-engineering/reverse-engineering.md` with `RE_MODE`.

**If `RE_MODE = full`** (default):
- Per-repo subagents produce 11 artifacts each, written to `{repo}/reverse-engineering/`
- After all per-repo subagents complete, the combined architecture subagent reads the per-repo artifacts and produces combined views in the workspace

**If `RE_MODE = combined-only`**:
- Skip per-repo RE subagents entirely
- Launch the combined architecture subagent directly — it reads each repo's codebase (not pre-produced artifacts) and produces only the combined workspace-level views
- No files are written inside any target repos

In both modes, the combined output in the workspace repo includes:
- `reverse-engineering/combined-architecture.md`
- `reverse-engineering/combined-c4.md`
- `reverse-engineering/reverse-engineering-timestamp.md`

Wait for user approval of RE results.

### 5. Generate `ff-workspace.yaml`

From RE findings, generate `ff-workspace.yaml` in the workspace root.

Include `re_mode: full` or `re_mode: combined-only` based on the user's choice in Step 3. This persists the preference for future RE runs.

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

───────────────────────────────────────────────────
```

Present using the IDE question tool (Cursor: `AskQuestion` / VS Code: `vscode_askQuestions`):
- **A**: Approve and save
- **B**: Request changes
- **C**: Redo generation

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
