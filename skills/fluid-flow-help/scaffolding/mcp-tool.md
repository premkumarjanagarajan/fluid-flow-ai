# Scaffolding: MCP Tool

Add a new external service connection to the department's MCP configuration.

---

## Guided Setup

Ask **one question at a time**:

1. **"What's the name of the service and what does it do?"**

2. **"Does it have a URL endpoint, or is it a CLI command?"**
   — HTTP (URL-based, like Atlassian) vs stdio (command-based, like GitHub via npx).

3. **"Does it need authentication?"**
   — If yes, what kind (API key, token, OAuth)?

Then:

1. Add the server entry to `{DEPT_FF_PATH}/.cursor/mcp.json` (and `.vscode/mcp.json` if VS Code support is needed)

   **HTTP example:**
   ```json
   "{server-name}": {
     "url": "{endpoint-url}",
     "headers": {
       "Authorization": "Bearer ${env:VAR_NAME}"
     }
   }
   ```

   **stdio example:**
   ```json
   "{server-name}": {
     "command": "{cmd}",
     "args": ["{args}"],
     "env": {
       "API_KEY": "${env:VAR_NAME}"
     }
   }
   ```

2. If auth is needed, add the env var to `{DEPT_FF_PATH}/.env.example` with a comment explaining where to get the value

3. Explain: "The MCP check skill will verify this connection on your next workflow run. If it fails, it will guide you through fixing it."

After setup, return to the caller (Completion).
