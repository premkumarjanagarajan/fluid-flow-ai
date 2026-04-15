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

## Notes

- Requires a GitHub Personal Access Token (classic or fine-grained) with appropriate scopes (e.g. `repo`, `read:org`).
- Set the token as an environment variable named `GITHUB_PERSONAL_ACCESS_TOKEN` on the host machine or in a `.env` file loaded by your shell.
- The server is fetched and executed on demand via `npx`; no local installation required.
- Fine-grained tokens can be scoped to specific repositories to follow the principle of least privilege.
