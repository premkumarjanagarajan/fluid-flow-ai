---
step: design
subagent: true
checkpoint: initiatives/{INITIATIVE_NAME}/artefacts/1.5-architecture.md
---

## Inputs

- `1.2-analysis-summary.md` (from 2-analyze)
- `1.4-requirements.md` (from 4-requirements)
- `TARGET_TYPE` (from 1-specify)

## Guidance

Load `instructions/event-bus-patterns.md` and `instructions/naming-conventions.md`.

### 1. Reusability Scan

Scan the target repository for existing code that can be reused. Scope by target type:

| Target type | Search scope |
|---|---|
| app-mfe | `design-system/` + `libs/` |
| service-mfe | `libs/` only |
| design-system | `libs/` only (no design-system imports) |
| typescript library | `libs/` only |

For each candidate found, decide: **Reuse as-is** / **Adapt** / **Create new**. Document reasoning.

### 2. Component Decomposition

- Root widget component = orchestrator only (state, lifecycle, Event Bus, data fetching)
- Each distinct UI section = its own child component (pure, props-only, no Event Bus)
- If a component file would exceed ~150 lines, split further
- Document: component name, tag name, responsibility, inputs, parent

### 3. Service Layer

Map Angular services to StencilJS equivalents. Define Event Bus contracts for inter-MFE communication.

### 4. Produce Architecture

Populate `templates/1.5-architecture.template.md` and save to `initiatives/{INITIATIVE_NAME}/artefacts/1.5-architecture.md`.

This is a **permanent** document -- it survives after implementation.

## Outputs

- `1.5-architecture.md` in initiative artefacts folder
- Reusability decision table (inline in architecture)

## Gate

None -- continue to next step. (Phase gate after step 6 covers approval.)
