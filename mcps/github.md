---
name: github
description: GitHub access — repos, issues, PRs, branches, commits, code search.
type: stdio
scope: remote
auth: token | oauth
requires: [npx]
version: 1.0
last-updated: 2026-04-20
---

# MCP: GitHub

## Description

Provides AI access to GitHub via the official Model Context Protocol server for GitHub. Enables reading and writing to **repositories**, **issues**, **pull requests**, **branches**, **commits**, **releases**, and **code search**. Use this MCP in repositories where workflows involve source control operations, PR reviews, issue management, or automated branch/release workflows.

## Config

```json
"github": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-github"],
  "env": {
    "GITHUB_PERSONAL_ACCESS_TOKEN": "${env:GITHUB_PERSONAL_ACCESS_TOKEN}"
  }
}
```

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `GITHUB_PERSONAL_ACCESS_TOKEN` | No | GitHub Personal Access Token (classic or fine-grained). If not set, the server falls back to OAuth browser sign-in. |

### How to get the token (optional)

If you prefer token-based auth over OAuth:

1. Go to [github.com/settings/tokens](https://github.com/settings/tokens)
2. Click **Generate new token**
3. Select the required scopes (at minimum: `repo`, `read:org`)
4. Copy and paste the token into your `.env` file

If you skip this, VS Code will prompt you to sign in via the browser on first use (OAuth flow).

> **Note:** VS Code reads `${env:...}` from the OS process environment, not from `.env` directly. The `/ff-init` skill persists these variables to your shell profile (`~/.zshrc`) automatically. After setting the token, restart VS Code so the MCP server can pick up the new value.

## Notes

- The server is fetched and executed on demand via `npx`; no local installation required.
- Fine-grained tokens can be scoped to specific repositories to follow the principle of least privilege.

> **AI Agent rule:** Do NOT attempt to read, search for, or access `.env`, `.env.*`, or any environment variable files. These files are listed in `.copilotignore` and are intentionally excluded from AI context. Never inspect, reference, or infer token values from the filesystem. Token setup is the user's responsibility — guide them to the instructions above if needed.
