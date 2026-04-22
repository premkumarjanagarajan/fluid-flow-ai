---
step: depth-guidance
subagent: false
---

## Inputs

- Confirmed artefact type + loaded template from Step 2.7

## Execution

These prompts prevent over- or under-splitting. Apply the relevant prompt based on the artefact type selected.

### Feature Brief → Needs & Opportunities

Ask: *"Does this Feature Brief contain more than one core problem or opportunity?"*

If yes:
- List each distinct problem
- Confirm whether each could be prioritised independently
- If more than 3 exist, recommend splitting the brief

### Need & Opportunity → Solutions

Ask: *"For this need, list up to three materially different solution approaches."*

If differences are only implementation details, keep them as one solution.

### Solution → Phases

Ask: *"Can this solution deliver meaningful value in stages?"*

If yes:
- Define Phase 1 (minimum viable outcome)
- Define later phases only if they add distinct value

### Phase / Solution → Epics

Ask: *"Does this phase or solution span different teams, different systems, or different user outcomes?"*

If yes, split into multiple Epics. Each Epic must represent a coherent delivery outcome.

### Epic → User Stories

Break the Epic into user stories. Each story must:
- Deliver independent user value
- Be testable
- Fit within a sprint

If a story has multiple user roles, flows, or outcomes, split it.

### User Story → Test Cases

For each user story, identify what must be proven for it to be considered working. Cover:
- Happy path
- Key alternate paths
- Error states
- Permissions or roles
- Analytics where relevant

Do not optimise for a number. Optimise for confidence.

> Phase 2 exists to decide the right level of structure — not to default into documentation.

## Outputs

- Artefact depth confirmed, splitting/grouping decisions recorded

## Gate

- [ ] Correct artefact type selected and confirmed by the user
- [ ] Existing context reused where possible (Phase 1.5 results applied)
- [ ] No unnecessary artefacts created
- [ ] Depth of breakdown justified (problem clarity, solution certainty, delivery complexity)
- [ ] Traceability intact — artefact links back to its parent (Big Bet, Need & Opportunity, or Solution)
- [ ] No forced Feature Briefs — artefact type matches the actual level of understanding

**Re-entry rule:**
When JPD discovery is completed and a Solution is approved, re-enter the lifecycle at Phase 2 (Artefact Selection). Never jump directly from JPD to Feature Brief without re-evaluating the required structure.
