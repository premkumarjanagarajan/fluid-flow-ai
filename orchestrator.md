# Orchestrator

Display:

```
═══════════════════════════════════════════════════
  FLUID-FLOW AI v1.0 WORKFLOW ACTIVATED
  All development follows the unified lifecycle.
  Reading workflow instructions now...

  ⚠ MODEL CHECK: Subagents are capped at the model
  you selected for this chat. If you're using Haiku
  or a free-tier model, ALL subagents (RE, KB
  compliance, conflict detection) will also use it.
  For best results, select Claude Opus / GPT-5.2+
  BEFORE starting the workflow.
═══════════════════════════════════════════════════
```

## MCP Check

1. Read `.cursor/mcp.json` or `.vscode/mcp.json` (depending on IDE)
2. For each configured server, verify it is running and accessible
3. Report status:

```
  MCP Status:
    {server-name}: OK | FAIL ({error})
```

4. If any server fails: present a multi-choice question using the IDE question tool (Cursor: `AskQuestion` / VS Code: `vscode_askQuestions`):
   - **A**: Continue without failed server(s)
   - **B**: Stop and fix

   > **Tool note**: `vscode_askQuestions` and `AskQuestion` are deferred tools. You **must** load them via `tool_search_tool_regex` before calling them.

---

## Triage

1. Read all `workflow/*/wf-*.md` frontmatter to know available workflows
2. Check `initiatives/` for any existing initiative folders with incomplete `metadata/state.md`
3. Check for `ff-workspace.yaml` in the workspace root
4. Based on the user's prompt, classify the intent:

| Intent | Criteria | Action |
|--------|----------|--------|
| **Question** | No development needed | Answer directly. Stop here. |
| **Continue** | Matches an existing incomplete initiative | Confirm with user, run Stages 0-2, then resume from last completed stage in its `metadata/state.md` |
| **New** | Development request, no matching initiative | Run all stages (0-6) |
| **Workspace Setup (multi-repo)** | No `ff-workspace.yaml` found AND workspace has multiple repos, OR user explicitly requests workspace setup | Entry A: Load `skills/workspace-setup/workspace-setup.md` |
| **Workspace Creation (empty folder)** | No `ff-workspace.yaml` found AND no source code detected (empty or near-empty folder) AND user says "create FF workspace" or similar | Entry B: Load `skills/workspace-setup/workspace-setup.md` in catalog-guided mode |

### Multi-Repo Detection Prompt

When multiple repos are detected in the workspace without an `ff-workspace.yaml`, present this prompt before proceeding to Stages 0-6:

```
══════════════════════════════════════════════════════════
  MULTI-REPO WORKSPACE DETECTED
══════════════════════════════════════════════════════════

  This workspace contains {N} repositories.
  Fluid Flow can set this up as a Fluid Flow Workspace,
  which gives you:

  • Unified codebase awareness — the AI sees architecture,
    dependencies, and contracts across all {N} repos
  • Cross-repo initiative specs — plan features that span
    multiple repos in a single specification
  • Conflict detection — catch contract and file conflicts
    between parallel initiatives before construction
  • Single version of Fluid Flow — no copies in each repo,
    one source of truth for workflows and governance

  A) Set up as Fluid Flow Workspace (recommended)
     Use this repo as the workspace

  B) Continue with single-repo mode
     No workspace setup, standard Stages 0-6

  C) Create a new Fluid Flow Workspace repo
     Creates {context}-ff-workspace/ as a sibling
     directory and adds it to the .code-workspace file

══════════════════════════════════════════════════════════
```

Present choices using the IDE question tool (Cursor: `AskQuestion` / VS Code: `vscode_askQuestions`):
- **A**: Set up as Fluid Flow Workspace
- **B**: Continue with single-repo mode
- **C**: Create a new Fluid Flow Workspace repo

> **Tool note**: `vscode_askQuestions` and `AskQuestion` are deferred tools. You **must** load them via `tool_search_tool_regex` before calling them.

If the user selects **B**, proceed with single-repo behaviour (standard Stages 0-6). No disruption.

If the user selects **A**, load `skills/workspace-setup/workspace-setup.md`.

If the user selects **C**, run workspace repo creation:

1. Ask for the workspace context name (e.g. `sportsbook`, `payments`). Suggest based on common repo name prefixes.
2. Create the directory `../{context}-ff-workspace/` as a sibling to the current repos
3. Initialise it as a git repo (`git init`)
4. Copy the Fluid Flow framework files into it (orchestrator.md, knowledge-base-core/, primitives/, skills/, workflow/, templates/)
5. Copy the IDE entry points (`.cursor/rules/instructions.mdc`, `.github/copilot-instructions.md`)
6. Update the `.code-workspace` file: add `{context}-ff-workspace` as the **first** folder entry
7. Load `skills/workspace-setup/workspace-setup.md` to complete setup (RE, ff-workspace.yaml, shared repo discovery)

