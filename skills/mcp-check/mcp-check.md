---
name: mcp-check
description: Lets the user select which MCPs to enable, generates mcp.json, and verifies connectivity.
execution: inline
scope: shared
version: 2.0
last-updated: 2026-04-20
---

# MCP Check

Select which MCP servers to enable, generate a local `mcp.json`, and verify connectivity. The generated file is gitignored — it's local to the user's machine and regenerated on each run.

## Pre-Execution: Resolve IDE config path

Before any step, determine the target `mcp.json` path based on the user's IDE:

1. Read `{FF_CORE_PATH}/.local-environment.json` and extract `environment.ide`.
2. Set `MCP_CONFIG_DIR` based on the value:

| `environment.ide` | `MCP_CONFIG_DIR` | Target file |
|-------------------|------------------|-------------|
| `vscode` | `{FF_CORE_PATH}/.vscode` | `{FF_CORE_PATH}/.vscode/mcp.json` |
| `cursor` | `{FF_CORE_PATH}/.cursor` | `{FF_CORE_PATH}/.cursor/mcp.json` |

3. If `.local-environment.json` is missing or has no `environment.ide` value, **ask the user**:

```
Which IDE are you using?
  A) VS Code
  B) Cursor
```

Use this resolved path (`MCP_CONFIG_DIR/mcp.json`) for all references to `mcp.json` throughout this skill.

---

## Pre-Execution Briefing

Before running **any** terminal command in this skill, you **MUST** print a visible one-liner explanation **as a chat message** to the user. This must appear in the conversation **before** the terminal tool call — setting the tool's `explanation` parameter alone is NOT sufficient.

> **Rule**: Every terminal invocation in this skill must be preceded by a visible chat briefing. No exceptions.

---

## Step 1 — Discover available MCPs

Scan both repos for MCP definition files:

| Source | Path | Tag |
|--------|------|-----|
| Core | `{FF_CORE_PATH}/mcps/*.md` | `[core]` |
| Core (local) | `{FF_CORE_PATH}/mcps/local/*.md` | `[core/local]` |
| Department | `{DEPT_FF_PATH}/mcps/*.md` (if exists) | `[dept]` |
| Department (local) | `{DEPT_FF_PATH}/mcps/local/*.md` (if exists) | `[dept/local]` |

For each MCP file found, read:
- The `# MCP: {name}` heading → display name
- The `## Description` section → one-line summary
- The `## Config` JSON block → the config to write if selected

Build a list of all available MCPs with their source tag.

---

## Step 2 — Check existing mcp.json

Read the current `{MCP_CONFIG_DIR}/mcp.json` if it exists. Extract the list of server names already configured — these will be **pre-selected** in the next step.

If no `mcp.json` exists, nothing is pre-selected.

---

## Step 3 — Ask the user

Use the IDE question tool with multi-select enabled:

```
Which MCP servers do you want to enable?
(Pre-selected items are already configured)

  ☑ github          — GitHub repos, PRs, issues, code search           [core]
  ☑ atlassian       — Jira & Confluence access                         [core]
  ☐ figma           — Figma remote endpoint (OAuth)                    [core]
  ☐ aws-document-loader — AWS Labs document loader                     [core]
  ☐ figma-dev-mode  — Figma desktop Dev Mode (local)                   [core/local]
  ☐ playwright      — Browser automation                               [core/local]
  ☐ {name}          — {description}                                    [dept]
```

> **Do not hardcode this list** — always build it from the scan in Step 1. The example above shows a typical result.

If the user's selection matches exactly what's already in `mcp.json` (same servers, no additions, no removals):
- Print: `No changes — MCP configuration is up to date.`
- Skip to Step 5 (verify).

If the user selects nothing:
- Print: `No MCPs selected — skipping mcp.json generation.`
- Store `MCP_SERVERS_OK[]` as empty and return.

---

## Step 4 — Generate mcp.json

For each selected MCP:

1. Read its `## Config` JSON block from the MCP definition file.
2. **Version pinning** (npm packages only): If the config contains `"command": "npx"` and the `args` array includes a package name without an explicit version:
   a. Run `npm view <package-name> version` to get the latest published version.
   b. Replace the unversioned entry with `<package-name>@<latest>`.
   c. If `npm view` fails, keep the unversioned form and note a ⚠️ in the report.

3. Merge all selected configs under the correct top-level key **based on the detected IDE**:
   - **VS Code** (`IDE=vscode`): use `"servers"` as the top-level key
   - **Cursor** (`IDE=cursor`): use `"mcpServers"` as the top-level key

4. Write the result to `{MCP_CONFIG_DIR}/mcp.json`, formatted with 2-space indentation. **This overwrites the file completely** — only selected servers are included.

**Example output (VS Code):**
```json
{
  "servers": {
    "atlassian": {
      "type": "http",
      "url": "https://mcp.atlassian.com/v1/mcp"
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github@1.2.0"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${env:GITHUB_PERSONAL_ACCESS_TOKEN}"
      }
    }
  }
}
```

