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

> **⚠️ Security warning:** Storing personal access tokens in your shell profile exposes them to any process running under your user account, including AI agents. Prefer the default **OAuth browser sign-in** for day-to-day use. Only create a token if you have a specific need (e.g. headless/CI environments) and understand the risks.

If you prefer token-based auth over OAuth:

1. Go to [github.com/settings/tokens](https://github.com/settings/tokens)
2. Click **Generate new token**
3. Select the required scopes (at minimum: `repo`, `read:org`)
4. Set the token as an environment variable in your shell profile:
   ```
   export GITHUB_PERSONAL_ACCESS_TOKEN=ghp_your-token-here
   ```
   Then restart VS Code so the MCP server can pick up the new value.

If you skip this, VS Code will prompt you to sign in via the browser on first use (OAuth flow).

## Notes

- The server is fetched and executed on demand via `npx`; no local installation required.
- Fine-grained tokens can be scoped to specific repositories to follow the principle of least privilege.
