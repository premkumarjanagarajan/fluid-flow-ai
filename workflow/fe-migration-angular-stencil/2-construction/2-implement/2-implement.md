---
step: implement
subagent: true
checkpoint: initiatives/{INITIATIVE_NAME}/artefacts/2.2-implementation-complete.md
---

## Inputs

- `1.4-requirements.md` (from 4-requirements)
- `1.5-architecture.md` (from 5-design)
- `1.6-implementation-plan.md` (from 6-plan)
- Scaffolded project (from 1-scaffold)

## Guidance

Load `instructions/stenciljs-conventions.md` and `instructions/css-conventions.md`.

### Build-First Approach

Implement from the plan and architecture, not from Figma-generated code. Use Figma/screenshots only for visual verification after building.

### Implementation Order

Follow the order from `1.6-implementation-plan.md`:

1. **Contracts**: types and enums in `libs/contracts/src/types/`
2. **Root component**: orchestrator only (state, lifecycle, Event Bus, data fetching)
3. **Child components**: one at a time, each pure (props-only, no Event Bus)
4. **Styles**: SCSS with FDS tokens only, container queries, no hardcoded values

### Rules

- Root component must NOT contain render logic for distinct UI sections
- Each child component must be independently testable
- Use `@Prop()`, `@Event()`, `@State()` per StencilJS conventions
- Event Bus for inter-MFE communication, not `@Method()`
- Do NOT migrate Angular config file logic -- omit and document

### Checkpoint

After all components are implemented, write a brief summary to the checkpoint file listing files created and requirements covered.

## Outputs

- All component `.tsx`, `.scss`, type files
- `2.2-implementation-complete.md` checkpoint

## Gate

None -- continue to build step.