**Example output (Cursor):**
```json
{
  "mcpServers": {
    "atlassian": {
      "type": "http",
      "url": "https://mcp.atlassian.com/v1/mcp"
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github@1.2.0"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${env:GITHUB_PERSONAL_ACCESS_TOKEN}"
      }
    }
  }
}
```

Report what was generated:

```
  MCP Configuration:
    ✅ atlassian (http)
    ✅ github (npx → pinned to 1.2.0)
    ⚠️  figma (npm view failed — using unversioned)

  Written to: {MCP_CONFIG_DIR}/mcp.json
```

---

## Step 5 — Verify each server

**Briefing**: _"Checking connectivity to configured MCP servers (lightweight HTTP pings and command lookups — no data is sent)."_

For each server in the generated `mcp.json`:

- **HTTP servers** (have `url` property): make a HEAD or GET request to the URL
- **stdio servers** (have `command` property): verify the command exists (`which {command}` on bash, `Get-Command {command}` on PowerShell)

Record result per server: `OK` or `FAIL` with error category.

### Report status

```
  MCP Status:
    {server-name}: OK
    {server-name}: FAIL ({error category})
```

If all servers pass, MCP Check is complete.

---

## Step 6 — Diagnose failures

For each failed server, classify the error and present the matching troubleshooting guide:

#### Missing environment variable

The server config references `${env:VAR_NAME}` but the variable is empty or unset.

```
  {server-name}: FAIL (missing env var: {VAR_NAME})

  Fix:
    1. Set the environment variable in your shell profile (~/.zshrc or equivalent)
       export {VAR_NAME}=your-value
    2. Restart VS Code so the MCP server can pick up the new value
    3. See the MCP definition file (mcps/*.md) for instructions on where to get the value
```

#### Missing command / dependency

The server uses `command: {cmd}` but the command is not found on PATH.

```
  {server-name}: FAIL (command not found: {cmd})

  Fix:
    npm-based (npx):  npm install -g {package}
    Python-based (uvx): pip install {package}
    Other: install {cmd} and ensure it is on your PATH
```

#### Authentication failure (401 / 403)

```
  {server-name}: FAIL (auth error: {status code})

  Fix:
    Token-based servers:
      1. Check that the environment variable has a valid, non-expired token
      2. Regenerate the token if needed (see the MCP definition file for links)

    OAuth servers (Atlassian, Slack):
      1. The browser auth flow should trigger automatically on first use
      2. If it doesn't, check your browser for blocked popups
      3. Try disconnecting and reconnecting the server in IDE settings
```

#### Network / connection error

```
  {server-name}: FAIL (connection error: {details})

  Fix:
    1. Check your internet connection
    2. Verify the URL is correct in the MCP config
    3. Check if a VPN is required to reach {url}
    4. Try opening {url} in your browser
```

#### Conflict with global MCP config

Based on `IDE`, check for a global config at:

**Cursor** (`IDE=cursor`):
- macOS: `~/.cursor/mcp.json`
- Windows: `%APPDATA%\Cursor\mcp.json`

**VS Code** (`IDE=vscode`):
- macOS: `~/.vscode/mcp.json` and `~/Library/Application Support/Code/User/settings.json` (look for `mcp.servers` key)
- Windows: `%APPDATA%\Code\User\settings.json` (look for `mcp.servers` key)
- Linux: `~/.config/Code/User/settings.json` (look for `mcp.servers` key)

If a global config defines servers that overlap:

```
  {server-name}: FAIL (possible conflict with global MCP config)

  A global mcp.json was found at {global-config-path} that also
  defines "{server-name}". The global config may override or
  conflict with the workspace config.

  Fix:
    1. Open {global-config-path}
    2. Remove or rename the conflicting server entry
    3. Alternatively, remove the global config entirely if all
       your servers are defined per-workspace
```

#### Unknown error

```
  {server-name}: FAIL ({raw error message})

  Check the MCP config and the server's documentation.
```

---

## Step 7 — User decision

After presenting all diagnostics, use the IDE question tool:

- **A**: Retry — run Step 5 again (useful after the user fixes something)
- **B**: Continue without failed server(s) — proceed with the workflow; disabled servers will not be available during the session
- **C**: Stop and fix — halt so the user can resolve issues outside the session

Store which servers are available as `MCP_SERVERS_OK[]` for downstream steps.

---

## Session Variables

| Variable | Description |
|----------|-------------|
| `MCP_SERVERS_OK[]` | List of server names that passed the check |

## Notes

- This skill is non-blocking by design. Failing MCP servers never halt the workflow unless the user chooses option C.
- OAuth-based servers (Atlassian, Slack) may show as FAIL on first run if the user hasn't completed the browser auth flow yet. Guide them through it rather than treating it as a hard error.
- The generated `mcp.json` is gitignored (both `.vscode/mcp.json` and `.cursor/mcp.json`) — it is local to the user's machine and rebuilt on each run.
