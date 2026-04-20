# Report

Present the audit findings collected by `scan.md` or `cross-references.md`.

---

## Format

```
═══════════════════════════════════════════════════
  FF AUDIT REPORT
  Date: {date}
  Branch: {current git branch}
  Target: {core | department | both}
  Scope: {all | workflows | skills | agents | mcps | primitives | commands | initiatives | local-kb | config | cross-references}
═══════════════════════════════════════════════════

## Summary — Core ({FF_CORE_PATH})

| Building Block | Files | Format | Naming | Broken Refs | Unreferenced |
|----------------|-------|--------|--------|-------------|--------------|
| Workflows      | N     | N      | N      | N           | N            |
| Skills         | N     | N      | N      | N           | N            |
| Agents         | N     | N      | N      | N           | N            |
| MCPs           | N     | N      | N      | N           | N            |
| Primitives     | N     | N      | N      | N           | N            |
| Commands       | N     | N      | N      | N           | N            |

## Summary — Department ({DEPT_FF_PATH})

| Building Block   | Files | Format | Naming | Broken Refs | Unreferenced |
|------------------|-------|--------|--------|-------------|--------------|
| Workflows        | N     | N      | N      | N           | N            |
| Skills           | N     | N      | N      | N           | N            |
| Commands         | N     | N      | N      | N           | N            |
| Initiatives      | N     | N      | N      | N           | N            |
| Local KB         | N     | N      | N      | N           | N            |
| Config           | N     | N      | —      | —           | —            |

## Issues

| # | File | Type | Detail | Suggested Fix |
|---|------|------|--------|---------------|
| 1 | path/to/file.md | Format | Missing `version` in frontmatter | Add `version: 1.0` |
| 2 | path/to/file.md | Naming | Expected `*.skill.md` suffix | Rename to `file.skill.md` |
| 3 | wf-example.md | Broken Ref | Dependencies list `skills/deleted/` — not found | Remove from dependencies |

## Clean ✅

{List building blocks / files with no issues, for confirmation.}

═══════════════════════════════════════════════════
```

---

## Rules

- Only include the Summary table(s) for the target(s) that were scanned. If target is `core`, omit the Department table. If target is `department`, omit the Core table.
- Only include rows in each Summary table for building blocks that were in scope.
- If a cross-references-only check was run, skip the Summary table and show only the Issues table.
- If no issues were found, display: `✅ All clean — no issues found.`
- Sort issues by building block, then by file path.
- The **Suggested Fix** column must be actionable — not just "fix it" but the specific change to make.
