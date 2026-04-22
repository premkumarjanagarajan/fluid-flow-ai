---
name: atlassian
description: Atlassian access — Jira issues, Confluence pages, search.
type: http
scope: remote
auth: oauth | token
requires: []
version: 1.0
last-updated: 2026-04-20
---

# MCP: Atlassian

## Description

Provides AI access to Atlassian cloud products via the official Atlassian remote MCP endpoint. Enables reading and writing to **Jira** (issues, projects, transitions, comments) and **Confluence** (pages, spaces, inline/footer comments, search). Use this MCP in repositories where workflows involve product management, issue tracking, or documentation hosted in an Atlassian cloud workspace.

## Config

```json
"atlassian": {
  "type": "http",
  "url": "https://mcp.atlassian.com/v1/mcp"
}
```

## Notes

- By default, authentication is handled by the Atlassian MCP endpoint directly (OAuth / Atlassian account sign-in is triggered on first use in VS Code).
- No API token or environment variable is required for the default OAuth config.
- Scope is limited to the Atlassian cloud resources accessible by the signed-in account.

## Environment Variables (optional — PAT-based auth)

If you prefer token-based auth over OAuth, replace the default config block above with:

```json
"atlassian": {
  "command": "npx",
  "args": ["-y", "@anthropic/atlassian-mcp-server"],
  "env": {
    "ATLASSIAN_SITE": "betssongroup.atlassian.net",
    "ATLASSIAN_EMAIL": "${env:ATLASSIAN_EMAIL}",
    "ATLASSIAN_API_TOKEN": "${env:ATLASSIAN_API_TOKEN}"
  }
}
```

| Variable | Required | Description |
|----------|----------|-------------|
| `ATLASSIAN_API_TOKEN` | No | Atlassian API token. Only needed if switching to PAT-based auth. |
| `ATLASSIAN_EMAIL` | No | Your Atlassian email (e.g. `you@betsson.com`). Only needed with PAT-based auth. |

### How to get the token (optional)

> **⚠️ Security warning:** Storing personal access tokens in your shell profile exposes them to any process running under your user account, including AI agents. Prefer the default **OAuth browser sign-in** for day-to-day use. Only create a token if you have a specific need (e.g. headless/CI environments) and understand the risks.

If you prefer PAT-based auth over OAuth:

1. Go to [id.atlassian.com/manage-profile/security/api-tokens](https://id.atlassian.com/manage-profile/security/api-tokens)
2. Click **Create API token**, give it a label (e.g. "Fluid Flow")
3. Set the token and email as environment variables in your shell profile:
   ```
   export ATLASSIAN_API_TOKEN=your-token-here
   export ATLASSIAN_EMAIL=you@betsson.com
   ```
   Then restart VS Code so the MCP server can pick up the new values.

If you skip this, VS Code will prompt you to sign in via the browser on first use (OAuth flow — the default).
