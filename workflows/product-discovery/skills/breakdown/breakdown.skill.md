---
name: breakdown
description: Breaks down an approved Feature Brief into a full Jira artefact chain — JPD item in PROX, Epic in BET or SWAT, and User Stories — maintaining full traceability back to the Feature Brief.
execution: inline
scope: workflow-local
version: 1.0
last-updated: 2026-05-22
---

# Breakdown

Converts an approved Feature Brief into a traceable Jira artefact chain ready for engineering inception. Produces: a JPD item in PROX (the C&R product discovery project), one or more Epics in the correct delivery project (BET or SWAT), and User Stories under each Epic.

---

## When to Run

- After the Feature Brief is approved and merged (Phase 3 gate passed)
- On demand when the user says "break this down", "create the Jira tickets", "breakdown [feature]"
- Before Handshake phase — the handshake pre-entry conditions require Epics and Stories to exist

---

## Prerequisites

- An approved Feature Brief (pasted inline, or path provided)
- Atlassian MCP available (`MCP_SERVERS_OK[]` includes `atlassian`)
- User must confirm BET vs SWAT before any Epic is created

---

## Execution

### Step 1: Read the Feature Brief

If a Feature Brief path or content is not already in context, ask:

> *"Which Feature Brief should I break down? You can paste it here or give me the file path."*

Extract:
- **Feature name** — used for Jira summary and naming
- **Problem statement** — drives the JPD item description
- **Scope** — in-scope items drive Epic and Story content
- **Success criteria** — drives acceptance criteria on Stories
- **Markets** — may require separate stories or Epic variants per market
- **Out of scope** — used to define story boundaries

---

### Step 2: Determine the JPD Item Type

Ask the user:

> *"What stage is this in Jira Product Discovery (PROX)?*
> *A) Idea — still early concept, hasn't been validated yet*
> *B) Need & Opportunity — problem is understood, no solution committed yet*
> *C) Solution — solution direction is confirmed, ready to plan delivery*
> *D) Phase — large solution being sliced into milestones*
> *Or: skip PROX — a JPD item already exists (provide the key)"*

| Choice | Action |
|--------|--------|
| A — Idea | Draft Idea content using `knowledge/shared/canonical-templates/` Idea template |
| B — N&O | Draft Need & Opportunity content |
| C — Solution | Draft Solution content (most common post-brief) |
| D — Phase | Draft Phase content; ask how many phases and what each one delivers |
| Skip | Ask for the existing PROX key and proceed to Epic creation |

**PROX area is always C&R** — do not ask; set this as a default.

---

### Step 3: Confirm BET vs SWAT

Always ask, every time — never assume:

> *"Should the Epic(s) go in BET or SWAT? If you're not sure, BET is the default for most product delivery work. SWAT is typically used for technical or platform-level work."*

Store as `EPIC_PROJECT`.

---

### Step 4: Determine Epic Count

Analyse the Feature Brief scope to determine how many Epics are appropriate:

| Signal | Guidance |
|--------|---------|
| Single user journey, single market | One Epic |
| Multiple distinct user outcomes | One Epic per outcome |
| Phased delivery (MVP → expansion) | One Epic per phase |
| Multiple markets with different rules | Consider market-specific Epics only if the acceptance criteria differ materially |

Present the proposed Epic structure to the user:

> *"Based on the scope, I'd suggest [N] Epics:*
> *— Epic 1: [name + one-line outcome]*
> *— Epic 2: [name + one-line outcome]*
> *Does this make sense, or would you like to adjust the split?"*

Wait for confirmation before proceeding.

---

### Step 5: Draft the JPD Item

Draft the JPD item content using the confirmed type and the Feature Brief as source:

```markdown
## [DRAFT] JPD — [Feature Name]

**Type:** [Idea / Need & Opportunity / Solution / Phase]
**Project:** PROX
**Area:** C&R
**Status:** Draft

### Summary
[One line: what is being solved or delivered]

### Description
[Problem statement from the Feature Brief — adapted for JPD format]

### Why This Matters
[Business rationale and user impact from the Feature Brief]

### Scope
[High-level scope — link to the approved Feature Brief for full detail]

### Success Criteria
[Top-level metrics from the product impact statement]

### Links
- Feature Brief: [path or Confluence link]
- Epics: [to be linked after creation]
```

