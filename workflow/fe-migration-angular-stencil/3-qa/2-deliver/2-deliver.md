---
step: deliver
subagent: false
---

## Inputs

- All approved code + tests + stories
- `JIRA_KEY`, `WIDGET_NAME` (from 1-specify)

## Guidance

### 1. Logical Commits

Split changes into separate commits in this order (skip any with no changes):

| # | Scope | What it covers |
|---|---|---|
| 1 | contracts | Types and enums in `libs/contracts/` |
| 2 | scaffold | App folder, `package.json`, `stencil.config.ts`, `jest.config.js` |
| 3 | components | Root widget + all child components |
| 4 | styles | SCSS files |
| 5 | stories | Storybook stories + mocks |
| 6 | tests | Unit test files |
| 7 | docs | `architecture.md`, `implementation-plan.md`, `readme-notes.md` |

Commit message format: `feat({WIDGET_NAME}): {scope} -- {short description}`

### 2. Push

Push branch to origin.

### 3. Handoff to Orchestrator

After push, control returns to the orchestrator's Stage 6 (Completion) which handles PR creation and risk report.

## Outputs

- Logical commits on feature branch
- Branch pushed to origin

## Gate

STOP -- present commit plan to user and wait for approval before executing commits and push.
