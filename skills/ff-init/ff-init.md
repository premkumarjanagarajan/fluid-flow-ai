# FF Init

Initialize the Fluid-Flow workspace: detect environment, validate workspace structure, load environment variables, verify MCP servers, and run reverse engineering for brownfield repos. Results are cached to `.local-environment.json` — subsequent runs on the same day with the same workspace skip all work.

## Subagent Execution

This skill runs as a **dedicated subagent** defined in `ff-init.agent.md` (same folder). The orchestrator launches it by agent name (`ff-init`), keeping all detection, scanning, MCP verification, and RE work out of the main conversation's context window.

### Subagent Inputs

The orchestrator launches a single subagent with:

1. **Skill path**: `skills/ff-init/ff-init.md` — the subagent reads and executes this file
2. **Workspace roots**: all workspace root folder paths (so the subagent can scan and classify them)
3. **Force flag**: `true` if the user explicitly invoked `/ff-init`, otherwise `false`

### Subagent Output

The subagent must return **ONLY** the structured payload defined in the **Return Payload** section at the bottom of this file. Do NOT return detection details, MCP diagnostics, or RE analysis — all verbose output stays inside the subagent's context or is written to `.local-environment.json`.

The orchestrator parses the returned payload:
- **If `COMPLETE`**: stores all session variables, displays the summary, continues to Triage
- **If `BLOCKED`**: displays the blocker message, halts the workflow

---

## Run Decision

Before executing any steps, determine whether a full run is needed:

1. Read `{FF_CORE_PATH}/.local-environment.json`
2. Evaluate:

```
.local-environment.json:
├── Does NOT exist                              → FULL RUN
├── Missing "version" field or version < 2      → FULL RUN (schema migration)
├── "detectedAt" date is NOT today              → FULL RUN
├── "workspace.folderList" ≠ current folders    → FULL RUN (workspace changed)
├── All checks pass                             → SKIP
└── User explicitly ran /ff-init                → FULL RUN (always)
```

**Workspace change detection**: sort the current workspace root folder names alphabetically and compare against the stored `workspace.folderList` array. Any difference (added, removed, or renamed folder) triggers a full run.

---

### Skip Path

When the cache is valid (today + same workspace + version 2):

1. Load all session variables from the cached JSON (see **Return Payload** section below for the full list)
2. Return the payload with status `COMPLETE` and a summary indicating cached values were used

The orchestrator receives the session variables without any detection, scanning, or MCP work entering its context.

```
═══════════════════════════════════════════════════
  FF INIT — Cached (valid for today)
═══════════════════════════════════════════════════
  OS: {os} | Shell: {shellType} | IDE: {ide}
  Repos: {N} source ({N} brownfield, {N} greenfield)
  MCP: {ok}/{total} OK
  Env vars: {loaded} loaded
  (run /ff-init to force refresh)
═══════════════════════════════════════════════════
```

---

## Full Run Steps

### Pre-Execution Briefing

Before running **any** terminal command or script, you **MUST** print a visible one-liner explanation **as a chat message** to the user describing what the command does and why it is needed. This message must appear in the conversation **before** the terminal tool call — setting the tool's `explanation` parameter alone is NOT sufficient, because the user needs context in the chat history, not only in the IDE approval dialog.

The briefing should be concise and non-technical — just enough for the user to understand the action and feel confident approving it.

Examples of good briefings (print these as chat text before the tool call):
- _"I'll detect your OS, shell, package managers, and tech stack across all source repos."_
- _"Pulling latest changes for the FF Core repository (read-only, safe to run)."_
- _"Loading environment variables from .env files into the current shell session."_
- _"Checking connectivity to MCP servers (HTTP ping and command availability)."_

> **Rule**: Every terminal invocation in this skill must be preceded by a visible chat briefing. No exceptions.

### Step 1 — Environment Detection

Load `skills/environment-detection/environment-detection.md` and execute it.

Pass all **source repo paths** (identified in Step 2a) as arguments to the detection script so it can scan them for tech stack markers and classify them as brownfield/greenfield in a single pass:

```bash
bash skills/environment-detection/scripts/environment-detection.bash /path/to/repo1 /path/to/repo2 ...
```

