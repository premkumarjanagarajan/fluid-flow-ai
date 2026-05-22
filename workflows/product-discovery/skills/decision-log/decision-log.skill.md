---
name: decision-log
description: Drafts a structured decision log entry capturing options considered, rationale, consequences, and conflicts — required before closing the Decide phase.
execution: inline
scope: workflow-local
version: 1.0
last-updated: 2026-05-22
---

# Decision Log

Drafts a structured decision log entry that records the decision made, the options that were considered, the rationale, and any conflicts or trade-offs. Required as a gate condition for Phase 4 (Decide).

> **Note:** The Phase 4 step `1-decision-log/1-decision-log.md` already defines the decision log format used at the end of the workflow. This skill extends that with an interactive drafting flow and can also be invoked earlier — during discovery — to capture key decisions as they are made, not just at the end.

---

## When to Run

- Phase 4 (Decide) — mandatory before the phase gate is satisfied
- During Phase 1 or Phase 3 — when a significant scoping, tool, or design decision is made mid-session
- On demand: user says "log this decision", "let's record this", or "we decided to…"

---

## Prerequisites

- A decision has been made or is being made in the current session
- The decision relates to a product artefact, scope direction, tool selection, market inclusion, or delivery approach

---

## Execution

### Step 1: Identify the Decision Type

Determine which category this decision falls into:

| Type | Examples |
|------|---------|
| **Scope** | What is in / out of scope; which markets are included |
| **Tool** | CW vs CT; which system owns the logic |
| **Architecture** | Where logic lives; which service is responsible |
| **Delivery** | Phased vs big bang; MVP definition |
| **Prioritisation** | Why this now; what was deprioritised |
| **Compliance** | How a regulatory constraint was resolved |
| **Design** | UX/behaviour choice made over an alternative |

If the type is unclear, ask: *"What type of decision is this — scope, tool, delivery, or something else?"*

---

### Step 2: Gather the Decision Details

Ask the following questions. Work through them conversationally — not as a form:

1. **What was decided?** — State the decision in one sentence.
2. **What were the alternatives?** — What other options were considered before this one was chosen? (Minimum 2 options required; if only one option was considered, flag this as a risk.)
3. **Why this option?** — What drove the choice? Reference data, constraints, compliance requirements, or strategic direction.
4. **What does this enable?** — What becomes possible because of this decision?
5. **What does this prevent or limit?** — What is no longer possible, or what has been explicitly deferred?
6. **What trade-offs are being accepted?** — What are we knowingly giving up?
7. **Who made this decision?** — Name and role. Must be Head of Area or above for Phase 4 gate.
8. **Are there conflicts?** — Does this contradict any existing rule, artefact, or active decision? If so, how is the conflict resolved?

---

### Step 3: Draft the Decision Log Entry

Produce a `[DRAFT]` decision log entry using this format:

```markdown
## [DRAFT] Decision — [Short Decision Name]

**Date:** [YYYY-MM-DD]
**Decision type:** [Scope / Tool / Architecture / Delivery / Prioritisation / Compliance / Design]
**Decision-maker:** [Name — Role]
**Status:** 🔄 Draft / ✅ Final / Deferred / Rejected

### Options Considered
| Option | Pros | Cons |
|--------|------|------|
| [Option A] | [benefits] | [drawbacks] |
| [Option B] | [benefits] | [drawbacks] |
| [Option C — selected] ✅ | [benefits] | [drawbacks] |

### Assessment
| Criterion | Rating | Notes |
|-----------|--------|-------|
| Strategic alignment | High / Medium / Low | [notes] |
| Impact | High / Medium / Low | [notes] |
| Effort | High / Medium / Low | [notes] |
| Urgency | High / Medium / Low | [notes] |
| Risk | High / Medium / Low | [notes] |

### Rationale
[Why this option was chosen — reference data, constraints, compliance, or strategic direction]

### Consequences
- **Enables:** [what this makes possible]
- **Prevents / limits:** [what this closes off or defers]
- **Trade-offs accepted:** [what we are knowingly giving up]

### Conflicts Flagged
- [Conflict description and resolution — or "None"]
```

---

### Step 4: Handle Single-Option Decisions

If only one option was considered (no alternatives):

Prompt the user: *"Only one option was considered here. That's a risk — not because the decision is wrong, but because it hasn't been stress-tested. Can you name at least one alternative that was ruled out, and briefly why? This protects the decision from challenge later."*

If the user cannot provide an alternative, record:
```
⚠️ Single-option decision — no alternatives were considered. This decision has not been stress-tested.
```

---

### Step 5: Confirm and Store

Present the draft entry and ask:

> *"Does this accurately capture the decision? Once confirmed, this will be logged as part of the artefact record."*

Store the confirmed entry as a session variable `DECISION_LOG[]` — appended (not replaced) each time the skill runs. Multiple decisions can be logged in a single session.

---

## Outputs

| Output | Format | Description |
|--------|--------|-------------|
| Decision log entry | Inline `[DRAFT]` | Structured entry with options, rationale, consequences, and conflicts |
| Session variable `DECISION_LOG[]` | Stored context | Accumulated decision entries for the session |

---

## Rules

- A minimum of 2 options must be considered for every decision — prompt if missing
- The decision-maker must be named — "the team" is not acceptable
- For Phase 4 gate: the decision-maker must be Head of Area or above
- Every conflict flagged during the session must appear in the log — none may be silently omitted
- Mid-session decisions (during Phase 1 or 3) use the same format but with status `🔄 Draft`
