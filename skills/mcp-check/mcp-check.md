# MCP Check

Verify all configured MCP servers are reachable and guide the user through fixing any failures.

## How to Run

### Pre-Execution Briefing

Before running **any** terminal command for MCP verification (HTTP requests, command lookups), you **MUST** print a visible one-liner explanation **as a chat message** to the user describing what the command does. This message must appear in the conversation **before** the terminal tool call — setting the tool's `explanation` parameter alone is NOT sufficient, because the user needs context in the chat history, not only in the IDE approval dialog.

Examples of good briefings (print these as chat text before the tool call):
- _"I'll check if MCP servers are reachable (lightweight HTTP ping — no data is sent)."_
- _"Verifying that required CLI tools (npx, uvx) are installed on your system."_

> **Rule**: Every terminal invocation in this skill must be preceded by a visible chat briefing. No exceptions.

### Step 1 — Locate MCP configs

Read MCP configs from **both** repos (core provides shared servers, department provides team-specific ones):

| Source | Cursor | VS Code |
|--------|--------|---------|
| Core | `{FF_CORE_PATH}/.cursor/mcp.json` | `{FF_CORE_PATH}/.vscode/mcp.json` |
| Department | `{DEPT_FF_PATH}/.cursor/mcp.json` | `{DEPT_FF_PATH}/.vscode/mcp.json` |

Use the `IDE` session variable (from Stage 0A) to pick the right config files. Merge both server lists — if the same server name appears in both, the department config takes precedence.

### Step 2 — Check .env file

For each repo that has a `.env.example`:

1. Check if `.env` exists alongside it
2. If missing, copy `.env.example` to `.env` and inform the user:

```
  .env scaffolded from .env.example in {repo folder name}

  Tokens are optional — OAuth servers (Atlassian, Slack) will
  authenticate via browser on first use. However, configuring
  personal tokens in .env provides a more stable connection
  (no re-auth prompts, works in headless/CI environments, and
  avoids browser popup issues).

  Open {repo}/.env to set up your tokens. See .env.example
  for instructions on where to generate each one.
```

### Step 3 — Verify each server

**Briefing**: Before running the verification commands, explain to the user: _"Check connectivity to configured MCP servers (lightweight HTTP pings and command lookups — no data is sent)"_.

For each server in the merged config, attempt a lightweight connectivity check:

- **HTTP servers** (have `url` property): make a HEAD or GET request to the URL
- **stdio servers** (have `command` property): verify the command exists (`which {command}` on bash, `Get-Command {command}` on PowerShell)

Record result per server: `OK` or `FAIL` with error category.

### Step 4 — Report status

```
  MCP Status:
    {server-name}: OK
    {server-name}: FAIL ({error category})
```

If all servers pass, stop here — MCP Check is complete.

### Step 5 — Diagnose failures

For each failed server, classify the error and present the matching troubleshooting guide:

#### Missing environment variable

The server config references `${env:VAR_NAME}` but the variable is empty or unset.

```
  {server-name}: FAIL (missing env var: {VAR_NAME})

  Fix:
    1. Open {repo}/.env
    2. Set {VAR_NAME}=your-value
    3. See .env.example for instructions on where to get the value
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

The server is reachable but rejected the credentials.

```
  {server-name}: FAIL (auth error: {status code})

  Fix:
    Token-based servers:
      1. Check that {repo}/.env has a valid, non-expired token
      2. Regenerate the token if needed (see .env.example for links)

    OAuth servers (Atlassian, Slack):
      1. The browser auth flow should trigger automatically on first use
      2. If it doesn't, check your browser for blocked popups
      3. Try disconnecting and reconnecting the server in IDE settings
```

#### Network / connection error

The server URL is unreachable (timeout, DNS failure, etc.).

```
  {server-name}: FAIL (connection error: {details})

  Fix:
    1. Check your internet connection
    2. Verify the URL is correct in the MCP config
    3. Check if a VPN is required to reach {url}
    4. Try opening {url} in your browser
```

#### Conflict with global MCP config

The user may have a global `mcp.json` installed at the machine level that conflicts with the workspace configs (duplicate server names, different auth, or outdated URLs).

Based on `IDE`, check for a global config at:

**Cursor** (`IDE=cursor`):
- macOS: `~/.cursor/mcp.json`
- Windows: `%APPDATA%\Cursor\mcp.json`

**VS Code** (`IDE=vscode`):
- macOS: `~/.vscode/mcp.json` and `~/Library/Application Support/Code/User/settings.json` (look for `mcp.servers` key)
- Windows: `%APPDATA%\Code\User\settings.json` (look for `mcp.servers` key)
- Linux: `~/.config/Code/User/settings.json` (look for `mcp.servers` key)

If a global config exists and defines servers that overlap with the workspace configs:

```
  {server-name}: FAIL (possible conflict with global MCP config)

  A global mcp.json was found at {global-config-path} that also
  defines "{server-name}". The global config may override or
  conflict with the workspace config.

  Fix:
    1. Open {global-config-path}
    2. Remove or rename the conflicting server entry
       (workspace configs should take precedence)
    3. Alternatively, remove the global config entirely if all
       your servers are defined per-workspace
```

#### Unknown error

```
  {server-name}: FAIL ({raw error message})

  Check the MCP config in {repo} and the server's documentation.
```

### Step 6 — User decision

After presenting all diagnostics, ask the user via `AskQuestion`:

- **A**: Retry — run Step 3 again (useful after the user fixes something)
- **B**: Continue without failed server(s) — proceed with the workflow; disabled servers will not be available during the session
- **C**: Stop and fix — halt the workflow so the user can resolve issues outside the session

Store which servers are available as `MCP_SERVERS_OK[]` for downstream steps.

## Session Variables

| Variable | Description |
|----------|-------------|
| `MCP_SERVERS_OK[]` | List of server names that passed the check |

## Notes

- This skill is non-blocking by design. Failing MCP servers never halt the workflow unless the user chooses option C.
- OAuth-based servers (Atlassian, Slack) may show as FAIL on first run if the user hasn't completed the browser auth flow yet. This is expected — guide them through it rather than treating it as a hard error.
- The `.env` scaffold step ensures first-time users get a working template before the check runs.