The script outputs a **single JSON object** containing:
- `os`, `shellType`, `packageManagers`, `techStack`
- `sourceRepos` — array with each repo's name, type (brownfield/greenfield), and RE timestamp

Parse the JSON output and store session variables:
- `OS` (darwin / linux / windows)
- `SHELL_TYPE` (bash / powershell)
- `IDE` (cursor / vscode) — inferred by the AI from the runtime context
- `PACKAGE_MANAGERS` (comma-separated list)
- `TECH_STACK` (comma-separated list)
- `SOURCE_REPOS[]` — from the `sourceRepos` array in the JSON output

**Write progressive cache** after this step — update `{FF_CORE_PATH}/.local-environment.json` with the `environment` block so progress is preserved if later steps fail.

### Step 2 — Workspace Detection

The workspace is a multi-root IDE workspace with separate repos cloned side by side. Three repos are mandatory; at least one source repo is required.

#### 2a — Identify repos

Scan all workspace root folders and classify each by name or marker:

| Rule | Repo type | Variable |
|------|-----------|----------|
| Folder name is `fluid-flow-ai` | FF Core | `FF_CORE_PATH` |
| Folder name is `betsson-kb-docs` | Enterprise KB | `KB_PATH` |
| Contains `.department-fluid-flow.json` | Department FF | `DEPT_FF_PATH` |
| None of the above | Source repo | `SOURCE_REPOS[]` |

If `DEPT_FF_PATH` is unset (no repo contained `.department-fluid-flow.json`), apply a **fallback heuristic** before halting:

1. Scan `SOURCE_REPOS[]` for any repo that contains an `initiatives/` directory at its root
2. If exactly one candidate is found, it is likely a department repo missing its config file. Offer to scaffold it:

```
  Department repo detected by structure: {candidate folder name}
  Missing: .department-fluid-flow.json

  Scaffolding from template...
```

3. Copy `{FF_CORE_PATH}/local-fluid-flow/.department-fluid-flow.json` into the candidate repo root
4. Prompt the user to configure the `department` and `name` fields (pre-fill `name` from the repo folder name)
5. Write the configured values, reclassify the repo as Department FF (`DEPT_FF_PATH`), remove it from `SOURCE_REPOS[]`, and continue
6. If zero or multiple candidates are found, do not attempt remediation — fall through to the halt below

If any of the three mandatory repos is still missing after the fallback, return `BLOCKED`:

```
  Workspace Validation: FAIL
  Missing: {list of missing repo types}

  Required workspace structure:
    fluid-flow-ai/                 (FF core — contains orchestrator.md)
    betsson-kb-docs/               (enterprise KB — contains knowledge/)
    {dept}-fluid-flow/             (department repo — contains .department-fluid-flow.json)
    {source-repo}/                 (at least 1 working repo)
```

#### 2b — Auto-update immutable repos

FF Core and the Enterprise KB are immutable — development teams do not modify them. Pull latest `main` for both, using the appropriate shell from `SHELL_TYPE` (Step 1).

**Briefing**: Before each `git pull`, print a visible chat message: _"Pulling latest changes for {repo name} (read-only repo, safe to run)."_ — this must appear in the conversation before the terminal tool call.

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

#### 2c — Find source repos

Validate at least 1 source repo is present in `SOURCE_REPOS[]`. If none found, return `BLOCKED`:

```
  Workspace Validation: FAIL
  No source code repositories found. Add at least one working repo to the workspace.
```

#### 2d — Read department config

Read `{DEPT_FF_PATH}/.department-fluid-flow.json`. Validate the file is valid JSON and that `department` is set (not `"CHANGE_ME"` or empty). If validation fails, prompt the user to provide the value before continuing.

Store:
- `DEPARTMENT` — department identifier (used for KB overlay routing)

If `knowledgeBaseLocal` is `true`, check if `{DEPT_FF_PATH}/knowledge-base-local/manifest.md` exists:
- If found: read the manifest and load all files under its "Always Load" section. Store `LOCAL_KB_MANIFEST` path. Report: `Local KB: loaded ({N} domain files)`
- If not found: `LOCAL_KB_MANIFEST` remains empty. No error — local KB is optional even when flagged.

