---
step: delivery-size
subagent: false
---

## Inputs

- Step 2.4 confirmation that a Feature Brief is allowed

## Execution

Ask the user:

> Is the proposed work too large to deliver as a single user story?

Consider:
- Number of systems involved
- Number of teams involved
- Delivery over multiple sprints
- Multiple user journeys

**Routing logic:**
- If **yes** → **Epic(s)** will be required later.
- If **no** → a **User Story** may be sufficient.

## Outputs

- Epic vs User Story signal stored in session state

## Gate

User confirms delivery size assessment.
