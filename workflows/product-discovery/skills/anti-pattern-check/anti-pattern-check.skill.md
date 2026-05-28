---
name: anti-pattern-check
description: Validates a proposed scope or approach against known product and delivery anti-patterns before a Feature Brief is written or approved. Includes a CW capability check when campaigns are in scope.
execution: inline
scope: workflow-local
version: 1.1
last-updated: 2026-05-22
---

# Anti-Pattern Check

Scans a proposed scope, solution direction, or Feature Brief against a catalogue of known product, delivery, and campaign anti-patterns. Surfaces any matches before work enters Define phase, preventing rework and governance failures downstream.

---

## When to Run

- End of Discover phase (before advancing to Artefact Selection)
- Start of Define phase (before building the Feature Brief)
- When `review-document` skill flags an anti-pattern during peer review
- When the user asks "is this a good idea?" or "have we done this wrong before?"

---

## Prerequisites

- A clear scope direction or problem statement from the discovery conversation
- Access to the Knowledge Base anti-patterns content via `kb-retrieval`

---

## Execution

### Step 1: Load Anti-Pattern Sources

Delegate a lookup to a **subagent** running `skills/kb-retrieval/kb-retrieval.skill.md`.

Query: anti-patterns relevant to the current topic, scope, and domain. Pass the feature topic and any campaign/tool context (e.g. CW vs CT, regulated markets) as part of the query.

Also check internally against the built-in catalogue below (Step 2) — these do not require a KB lookup.

---

### Step 1b: CW Capability Check (conditional — runs when campaigns are in scope)

**Trigger**: Run this check whenever the scope involves campaigns, bonuses, offers, prize draws, tournaments, or gamification mechanics.

Ask the user:

> *"Before I run the anti-pattern check — can you briefly describe what the campaign needs to do? I'll check whether Campaign Wizard can support it natively before we go further."*

Then delegate a KB lookup via `skills/kb-retrieval/kb-retrieval.skill.md` with query: "Campaign Wizard offer types, task types, reward types, and known limitations."

Evaluate the requirement against what CW supports:

| CW Can Do | CW Cannot Do (or has limitations) |
|-----------|-----------------------------------|
| Task-based offers (deposit, wager, login) | Real-time eligibility checks mid-session |
| Multi-step campaign flows | Complex cross-product wagering rules in a single campaign |
| Scheduled and triggered campaigns | Fully custom fulfillment logic outside CW reward types |
| Segmentation by player attributes | Market-specific legal text injection per player |
| Bonus Wheel, spin mechanics | — |

**Decision output:**

- If CW **can** support the requirement: record as confirmed — add to `ASSUMPTION_RISKS[]` as a Known fact
- If CW **cannot** support it: flag as anti-pattern C1 (CT Default) and ask the user to confirm CT is the correct fallback before proceeding
- If **unclear**: state this explicitly and recommend an engineering spike via `hypothesis-validation` (Technical Spike method)

---

### Step 2: Built-in Anti-Pattern Catalogue

Check the proposed scope against all items in this catalogue:

#### Discovery Anti-Patterns

| ID | Anti-Pattern | Signal | Risk |
|----|-------------|--------|------|
| D1 | **Solution before problem** | User describes a feature without naming a user problem | 🔴 Brief will have no valid problem statement |
| D2 | **Scope by committee** | Scope defined by collecting requests from multiple stakeholders with no prioritisation | 🔴 Conflicting success criteria; no clear owner |
| D3 | **Assumed user need** | "Users want X" stated with no research, data, or feedback reference | 🟡 Feature may solve the wrong problem |
| D4 | **Complexity disguised as simplicity** | Scope described as "just a small change" but touches regulated logic, wallets, or multi-brand behaviour | 🔴 Underestimated risk and delivery effort |
| D5 | **Skipped discovery** | Feature Brief started without a confirmed problem statement | 🔴 No validated rationale — governance gate fails |

#### Delivery Anti-Patterns

| ID | Anti-Pattern | Signal | Risk |
|----|-------------|--------|------|
| D6 | **Big Bang delivery** | Everything in scope delivered at once, no phased rollout planned | 🟡 High risk, no learning loop |
| D7 | **Missing rollback plan** | Feature affects live campaign logic with no defined rollback or kill switch | 🔴 Regulatory and financial exposure |
| D8 | **Undefined success metric** | Success criteria section is empty, vague ("improve UX"), or purely delivery-based ("ship by Q3") | 🟡 No basis for post-launch evaluation |
| D9 | **Out-of-scope creep** | "While we're there" additions mentioned in the brief that were not in the problem statement | 🟡 Scope drift; effort underestimated |

