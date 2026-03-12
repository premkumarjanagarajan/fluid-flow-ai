---
step: implement
subagent: true
checkpoint: initiatives/{INITIATIVE_NAME}/artefacts/2.2-implementation-complete.md
---

## Inputs

- `1.4-requirements.md` (from 4-requirements)
- `1.5-architecture.md` (from 5-design)
- `1.6-implementation-plan.md` (from 6-plan)
- `1.6-migration-context.md` (from 6-plan) — read this first as the compact reference
- Scaffolded project (from 1-scaffold)

## Guidance

Load these instructions before implementing:
- `instructions/stenciljs-conventions.md` — component structure, shadow DOM, lifecycle, Event Bus access, BFF fetching
- `instructions/css-conventions.md` — FDS tokens, shadow DOM CSS rules, responsive layout system, specificity
- `instructions/tsx-structure-semantics.md` — semantic HTML5 in TSX render output
- `instructions/sass-standards.md` — SCSS formatting, ordering, modules
- `instructions/performance-best-practices.md` — lazy loading, bundle size, observers

Also pre-load from `knowledge-core/`:
- `shadow-dom-css-rules.md` — two mandatory rules (class placement, flat selectors)
- `event-bus-access.md` — mandatory `window.sbXpEventBus` rule
- `bff-data-fetching.md` — three mandatory BFF data fetching rules
- `typescript-standards.md` — explicit return types, enum guidance, null handling
- `troubleshooting.md` — common build/test/styling issues and fixes
- `typography-and-genos-rules.md` — fds-sb-typography mandatory, Genos CSS variables forbidden

### Group-Based Implementation

Implement the migration in **groups**, one at a time. Each group follows this cycle:

1. **Implement** — write all files for the group
2. **Lint** — run linter on the new files, fix any errors
3. **Review** — launch a review subagent to check standards compliance (see step 2.5)
4. **Fix** — address all MUST-FIX issues from the review; apply SHOULD-FIX unless there is a documented reason not to
5. **Commit** — stage only the files in this group (never `git add -A`); commit locally with format `feat({WIDGET_NAME}): {scope} — {short description}`
6. **STOP** — present the group summary to the user and wait for approval before starting the next group

### Group Plan

Present the planned groups to the user before writing any code. Wait for confirmation.

Groups from `1.6-implementation-plan.md`:

| Group | Scope | Commit scope |
|---|---|---|
| 1 | Contracts & Scaffold | `contracts & scaffold` |
| 2 | Root Component | `component — root` |
| 3+ | Child Component(s) | `component — {child-name}` |
| N-1 | Unit Tests | `tests` |
| N | Storybook Stories | `stories` |

### Build-First Approach

Implement from the plan and architecture, not from Figma-generated code. Use Figma/screenshots only for visual verification after building.

### Constant Rules Across All Groups

- Root component must NOT contain render logic for distinct UI sections
- Each child component must be independently testable (pure, props-only)
- Use `@Prop()`, `@Event()`, `@State()` per StencilJS conventions
- Event Bus via `window.sbXpEventBus` for inter-MFE communication
- Do NOT migrate Angular config file logic — omit and document
- All typography via `<fds-sb-typography>` — no raw Genos classes
- No Genos CSS variables (`var(--genos-*)`) — use project tokens
- Follow reusability decisions from `1.6-migration-context.md` exactly

### Test and Story Groups

For widgets with 3+ components, tests and stories can be parallelised by launching one subagent per component. For simpler widgets (1-2 components), write directly.

### Final Requirements Check

After the last component group (before tests), verify every requirement from `1.4-requirements.md` is covered. If any requirement is not addressed, implement it or document the gap and ask the user.

### Checkpoint

After all groups are implemented, write a brief summary to the checkpoint file listing files created, groups completed, and requirements covered.

## Outputs

- All component `.tsx`, `.scss`, type files (committed per group)
- `2.2-implementation-complete.md` checkpoint

## Gate

STOP after each group — user must approve before the next group starts.
