---
step: load-template
subagent: false
conditional: true
---

## Inputs

- Confirmed artefact type from Step 2.6

## Execution

Based on the confirmed artefact type, load the appropriate template:

| Route | Template Path |
|-------|---------------|
| JPD (Idea) | `knowledge/Layer 1 – Global Company Knowledge (Shared)/canonical-templates/jpd-idea-template.md` — use when the concept is early-stage and needs initial framing before proper problem definition |
| JPD (Need & Opportunity) | `knowledge/Layer 1 – Global Company Knowledge (Shared)/canonical-templates/jpd-need-opportunity-template.md` — stop here until discovery is completed and confirmed |
| JPD (Solution) | `knowledge/Layer 1 – Global Company Knowledge (Shared)/canonical-templates/jpd-solution-template.md` — use when a Need has been validated and prioritised |
| Feature Brief | `knowledge/Layer 1 – Global Company Knowledge (Shared)/canonical-templates/feature-brief-template.md` — walk through each section one at a time with the user. Flag scope gaps, dependencies, and assumptions as you go |
| Epic (full planning) | `knowledge/Layer 1 – Global Company Knowledge (Shared)/canonical-templates/epic-brief-template.md` — define: the delivery outcome, dependencies, and success signal |
| Epic (lean Jira ticket) | `knowledge/Layer 1 – Global Company Knowledge (Shared)/canonical-templates/jira-epic-template.md` — for lean Jira ticket creation post-inception |
| User Story | `knowledge/Layer 1 – Global Company Knowledge (Shared)/canonical-templates/jira-user-story-template.md` — ensure the story represents a single, testable slice of user value |
| Phased delivery | Also load `knowledge/Layer 1 – Global Company Knowledge (Shared)/canonical-templates/jpd-phase-template.md` for phase breakdown (MVP → Optimisation → Expansion) |

> **Epic boundary rule:** Epics are delivery containers. They do **not** restate problems or justify investment — that belongs in the Feature Brief or Solution. Do not duplicate discovery or justification content when creating Epics.

## Outputs

- Template loaded into working context

## Gate

Template successfully loaded and presented to user.
