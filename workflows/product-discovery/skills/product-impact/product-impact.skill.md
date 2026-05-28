---
name: product-impact
description: Structures the quantitative and qualitative impact of a proposed solution across key business metrics before the success criteria section of a Feature Brief is written.
execution: inline
scope: workflow-local
version: 1.0
last-updated: 2026-05-22
---

# Product Impact

Guides the PO through defining measurable impact for a proposed solution. Produces a structured impact statement that covers business metrics, user outcomes, market scope, and segment effects — to be embedded in the success criteria section of the Feature Brief.

---

## When to Run

- During Phase 3 (Define), when reaching the success criteria section of the Feature Brief
- When the problem statement contains only qualitative goals ("improve UX", "increase engagement")
- When the user cannot articulate how success will be measured
- On demand when the user asks "what does success look like?" or "how do we measure this?"

---

## Prerequisites

- Phase 1 (Discover) complete — problem statement confirmed
- The artefact type and scope are known (from Phase 2)

---

## Execution

### Step 1: Ask for Existing Evidence

Before prompting for targets, check whether any data already exists:

> *"Do you have any current baseline data for this area? For example: conversion rates, engagement numbers, drop-off points, ARPU, or NGR figures? Even rough numbers help us set meaningful targets."*

If the user has data, capture it as baseline. If not, note: "No baseline available — targets will be directional."

---

### Step 2: Prompt for Impact Across Dimensions

Work through the following dimensions one at a time. For each, ask the guiding question, then capture the answer in the structured format below.

Do not ask all questions at once — go dimension by dimension. If a dimension is not applicable, mark it `N/A — [reason]`.

#### Business Metrics

| Dimension | Guiding Question |
|-----------|-----------------|
| **Active Days** | Will this feature affect how often or how regularly users engage? What change do we expect? |
| **ARPU** (Average Revenue Per User) | Do we expect revenue per user to increase, decrease, or stay flat? What drives that? |
| **NGR** (Net Gaming Revenue) | Is there a direct or indirect NGR impact? What is the expected direction and magnitude? |
| **Conversion / Funnel** | Does this feature change a conversion step? Where in the funnel, and what improvement do we expect? |
| **Retention** | Will this affect return visit rate or churn? How? |

#### User Outcomes

| Dimension | Guiding Question |
|-----------|-----------------|
| **User problem resolved** | How will we know the user problem is solved? What user behaviour will change? |
| **Experience quality** | Is there a UX quality signal (e.g. task completion rate, support ticket reduction, NPS) we can track? |

#### Scope & Segment

| Dimension | Guiding Question |
|-----------|-----------------|
| **Markets in scope** | Which markets or brands will this roll out to? Are any excluded or phased? |
| **User segments affected** | Which player segments does this target? (e.g. VIP, casual, new, dormant) |
| **Volume estimate** | How many users or sessions will this impact at launch? |

#### Risk & Guardrails

| Dimension | Guiding Question |
|-----------|-----------------|
| **Downside risk** | What is the worst-case outcome if this underperforms? What's our floor? |
| **Unintended consequences** | Could this negatively affect another metric or segment? What guardrails will we put in place? |
| **Rollback trigger** | What signal would cause us to roll back or pause this feature post-launch? |

---

### Step 3: Produce the Impact Statement

Assemble the answers into a structured `[DRAFT]` impact statement:

```markdown
## [DRAFT] Product Impact — [Feature Name]

### Baseline
[Baseline data provided / No baseline available — targets are directional]

### Business Metrics
| Metric | Current Baseline | Target / Expected Direction | Confidence | Notes |
|--------|-----------------|----------------------------|------------|-------|
| Active Days | [baseline] | [target / ↑↓→] | High / Medium / Low | [notes] |
| ARPU | [baseline] | [target / ↑↓→] | High / Medium / Low | [notes] |
| NGR | [baseline] | [target / ↑↓→] | High / Medium / Low | [notes] |
| Conversion | [baseline] | [target / ↑↓→] | High / Medium / Low | [notes] |
| Retention | [baseline] | [target / ↑↓→] | High / Medium / Low | [notes] |

### User Outcomes
- **Problem resolved indicator**: [how we'll know]
- **Experience quality signal**: [metric or proxy, or N/A]

### Scope & Segments
- **Markets**: [list]
- **User segments**: [list]
- **Estimated volume at launch**: [number or range]

### Risk & Guardrails
- **Downside risk**: [description]
- **Unintended consequences**: [description, or "None identified"]
- **Rollback trigger**: [signal or threshold]
```

---

### Step 4: Confirm and Carry Forward

Present the impact statement and ask:

> *"Does this accurately reflect the expected impact? Once confirmed, this will form the success criteria section of the Feature Brief."*

Carry the confirmed impact statement into the success criteria section of the artefact being built in Phase 3.

---

## Outputs

| Output | Format | Description |
|--------|--------|-------------|
| Product impact statement | Inline `[DRAFT]` | Structured metrics, user outcomes, scope, and guardrails |
| Session variable `PRODUCT_IMPACT` | Stored context | Carried into Define phase success criteria section |

---

## Rules

- Never accept "improve UX" or "increase engagement" as success criteria without converting them into a measurable signal
- If no baseline data is available, note this explicitly — do not invent numbers
- Every 🔴 assumption from the assumption map that is metric-dependent must appear in the Confidence column
- Markets listed here must match the market scope in the Feature Brief exactly
- The rollback trigger is mandatory — do not allow it to be skipped
