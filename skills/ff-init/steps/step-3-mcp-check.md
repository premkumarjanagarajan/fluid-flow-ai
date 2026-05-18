# Step 3 — MCP Check

**Scope behavior**: Runs in both `full` and `workspace-only` modes (no differences).

**Session variables produced**: `MCP_SERVERS_OK[]`

**Progressive cache**: Writes the `mcp` block to `.local-environment.json`.

---

**Briefing**: Before running MCP verification commands, print a visible chat message: _"Checking connectivity to configured MCP servers (lightweight HTTP pings and command lookups — no data is sent)."_ — this must appear in the conversation before the terminal tool call.

**Before loading mcp-check, detect whether this is a first-time setup:**

Check if `{FF_CORE_PATH}/.vscode/mcp.json` (or `.cursor/mcp.json`) exists and contains at least one configured server.

- **If MCPs are already configured and verified**: skip the setup wizard and proceed directly to connectivity verification. Display: *"MCP servers already configured — running connectivity check."*
- **If no MCPs are configured (first-time setup)**: display the following plain-language briefing before loading mcp-check:

  > *"To get the most out of Product Buddy, I need to connect to a few tools — Jira for tracking your artefacts and Confluence for pushing documents. This is a one-time setup and I'll walk you through every step. You won't need to touch the terminal."*
  >
  > *"Here's what I'll connect:*
  > *• Jira & Confluence — to create and track your artefacts*
  > *• GitHub — to keep your work versioned (optional)*
  >
  > *This takes about 2 minutes. Ready?"*

  Wait for confirmation before proceeding.

Load `skills/mcp-check/mcp-check.md` and execute it. The skill will:

1. Scan available MCP definitions from `{FF_CORE_PATH}/mcps/` and `{DEPT_FF_PATH}/mcps/`
2. Ask the user which MCPs to enable (multi-select, pre-selecting already configured ones)
3. Generate `{FF_CORE_PATH}/.vscode/mcp.json` or `{FF_CORE_PATH}/.cursor/mcp.json` (based on detected IDE) from the selected configs (with npm version pinning)
4. Verify each selected server (HTTP connectivity or command existence)
5. On failure, present a **plain-language fix guide** — avoid jargon. For non-technical users: explain what the error means, what to do next, and offer to retry automatically where possible.
6. Ask the user: **Retry** / **Continue without** / **Stop and fix**

Store `MCP_SERVERS_OK[]` for downstream use.

**Write progressive cache** after this step — update `{FF_CORE_PATH}/.local-environment.json` with the `mcp` block.
