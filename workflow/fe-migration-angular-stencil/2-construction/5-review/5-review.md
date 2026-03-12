---
step: review
subagent: false
checkpoint: initiatives/{INITIATIVE_NAME}/artefacts/2.5-code-review.md
---

## Inputs

- All implemented files (from 2-implement)
- `1.4-requirements.md` (from 4-requirements)
- `2.4-test-report.md` (from 4-test)

## Guidance

Pre-load `knowledge-core/troubleshooting.md` for reference when diagnosing any issues found during review. Also reference `knowledge-core/shadow-dom-css-rules.md`, `knowledge-core/event-bus-access.md`, and `knowledge-core/bff-data-fetching.md` when verifying implementation correctness.

### 1. Requirements Verification

Check every requirement in `1.4-requirements.md` against the implementation:
- FR-xxx: is the functional requirement met?
- DR-xxx: are data contracts correct?
- VR-xxx: does the visual match the expected layout?

Mark each requirement as: MET / PARTIAL / NOT MET.

### 2. Code Review

Populate `templates/2.5-code-review.template.md` with findings categorised as:

- **Must Fix**: blocks delivery (broken functionality, missing requirements, security issues)
- **Should Fix**: high impact but not blocking (naming violations, missing edge cases)
- **Consider**: suggestions for improvement (performance, readability)

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

STOP -- this triggers the **Phase 2 gate**. User must confirm local review passes.
