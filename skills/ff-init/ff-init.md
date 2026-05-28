---
name: ff-init
description: Initialises the Fluid-Flow workspace — detects environment, validates structure, verifies MCPs, and runs reverse engineering for brownfield repos.
execution: subagent
scope: shared
version: 1.2
last-updated: 2026-04-21
---

# FF Init

Detect environment, validate workspace structure, verify MCP servers, and run reverse engineering for brownfield repos. Results cached to `.local-environment.json` — same-day runs with the same workspace skip all work.

## Subagent Contract

Runs as an **generic (unnamed) subagent** (`runSubagent` without `agentName`). The `ff-init.agent.md` file is documentation only — not registered.

**Inputs:** skill path, workspace root paths, force flag (`true` when `/ff-init`), scope (`full` | `workspace-only`), agent MCP dependencies (optional list from calling agent's `dependencies.mcps`).

**Output:** structured payload from `return-payload.md` only. No detection details, MCP diagnostics, or RE analysis — verbose output stays in subagent context or `.local-environment.json`.

- `COMPLETE` → orchestrator stores session variables, continues to Triage
- `BLOCKED` → orchestrator displays blocker, halts

### Scope Modes

| Scope | Use case | Behaviour |
|-------|----------|-----------|
| `full` | Engineering workflows with source repos | All steps, including tech stack, source repo classification, RE |
| `workspace-only` | Non-engineering (e.g. Product Buddy) | Step 1 reduced (OS/shell/IDE only), Step 2c skipped, Step 4 skipped. `PACKAGE_MANAGERS`, `TECH_STACK`, `SOURCE_REPOS[]` = empty |

### Agent MCP Dependencies

When called by an agent that declares `dependencies.mcps` in its `.agent.md` file, the orchestrator passes that list to `ff-init`. These are the MCPs the agent **needs** to function fully.

**How it flows:**
1. The orchestrator reads the calling agent's `.agent.md` → extracts `dependencies.mcps[]`
2. Passes the list to the `ff-init` subagent as `AGENT_MCP_DEPS`
3. `ff-init` forwards `AGENT_MCP_DEPS` to Step 3 (MCP Check)
4. `mcp-check` uses it to mark those MCPs as `[recommended]` and pre-select them

If `AGENT_MCP_DEPS` is empty or not provided, `mcp-check` behaves as before (nothing pre-recommended).

---

## Run Decision

> **Tool rule:** Always use `read_file` to load `{FF_CORE_PATH}/.local-environment.json` directly by absolute path. **Never** use `file_search` or `grep_search` — dotfiles are excluded from glob-based search indexes and will not be found.

Read `{FF_CORE_PATH}/.local-environment.json` and evaluate:

```
├── Does NOT exist                              → FULL RUN
├── Missing "version" or version < 2            → FULL RUN
├── "detectedAt" date ≠ today                   → FULL RUN
├── "workspace.folderList" ≠ current folders    → FULL RUN
├── All checks pass                             → SKIP
└── User ran /ff-init                           → FULL RUN (always)
```

Workspace change = sorted folder names differ from stored `folderList`.

### Skip Path

When cache is valid: load session variables from cache.

**Before offering the skip option**, check if `AGENT_MCP_DEPS` was provided. If so, compare it against the cached `mcp.serversOk[]` in `.local-environment.json`:
- If ALL agent-required MCPs are already in `serversOk` → offer the skip option below
- If ANY agent-required MCPs are MISSING from `serversOk` → **do NOT offer skip**. Instead, display: *"Cache is valid but your agent requires MCPs that aren't configured yet. Running MCP setup."* Then proceed directly to Step 3 (MCP Check) only — skip Steps 1, 2, 4 but run Step 3, 5, 6.

If skip is offered, display cached summary, then ask:

```
  A) Use cached values — skip init and continue
  B) Run full init — re-detect everything from scratch
```

**A →** return `COMPLETE` with cached values. **B →** proceed to Full Run.

---

## Full Run

> **Rule:** Before every terminal command, print a one-liner explanation **as a chat message** (not just the tool's `explanation` param). No exceptions.

Execute steps sequentially — load each file only when you reach it. If any step returns `BLOCKED`, stop and return the blocked payload.

| Step | File | Skip when `workspace-only` |
|------|------|----------------------------|
| 1 | `steps/step-1-environment-detection.md` | Reduced mode |
| 2 | `steps/step-2-workspace-detection.md` | 2c skipped |
| 3 | `steps/step-3-mcp-check.md` | No |
| 4 | `steps/step-4-reverse-engineering.md` | Yes |
| 5 | `steps/step-5-finalize-cache.md` | No |
| 6 | `steps/step-6-report.md` | No |

Each step progressively writes to `.local-environment.json`. After all steps, return the payload from `return-payload.md`.

Standalone via `/ff-init` → always full run.
