---
step: review
subagent: false
checkpoint: initiatives/{INITIATIVE_NAME}/artefacts/2.5-code-review.md
---

## Inputs

- All implemented files (from 2-implement, committed per group)
- `1.4-requirements.md` (from 4-requirements)
- `2.4-test-report.md` (from 4-test)

## Guidance

Pre-load `knowledge-core/troubleshooting.md` for reference when diagnosing any issues found during review. Also reference `knowledge-core/shadow-dom-css-rules.md`, `knowledge-core/event-bus-access.md`, `knowledge-core/bff-data-fetching.md`, and `knowledge-core/typography-and-genos-rules.md` when verifying implementation correctness.

### Per-Group Review (during 2-implement)

During the group-based implementation (step 2.2), a review subagent is launched after each group. The review subagent checks the group's files against standards and returns findings categorised as:

- **MUST-FIX**: blocks continuation (broken functionality, missing requirements, architecture violations, Genos typography classes, Genos CSS variables)
- **SHOULD-FIX**: guideline violations that should be addressed before PR merge
- **CONSIDER**: suggestions for improvement

The review subagent checks vary by group type:

| Group type | Key checks |
|---|---|
| contracts-scaffold | Types match BFF contract, `Get{Widget}Response` alias exported, no duplicate types, scaffold config consistent |
| component | Root is orchestrator-only, children are pure, BFF dual guard, no Angular config, no Genos classes/variables, `fds-sb-typography` used, Event Bus via `window.sbXpEventBus`, SCSS flat selectors, no hardcoded values |
| tests | All props tested, all render branches covered, all events tested, mocks reset in beforeEach, `newSpecPage` used |
| stories | All meaningful states covered, Event Bus mocks present, mock data matches BFF types, no duplicates |

### 1. Final Requirements Verification

After all groups are complete, check every requirement in `1.4-requirements.md` against the full implementation:
- FR-xxx: is the functional requirement met?
- DR-xxx: are data contracts correct?
- VR-xxx: does the visual match the expected layout?

Mark each requirement as: MET / PARTIAL / NOT MET.

### 2. Consolidated Code Review

Populate `templates/2.5-code-review.template.md` with a consolidated summary of all per-group reviews plus any additional findings.

### 3. Present to User

Save review to `initiatives/{INITIATIVE_NAME}/artefacts/2.5-code-review.md`.

Ask user to review locally:
1. Run the app or Storybook
2. Run unit tests
3. Report any issues or approve

## Outputs

- `2.5-code-review.md` in initiative artefacts folder
- Requirements verification checklist

## Gate

STOP — this triggers the **Phase 2 gate**. User must confirm local review passes.
