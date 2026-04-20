---
name: review-document
description: Section-by-section artefact review against canonical templates and anti-patterns.
execution: inline
scope: workflow-local
version: 1.0
last-updated: 2026-04-20
---

# Review Document

Reviews a product artefact against Betsson product governance standards, canonical templates, and known anti-patterns. Produces a structured, actionable review report.

---

## When to Run

- A document is provided for quality review before a gate or merge
- A Feature Brief, Epic, User Story, Need & Opportunity, or Solution needs peer review support
- User asks to validate an artefact against governance standards

---

## Prerequisites

- The document to review (pasted inline or referenced by path)
- Access to the canonical templates at `knowledge/Layer 1 – Global Company Knowledge (Shared)/canonical-templates/`

---

## Execution

### Step 1: Identify the Document Type

Determine which artefact type this is. Valid types:

- Feature Brief
- Need & Opportunity
- Solution
- Epic (Epic Brief or Jira Epic)
- User Story
- Big Bet
- Test Case
- Decision Log

If the type is unclear, ask the user to confirm before proceeding.

### Step 2: Load the Canonical Template

Load the corresponding canonical template from `knowledge/Layer 1 – Global Company Knowledge (Shared)/canonical-templates/`. This is the review standard — every section in the template must be assessed.

### Step 3: Section-by-Section Comparison

Compare each section of the provided document against the template. For each section, assess:

- **Present / Missing / Incomplete** — Is the section present? Is it fully completed?
- **Quality** — Does the content meet the purpose described in the template for that section?
- **Anti-patterns** — Does the section exhibit any known anti-patterns (see Step 4)?

### Step 4: Anti-Pattern Scan

Explicitly check for these anti-patterns across the whole document:

| Anti-Pattern | What it looks like |
|---|---|
| **Solution in Problem Statement** | "The problem is we don't have [feature X]" instead of a user problem |
| **Empty or Vague Out of Scope** | "N/A" or "Future enhancements" without naming specific exclusions |
| **No Supporting Evidence** | No research, analytics, customer insight, or data referenced |
| **Scope Creep** | Content that belongs in a different section or a different artefact |
| **Tech-Stack Detail** | Implementation or engineering-specific detail in a product document |
| **Missing Traceability** | No link to a parent artefact (N&O, Solution, Big Bet, or Feature Brief) |
| **Guessed Regulatory Requirements** | "I think Spain requires…" or "Probably compliant" without a cited source |

### Step 5: Produce a Structured Review

Present the review with three sections:

1. **What's good** — Sections and content that meet the standard. Be specific.
2. **What needs work** — Sections that are missing, incomplete, or contain anti-patterns. Name the anti-pattern explicitly.
3. **Recommendations** — Numbered, specific, actionable improvements for each issue. Reference the relevant template section or governance rule.

### Step 6: Label Output

Label the review output `[DRAFT]`. The review is an AI-assisted opinion — the human reviewer and named approver remain the decision-makers on what changes are made.

---

## Outputs

| Output | Format | Description |
|--------|--------|-------------|
| Review report `[DRAFT]` | Inline chat response | Section-by-section assessment with numbered recommendations |
