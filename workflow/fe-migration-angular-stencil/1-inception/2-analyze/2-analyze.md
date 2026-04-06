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

### 0. Check for Saved Analysis Report

Before launching any subagent, check whether `docs/{WIDGET_NAME}/angular-analysis-report.md` exists in the target repository (produced by a prior JIRA Epic / analysis workflow).

- **If the file exists**: read it. This is the full Angular analysis report. Use it in place of step 1 below — skip straight to step 2 (BFF contracts). Inform the user: "Found existing analysis report — reusing it."
- **If the file does NOT exist**: proceed with step 1.

### 1. Deep Widget Analysis

Using `ENTRY_POINT` in the source Angular repository:

- Analyse the main component: inputs, outputs, template, lifecycle, state, methods
- Identify nested components (up to 3 levels): inputs, outputs, behaviour
- Identify services: API calls, stores/NgRx, config, feature flags
- Map data flow, event flow, styling/SCSS usage
- Note config usage that will be omitted in the MFE (replaced by props, Event Bus, or BFF)
- **Typography classes**: scan all HTML templates for Genos typography classes (e.g. `genos-heading-h2`, `genos-body-regular`). Record each occurrence and mark as → replace with `<fds-sb-typography>`. See `$KB_PATH/knowledge/shared/engineering-standards/fabric/coding-standards/typography-and-genos-rules.md`.
- **Genos CSS variables**: scan all SCSS/CSS files for `var(--genos-*)` usage. List every occurrence. Mark as → MUST NOT be used in new architecture.
- **Analytics tracking**: scan for analytics/tracking calls (`track()`, `trackEvent()`, `dataLayer.push()`, GTM triggers). Record event names, trigger conditions, and payloads. If none found, state "No analytics tracking found."

### 2. BFF Contract Extraction

- Fetch widget contracts from Confluence via MCP (page ID `844497904` for Widgets Contracts index, space `SB`)
- If the correct child page is ambiguous, ask the user for the exact Confluence link
- Derive TypeScript request/response types
- Search existing `libs/contracts/src/types/` for reusable types before creating new ones
- For missing types, check shared contracts page via MCP (page ID `838467673`, space `SB`)
- Types from the Commonly Used Contracts page must go in `libs/contracts/src/types/shared.types.ts`

### 3. Produce Checkpoint

Populate `templates/1.2-analysis-summary.template.md` and save to `initiatives/{INITIATIVE_NAME}/artefacts/1.2-analysis-summary.md`.

## Outputs

- `1.2-analysis-summary.md` in initiative artefacts folder

## Gate

STOP until all contracts are resolved (fetched, found in libs, or confirmed by user).
