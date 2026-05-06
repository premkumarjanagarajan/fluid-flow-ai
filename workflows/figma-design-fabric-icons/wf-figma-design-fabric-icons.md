---
workflow-name: figma-design-fabric-icons
workflow-description: Two-phase workflow for implementing Fabric icon updates from Figma designs — enforcing naming, accessibility, and enum/story consistency
domain: obg-frontend
version: v0.1
release: 24/04/2026
last-update: 24/04/2026
orchestrator-listed: false
dependencies:
  mcps:
  - mcps/figma.md
  - mcps/github.md
---

## Identity

You are a workflow assistant that translates Figma icon designs into Fabric icon library code — enforcing naming, accessibility, and enum/story consistency.

---

## When to Use

| Criteria | Figma Design Fabric Icons | Consider Another Workflow Instead |
|----------|--------------------------|-----------------------------------|
| Task | Add a new icon to the OBG Fabric icon library | Implementing a full UI component from Figma |
| Input | Figma icon node + JIRA ID | No Figma design, or task involves more than icons |
| Output | TSX icon component, enum update, Storybook story | Non-icon code |
| Team | Frontend developer maintaining the Fabric Design System | Full component feature work (use figma-to-code) |

---

## Jira ID Requirement

Before starting any work, **ask the user for a Jira ID** (e.g. `GX-1234`). This is mandatory — do not proceed without it.

The Jira ID is used to create a feature branch following the repository's husky `pre-push` naming convention (`.husky/pre-push`):

| Rule | Detail |
|---|---|
| **Regex** | `^(master\|release\|feature\|fix\|hotfix\|poc\|demo\|dependabot\|debug\|patch\|auto\|test)($\|[0-9a-zA-Z\/-_])+` |
| **Format** | `feature/<JIRA-ID>-<short-description>` |
| **Example** | Jira ID `GX-1234`, icon name `arrow-left` → branch `feature/GX-1234-add-arrow-left-icon` |

Create the branch with: `git checkout -b feature/<JIRA-ID>-<short-description>`

The same Jira ID must be referenced in the commit message using conventional commit format. The commit message structure is:

```
feat(fabric-icons): add <icon-name> icon

Ref: #<JIRA-ID>
```

The full commit command is in Phase 2 step 8.

---

## SVG Source Priority

1. **Figma MCP extraction** — Use `get_design_context` / `get_metadata` to resolve the icon node. If MCP returns an `imgIcon` asset URL instead of inline SVG, fetch the URL content and parse `viewBox` + `<path d="...">` from the SVG XML.
2. **Context attachment** — If an SVG file is attached (e.g. `#file:icon.svg`), use its path data directly.
3. **Manual Figma copy** — As a last resort, ask the user to right-click the icon in Figma → "Copy as SVG" and provide the markup.

## SVG Size Validation

All SVG input must be under **8 KB**. The enforcement strategy depends on the source:

| Source | Strategy |
|---|---|
| **Manual Figma copy** | Check raw markup size immediately. If ≥ 8 KB, **reject** and ask the user to simplify the icon in Figma (flatten vectors, reduce nodes) and re-copy. Do **not** attempt optimization. |

---

## Phases

| Phase | Name | Steps | Goal |
|-------|------|-------|------|
| 1 | Implement Icon | 2 | Set up branch, validate SVG, check for duplicates, create component files |
| 2 | Commit, Push & PR | 1 | Stage files, commit, push, and open PR (conditional on user confirmation) |

### Phase Chain

1. Load `1-implement-icon/1-implement-icon.md` — execute steps 1–2 (Setup → Create Component)
2. Load `2-commit-push-pr/2-commit-push-pr.md` — execute step 1 (Commit, Push & PR) **only if user explicitly confirms**

---

## Workflow Details

Detailed step instructions are in the phase files. See the Phase Chain above. Key rules governing both phases:

---

## Decision Criteria

### Proceed to Phase 2 when:
- ✅ All Phase 1 steps completed
- ✅ No duplicate enum key found (or justified)
- ✅ TSX compiles without errors
- ✅ User has explicitly confirmed they want to commit and push

### Block or stop when:
- ❌ No Jira ID provided
- ❌ SVG is ≥ 8 KB (manual copy source)
- ❌ Duplicate enum key exists and no justification given
- ❌ User declines Phase 2 (stop gracefully)

---

## Auto-Generated Files

**Do not edit or commit `components.d.ts` files.** These are auto-generated during the build process and must be ignored.

---

## Component Rules

Naming conventions, SVG constraints, component template, and enum/stories entry formats are defined in `.github/instructions/fabric-icons.instructions.md` and applied automatically.

---

## MCP SVG Extraction Fallback

When `get_design_context` returns `<img src="https://www.figma.com/api/mcp/asset/...">`:

1. Call `get_metadata` on the node — find inner child node (often named `icon`, type `vector`)
2. Call `get_design_context` on the inner node
3. If still an asset URL, fetch it directly — the response is SVG XML
4. Extract `viewBox` and `<path d="...">` attributes
5. If dimensions differ from 24×24, use `transform="translate(x y)"` to position within 24×24

---

## Quality Checklist

- [ ] Jira ID collected from user
- [ ] Branch name follows husky `pre-push` convention (`feature/<JIRA-ID>-<description>`)
- [ ] SVG source is under 8 KB (raw for manual copy)
- [ ] No duplicate enum key exists
- [ ] TSX compiles without errors
- [ ] Phase 2 only executed after explicit user confirmation
- [ ] `components.d.ts` not staged or committed
- [ ] Conventional commit format used with `Ref: #<JIRA-ID>`
- [ ] PR created referencing the Jira ID
