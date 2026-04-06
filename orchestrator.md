# Orchestrator

Display:

```
═══════════════════════════════════════════════════
  FLUID-FLOW AI v0.9.1 WORKFLOW ACTIVATED
  All development follows the unified lifecycle.
  Reading workflow instructions now...
═══════════════════════════════════════════════════
```

## Stage 0A: Environment Detection

Load `skills/environment-detection/environment-detection.md`. Store session variables:

- `SHELL_TYPE` (bash / powershell)
- `OS` (darwin / linux / windows)
- `IDE` (cursor / vscode) — inferred by the AI from the runtime context
- `PACKAGE_MANAGERS` (comma-separated list)
- `TECH_STACK` (comma-separated list)

Display:

```
  Environment:
    OS            : {OS}
    Shell         : {SHELL_TYPE}
    IDE           : {IDE}
    Package mgrs  : {PACKAGE_MANAGERS}
    Tech stack    : {TECH_STACK}
```

## Stage 0B: Workspace Detection

The workspace is a multi-root IDE workspace with separate repos cloned side by side. Three repos are mandatory; at least one source repo is required.

### Step 1 — Identify repos

Scan all workspace root folders and classify each by its markers:

| Marker | Repo type | Variable |
|--------|-----------|----------|
| Contains `orchestrator.md` | FF Core | `FF_CORE_PATH` |
| Contains `knowledge/` directory | Enterprise KB | `KB_PATH` |
| Contains `.department-fluid-flow.json` | Department FF | `DEPT_FF_PATH` |
| None of the above | Source repo | `SOURCE_REPOS[]` |

If any of the three mandatory repos is missing, halt:

```
  Workspace Validation: FAIL
  Missing: {list of missing repo types}

  Required workspace structure:
    fluid-flow-ai/                 (FF core — contains orchestrator.md)
    betsson-kb-docs/               (enterprise KB — contains knowledge/)
    {dept}-fluid-flow/             (department repo — contains .department-fluid-flow.json)
    {source-repo}/                 (at least 1 working repo)
```

### Step 2 — Auto-update immutable repos

FF Core and the Enterprise KB are immutable — development teams do not modify them. Pull latest `main` for both, using the appropriate shell from `SHELL_TYPE` (Stage 0A):

**Bash / Zsh** (`SHELL_TYPE=bash`):

```bash
cd "$FF_CORE_PATH" && git pull origin main
cd "$KB_PATH" && git pull origin main
```

**PowerShell** (`SHELL_TYPE=powershell`):

```powershell
Push-Location $FF_CORE_PATH; git pull origin main; Pop-Location
Push-Location $KB_PATH; git pull origin main; Pop-Location
```

If either pull fails (e.g. network, auth), warn but do not halt — continue with the local version.

### Step 3 — Find source repos

Validate at least 1 source repo is present in `SOURCE_REPOS[]`. If none found, halt:

```
  Workspace Validation: FAIL
  No source code repositories found. Add at least one working repo to the workspace.
```

### Step 4 — Read department config

Read `{DEPT_FF_PATH}/.department-fluid-flow.json`. Store:
- `DEPARTMENT` — department identifier (used for KB overlay routing)

If `knowledgeBaseLocal` is `true`, check if `{DEPT_FF_PATH}/knowledge-base-local/manifest.md` exists:
- If found: read the manifest and load all files under its "Always Load" section. Store `LOCAL_KB_MANIFEST` path. Report: `Local KB: loaded ({N} domain files)`
- If not found: `LOCAL_KB_MANIFEST` remains empty. No error — local KB is optional even when flagged.

### Step 5 — Classify source repos

For each repo in `SOURCE_REPOS[]`, scan for source code (`src/`, `package.json`, `*.csproj`, `go.mod`, etc.):
- If source code found: **brownfield**
- If empty or no code markers: **greenfield**

Store classification per repo.

Display:

```
  Workspace:
    FF Core       : {FF_CORE_PATH folder name} (updated to latest main)
    Betsson KB    : {KB_PATH folder name} (updated to latest main)
    Department FF : {DEPT_FF_PATH folder name}
    Department    : {DEPARTMENT}
    Local KB      : {loaded (N files) | not configured}
    Source repos  : {repo1} ({brownfield|greenfield}), {repo2} ({brownfield|greenfield})
```

---

## MCP Check

1. Based on `IDE`, read the appropriate MCP config:
   - Cursor: `{DEPT_FF_PATH}/.cursor/mcp.json`
   - VS Code: `{DEPT_FF_PATH}/.vscode/mcp.json`
2. For each configured server, verify it is running and accessible
3. Report status:

```
  MCP Status:
    {server-name}: OK | FAIL ({error})
```

4. If any server fails: present a multi-choice question using the IDE question tool (Cursor: `AskQuestion` / VS Code: `vscode_askQuestions`):
   - **A**: Continue without failed server(s)
   - **B**: Stop and fix

---

## Triage

