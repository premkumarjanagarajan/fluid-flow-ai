---
step: setup
subagent: false
---

## Inputs

- Jira ID (must be requested from user — do not proceed without it)
- Figma icon node URL or SVG source

## Guidance

### 1. Collect Jira ID

Ask the user for the Jira ID (e.g. `GX-1234`). This is mandatory. Do not proceed without it.

### 2. Create Feature Branch

Create a branch following the husky `pre-push` naming convention (`.husky/pre-push`):

| Rule | Detail |
|---|---|
| **Regex** | `^(master\|release\|feature\|fix\|hotfix\|poc\|demo\|dependabot\|debug\|patch\|auto\|test)($\|[0-9a-zA-Z\/-_])+` |
| **Format** | `feature/<JIRA-ID>-<short-description>` |
| **Example** | `feature/GX-1234-add-arrow-left-icon` |

```
git checkout -b feature/<JIRA-ID>-<short-description>
```

### 3. Resolve SVG Source

Use this priority order:

1. **Figma MCP extraction** — call `get_design_context` / `get_metadata` on the icon node. If an asset URL is returned instead of inline SVG, fetch the URL and parse `viewBox` + `<path d="...">` from the SVG XML.
2. **Context attachment** — if an SVG file is attached, use its path data directly.
3. **Manual Figma copy** — as a last resort, ask the user to right-click the icon in Figma → "Copy as SVG".

**MCP fallback:** If `get_design_context` returns `<img src="https://www.figma.com/api/mcp/asset/...">`:
1. Call `get_metadata` on the node — find the inner child node (often named `icon`, type `vector`)
2. Call `get_design_context` on the inner node
3. If still an asset URL, fetch it directly — the response is SVG XML
4. Extract `viewBox` and `<path d="...">` attributes
5. If dimensions differ from 24×24, use `transform="translate(x y)"` to position within 24×24

**SVG Size Validation:** All SVG input must be under **8 KB**.
- Manual Figma copy: check raw markup size immediately. If ≥ 8 KB, reject and ask the user to simplify the icon in Figma (flatten vectors, reduce nodes). Do **not** attempt optimization.

### 4. Determine Icon Category and Name

Resolve:
- Icon name (kebab-case, e.g. `arrow-left`)
- Category: `generic` or `branded`

### 5. Check for Duplicates

Search the codebase for an existing enum entry matching this icon name before proceeding.

- If found — block. Do not create a duplicate. Inform the user.
- If not found — proceed to `2-create-component/`.
