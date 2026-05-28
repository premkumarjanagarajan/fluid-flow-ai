---
step: load-template
subagent: false
conditional: true
---

## Inputs

- Confirmed artefact type from Step 2.6

## Execution

Based on the confirmed artefact type, load the appropriate template from `{KB_PATH}/knowledge/shared/canonical-templates/`:

| Route | Template file | Enforcement rule |
|-------|---------------|-----------------|
| Big Bet | `big-bet-template.md` | ⚠️ No solutions, no delivery detail. Big Bets justify direction, not execution. |
| Need & Opportunity | `need-opportunity-template.md` | ⚠️ No solutioning. If "how" appears in any field, redirect to Solution instead. |
| Solution | `solution-template.md` | ⚠️ Investment decision artefact. Delivery detail belongs downstream in Epics — do not include it here. |
| Feature Brief | `feature-brief-template.md` | Walk through each section one at a time with the user. Flag scope gaps, dependencies, and assumptions as you go. |
| Epic | `epic-template.md` | ⚠️ Delivery container only. Do not restate problems or justify investment — that belongs in the Feature Brief or Solution. |
| User Story | `user-story-template.md` | ⚠️ Must be testable and independent. If a story cannot be verified in isolation, it is not ready for sprint commitment. |
| Test Case | `test-case-template.md` | ⚠️ Template under development. Confirm with QA Lead before using in production workflows. Every User Story must have at least one Test Case before it can be marked as Done. |

## Outputs

- Template loaded into working context

## Gate

Template successfully loaded and presented to user.
