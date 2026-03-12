---
step: analyze
subagent: true
checkpoint: initiatives/{INITIATIVE_NAME}/artefacts/1.2-analysis-summary.md
---

## Inputs

- `ENTRY_POINT` (from 1-specify)
- `WIDGET_NAME` (from 1-specify)
- `TARGET_TYPE` (from 1-specify)

## Guidance

Load `instructions/angular-stencil-mapping.md` for Angular-to-StencilJS pattern reference.

### 1. Deep Widget Analysis

Using `ENTRY_POINT` in the source Angular repository:

- Analyse the main component: inputs, outputs, template, lifecycle, state, methods
- Identify nested components (up to 3 levels): inputs, outputs, behaviour
- Identify services: API calls, stores/NgRx, config, feature flags
- Map data flow, event flow, styling/SCSS usage
- Note config usage that will be omitted in the MFE (replaced by props, Event Bus, or BFF)

### 2. BFF Contract Extraction

- Fetch widget contracts from Confluence via MCP (or ask user for link if ambiguous)
- Derive TypeScript request/response types
- Search existing `libs/contracts/src/types/` for reusable types before creating new ones
- For missing types, check shared contracts page via MCP

### 3. Produce Checkpoint

Populate `templates/1.2-analysis-summary.template.md` and save to `initiatives/{INITIATIVE_NAME}/artefacts/1.2-analysis-summary.md`.

## Outputs

- `1.2-analysis-summary.md` in initiative artefacts folder

## Gate

STOP until all contracts are resolved (fetched, found in libs, or confirmed by user).
