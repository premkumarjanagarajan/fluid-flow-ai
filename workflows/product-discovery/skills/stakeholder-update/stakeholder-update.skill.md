---
name: stakeholder-update
description: Generates a concise stakeholder update from the current discovery session state — covering what's been decided, what's in progress, and what comes next.
execution: inline
scope: workflow-local
version: 1.0
last-updated: 2026-05-22
---

# Stakeholder Update

Produces a concise, audience-appropriate update from the current state of a discovery session or Feature Brief. Can be invoked at any phase to generate a one-pager for leadership, cross-team alignment, or area reviews.

---

## When to Run

- At any phase, on demand
- When the user says "I need to update my stakeholders", "can you write a summary", or "I need to share where we are"
- After a key gate is passed (problem statement confirmed, Feature Brief approved, decision logged)
- Before a review meeting or Area Director sync

---

## Prerequisites

- At least Phase 1 Step 1.4 (problem statement) must be complete, or the user must provide context manually
- The audience for the update must be specified (or asked)

---

## Execution

### Step 1: Confirm Audience and Scope

Ask two questions before generating anything:

1. *"Who is this update for? Options: (A) Leadership / Area Director (high-level, strategic), (B) Cross-team (technical peers, adjacent PMs/POs), or (C) Your own area team (operational detail)."*

2. *"Is there anything specific to highlight or avoid in this update?"*

Store answers as `UPDATE_AUDIENCE` and `UPDATE_CONSTRAINTS`.

---

### Step 2: Gather Session State

Pull the relevant context from the current session:

- Feature/initiative name and one-line description
- Current phase and step
- Problem statement (if confirmed)
- Key decisions made (from `DECISION_LOG[]` if populated)
- Assumptions carrying risk (from `ASSUMPTION_RISKS[]` if populated)
- Open questions or blockers
- Next step or next gate

If session context is incomplete, ask the user to fill the gaps before generating.

---

### Step 3: Generate the Update

Produce the update in the format appropriate for the confirmed audience. Label it `[DRAFT]`.

---

#### Format A — Leadership / Area Director

Short, outcome-focused. No implementation detail. Maximum one page.

```markdown
## [DRAFT] Product Update — [Initiative Name]
**Date:** [YYYY-MM-DD]
**Phase:** [Current phase name]
**Prepared by:** [PO name if known, or leave blank]

### In One Line
[Single sentence describing what is being solved and for whom]

### Where We Are
[2–3 sentences: what has been done, what was decided, what was confirmed]

### Key Decision Made
[Most significant decision from this session — option chosen and one-line rationale]

### Open Items
- [Item 1 — what is unresolved and who needs to act]
- [Item 2]

### Next Step
[Single next action — what happens next and who owns it]
```

---

#### Format B — Cross-team / Adjacent PMs and POs

More detail on scope, decisions, and cross-team dependencies.

```markdown
## [DRAFT] Discovery Update — [Initiative Name]
**Date:** [YYYY-MM-DD]
**Status:** [Phase and step — e.g. Phase 3: Define, in progress]

### Problem Statement
[Confirmed problem statement, or "Not yet confirmed — in progress"]

### Scope Summary
- **In scope:** [brief list]
- **Out of scope:** [brief list or "TBD"]
- **Markets:** [list]

### Decisions Made
| Decision | Option Chosen | Rationale |
|----------|--------------|-----------|
| [decision] | [choice] | [why] |

### Assumptions Flagged
| Assumption | Risk | Status |
|-----------|------|--------|
| [assumption] | 🔴/🟡 | Accepted risk / Being validated |

### Dependencies / Cross-team Asks
- [Team / person — what is needed and by when]

### Next Steps
1. [Action — owner]
2. [Action — owner]
```

---

#### Format C — Area Team (Operational)

Full session context. Suitable for standup, team sync, or sprint planning input.

```markdown
## [DRAFT] Team Update — [Initiative Name]
**Date:** [YYYY-MM-DD]
**Session phase:** [Phase and step]

### What We've Done
- [Activity 1]
- [Activity 2]

### What We've Decided
- [Decision 1 — brief rationale]
- [Decision 2 — brief rationale]

### Open Questions
| Question | Owner | Due |
|---------|-------|-----|
| [question] | [name or team] | [date or "TBC"] |

### Risks & Assumptions Carrying Forward
| Item | Risk | Action |
|------|------|--------|
| [item] | 🔴/🟡 | [what we're doing about it] |

### Next Steps
1. [Action — owner]
2. [Action — owner]
3. [Action — owner]
```

---

### Step 4: Iterate

After presenting the draft, ask:

> *"Anything to add, remove, or reframe before you share this?"*

Apply changes and re-present. Do not finalise until the user explicitly approves.

---

## Outputs

| Output | Format | Description |
|--------|--------|-------------|
| Stakeholder update | Inline `[DRAFT]` | Audience-appropriate one-pager |

---

## Rules

- Always ask for the audience before generating — never assume
- Always label `[DRAFT]` until the user explicitly approves
- Do not include confidential metrics unless the user explicitly provides them
- Do not invent progress, decisions, or status — only report what is confirmed in the session
- Format A must fit on one page — cut ruthlessly
- Format B and C may include more detail but must still close with clear next steps and owners
