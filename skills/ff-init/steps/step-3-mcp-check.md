# Step 3 — MCP Check

**Scope behavior**: Runs in both `full` and `workspace-only` modes (no differences).

**Session variables produced**: `MCP_SERVERS_OK[]`

**Progressive cache**: Writes the `mcp` block to `.local-environment.json`.

---

**Briefing**: Before running MCP verification commands, print a visible chat message: _"Checking connectivity to configured MCP servers (lightweight HTTP pings and command lookups — no data is sent)."_ — this must appear in the conversation before the terminal tool call.

Load `skills/mcp-check/mcp-check.md` and execute it, passing `AGENT_MCP_DEPS` (the list of MCP file paths from the calling agent's `dependencies.mcps`). The skill will:

1. Scan available MCP definitions from `{FF_CORE_PATH}/mcps/` and `{DEPT_FF_PATH}/mcps/`
2. Ask the user which MCPs to enable (multi-select, pre-selecting already configured ones)
3. Generate `{FF_CORE_PATH}/.vscode/mcp.json` or `{FF_CORE_PATH}/.cursor/mcp.json` (based on detected IDE) from the selected configs (with npm version pinning)
4. Verify each selected server (HTTP connectivity or command existence)
5. On failure, diagnose the error category and present a targeted fix guide
6. Ask the user: **Retry** / **Continue without** / **Stop and fix**

Store `MCP_SERVERS_OK[]` for downstream use.

**Write progressive cache** after this step — update `{FF_CORE_PATH}/.local-environment.json` with the `mcp` block.