#### Campaign & Rewards Anti-Patterns

| ID | Anti-Pattern | Signal | Risk |
|----|-------------|--------|------|
| C1 | **Campaign Tool (CT) default** | CT proposed without confirming CW cannot support the requirement | 🟡 CT is deprecated — all new campaigns should use CW unless validated otherwise |
| C2 | **Regulated market assumption** | Brazil, Italy, or Spain in scope but no compliance check mentioned | 🔴 Market-specific rules may block launch |
| C3 | **Bonus logic in the wrong layer** | Wagering, eligibility, or wallet logic described as frontend work | 🔴 Incorrect ownership; builds technical debt |
| C4 | **Missing RG consideration** | Feature affects bonuses, deposits, or engagement mechanics with no Responsible Gaming review flagged | 🔴 Regulatory and ethical risk |
| C5 | **Duplicating existing CW capability** | Proposed feature replicates something already possible in Campaign Wizard | 🟡 Wasted effort; inconsistent tooling |
| C6 | **CW capability unverified** | Campaign requirement stated but CW capability not checked — assuming it works without confirming | 🟡 Risk of designing for a tool constraint that doesn't exist, or missing one that does |

---

### Step 3: Evaluate the Scope

Cross-reference the current feature topic, problem statement, and any scope signals from the discovery conversation against:
- Every item in the built-in catalogue (Step 2)
- Any KB-returned anti-patterns from the subagent lookup (Step 1)

For each match found, note:
- The anti-pattern ID and name
- The specific signal that triggered the match (quote the user's words if possible)
- The risk level
- A recommended action

---

### Step 4: Present the Findings

If matches are found, output a structured report:

```markdown
## Anti-Pattern Check — [Feature/Topic Name]

### ⚠️ Matches Found

| ID | Anti-Pattern | Triggered By | Risk | Recommended Action |
|----|-------------|--------------|------|-------------------|
| D1 | Solution before problem | "We want to add a bonus wheel to the homepage" — no user problem stated | 🔴 Critical | Return to Discover — define the user problem before continuing |
| C1 | CT default | "We'll use Campaign Tool for this" | 🟡 Significant | Confirm CW cannot meet this requirement before proceeding with CT |

### ✅ No Issues Found
[List categories checked with no matches, e.g. "Regulated market checks: no Brazil/Italy/Spain scope detected"]
```

If no matches are found:

```markdown
## Anti-Pattern Check — [Feature/Topic Name]

### ✅ No Anti-Patterns Detected

All checks passed. No known anti-patterns match the current scope and approach.

Checked:
- Discovery anti-patterns (D1–D5)
- Delivery anti-patterns (D6–D9)
- Campaign & Rewards anti-patterns (C1–C5)
- KB anti-pattern sources: [source paths if found]
```

---

### Step 5: Gate Decision

After presenting findings:

- If any 🔴 Critical match is found: **block progression**. Do not advance to Define or Artefact Selection until the anti-pattern is addressed. State clearly: *"This is a hard stop. [Anti-pattern] must be resolved before we continue."*
- If only 🟡 Significant matches: present and ask the user to acknowledge each one explicitly before proceeding
- If only 🟢 Low or no matches: proceed, noting any low-risk items in the session log

---

## Outputs

| Output | Format | Description |
|--------|--------|-------------|
| Anti-pattern report | Inline response | Matches with risk ratings and recommended actions |
| Gate decision | Hard stop / proceed / proceed with acknowledgement | — |

---

## Rules

- Never skip this check when the scope involves campaigns, bonuses, regulated markets, or wallet logic
- Always run Step 1b (CW capability check) when campaign mechanics are mentioned — before checking anti-patterns
- Do not soft-pass a 🔴 match — always hard-block
- If the KB lookup returns no anti-pattern content, fall back to the built-in catalogue and note the limitation
- Always check C1 (CT default) whenever Campaign Tool is mentioned by the user
- Always check C6 (CW capability unverified) whenever a campaign requirement is described without a CW capability confirmation
- If CW capability is unclear, recommend a technical spike via `skills/hypothesis-validation/hypothesis-validation.skill.md` (Technical Spike method)
