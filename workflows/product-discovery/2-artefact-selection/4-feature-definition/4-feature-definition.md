---
step: feature-definition
subagent: false
---

## Inputs

- Phase 1 context + Step 2.3 results

## Execution

Ask the user: *"Do we understand the problem well enough to propose a specific feature direction?"*

Answer **yes** only if ALL of the following are true:
- The user problem is clear
- The intended outcome is clear
- The direction is credible

**Routing logic:**
- If **yes** → Feature Brief is allowed. Continue to Step 2.5.
- If **no** → route to **Jira Product Discovery (Need & Opportunity)** and stop Phase 2.

## Outputs

- Feature Brief allowed or routed to JPD

## Gate

User confirms problem clarity.
