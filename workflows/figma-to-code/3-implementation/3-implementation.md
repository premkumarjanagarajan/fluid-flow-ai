---
phase: implementation
steps: 2
---

# Phase 3: Implementation

Goal: build the UI component from design understanding — using the target framework and design system defined by local repository instructions — and validate implementation quality before test generation.

## Step Chain

1. Load `1-component-generation/1-component-generation.md` — load local instruction files, then implement the component using Build-First approach
2. Load `2-code-review/2-code-review.md` — validate code quality, FDS compliance, and resolve all issues

## Phase Gate

Both gates must pass before Phase 4 begins:
- Component Generation: **builds successfully** (no TypeScript/CSS errors)
- Code Review: **all issues resolved**

Present:
- **A**: All gates pass — proceed to Phase 4 (Quality)
- **B**: Build fails — fix errors, re-run Step 1
- **C**: Code review issues found — resolve violations, re-run Step 2
