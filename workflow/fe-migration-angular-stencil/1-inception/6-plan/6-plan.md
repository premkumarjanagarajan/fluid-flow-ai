---
step: plan
subagent: false
checkpoint: initiatives/{INITIATIVE_NAME}/artefacts/1.6-implementation-plan.md
---

## Inputs

- `1.4-requirements.md` (from 4-requirements)
- `1.5-architecture.md` (from 5-design)
- `JIRA_KEY`, `WIDGET_NAME`, `TARGET_TYPE` (from 1-specify)

## Guidance

Populate `templates/1.6-implementation-plan.template.md`.

### 1. Implementation Steps

Ordered task list covering the full scope:
1. Contracts (types, enums in libs/contracts)
2. Scaffold (app folder, package.json, stencil.config, jest.config)
3. Components (root + children, one per task)
4. Styles (SCSS files)
5. Stories (Storybook stories with mocks)
6. Tests (unit test files)
7. Docs (architecture.md already done; add readme-notes.md)

### 2. Files to Create

Explicit list of new files with their purpose, mapped to which requirement they satisfy.

### 3. Requirement Mapping

Each implementation step must reference which requirement IDs (FR-xxx, DR-xxx, VR-xxx) it fulfills.

Save to `initiatives/{INITIATIVE_NAME}/artefacts/1.6-implementation-plan.md`.

This is a **temporary** document -- kept until the migration is live in production.

## Outputs

- `1.6-implementation-plan.md` in initiative artefacts folder

## Gate

STOP -- this triggers the **Phase 1 gate**. User must approve both `1.5-architecture.md` and `1.6-implementation-plan.md` before Phase 2.
