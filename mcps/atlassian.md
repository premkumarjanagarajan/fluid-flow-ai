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

- Authentication is handled by the Atlassian MCP endpoint directly (OAuth / Atlassian account sign-in is triggered on first use in VS Code).
- No API token or environment variable is required in the config itself.
- Scope is limited to the Atlassian cloud resources accessible by the signed-in account.
