# Step 3 — Env Loading

**Scope behavior**: Runs in both `full` and `workspace-only` modes (no differences).

**Session variables produced**: loaded/skipped counts, persisted flag.

**Progressive cache**: Writes the `envVars` block to `.local-environment.json`.

---

Locate `.env` files in both repos:

| Source | Path |
|--------|------|
| Core | `{FF_CORE_PATH}/.env` |
| Department | `{DEPT_FF_PATH}/.env` |

For each repo that has a `.env.example` but no `.env`:
1. Copy `.env.example` → `.env`
2. Inform the user to fill in their tokens

The `load-env.sh` script accepts **file paths as arguments** — pass both `.env` files in a single call. Department vars override core vars when the same key appears in both.

**Briefing**: Before running the load-env script, print a visible chat message: _"Loading environment variables from .env files and persisting them to your shell profile (~/.zshrc or equivalent). You will need to restart VS Code afterwards so MCP servers can pick up the new values."_ — this must appear in the conversation before the terminal tool call.

The script runs with `--persist` by default so that environment variables survive across terminal sessions and are available to VS Code's MCP client via `${env:...}` references.

**bash** (`OS` = `darwin` or `linux`):

```bash
source "{FF_CORE_PATH}/skills/ff-init/scripts/load-env.sh" --persist "{FF_CORE_PATH}/.env" "{DEPT_FF_PATH}/.env"
```

If the department has no `.env`, pass only the core one:

```bash
source "{FF_CORE_PATH}/skills/ff-init/scripts/load-env.sh" --persist "{FF_CORE_PATH}/.env"
```

**powershell** (`OS` = `windows`):

```powershell
. "{FF_CORE_PATH}\skills\ff-init\scripts\load-env.ps1" -Persist "{FF_CORE_PATH}\.env" "{DEPT_FF_PATH}\.env"
```

The script outputs a `LOAD_ENV_RESULT` JSON line at the end — parse it for loaded/skipped counts.

Store loaded/skipped counts (persisted is always `true` during init).

After env loading completes, display a restart notice to the user:

```
  ⚠️  VS Code restart required
  Environment variables have been persisted to your shell profile.
  Please quit and reopen VS Code (Cmd+Q / Ctrl+Q) so MCP servers
  can read the updated tokens via ${env:...}.
```

**Write progressive cache** after this step — update `{FF_CORE_PATH}/.local-environment.json` with the `envVars` block.

## Script Locations

- `{FF_CORE_PATH}/skills/ff-init/scripts/load-env.sh` (bash/zsh)
- `{FF_CORE_PATH}/skills/ff-init/scripts/load-env.ps1` (PowerShell)

Variables with placeholder values (containing `your-` or `CHANGE_ME`) are automatically skipped by the load-env scripts.
