---
name: slack
description: Slack access — channels, threads, messages, search, canvases.
type: http
scope: remote
auth: token
requires: []
version: 1.0
last-updated: 2026-04-20
---

# MCP: Slack

## Description

Provides AI access to Slack via the official Slack remote MCP endpoint. Enables reading and searching **channels**, **threads**, **messages**, **user profiles**, and **canvases**, as well as sending messages and scheduling them. Use this MCP in repositories where workflows involve team communication, status updates, or Slack-based collaboration.

## Config

```json
"slack": {
  "type": "http",
  "url": "https://mcp.slack.com/mcp",
  "headers": {
    "Authorization": "Bearer ${env:SLACK_TOKEN}"
  }
}
```

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `SLACK_TOKEN` | Yes | Slack user token (`xoxp-...`). Impersonates you — no Slack bot involved. |

### How to get the token

1. Open the Betsson Slack MCP Setup app: [slack-mcp-setup.apps.igaming-test.euc1.betsson.tech](https://slack-mcp-setup.apps.igaming-test.euc1.betsson.tech/)
2. Click **Connect with Slack** and approve the requested permissions
3. Copy the token from the JSON snippet shown on the success page (starts with `xoxp-`)
4. Paste the token into your `.env` file

The setup app does **not** store your token — it is shown only once. If you lose it, go through the flow again.

### How to revoke the token

Go to [betssontech.slack.com/marketplace](https://betssontech.slack.com/marketplace/A0AJMCE0W9J-slack-mcp-setup?tab=settings) → click **Revoke** under "Your authorization".

> **Note:** VS Code reads `${env:...}` from the OS process environment, not from `.env` directly. The `/ff-init` skill persists these variables to your shell profile (`~/.zshrc`) automatically. After setting the token, restart VS Code so the MCP server can pick up the new value.

## Notes

- The token impersonates your Slack user account — messages sent via this MCP appear as you, not as a bot.
- Scope is limited to the workspaces and channels accessible by your Slack account.
- More info: [github.com/BetssonGroup/slack-mcp-setup](https://github.com/BetssonGroup/slack-mcp-setup)

> **AI Agent rule:** Do NOT attempt to read, search for, or access `.env`, `.env.*`, or any environment variable files. These files are listed in `.copilotignore` and are intentionally excluded from AI context. Never inspect, reference, or infer token values from the filesystem. Token setup is the user's responsibility — guide them to the instructions above if needed.
