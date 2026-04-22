---
name: ff-audit
description: Audits fluid-flow-ai building blocks for format compliance, naming conventions, frontmatter integrity, and structural drift — then helps fix issues.
execution: inline
scope: shared
version: 1.0
last-updated: 2026-04-20
---

# FF Audit

Audits the fluid-flow-ai repository's building blocks (workflows, skills, agents, MCPs, primitives, commands) for structural integrity, format compliance, and drift. Reports all findings, then helps the user fix issues interactively.

---

## When to Run

- After adding, moving, or deleting skills, agents, workflows, or MCPs
- Periodic health check on the repo structure
- Before a release or merge to main
- When something "feels off" and needs validation

---

## Execution

### Step 1 — Entry

Display:

```
═══════════════════════════════════════════════════
  FF AUDIT
  Structural health check for fluid-flow-ai
═══════════════════════════════════════════════════
```

Then use the IDE question tool (Cursor: `AskQuestion` / VS Code: `vscode_askQuestions`):

- **A**: Full audit — scan everything
- **B**: Audit a specific building block (workflows, skills, agents, MCPs, primitives, commands)
- **C**: Cross-reference check only — verify all dependency links resolve

If A → load `scan.md` from this skill's directory with scope `all`, then proceed to Step 2.
If B → ask which building block, then load `scan.md` with scope set to the chosen block, then proceed to Step 2.
If C → load `cross-references.md` from this skill's directory, then proceed to Step 2.

### Step 2 — Report

Load `report.md` from this skill's directory and present the findings.

If everything passes: `✅ All clean — no issues found.` → end.

### Step 3 — Fix

If issues were found, use the IDE question tool:

- **A**: Fix all — apply every suggested fix automatically
- **B**: Fix selectively — approve each fix one by one
- **C**: Skip — leave the report as-is

If A or B → load `fix.md` from this skill's directory and follow its instructions. After all fixes, re-run the scan from Step 1 (same scope) to confirm resolution.
If C → end.

---

## Completion

After any path completes, use the IDE question tool:

- **A**: Run another audit (different scope)
- **B**: I'm done

If A → return to Step 1. If B → end.

---

## Operating Rules

| Signal | Rule |
|--------|------|
| ✅ Always | Read the actual file before reporting an issue — never assume based on filename alone |
| ✅ Always | Report all findings before making any changes |
| ✅ Always | Re-run validation after applying fixes to confirm resolution |
| ⚠️ Ask | Before renaming or deleting any file |
| ⚠️ Ask | Before adding frontmatter to a file that currently has none |
| 🚫 Never | Edit semantic content during a fix — structural changes only |
| 🚫 Never | Auto-commit fixes — leave that to the user |
| 🚫 Never | Modify files outside the scoped building block folders |
| 🚫 Never | Modify files in the core repo when auditing department (read-only reference) |
