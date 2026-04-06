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
Also load `$KB_PATH/knowledge/shared/engineering-standards/fabric/coding-standards/typography-and-genos-rules.md` for typography and Genos CSS variable constraints.

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

### 3. Component Breakdown Approval (STOP gate)

**Before writing the architecture document**, present the proposed component breakdown to the user for approval. This prevents plan rewrites — the agreed breakdown drives all output documents.

Present:
- The root component and its responsibilities
- Each proposed child component with: name, responsibility, what gets extracted into it, and which parent mounts it
- The reasoning for each extraction (extract vs combine rule of thumb)
- How the breakdown maps to the visual sections identified in the analysis/screenshots

Ask the user to review against Figma/screenshots and confirm:
- **A**: Approved — proceed with this breakdown
- **B**: I have changes (describe them)

**STOP until the user approves the component breakdown.**

If the user requests changes, adjust and re-present until approved.

### 4. Service Layer

Map Angular services to StencilJS equivalents. Define Event Bus contracts for inter-MFE communication.

### 5. Typography and Genos Replacements

Using the typography and Genos CSS variable findings from the analysis report:
- Map every Genos typography class to its `<fds-sb-typography>` equivalent (variant + tag)
- Identify replacements for every Genos CSS variable (project token or documented gap)
- Include both mappings in the architecture document

### 6. Produce Architecture

Populate `templates/1.5-architecture.template.md` and save to `initiatives/{INITIATIVE_NAME}/artefacts/1.5-architecture.md`.

This is a **permanent** document — it survives after implementation. Must include all reusability decisions (permanent record since implementation-plan.md is deleted after migration).

## Outputs

- `1.5-architecture.md` in initiative artefacts folder
- Reusability decision table (inline in architecture)
- Approved component breakdown

## Gate

STOP at step 3 for component breakdown approval. Then continue to completion. (Phase gate after step 6 covers overall approval.)
