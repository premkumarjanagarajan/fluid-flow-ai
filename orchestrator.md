# Orchestrator

Display:

```
═══════════════════════════════════════════════════
  FLUID-FLOW AI v0.9 WORKFLOW ACTIVATED
  All development follows the unified lifecycle.
  Reading workflow instructions now...
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
2. Read `.fluid-flow-local.json` (if present) to locate the local fluid-flow repository; check its `initiatives/` for any existing initiative folders with incomplete `metadata/state.md`
3. Based on the user's prompt, classify the intent:

| Intent | Criteria | Action |
|--------|----------|--------|
| **Question** | No development needed | Answer directly. Stop here. |
| **Continue** | Matches an existing incomplete initiative | Confirm with user, run Stages 0-3, then resume from last completed stage in its `metadata/state.md` |
| **New** | Development request, no matching initiative | Run all stages (0-7) |

---

## Stage 0: Shell Detection

Load `skills/shell-detection/shell-detection.md`. Store `SHELL_TYPE`.

## Stage 1: Workspace Detection

1. Scan for source code (`src/`, `package.json`, `*.csproj`, `go.mod`, etc.)
2. Classify: **greenfield** or **brownfield**

## Stage 2: Reverse Engineering (brownfield, run-once)

**Skip if**: greenfield, or **every** non-fluid-flow repository in the workspace already contains `reverse-engineering/reverse-engineering-timestamp.md`. If some repos have the timestamp and others do not, run the skill — it will only process the repos that are missing it.

Load `skills/reverse-engineering/reverse-engineering.md`. **Wait for user approval.**

**Continue stops here** -- resume the ongoing initiative from its last completed stage.

## Stage 3: Local Repository Detection

The local fluid-flow repository is a per-team/domain folder that holds all initiative artifacts. It is separate from `fluid-flow-ai-core` (the shared framework).

1. **Check for existing config**: Look for `.fluid-flow-local.json` in the current workspace root. If found, read its `localRepoPath` and `name` fields.
2. **If config exists**: Validate the path exists and contains an `initiatives/` subfolder. Store `LOCAL_REPO_PATH` for the session.
3. **If config is missing or invalid**: Present a multi-choice question using the IDE question tool (Cursor: `AskQuestion` / VS Code: `vscode_askQuestions`):
   - **A**: I already have a local fluid-flow repository (user provides the path)
   - **B**: Create a new one for me
4. **If A (existing)**: User provides the path. Validate it has an `initiatives/` folder. Store `LOCAL_REPO_PATH`. Write `.fluid-flow-local.json` to the workspace:
   ```json
   {
     "localRepoPath": "{user-provided-path}",
     "name": "{folder-name}"
   }
   ```
5. **If B (create new)**: Ask for:
   - **Path**: Where to create it (e.g. `/Users/me/repos/`)
   - **Name**: What to call it (e.g. `fluid-flow-data`, `fluid-flow-platform`)

   Then create:
   ```
   {path}/{name}/
     initiatives/
   ```
   Store `LOCAL_REPO_PATH`. Write `.fluid-flow-local.json` to the workspace.

6. **Local knowledge base**: Check if `{LOCAL_REPO_PATH}/knowledge-base-local/manifest.md` exists.
   - If found: read the manifest and load all files listed under its "Always Load" section into context. Store `LOCAL_KB_MANIFEST` path for the session. Report:
     ```
     Local KB: loaded ({N} domain files from {LOCAL_REPO_PATH}/knowledge-base-local/)
     ```
   - If not found: `LOCAL_KB_MANIFEST` remains empty. No error -- local KB is optional.

## Stage 4: Workflow Selection

Present workflows grouped by source. Suggest best match with `-->`. **Wait for user choice.**

```
-------------------------------------------
  AVAILABLE WORKFLOWS
-------------------------------------------

  Core:
    {N}. {workflow-name} -- {description}  {--> if suggested}

  Local:
    {N}. {workflow-name} -- {description}  {--> if suggested}

  Reply with number or name.
-------------------------------------------
```

- **Core**: workflows shipped with this repository (`workflow/`)
- **Local**: workflows added by the working repository (future support)

## Stage 5: Initiative Creation (new only)

1. Load `templates/branch-template.md` for naming convention
2. Generate a suggested name based on user's request and the template pattern
3. Present a multi-choice question using the IDE question tool (Cursor: `AskQuestion` / VS Code: `vscode_askQuestions`):
   - **A**: `{suggested-name}` (generated)
   - **B**: Other (user provides custom name)
4. Create the initiative folder structure inside the local repository:
   ```
   {LOCAL_REPO_PATH}/initiatives/{chosen-name}/
     metadata/
       state.md
       audit.md
       analytics.md
     artefacts/
   ```
5. Store `INITIATIVE_NAME` for the session

**Artifacts location**: All workflow step outputs (specs, plans, tasks, designs, code, etc.) are saved to `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/`. Workflow step files reference this path via the `LOCAL_REPO_PATH` and `INITIATIVE_NAME` session variables.

## Stage 6: Workflow Routing

1. Load `workflow/{selected}/wf-{selected}.md`
2. Execute phase->step chain: each `{N}-{phase}.md` defines its steps, each `{N}-{step}.md` is loaded and executed in order
3. **After every step completes**: run `primitives/human-gate.md`, then `primitives/state-manager.md` and `primitives/analytics.md`
4. **After the last step of each phase** (phase transition or workflow end): additionally run `primitives/kb-compliance.md`

## Stage 7: Completion

Post-implementation actions, executed in order:

1. **VAPT**: Load `primitives/vapt.md`. Run the vulnerability assessment and penetration testing. Must pass its human gate (Critical/High findings) before proceeding.
2. **Risk Report**: Load `primitives/risk-report.md`. Generate the change risk report at `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/operations/risk-report.md`.
3. **Reverse Engineering Update** (brownfield only): Load `skills/reverse-engineering/reverse-engineering.md` to refresh project-level documentation with the new changes.
4. **Analytics Reconciliation**: Load `primitives/analytics.md` to finalize initiative-level timing and metrics.
5. **Commit**: Present summary + conventional commit --> **wait for approval** --> commit.
6. **PR**: Push branch, create PR, attach risk report, present link.
7. **Retrospective** (recommended): After PR, suggest: "Run a workflow retrospective? Load `skills/retrospective/retrospective.md` for continuous improvement analysis." This is optional — the user may decline.

---

**Rules**:
- Never auto-commit. Never skip stages. Wait for user approval at gates.
- All initiative artifacts are stored in the local fluid-flow repository (`LOCAL_REPO_PATH`), never in the core repository.
- **After every step**: run `primitives/human-gate.md`, then `primitives/state-manager.md` and `primitives/analytics.md`.
- **After the last step of each phase** (phase transition): additionally run `primitives/kb-compliance.md`.

## Autonomous Skills

The following skills are **not** tied to a specific stage. The AI must load and execute them whenever the triggering condition is met, regardless of which stage or workflow step is active.

| Skill | Trigger | Behaviour |
|-------|---------|-----------|
| `skills/jira-ff-assisted/jira-ff-assisted.md` | Any interaction that reads, creates, or edits a JIRA issue (e.g. initiative creation referencing a ticket key, tasks-to-issues conversion, completion linked to an epic) | Flag the issue with the "FF Assisted" custom field. Non-blocking -- failures never halt the workflow. |
