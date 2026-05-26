---
name: powerbi
description: Power BI access — reports, dashboards, datasets, dataflows, workspaces.
type: http
scope: remote
auth: oauth
requires: []
version: 1.0
last-updated: 2026-05-26
---

# MCP: Power BI

## Description

Provides AI access to Microsoft Power BI via the Power BI REST API, surfaced as an MCP endpoint. Enables reading **reports**, **dashboards**, **datasets**, **dataflows**, and **workspace metadata**. Use this MCP in workflows where product discovery or analytics require pulling insight data, KPIs, or dashboard snapshots from Power BI.

## Config

```json
"powerbi": {
  "type": "http",
  "url": "https://api.powerbi.com/v1.0/myorg",
  "headers": {
    "Authorization": "Bearer ${env:POWERBI_ACCESS_TOKEN}"
  }
}
```

> **Note:** Power BI uses Microsoft Entra ID (Azure AD) OAuth 2.0. Authentication is handled via an access token obtained through the OAuth flow. The token must be refreshed periodically (typically every 1 hour).

## Authentication Flow

Power BI uses **Microsoft Entra ID OAuth 2.0** — browser-based login on first use.

### Step 1 — Register an app (one time, admin action)

If a shared Betsson app registration already exists for Power BI MCP access, skip to Step 2.

1. Go to [portal.azure.com](https://portal.azure.com) → **Azure Active Directory** → **App registrations**
2. Click **New registration**, give it a name (e.g. `betsson-mcp-powerbi`)
3. Set redirect URI to `http://localhost` (for interactive OAuth)
4. Under **API permissions**, add:
   - `Power BI Service → Delegated → Report.Read.All`
   - `Power BI Service → Delegated → Dashboard.Read.All`
   - `Power BI Service → Delegated → Dataset.Read.All`
   - `Power BI Service → Delegated → Workspace.Read.All`
5. Note the **Application (client) ID** and **Tenant ID**

### Step 2 — Obtain an access token

```bash
# Interactive OAuth (browser pop-up — first time only)
az login --tenant <TENANT_ID>
az account get-access-token --resource https://analysis.windows.net/powerbi/api \
  --query accessToken -o tsv
```

Or use MSAL / the Azure CLI to obtain and cache the token. Set the result as an environment variable:

```bash
export POWERBI_ACCESS_TOKEN=<token-from-above>
```

### Step 3 — Use in MCP config

Set the token in your shell profile and restart VS Code:

```bash
export POWERBI_ACCESS_TOKEN=your-token-here
```

> **⚠️ Security warning:** Access tokens are short-lived (≈1 hour). Refresh using `az account get-access-token` before each session. Do not store long-lived credentials in shell profiles.

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `POWERBI_ACCESS_TOKEN` | Yes | Microsoft Entra ID OAuth 2.0 bearer token for Power BI |

## Notes

- Scope is limited to the Power BI workspaces and reports accessible by the authenticated Betsson account.
- Admin-level operations (workspace creation, dataset refresh orchestration) require a Power BI admin account.
- For read-only product analytics use cases (dashboards, reports, KPIs), standard user permissions are sufficient.
- Token expiry is typically 1 hour — implement a refresh flow for long-running sessions.