### Catalog-Guided Workspace Creation (Entry B)

When the workspace is an empty or near-empty folder with Fluid Flow installed and the user requests workspace creation:

```
══════════════════════════════════════════════════════════
  WORKSPACE CREATION — Catalog-Guided
══════════════════════════════════════════════════════════

  This folder has Fluid Flow installed but no source code.
  I can help you build a workspace from the domain catalog.

  Workspace name: {suggest from folder name, e.g. sbbonus}

  Do you have a domain catalog to work from?

  A) Yes — I have domain-catalog.yaml (provide path or
     it's already in this folder)

  B) No — I'll name the repos manually

══════════════════════════════════════════════════════════
```

Present using the IDE question tool.

**If A (catalog-guided):**
1. Load `domain-catalog.yaml` and any `*-domain-catalog.yaml` files
2. Present domains and key repos for the user to select
3. For each selected repo: clone as sibling directory (`../{repo-name}/`)
4. Generate `.code-workspace` file with this folder + all cloned repos
5. Load `skills/workspace-setup/workspace-setup.md` to complete setup (RE, `ff-workspace.yaml`)

**If B (manual):**
1. Ask the user to list repos (org/repo format or URLs)
2. Clone each as sibling directory
3. Generate `.code-workspace` file
4. Load `skills/workspace-setup/workspace-setup.md` to complete setup

---

## Stage 0: Shell Detection

Load `skills/shell-detection/shell-detection.md`. Store `SHELL_TYPE`.

## Stage 1: Workspace Detection

1. Scan for source code (`src/`, `package.json`, `*.csproj`, `go.mod`, etc.)
2. Classify: **greenfield** or **brownfield**
3. Check for `ff-workspace.yaml` in the workspace root:
   - If found: this is the **source of truth** for repo list, teams, and workspace config. Read it, store `WORKSPACE_NAME`, `REPO_LIST`, and `SHARED_REPOS` (repos with `shared: true`) for the session. Do NOT fall back to `.code-workspace` — `ff-workspace.yaml` takes precedence.
   - If NOT found: fall back to `.code-workspace` for repo discovery (used only during initial workspace setup)
   - **Do NOT** load any RE artifacts, combined architecture, or incident learnings at this stage
   - Report in workspace status:

```
  Workspace: {WORKSPACE_NAME}
  Repos: {count} repositories
  Shared repos: {list of shared: true repos, if any}
```

> **Context loading rule**: `ff-workspace.yaml` is the map — always loaded here. Everything else is territory — loaded on demand. See `knowledge-base-core/manifest.md` § Workspace Artifacts.

## Stage 2: Reverse Engineering (brownfield, run-once)

**Skip if**: greenfield or `reverse-engineering/reverse-engineering-timestamp.md` exists.

Load `skills/reverse-engineering/reverse-engineering.md`. **Wait for user approval.**

If `ff-workspace.yaml` exists (Fluid Flow Workspace mode):
- RE mode is read from `ff-workspace.yaml` field `re_mode` (default: `full`)
- If `full`: per-repo RE subagents produce 11 artifacts each in `{repo}/reverse-engineering/`, then combined architecture in workspace
- If `combined-only`: skip per-repo RE entirely — combined architecture subagent reads codebases directly and writes only to `reverse-engineering/` in workspace. No files written to target repos.
- Validate and update `ff-workspace.yaml` from RE findings

If no `ff-workspace.yaml` (single-repo mode):
- Standard v0.9 behaviour — per-repo artifacts only

**Continue stops here** -- resume the ongoing initiative from its last completed stage.

## Stage 3: Workflow Selection

Present workflows grouped by source. Suggest best match with `-->`. **Wait for user choice.**

```
-------------------------------------------
  AVAILABLE WORKFLOWS
-------------------------------------------

  Core:
    {N}. {workflow-name} -- {description}  {--> if suggested}

  Local:
    {N}. {workflow-name} -- {description}  {--> if suggested}

-------------------------------------------
```

Present workflow choices using the IDE question tool (Cursor: `AskQuestion` / VS Code: `vscode_askQuestions`) with one option per workflow.

> **Tool note**: `vscode_askQuestions` and `AskQuestion` are deferred tools. You **must** load them via `tool_search_tool_regex` before calling them.

- **Core**: workflows shipped with this repository (`workflow/`)
- **Local**: workflows added by the working repository (future support)

