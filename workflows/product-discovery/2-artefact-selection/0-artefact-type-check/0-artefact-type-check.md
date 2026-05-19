---
step: artefact-type-check
subagent: false
conditional: false
---

## Inputs

- Confirmed problem statement (Phase 1)

## Purpose

Before running the full 8-step selection process, ask the human directly. They may already know what they need. If they do, respect that and fast-track. If they are unsure, run the full step chain.

## Execution

Ask the user:

> Before we work through the selection steps — do you already know what type of artefact you need?
>
> **A) Feature Brief** — full specification document in Confluence (for significant Solutions)
> **B) JPD artefact** — Big Bet, Need & Opportunity, or Solution in Jira Product Discovery
> **C) Jira artefact** — Epic or User Story in Jira Software
> **D) Not sure** — walk me through the selection

---

### If A — Feature Brief

Confirm with one question:

> Is there already an approved Solution in JPD that this Feature Brief will sit under?
> - **Yes** → proceed to Step 2.7 (load `feature-brief-template.md`) — skip Steps 2.1–2.6
> - **No** → flag: *"A Feature Brief requires a validated Solution in JPD first. Should we create the Solution record before the Brief?"*
>   - If user confirms they want to go JPD first → route to Step 2.1 (New vs Existing) with artefact type = Solution
>   - If user insists on Feature Brief directly → proceed but record the gap in the artefact's Attribution section

---

### If B — JPD artefact

Ask one follow-up:

> Which JPD artefact?
> - **Big Bet** → proceed to Step 2.7 (load `big-bet-template.md`) — skip Steps 2.1–2.6
> - **Need & Opportunity** → proceed to Step 2.7 (load `need-opportunity-template.md`) — skip Steps 2.1–2.6
> - **Solution** → confirm a linked N&O exists, then proceed to Step 2.7 (load `solution-template.md`) — skip Steps 2.1–2.6

---

### If C — Jira artefact

Ask one follow-up:

> Which Jira artefact?
> - **Epic** → proceed to Step 2.7 (load `epic-template.md`) — skip Steps 2.1–2.6
> - **User Story** → confirm a parent Epic exists, then proceed to Step 2.7 (load `user-story-template.md`) — skip Steps 2.1–2.6
> - **Test Case** → confirm a parent User Story exists, then proceed to Step 2.7 (load `test-case-template.md`) — skip Steps 2.1–2.6

---

### If D — Not sure

Proceed to Step 2.1 (New vs Existing). Run the full step chain.

---

## Fast-track rule

When the human selects A, B, or C and the pre-condition is met: load the template directly in Step 2.7. Do **not** run Steps 2.1–2.6. Record the human's selection as the routing decision.

When the pre-condition is **not** met (e.g. Feature Brief without a Solution, User Story without an Epic): flag the gap, ask whether to resolve it first or proceed with the risk noted.

## Outputs

- Artefact type confirmed (or "not sure" → defer to step chain)
- Fast-track flag: YES / NO

## Gate

Human has selected an artefact type OR confirmed they want guided selection.
