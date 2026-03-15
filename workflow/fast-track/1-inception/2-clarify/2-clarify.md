---
step: clarify
subagent: false
---

## Inputs

- `artefacts/1.1-spec.md` — feature specification from specify step

## Guidance

Resolve specification ambiguities through structured, sequential questioning. This step is **conditional** — skip if the specification has no critical ambiguities.

### 1. Load and Scan Specification

Load the spec and perform a structured ambiguity & coverage scan across these categories:

| Category | Check for |
|----------|-----------|
| Functional Scope | Core user goals, out-of-scope declarations, user roles |
| Domain & Data Model | Entities, attributes, relationships, lifecycle states |
| Interaction & UX | Critical user journeys, error/empty/loading states |
| Non-Functional | Performance, scalability, reliability, security, compliance |
| Integration | External services, data formats, protocol assumptions |
| Edge Cases | Negative scenarios, rate limiting, conflict resolution |
| Constraints | Technical constraints, explicit tradeoffs |
| Terminology | Canonical glossary terms, avoided synonyms |

For each category, mark status: **Clear** / **Partial** / **Missing**.

If no meaningful ambiguities found: report "No critical ambiguities detected" and recommend proceeding to plan.

### 2. Generate Clarification Questions

Generate a prioritized queue of **maximum 5** questions. Each question must:
- Be answerable with a short multiple-choice selection (2-5 options) or a short phrase (<=5 words)
- Materially impact architecture, data modeling, task decomposition, test design, or compliance
- Not duplicate information already in the spec

Present your **recommended option** prominently with reasoning, then all options in a table.

### 3. Sequential Questioning

Present **one question at a time**. After each answer:
1. Record the answer
2. Immediately update the spec:
   - Add to `## Clarifications > ### Session {date}` section: `- Q: {question} → A: {answer}`
   - Update the relevant spec section (functional requirements, data model, NFRs, etc.)
   - Remove any `[NEEDS CLARIFICATION]` marker that the answer resolves
3. Save the spec after each integration
4. Move to next question

Stop when: all critical ambiguities resolved, user signals "done", or 5 questions reached.

### 4. Write Updated Spec

Write the updated specification back to `initiatives/{INITIATIVE_NAME}/artefacts/1.1-spec.md`.

## Outputs

- `artefacts/1.1-spec.md` — updated specification with clarifications integrated

## Gate

STOP. Present via `primitives/human-gate.md`. Report:
- Questions asked and answered
- Sections updated
- Coverage summary (Resolved / Deferred / Clear / Outstanding per category)
