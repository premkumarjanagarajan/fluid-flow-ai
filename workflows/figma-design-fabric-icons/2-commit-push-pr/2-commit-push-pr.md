---
phase: commit-push-pr
steps: 1
conditional: true
condition: user explicitly confirms Phase 2
---

# Phase 2: Commit, Push & PR

Goal: stage only the icon-related files, commit with conventional commit format, push the branch, and open a Pull Request.

**Only execute this phase if the user explicitly confirmed at the end of Phase 1.**

## Step Chain

1. Load `1-commit-push-pr/1-commit-push-pr.md` — stage files, commit, push, create PR

## Phase Gate

PR created successfully, referencing the Jira ID.