#### 2e — Source repo classification (already done)

Repo classification (brownfield / greenfield) and RE timestamp extraction are performed by the environment-detection script in Step 1. The `sourceRepos` array from its JSON output already contains each repo's name, type, and `reTimestamp`.

Build the sorted `folderList` array from all workspace root folder names (for future change detection).

**Write progressive cache** after this step — update `{FF_CORE_PATH}/.local-environment.json` with the `workspace` block.

### Step 3 — Env Loading

Locate `.env` files in both repos:

| Source | Path |
|--------|------|
| Core | `{FF_CORE_PATH}/.env` |
| Department | `{DEPT_FF_PATH}/.env` |

For each repo that has a `.env.example` but no `.env`:
1. Copy `.env.example` → `.env`
2. Inform the user to fill in their tokens

The `load-env.sh` script accepts **file paths as arguments** — pass both `.env` files in a single call. Department vars override core vars when the same key appears in both.

**Briefing**: Before running the load-env script, print a visible chat message: _"Loading environment variables from .env files into the current shell session (session-only, nothing is persisted to disk)."_ — this must appear in the conversation before the terminal tool call.

**bash** (`OS` = `darwin` or `linux`):

```bash
source "{FF_CORE_PATH}/skills/ff-init/scripts/load-env.sh" "{FF_CORE_PATH}/.env" "{DEPT_FF_PATH}/.env"
```

If the department has no `.env`, pass only the core one:

```bash
source "{FF_CORE_PATH}/skills/ff-init/scripts/load-env.sh" "{FF_CORE_PATH}/.env"
```

**powershell** (`OS` = `windows`):

```powershell
. "{FF_CORE_PATH}\skills\ff-init\scripts\load-env.ps1" "{FF_CORE_PATH}\.env" "{DEPT_FF_PATH}\.env"
```

The script defaults to **session-only** loading. No user prompt is needed. If the user wants persistence, they can re-run with `--persist` manually at any time.

The script outputs a `LOAD_ENV_RESULT` JSON line at the end — parse it for loaded/skipped counts.

Store loaded/skipped counts (persisted is always `false` during init).

**Write progressive cache** after this step — update `{FF_CORE_PATH}/.local-environment.json` with the `envVars` block.

### Step 4 — MCP Check

**Briefing**: Before running MCP verification commands, print a visible chat message: _"Checking connectivity to configured MCP servers (lightweight HTTP pings and command lookups — no data is sent)."_ — this must appear in the conversation before the terminal tool call.

Load `skills/mcp-check/mcp-check.md` and execute it. The skill will:

1. Read MCP configs from both core and department repos (merged, department overrides)
2. Scaffold `.env` from `.env.example` if missing in either repo
3. Verify each server (HTTP connectivity or command existence)
4. On failure, diagnose the error category and present a targeted fix guide
5. Ask the user: **Retry** / **Continue without** / **Stop and fix**

Store `MCP_SERVERS_OK[]` for downstream use.

**Write progressive cache** after this step — update `{FF_CORE_PATH}/.local-environment.json` with the `mcp` block.

### Step 5 — Reverse Engineering

For each brownfield source repo, check whether `reverse-engineering/reverse-engineering-timestamp.md` exists **in that repo's root**.

- **If the timestamp file is missing** → RE is **mandatory**. Load `skills/reverse-engineering/reverse-engineering.md` and execute it. There are **no other valid reasons to skip** — scope, feature size, JIRA context, or "existing familiarity" are never grounds for bypass.
- **If the timestamp file exists** → skip that repo (already done). Store its timestamp.
- **If all source repos are greenfield** → skip this step entirely.

When some repos have the timestamp and others do not, run the skill — it will only process the repos that are missing it.

**Wait for user approval** before proceeding.

Store RE status per repo (timestamp or `null` if not yet done).

**Write progressive cache** after this step — update the `sourceRepos[].reTimestamp` entries in `{FF_CORE_PATH}/.local-environment.json`.

### Step 6 — Finalize Cache

By this point, the cache file (`{FF_CORE_PATH}/.local-environment.json`) already has partial data from progressive writes in Steps 1–5. Finalize it with any remaining fields and bump the `version` and `detectedAt` timestamp to confirm a complete run.

