# Fix

Apply fixes for issues found during the audit. This file is loaded after the user chooses "Fix all" or "Fix selectively" in the main skill.

---

## Fix Modes

### Fix All

Apply every suggested fix from the report automatically, in order:

1. Work through the Issues table top to bottom.
2. For each issue, apply the suggested fix.
3. Log each fix as: `✅ Fixed: {file} — {what was changed}`
4. After all fixes, return to the main skill to re-run the scan.

### Fix Selectively

Present each fix one by one. For each issue:

1. Show: `Issue #{N}: {file} — {detail}`
2. Show: `Suggested fix: {suggested_fix}`
3. Use the IDE question tool:
   - **A**: Apply this fix
   - **B**: Skip this one
4. If A → apply and log: `✅ Fixed: {file} — {what was changed}`
5. If B → log: `⏭️ Skipped: {file}`
6. Move to the next issue.

After all issues are reviewed, return to the main skill to re-run the scan.

---

## Fix Rules

| Signal | Rule |
|--------|------|
| ✅ Always | When adding missing frontmatter, infer `name` from the file's `# Title` heading, `description` from the first non-heading line, and `version` as `1.0` |
| ✅ Always | When renaming a file, search for all references to the old path across the repo and update them |
| ✅ Always | Preserve existing frontmatter fields — only add missing ones, never overwrite existing values |
| ⚠️ Ask | Before deleting any file — even if marked as unreferenced |
| ⚠️ Ask | Before renaming a file — confirm the new name with the user |
| 🚫 Never | Edit semantic content — structural and format fixes only |
| 🚫 Never | Auto-commit — leave committing to the user |