---

### Step 6: Draft Each Epic

For each confirmed Epic, produce a draft using the `epic-template.md` from the KB:

```markdown
## [DRAFT] Epic — [Epic Name]

**Project:** [BET / SWAT]
**Area / Label:** C&R
**Linked Solution/Feature Brief:** [reference]

### Goal
[One sentence: what user outcome does this Epic deliver?]

### Scope
[What this Epic covers — drawn from the Feature Brief in-scope section]

### Out of Scope
[What is explicitly excluded]

### Acceptance Criteria
- [ ] [Criterion 1 — testable, outcome-based]
- [ ] [Criterion 2]
- [ ] [Criterion 3]

### Markets
[Which brands/markets this Epic covers]

### Dependencies
[Any technical, compliance, or team dependencies]

### Definition of Ready Checklist
- [ ] Linked to approved Feature Brief or Solution
- [ ] Acceptance criteria defined and agreed
- [ ] Dependencies identified
- [ ] Market scope confirmed
- [ ] Engineering has reviewed and accepted into sprint planning
```

---

### Step 7: Draft User Stories

For each Epic, break the scope into User Stories. Apply these rules:

- Each story must represent **one independent, testable unit of user value**
- Each story must have **acceptance criteria** that can be verified in isolation
- Stories must be small enough to be delivered in a single sprint
- Do not restate the problem in stories — stories describe behaviour, not justification
- Every story must have at least one acceptance criterion before it is sprint-ready

Story format:

```markdown
## [DRAFT] Story — [Short Title]

**Epic:** [Epic name / key]
**As a** [user type]
**I want to** [action]
**So that** [outcome / value]

### Acceptance Criteria
- [ ] Given [context], when [action], then [expected result]
- [ ] Given [context], when [action], then [expected result]

### Out of Scope for This Story
[Explicit boundary — what this story does NOT include]

### Notes
[Any technical notes, edge cases, or market-specific considerations]
```

After drafting stories, present the full set grouped by Epic and ask:

> *"Here are [N] stories across [M] Epics. Review and let me know if any need to be split further, merged, or reworded before we create them in Jira."*

---

### Step 8: Create in Jira (conditional — requires Atlassian MCP)

Only proceed with Jira creation after the user explicitly approves the drafted content.

Creation order:
1. Create the JPD item in PROX (mark as `[DRAFT]` removed once approved)
2. Create each Epic in `EPIC_PROJECT`, linked to the JPD item
3. Create each User Story under its parent Epic
4. Run `skills/jira-ff-assisted/jira-ff-assisted.md` on every created issue

If Atlassian MCP is unavailable:
- Output all content in the draft format above
- State: *"Atlassian MCP is not available. Here is the full content ready to paste into Jira manually."*

---

### Step 9: Traceability Check

After creation, confirm the chain is intact:

```
Feature Brief → JPD item (PROX) → Epic(s) (BET/SWAT) → User Stories
```

Present a traceability summary:

```markdown
## Traceability Summary

| Level | Artefact | Key / Path | Status |
|-------|----------|-----------|--------|
| Feature Brief | [name] | [path] | ✅ Approved |
| JPD | [summary] | PROX-XXX | ✅ Created |
| Epic 1 | [name] | BET-XXX / SWAT-XXX | ✅ Created |
| Stories (Epic 1) | [N stories] | BET-XXX to BET-XXX | ✅ Created |
```

---

## Outputs

| Output | Format | Description |
|--------|--------|-------------|
| JPD item draft | Inline `[DRAFT]` | PROX item ready for creation |
| Epic draft(s) | Inline `[DRAFT]` | One per confirmed Epic |
| User Story drafts | Inline `[DRAFT]` | Grouped by Epic |
| Traceability summary | Inline table | Full chain from Feature Brief to Stories |
| Jira issues | Created via MCP | Conditional on MCP availability and user approval |

---

## Rules

- Always ask BET vs SWAT — never assume
- PROX area is always C&R — never ask
- Never create Jira issues without explicit user approval of the drafted content
- Every Epic must link back to the JPD item and Feature Brief
- Every Story must belong to an Epic — no orphan stories
- Run `jira-ff-assisted` on every issue created
- Stories must be testable independently — if they can't, they must be split or refined before creation