The final cache must contain the complete state:

```json
{
  "version": 2,
  "detectedAt": "{ISO-8601 timestamp}",
  "environment": {
    "os": "{OS}",
    "shellType": "{SHELL_TYPE}",
    "ide": "{IDE}",
    "packageManagers": "{PACKAGE_MANAGERS}",
    "techStack": "{TECH_STACK}"
  },
  "workspace": {
    "ffCorePath": "{FF_CORE_PATH folder name}",
    "kbPath": "{KB_PATH folder name}",
    "deptFfPath": "{DEPT_FF_PATH folder name}",
    "department": "{DEPARTMENT}",
    "localKbLoaded": {true|false},
    "localKbFiles": {N},
    "sourceRepos": [
      { "name": "{repo name}", "type": "{brownfield|greenfield}", "reTimestamp": "{ISO-8601|null}" }
    ],
    "folderList": ["{sorted list of all workspace root folder names}"]
  },
  "mcp": {
    "checkedAt": "{ISO-8601 timestamp}",
    "serversOk": ["{server names}"],
    "serversFailed": ["{server names}"]
  },
  "envVars": {
    "loadedAt": "{ISO-8601 timestamp}",
    "loaded": {N},
    "skipped": {N},
    "persisted": {true|false}
  }
}
```

### Step 7 — Report

Display the full summary:

```
═══════════════════════════════════════════════════
  FF INIT — Complete
═══════════════════════════════════════════════════
  Environment:
    OS: {os} | Shell: {shellType} | IDE: {ide}
    Packages: {packageManagers}
    Tech: {techStack}

  Workspace:
    FF Core       : {ffCorePath} (updated)
    Enterprise KB : {kbPath} (updated)
    Department FF : {deptFfPath}
    Department    : {department}
    Local KB      : {loaded (N files) | not configured}
    Source repos  : {name} ({type}), ...

  MCP: {ok}/{total} servers OK
  Env: {loaded} loaded, {skipped} skipped, persisted: {yes|no}
  RE:  {N} repos scanned, {N} pending

  Cached to .local-environment.json
  (run /ff-init to force refresh)
═══════════════════════════════════════════════════
```

---

## Return Payload

When called as a subagent by the orchestrator, return **ONLY** this structured payload. Do NOT return detection details, MCP diagnostics, RE analysis, or any verbose output. All detailed findings stay in the subagent context or in `.local-environment.json`.

```
FF-INIT: COMPLETE | BLOCKED

Session Variables:
  OS={value}
  SHELL_TYPE={value}
  IDE={value}
  PACKAGE_MANAGERS={value}
  TECH_STACK={value}
  FF_CORE_PATH={value}
  KB_PATH={value}
  DEPT_FF_PATH={value}
  DEPARTMENT={value}
  LOCAL_KB_MANIFEST={value or empty}
  SOURCE_REPOS={name:type:reStatus, name:type:reStatus, ...}
  MCP_SERVERS_OK={comma-separated list}

Summary:
  {2-3 line status: cached vs fresh run, repos found, MCP status}

Blockers (if BLOCKED):
  {what's missing and what the user needs to do}
```

---

## Notes

- This skill can be run standalone via the `/ff-init` slash command — it always performs a full run when invoked directly.
- The `load-env.sh` / `load-env.ps1` scripts are located in `{FF_CORE_PATH}/skills/ff-init/scripts/`. They accept `.env` file paths as arguments — no department-specific copy is needed.
- Variables with placeholder values (containing `your-` or `CHANGE_ME`) are automatically skipped by the load-env scripts.
- The environment-detection script outputs JSON and accepts workspace root paths as arguments. It performs tech stack detection and repo classification in a single pass.
- **Progressive caching**: each step writes its portion of `.local-environment.json` as it completes. If a later step fails, the next run can detect what was already cached and potentially skip completed steps.
- The `.local-environment.json` file is gitignored — it persists locally across `git pull` and is never committed.
- When the orchestrator calls this skill as a subagent, the subagent handles caching internally and returns the structured payload regardless of whether it ran a full init or used cached values.