1. Read all `{FF_CORE_PATH}/workflow/*/wf-*.md` frontmatter to know available workflows
2. Check `{DEPT_FF_PATH}/initiatives/` for any existing initiative folders with incomplete `metadata/state.md`
3. Based on the user's prompt, classify the intent:

| Intent | Criteria | Action |
|--------|----------|--------|
| **Question** | No development needed | Answer directly. Stop here. |
| **Continue** | Matches an existing incomplete initiative | Confirm with user, then resume from last completed stage in its `metadata/state.md` |
| **New** | Development request, no matching initiative | Run all stages (1-5) |

---

## Stage 1: Reverse Engineering (brownfield, run-once)

**Skip if**: all source repos are greenfield, or **every** brownfield source repo already contains `reverse-engineering/reverse-engineering-timestamp.md`. If some repos have the timestamp and others do not, run the skill — it will only process the repos that are missing it.

Load `skills/reverse-engineering/reverse-engineering.md`. **Wait for user approval.**

**Continue stops here** — resume the ongoing initiative from its last completed stage.

## Stage 2: Workflow Selection

Present workflows grouped by source. Suggest best match with `-->`, using `TECH_STACK` and `DEPARTMENT` to inform the suggestion. **Wait for user choice.**

```
-------------------------------------------
  AVAILABLE WORKFLOWS
-------------------------------------------

  Core:
    {N}. {workflow-name} -- {description}  {--> if suggested}

  Department:
    {N}. {workflow-name} -- {description}  {--> if suggested}

  Reply with number or name.
-------------------------------------------
```

- **Core**: workflows shipped with `fluid-flow-ai` (`{FF_CORE_PATH}/workflow/`)
- **Department**: workflows added by the department repo (`{DEPT_FF_PATH}/workflows/`)

## Stage 3: Initiative Creation (new only)

1. Load `{FF_CORE_PATH}/templates/branch-template.md` for naming convention
2. Generate a suggested name based on user's request and the template pattern
3. Present a multi-choice question using the IDE question tool (Cursor: `AskQuestion` / VS Code: `vscode_askQuestions`):
   - **A**: `{suggested-name}` (generated)
   - **B**: Other (user provides custom name)
4. Create the initiative folder structure inside the department repo:
   ```
   {DEPT_FF_PATH}/initiatives/{chosen-name}/
     metadata/
       state.md
       audit.md
       analytics.md
     artefacts/
   ```
5. Store `INITIATIVE_NAME` for the session

**Artifacts location**: All workflow step outputs are saved to `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/`. Workflow step files reference this path via the `DEPT_FF_PATH` and `INITIATIVE_NAME` session variables.

## Stage 4: Workflow Routing

1. Load `{FF_CORE_PATH}/workflow/{selected}/wf-{selected}.md`
2. Execute phase->step chain: each `{N}-{phase}.md` defines its steps, each `{N}-{step}.md` is loaded and executed in order
3. **After every step completes**: run `primitives/human-gate.md`, then `primitives/state-manager.md` and `primitives/analytics.md`
4. **After the last step of each phase** (phase transition or workflow end): additionally run `primitives/kb-compliance.md`

## Stage 5: Completion

Post-implementation actions, executed in order:

1. **VAPT**: Load `primitives/vapt.md`. Run the vulnerability assessment and penetration testing. Must pass its human gate (Critical/High findings) before proceeding.
2. **Risk Report**: Load `primitives/risk-report.md`. Generate the change risk report at `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/operations/risk-report.md`.
3. **Reverse Engineering Update** (brownfield only): Load `skills/reverse-engineering/reverse-engineering.md` to refresh project-level documentation with the new changes.
4. **Analytics Reconciliation**: Load `primitives/analytics.md` to finalise initiative-level timing and metrics.
5. **Commit**: Present summary + conventional commit --> **wait for approval** --> commit.
6. **PR**: Push branch, create PR, attach risk report, present link.
7. **Retrospective** (recommended): After PR, suggest: "Run a workflow retrospective? Load `skills/retrospective/retrospective.md` for continuous improvement analysis." This is optional — the user may decline.

---

**Rules**:
- Never auto-commit. Never skip stages. Wait for user approval at gates.
- All initiative artifacts are stored in the department fluid-flow repository (`DEPT_FF_PATH`), never in the core repository.
- **After every step**: run `primitives/human-gate.md`, then `primitives/state-manager.md` and `primitives/analytics.md`.
- **After the last step of each phase** (phase transition): additionally run `primitives/kb-compliance.md`.

## Autonomous Skills

The following skills are **not** tied to a specific stage. The AI must load and execute them whenever the triggering condition is met, regardless of which stage or workflow step is active.

| Skill | Trigger | Behaviour |
|-------|---------|-----------|
| `skills/jira-ff-assisted/jira-ff-assisted.md` | Any interaction that reads, creates, or edits a JIRA issue (e.g. initiative creation referencing a ticket key, tasks-to-issues conversion, completion linked to an epic) | Flag the issue with the "FF Assisted" custom field. Non-blocking — failures never halt the workflow. |
