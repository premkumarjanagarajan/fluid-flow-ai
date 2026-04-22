---
name: playwright
description: Browser automation — navigate, click, screenshot, accessibility tree, Lighthouse.
type: stdio
scope: local
auth: none
requires: [npx]
version: 1.0
last-updated: 2026-04-20
---

# MCP: Playwright

## Description

Provides AI access to browser automation via the official Playwright MCP server. Enables controlling a real Chromium browser — navigating pages, clicking elements, filling forms, taking screenshots, reading the accessibility tree, capturing network requests, running Lighthouse audits, and evaluating JavaScript. Use this MCP in repositories where workflows involve UI testing, end-to-end test generation, web scraping, or visual validation of web applications.

## Config

```json
"playwright": {
  "type": "stdio",
  "command": "npx",
  "args": [
    "@playwright/mcp@latest"
  ]
}
```

## Notes

- Requires [Node.js](https://nodejs.org) and `npx` available on the host machine.
- The server package is fetched and executed on demand via `npx`; no separate installation step required.
- Playwright browser binaries will be downloaded automatically on first run if not already present.
- By default the server launches a visible (headed) Chromium instance; this requires a display — use a virtual display (e.g. Xvfb) in headless/CI environments.
- For CI use, consider pinning a specific version: `@playwright/mcp@1.x.x` instead of `@latest`.