## Stage 4: Initiative Creation (new only)

1. Load `templates/branch-template.md` for naming convention
2. Generate a suggested name based on user's request and the template pattern
3. Present a multi-choice question using the IDE question tool (Cursor: `AskQuestion` / VS Code: `vscode_askQuestions`):
   - **A**: `{suggested-name}` (generated)
   - **B**: Other (user provides custom name)
4. Create the initiative folder structure:
   ```
   initiatives/{chosen-name}/
     metadata/
       state.md
       audit.md
       analytics.md
   ```
5. Store `INITIATIVE_NAME` for the session

## Stage 5: Workflow Routing

1. Load `workflow/{selected}/wf-{selected}.md`
2. Execute phase->step chain: each `{N}-{phase}.md` defines its steps, each `{N}-{step}.md` is loaded and executed in order
3. **After every step completes**: run `primitives/human-gate.md`, then `primitives/state-manager.md` and `primitives/analytics.md`
4. **After the last step of each phase** (phase transition or workflow end): additionally run `primitives/kb-compliance.md`

### Context Loading During Workflow (Workspace Mode)

When entering a workflow's planning phase:

1. If the workflow may produce `target-repos.md` (cross-repo scope):
   a. Load `reverse-engineering/combined-architecture.md` into the planning step's context
   b. Load `reverse-engineering/incident-learnings.md` filtered to repos mentioned in the spec/request
2. After planning produces `target-repos.md`:
   a. Load `target-repos.md`
   b. Load conflict detection skill (which loads `combined-architecture.md` in its own context)
3. During construction, for each target repo:
   a. Subagent loads ONLY that repo's RE artifacts from `{repo}/reverse-engineering/`
   b. Subagent loads `incident-learnings.md` filtered to that repo
   c. Subagent does NOT load other repos' RE artifacts

### Conflict Detection Hook (Workspace Mode)

After the planning phase completes, if `initiatives/{INITIATIVE_NAME}/target-repos.md` exists:

1. Load `skills/conflict-detection/conflict-detection.md`
2. Run conflict detection against all active initiatives
3. Present `conflict-report.md` via `primitives/human-gate.md`
4. For BLOCKING or CROSS-CONTEXT severity: the human gate **MUST NOT** be skipped
5. If approved and target repos need branches: create feature branches in target repos (lazy branching — same branch name across all repos)

## Stage 6: Completion

### Single-Repo Mode

1. **Commit**: present summary + conventional commit --> **wait for approval** --> commit
2. **PR**: push branch, create PR, present link
3. **Risk Report**: generate at `initiatives/{INITIATIVE_NAME}/operations/risk-report.md`, attach to PR

### Multi-Repo Mode (when `target-repos.md` exists)

1. **Commit workspace**: commit initiative artifacts and RE updates in the Fluid Flow Workspace repo
2. **Per-repo commits**: for each target repo in dependency order from `target-repos.md`:
   a. Stage and commit changes
   b. Push branch
   c. Create PR referencing the workspace initiative spec
3. **Risk Report**: generate risk report covering all repos at `initiatives/{INITIATIVE_NAME}/operations/risk-report.md`
4. **Attach**: attach risk report to all PRs

---

**Rules**:
- Never auto-commit. Never skip stages. Wait for user approval at gates.
- **After every step**: run `primitives/human-gate.md`, then `primitives/state-manager.md` and `primitives/analytics.md`.
- **After the last step of each phase** (phase transition): additionally run `primitives/kb-compliance.md`.
- **STATUS PREFIX**: You MUST start EVERY response with the `[FF · ...]` prefix (see § Status Prefix below). This is non-negotiable. The ONLY exception is when triage classifies the request as a Question answered directly.

---

## Status Prefix

**CRITICAL — apply to EVERY response, no exceptions (except Questions).**

Every response from the orchestrator or a workflow step MUST begin with a compact status prefix:

```
[FF · {workspace-or-repo} · {location}]
```

| Situation | Example |
|-----------|---------|
| Workflow step | `[FF · sportsbook · inception/specify]` |
| Orchestrator stage | `[FF · sportsbook · stage:workspace-detection]` |
| Workspace setup | `[FF · setup · workspace-setup]` |
| Single-repo mode | `[FF · sportsbook-api · inception/specify]` |
| Question (no Fluid Flow) | No prefix |

- `FF` identifies the response as Fluid Flow-orchestrated
- Workspace name from `ff-workspace.yaml`, or repo name in single-repo mode
- Current phase/step or stage name
- When triage classifies as **Question**: NO prefix — this signals Fluid Flow is not active

---

