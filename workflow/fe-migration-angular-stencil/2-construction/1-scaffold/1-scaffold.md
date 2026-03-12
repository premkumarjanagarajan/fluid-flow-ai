---
step: scaffold
subagent: false
---

## Inputs

- `JIRA_KEY`, `WIDGET_NAME`, `TARGET_TYPE` (from 1-specify)
- `1.5-architecture.md` (from 5-design)
- `1.6-implementation-plan.md` (from 6-plan)
- `templates/branch-template.md` (from root)

## Guidance

### 1. Branch Creation

- Checkout base branch and pull latest
- Create branch: `feature/{JIRA_KEY}-migrate-{WIDGET_NAME}`
- Run package manager install (`pnpm i` or equivalent)

### 2. Clean State Check

If uncommitted changes exist: STOP and ask user to stash or discard.

### 3. Project Scaffold

Based on `TARGET_TYPE`, create the project structure:
- `package.json`, `stencil.config.ts`, `jest.config.js`
- `src/components/` folder structure per architecture
- `__mocks__/` folder if needed
- `tsconfig.json` if needed

Follow the target repository's conventions for scaffold structure.

## Outputs

- Feature branch created
- Project scaffolded with build/test config
- Dependencies installed

## Gate

STOP if repo is not in clean state. Otherwise continue.
