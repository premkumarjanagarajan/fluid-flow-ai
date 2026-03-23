---
step: plan
subagent: false
checkpoint: initiatives/{INITIATIVE_NAME}/artefacts/1.6-implementation-plan.md
---

## Inputs

- `1.4-requirements.md` (from 4-requirements)
- `1.5-architecture.md` (from 5-design)
- `JIRA_KEY`, `WIDGET_NAME`, `PASCAL_CASE_WIDGET_NAME`, `TARGET_TYPE`, `ENTRY_POINT` (from 1-specify)
- Approved component breakdown (from 5-design step 3)

## Guidance

This step produces **two documents**: the implementation plan and the migration context handoff.

### 1. Implementation Plan

Populate `templates/1.6-implementation-plan.template.md`.

#### Implementation Groups

Organise the plan into **implementation groups** (not a flat list). Each group is implemented, reviewed, and committed separately during Construction:

| Group | Scope | What it covers |
|---|---|---|
| 1 | contracts & scaffold | Types/enums in `libs/contracts/`, app folder, config files, `docs/{widget}/architecture.md` |
| 2 | root component | Root widget `.tsx` + `.scss` |
| 3+ | child components | One group per child (or batch if ≤2 children) |
| N-1 | tests | All `*.spec.tsx` files |
| N | stories | All `*.stories.ts` files + `.storybook/mocks/` |

#### Files to Create

Explicit list of new files with their purpose, mapped to which requirement they satisfy.

#### Requirement Mapping

Each implementation step must reference which requirement IDs (FR-xxx, DR-xxx, VR-xxx) it fulfills.

Save to `initiatives/{INITIATIVE_NAME}/artefacts/1.6-implementation-plan.md`.

This is a **temporary** document — kept until the migration is live in production.

### 2. Migration Context Handoff

Populate `templates/1.6-migration-context.template.md`.

This is a compact (~80 lines) handoff file that the Construction phase reads first. It distils the key information from the full plan and architecture into a quick-reference format. It must include:

- Key references (JIRA, branch, widget name, target type, entry point)
- Approved component breakdown (from 5-design)
- Files to create
- Reusability decisions
- BFF summary
- Typography replacements (from 5-design)
- Genos CSS variable replacements (from 5-design)
- Key architectural decisions

Save to `initiatives/{INITIATIVE_NAME}/artefacts/1.6-migration-context.md`.

This is a **temporary** document — deleted after the implementation PR is merged.

## Outputs

- `1.6-implementation-plan.md` in initiative artefacts folder
- `1.6-migration-context.md` in initiative artefacts folder

## Gate

STOP — this triggers the **Phase 1 gate**. User must approve `1.5-architecture.md`, `1.6-implementation-plan.md`, and `1.6-migration-context.md` before Phase 2.
