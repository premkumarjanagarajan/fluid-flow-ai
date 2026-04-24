---
step: phasing
subagent: false
---

## Inputs

- Step 2.5 delivery-size signal

## Execution

Ask the user:

> Does the work require staged delivery?

Answer **yes** if:
- Value can be delivered incrementally
- Risk needs to be reduced
- Rollout differs by market, platform, or dependency

**Routing logic:**
- If **yes** → phases are required. The artefact should reflect staged delivery (e.g. phased Epic breakdown or phased Feature Brief scope).
- If **no** → single delivery scope is sufficient.

**Decision criteria (remaining artefacts):**

| Artefact | When to use |
|----------|-------------|
| Feature Brief | Problem is clear but the solution requires cross-functional alignment, market/compliance review, and structured definition |
| Epic | Solution is understood and agreed; work needs to be broken into a deliverable scope with engineering involvement |
| User Story | Solution is clear, scope is small, and the work can be expressed as a single user-facing outcome |

**User confirmation checkpoint:**
Present the recommended artefact type to the user with the reasoning. Wait for explicit confirmation before proceeding.

## Outputs

- Confirmed artefact type + phasing decision

## Gate

User explicitly confirms the recommended artefact type.
