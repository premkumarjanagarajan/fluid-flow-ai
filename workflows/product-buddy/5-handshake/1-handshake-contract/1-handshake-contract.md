---
step: handshake-contract
subagent: false
---

## Inputs

- Approved Feature Brief from Phase 3
- Completed decision log from Phase 4
- All Phase 5 pre-entry conditions confirmed

## AI Role

- Verify all pre-entry conditions before beginning any handshake work.
- Run the **Handshake Readiness Validation** below before drafting any contracts.
- Draft handshake contracts from the approved Feature Brief, capturing what Product and Engineering both commit to.
- Cross-reference any available integration standards for applicable constraints.
- Validate market constraints from available market documentation against the proposed implementation scope.
- Surface any remaining open questions that must be resolved before contracts can be signed off.

## Delivery Artefact Readiness Check

The Handshake phase can only be initiated when Epics, User Stories, and their corresponding Test Cases are fully defined.

If any pre-entry condition or delivery artefact readiness check is not met, **stop and surface the gap**. Do not proceed with drafting handshake contracts. Return to the phase where the gap originated.

1. **Epics** — one or more Epics must exist that:
   - [ ] Are linked to the approved Solution or Feature Brief
   - [ ] Represent coherent delivery outcomes
   - [ ] Meet Definition of Ready

2. **User Stories** — each Epic must contain User Stories that:
   - [ ] Represent independent, testable slices of user value
   - [ ] Include clear acceptance criteria
   - [ ] Are small enough to be delivered within a sprint

3. **Test Cases** — each User Story must have Test Cases that:
   - [ ] Validate the acceptance criteria
   - [ ] Cover happy path and key edge cases
   - [ ] Provide sufficient confidence that the story works as intended

## Handshake Readiness Validation

Before proceeding, answer each question explicitly. Record the answer for each.

| # | Question | Answer | Evidence |
|---|----------|--------|----------|
| 1 | Do approved Epics exist for this initiative? | Yes / No | [Epic references] |
| 2 | Are User Stories created and linked under each Epic? | Yes / No | [Story count per Epic] |
| 3 | Does every User Story have defined acceptance criteria? | Yes / No | [Stories missing AC, if any] |
| 4 | Are Test Cases defined for each User Story? | Yes / No | [Stories missing Test Cases, if any] |
| 5 | Is traceability intact from Epics back to Solution or Feature Brief? | Yes / No | [Broken links, if any] |

**If any answer is No:**
- **Do not** draft handshake contracts.
- **Do not** request Product or Engineering approval.
- Clearly state which artefacts are missing or incomplete, with their owner and what must be completed.
- Route back to the appropriate phase:
  - Missing or incomplete Epics, User Stories, or Test Cases → return to **Define** (Phase 3)
  - Missing Solution or Feature Brief linkage → return to **Artefact Selection** (Phase 2)
  - Broken traceability → return to the phase where the link was lost

## Handshake Contract Format

```markdown
## Handshake Contract — [Feature Name]

**Feature Brief ref:** [path to merged Feature Brief]
**Date:** YYYY-MM-DD

### Product Commitments
- [commitment]

### Engineering Commitments
- [commitment]

### Shared Constraints
- [market or compliance constraint binding both parties]

### Open Questions
- [question, owner, and resolution deadline — or "None"]
```

## Outputs

- Handshake Readiness Validation table (completed)
- Handshake contract drafted
- Open questions surfaced (if any)

## Gate

- [ ] All pre-entry conditions verified
- [ ] Delivery artefact readiness check passed (all 5 validation questions = Yes)
- [ ] Handshake contract reviewed and confirmed by both Product and Engineering
- [ ] No unresolved open questions remain (or resolution deadlines agreed)
