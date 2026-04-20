---
name: aws-document-loader
description: AWS documentation loader — docs, whitepapers, reference material.
type: stdio
scope: remote
auth: none
requires: [uvx]
version: 1.0
last-updated: 2026-04-20
---

# MCP: AWS Document Loader

## Description

Provides AI access to AWS documentation and knowledge sources via the AWS Labs Document Loader MCP server. Enables loading, searching, and reading content from **AWS documentation pages**, **whitepapers**, and other AWS-hosted reference material directly into the AI context. Use this MCP in repositories where workflows involve AWS architecture decisions, infrastructure-as-code guidance, or cloud compliance research.

## Config

```json
"aws-document-loader": {
  "command": "uvx",
  "args": ["awslabs.document-loader-mcp-server@latest"],
  "env": {
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```

## Notes

- Requires [uv](https://github.com/astral-sh/uv) to be installed on the host machine (`pip install uv` or via the official installer).
- The server package is fetched and executed on demand via `uvx`; no separate installation step is required.
- `FASTMCP_LOG_LEVEL` is set to `ERROR` to suppress verbose stdout logging that can interfere with the MCP stdio transport.
- No AWS credentials are required — the server only reads publicly available AWS documentation.

> **AI Agent rule:** Do NOT attempt to read, search for, or access `.env`, `.env.*`, or any environment variable files. These files are listed in `.copilotignore` and are intentionally excluded from AI context. Never inspect, reference, or infer token values from the filesystem. Token setup is the user's responsibility — guide them to the instructions above if needed.
