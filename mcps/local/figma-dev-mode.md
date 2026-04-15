# MCP: Figma Dev Mode MCP (Local)

## Description

Provides AI access to Figma design context via the **Figma desktop app's** locally running Dev Mode MCP server. This is the local alternative to the remote Figma MCP — it connects directly to the Figma desktop app on your machine, giving richer and faster access to the currently open file including detailed design specs, component properties, node metadata, and Code Connect mappings. Use this MCP when you have the Figma desktop app installed and want tighter design-to-code integration without going through the remote endpoint.

## Config

```json
"Figma Dev Mode MCP": {
  "type": "http",
  "url": "http://127.0.0.1:3845/mcp"
}
```

## Notes

- Requires the **Figma desktop app** to be running with Dev Mode MCP enabled (`Figma menu → Preferences → Enable Dev Mode MCP Server`).
- The server runs on `localhost:3845` by default — no installation or token needed.
- Only works on the machine where the Figma desktop app is running; not suitable for CI or headless environments.
