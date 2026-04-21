---
name: ff-init
description: Initialises the Fluid-Flow workspace — detects environment, validates structure, verifies MCPs, and runs reverse engineering for brownfield repos.
execution: subagent
scope: shared
version: 1.1
last-updated: 2026-04-20
---

# FF Init

Initialize the Fluid-Flow workspace: detect environment, validate workspace structure, verify MCP servers, and run reverse engineering for brownfield repos. Results are cached to `.local-environment.json` — subsequent runs on the same day with the same workspace skip all work.

## Subagent Execution

This skill runs as a **generic (unnamed) subagent** — the orchestrator launches it via `runSubagent` **without** specifying an `agentName`. This ensures it always executes as a subagent regardless of the IDE's registered agent list. The `ff-init.agent.md` file in this folder serves only as documentation of the agent contract; it is NOT required to be registered.

### Subagent Inputs

The orchestrator launches a single subagent with (no `agentName` parameter):

1. **Skill path**: `skills/ff-init/ff-init.md` — the subagent reads and executes this file
2. **Workspace roots**: all workspace root folder paths (so the subagent can scan and classify them)
3. **Force flag**: `true` if the user explicitly invoked `/ff-init`, otherwise `false`
4. **Scope**: `full` (default) or `workspace-only`

#### Scope Modes

| Scope | When to use | What it does |
|-------|-------------|---------------|
| `full` | Engineering workflows that work with source code repos | Runs all steps including tech stack detection, source repo classification, and reverse engineering |
| `workspace-only` | Non-engineering workflows (e.g. Product Buddy) that only need FF Core, KB, and Dept FF | Skips: package managers, tech stack, source repo classification (Step 1), source repo validation (Step 2c), and reverse engineering (Step 5) |

When `scope=workspace-only`:
- Step 1 runs the detection script **without** source repo paths — only OS, shell, and IDE are stored
- Step 2a still classifies repos but does **not** require source repos; remaining folders are ignored
- Step 2c is **skipped entirely**
- Step 5 is **skipped entirely**
- `PACKAGE_MANAGERS`, `TECH_STACK`, and `SOURCE_REPOS[]` are set to empty

### Subagent Output

The subagent must return **ONLY** the structured payload defined in `return-payload.md`. Do NOT return detection details, MCP diagnostics, or RE analysis — all verbose output stays inside the subagent's context or is written to `.local-environment.json`.

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

1. Load all session variables from the cached JSON (see `return-payload.md` for the full list)
2. Display the cached summary to the user
3. **Ask the user** before proceeding:

```
Which option do you prefer?
  A) Use cached values — skip init and continue
  B) Run full init anyway — re-detect environment, re-scan workspace, re-verify MCPs, and rebuild the cache from scratch
```

- **If A**: Return the payload with status `COMPLETE` and a summary indicating cached values were used
- **If B**: Proceed to **Full Run Steps** (treat as a forced run)

The orchestrator receives the session variables without any detection, scanning, or MCP work entering its context.

```
═══════════════════════════════════════════════════
  FF INIT — Cached (valid for today)
═══════════════════════════════════════════════════
  OS: {os} | Shell: {shellType} | IDE: {ide}
  Repos: {N} source ({N} brownfield, {N} greenfield)
  MCP: {ok}/{total} OK
═══════════════════════════════════════════════════
```

---

## Full Run Steps

### Pre-Execution Briefing

Before running **any** terminal command or script, you **MUST** print a visible one-liner explanation **as a chat message** to the user describing what the command does and why it is needed. This message must appear in the conversation **before** the terminal tool call — setting the tool's `explanation` parameter alone is NOT sufficient, because the user needs context in the chat history, not only in the IDE approval dialog.

> **Rule**: Every terminal invocation in this skill must be preceded by a visible chat briefing. No exceptions.

### Step Dispatch

Execute each step sequentially by loading its file, executing it, then proceeding to the next. **Do NOT read all step files upfront** — load each one only when you reach that step.

| Step | File | Skip when `scope=workspace-only` |
|------|------|----------------------------------|
| 1 | `steps/step-1-environment-detection.md` | No (runs in reduced mode) |
| 2 | `steps/step-2-workspace-detection.md` | Partially (2c skipped) |
| 3 | `steps/step-3-mcp-check.md` | No |
| 4 | `steps/step-4-reverse-engineering.md` | Yes (skip entirely) |
| 5 | `steps/step-5-finalize-cache.md` | No |
| 6 | `steps/step-6-report.md` | No |

Each step file writes its portion to `.local-environment.json` (progressive caching). If a step returns `BLOCKED`, stop immediately and return the blocked payload.

After all steps complete, return the payload defined in `return-payload.md`.

---

## Notes

- This skill can be run standalone via the `/ff-init` slash command — it always performs a full run when invoked directly.
