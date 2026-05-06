---
step: commit-push-pr
subagent: false
conditional: true
condition: user explicitly confirmed at Phase 1 gate
---

## Inputs

- Jira ID and branch name from Phase 1
- All files created/modified in Phase 1

## Guidance

### 7. Stage Files

Stage only the icon-related files explicitly — do **not** use `git add .` or `git add -A`:

```
git add icons/{category}/{name}.tsx types/models/fabric-icons-icon.models.ts fabric-icons-icon.all.stories.ts
```

For deletions or renames, use `git rm <file>` or `git add -u <file>` as appropriate.

**Never stage `components.d.ts` files.**

### 8. Commit

Use conventional commit format with `Ref: #<JIRA-ID>`:

```
git commit -m "feat(fabric-icons): add <icon-name> icon" -m "Ref: #<JIRA-ID>"
```

### 9. Push

Push the branch and set the upstream:

```
git push --set-upstream origin <branch-name>
```

### 10. Create PR

Use the GitHub MCP tool to open a Pull Request from the feature branch to `master`:
- **Title:** `feat(fabric-icons): add <icon-name> icon`
- **Body:** Description of the icon added, referencing `#<JIRA-ID>`
- **Base:** `master`
