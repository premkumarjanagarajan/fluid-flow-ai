---
name: assumption-mapping
description: Separates known facts from beliefs and unknowns, then ranks assumptions by risk to surface what must be validated before committing to scope.
execution: inline
scope: workflow-local
version: 1.0
last-updated: 2026-05-22
---

# Assumption Mapping

Produces a structured assumption map that separates what is known, what is believed, and what is unknown — then ranks all assumptions by risk so the PO can decide what must be validated before a Feature Brief is written.

---

## When to Run

- After Step 1.2 (Challenge & Deepen) in the Discover phase, before KB Validation
- When the user's answers contain phrases like "I think", "probably", "we assume", "users want", "it should", or "the team said"
- When a solution is being proposed before the problem is fully validated

---

## Prerequisites

- Phase 1 Steps 1.1 and 1.2 must be complete (structured discovery and challenge conversation)
- Session context from the discovery conversation is available

---

## Execution

### Step 1: Extract All Claims

Review everything said in Steps 1.1 and 1.2. Extract every claim made about:
- The problem (who is affected, how severely, why it matters)
- The users (who they are, what they do, what they want)
- The solution (what it should do, how it should work)
- The market or context (which brands, which regions, what constraints)
- The business outcome (what success looks like, what will change)

Do not filter — capture all claims, even ones that seem obvious.

---

### Step 2: Classify Each Claim

Sort every claim into one of three columns:

| Column | Definition | Examples |
|--------|------------|---------|
| **Known** | Confirmed by data, research, analytics, existing KB documentation, or engineering fact | "Our drop-off is 42% at step 3 per Q1 analytics", "CW does not support multi-step wagering" |
| **Believed** | The team's working assumption — plausible but not confirmed by evidence | "Users abandon because the UX is confusing", "This will improve conversion" |
| **Unknown** | Gaps where we have no view at all — the answer is not known and not assumed | "How does this behave in regulated markets?", "What is the current system limit?" |

---

### Step 3: Rank Assumptions by Risk

For every item in the **Believed** and **Unknown** columns, assign a risk rating:

| Rating | Criteria |
|--------|---------|
| 🔴 Critical | If this assumption is wrong, the entire solution direction collapses or creates a compliance risk |
| 🟡 Significant | If wrong, it changes scope or delivery significantly, but the core direction holds |
| 🟢 Low | If wrong, it requires a minor adjustment but does not derail the work |

---

### Step 4: Present the Map

Output the assumption map as a structured table. Label it `[DRAFT]`:

```markdown
## [DRAFT] Assumption Map — [Feature/Topic Name]

### What We Know
| # | Claim | Source |
|---|-------|--------|
| K1 | [claim] | [KB ref / analytics / engineering confirmation] |

### What We Believe (Assumptions)
| # | Assumption | Risk | Why It Matters |
|---|-----------|------|----------------|
| A1 | [assumption] | 🔴 Critical | [consequence if wrong] |
| A2 | [assumption] | 🟡 Significant | [consequence if wrong] |
| A3 | [assumption] | 🟢 Low | [consequence if wrong] |

### What We Don't Know
| # | Unknown | Risk | Recommended Action |
|---|---------|------|--------------------|
| U1 | [unknown] | 🔴 Critical | [who to ask / how to validate] |
| U2 | [unknown] | 🟡 Significant | [who to ask / how to validate] |
```

---

### Step 5: Prompt a Validation Decision

After presenting the map, ask:

> *"Before we move to KB validation — are there any 🔴 Critical assumptions or unknowns here that should be resolved before we go further? If so, I'd recommend pausing discovery until those are validated. If you're comfortable accepting them as risks, we can proceed and flag them in the problem statement."*

Give the user two explicit options:
- **A** — Pause and validate one or more 🔴 items before continuing
- **B** — Accept as risk, flag in the problem statement, and proceed

Record the user's choice and carry all unresolved 🔴 items forward as flagged risks into Step 1.3 (KB Validation) and Step 1.4 (Problem Statement).

---

## Outputs

| Output | Format | Description |
|--------|--------|-------------|
| Assumption map | Inline `[DRAFT]` table | Classified and ranked assumption map |
| Validation decision | Session variable `ASSUMPTION_RISKS[]` | List of 🔴 items with accepted/deferred status |

---

## Rules

- Never skip this step when Believed or Unknown claims were surfaced during the discovery conversation
- Do not validate the assumptions yourself — surface them for the human to decide
- Every 🔴 item that is accepted as a risk must appear as a flagged risk in the Problem Statement
- If all claims land in the Known column, state this explicitly: "Everything surfaced in discovery appears well-evidenced. I haven't identified critical assumptions."
