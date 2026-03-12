---
step: requirements
subagent: false
checkpoint: initiatives/{INITIATIVE_NAME}/artefacts/1.4-requirements.md
---

## Inputs

- `1.2-analysis-summary.md` (from 2-analyze)
- Resolved gaps (from 3-clarify)
- Screenshots / visual reference (from 3-clarify)
- Existing acceptance criteria at `docs/{widget}/main-acceptance-criteria.md` if available

## Guidance

Populate `templates/1.4-requirements.template.md` with three requirement categories:

### Functional Requirements

What the widget must do. Derive from analysis + clarifications. Use Given/When/Then format for each AC.

### Data Requirements

Contracts, types, and data flow. Which BFF endpoints are called, what types are consumed/produced, what Event Bus messages are sent/received.

### Visual Requirements

Layout, responsive behaviour, states (loading, empty, error, populated). Reference screenshots where applicable.

Each requirement must be:
- Uniquely numbered (FR-001, DR-001, VR-001)
- Testable
- Traceable to analysis source

Save to `initiatives/{INITIATIVE_NAME}/artefacts/1.4-requirements.md`.

## Outputs

- `1.4-requirements.md` in initiative artefacts folder

## Gate

None -- continue to next step.
