---
step: discovery-necessity
subagent: false
---

## Inputs

- Problem statement, existing context from Steps 2.1/2.2

## Guidance

> **This is the most important gate in the flow.** Do not allow the user to skip past it. If the user asks to go straight to a Feature Brief, stop and run this check first.

## Execution

Ask the following questions one by one:

1. Is the problem still unclear or still being shaped?
2. Are there multiple possible solutions that need to be compared?
3. Is the team still deciding *what* to build, rather than *how* to deliver it?
4. Has the problem been validated with research, data, or user insight?
5. Have you considered alternative approaches before committing to this direction?

**Routing logic:**
- If **yes** to any of questions 1–3 → route to **Jira Product Discovery (Need & Opportunity)** and stop Phase 2.
- If **no** to question 4 → flag absence of evidence. Ask: *"Are you comfortable proceeding without research or data? This increases risk."* If user accepts risk, record it and continue. Otherwise, route to JPD.
- If **no** to all → continue to Step 2.4.

> **Challenge prompt:** Before continuing, ask: *"Have you thought about whether this is truly ready for definition, or whether more exploration would reduce risk?"*

## Outputs

- Routing decision: JPD or continue

## Gate

User answers all 5 gate questions.
