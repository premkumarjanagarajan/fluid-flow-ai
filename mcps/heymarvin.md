---
name: heymarvin
description: HeyMarvin access — research projects, insights, transcripts, tags.
type: http
scope: remote
auth: client_credentials (OAuth2)
requires: []
version: 1.0
last-updated: 2026-05-21
---

# MCP: HeyMarvin

## Description

Provides AI access to [HeyMarvin](https://heymarvin.com) — a customer insights and UX research platform. Enables reading **research projects**, **insights**, **interview transcripts**, **tags**, and **knowledge hub** data. Use this MCP in workflows involving product discovery, user research synthesis, or when pulling customer evidence into artefacts.

## Config

```json
"marvin": {
  "type": "http",
  "url": "https://mcp.heymarvin.com/",
  "headers": {
    "Authorization": "Bearer <ACCESS_TOKEN>"
  }
}
```

> **Note:** HeyMarvin does not use a long-lived static token. You must exchange your API key credentials for a short-lived JWT (valid 1 hour) before each session. See the authentication flow below.

## Authentication Flow

HeyMarvin uses **OAuth2 client credentials** — no browser login required.

### Step 1 — Create an API key (one time)

1. Go to **Settings → MCP** in the Marvin web app
2. Click **Create token**
3. Save both values immediately — the secret is shown **only once**:

| Value | Example | Secret? |
|-------|---------|---------|
| Client ID | `cid-mrv_20672c99d4a192fb...` | No |
| Secret Key | `sk-mrv_443c348c0fc307fa...` | **Yes** |

### Step 2 — Exchange credentials for an access token (~every hour)

```bash
curl -X POST https://app.heymarvin.com/api/v1/oauth/token \
  -d "grant_type=client_credentials" \
  -d "client_id=${env:MARVIN_CLIENT_ID}" \
  -d "client_secret=${env:MARVIN_SECRET_KEY}" \
  -d "scope=mcp:read" \
  -d "resource=https://mcp.heymarvin.com"
```

Returns a JWT (`access_token`) valid for **1 hour**. Cache and reuse it — do not exchange on every request.

### Step 3 — Use the JWT in the MCP config

Replace `<ACCESS_TOKEN>` in the config block above with the JWT from Step 2.

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `MARVIN_CLIENT_ID` | Yes | Client ID from Settings → MCP (`cid-mrv_...`) |
| `MARVIN_SECRET_KEY` | Yes | Secret key from Settings → MCP (`sk-mrv_...`) |

Set both in your shell profile:

```bash
export MARVIN_CLIENT_ID=cid-mrv_your-client-id-here
export MARVIN_SECRET_KEY=sk-mrv_your-secret-key-here
```

Then restart VS Code.

## Quick Reference

| | |
|-|-|
| Token endpoint | `POST https://app.heymarvin.com/api/v1/oauth/token` |
| MCP server | `https://mcp.heymarvin.com/` |
| Grant type | `client_credentials` |
| Required scope | `mcp:read` |
| Required resource param | `https://mcp.heymarvin.com` |
| Token lifetime | 1 hour |
| Rate limit (token exchange) | 60 req/min per key |

## Troubleshooting

| Error | Cause | Fix |
|-------|-------|-----|
| `401` from MCP server | Token missing `scope=mcp:read` or wrong `resource` | Re-exchange with correct params |
| `invalid_client` on token exchange | Wrong secret, revoked, expired key, or suspended user | Create a new key in Settings → MCP |
| `rate_limited` on token exchange | Exchanging too often | Cache the JWT for its full 1-hour lifetime |
| Token works but no projects returned | Projects not shared with team | Share projects with the team in Marvin |
| `invalid_scope` | Key doesn't have `mcp:read` | Revoke and create a new key |

## Notes

- Keys expire after 30–180 days from creation. Create a new key when exchange starts returning `invalid_client`.
- The EU region uses `https://mcp.heymarvin.eu/` and `https://app.heymarvin.eu/api/v1/oauth/token` instead.
- Docs: [docs.heymarvin.com/mcp/api-keys](https://docs.heymarvin.com/mcp/api-keys)
