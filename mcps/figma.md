# MCP: Figma

## Description

Provides AI access to Figma design files via the official Figma remote MCP endpoint. Enables reading design context, component metadata, node structure, and Dev Mode information from **Figma** files — including design tokens, layer hierarchy, node IDs, screenshots, and Code Connect mappings. Use this MCP in repositories where workflows involve design-to-code handoff, component library maintenance, or UI implementation guided by Figma designs.

## Config

```json
"figma": {
  "type": "http",
  "url": "https://mcp.figma.com/v1/mcp"
}
```

## Notes

- Authentication is handled by the Figma MCP endpoint directly (Figma account OAuth sign-in is triggered on first use in VS Code).
- No API token or environment variable is required in the config itself.
- Requires a Figma account with access to the files you want to work with.
- Dev Mode features (detailed design context, code snippets, Code Connect) require a Figma Dev Mode seat on the relevant team/organisation.
- FigJam files are supported separately via the FigJam-specific tool surface.
