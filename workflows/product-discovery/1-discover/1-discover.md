---
phase: discover
steps: 5
---

# Phase 1: Discover

> **Scanning rule — two tiers, different timing:**
>
> **Tier 1 — Context & Existing Work:** Scan *immediately* when the PO states their idea. Check what's already known: existing KB coverage, past initiatives the PO or team has worked on, codebase capability, and any prior artefacts in Jira. Surface findings before asking question 2. This makes every subsequent question smarter.
>
> **Tier 2 — Compliance, Market Rules, and Deep Validation:** Comes *after* the full discovery conversation (Step 1.3). Do NOT load compliance or market rule sources until the user's perspective is fully understood.

Goal: understand the problem through structured conversation, challenge assumptions, validate against KB, draft a confirmed problem statement, and detect existing context.

## Step 0 — Persona Detection (mandatory, runs before all steps)

Before any discovery activity begins, identify who you are talking to.

Ask once, naturally:
"Before we start — are you coming at this as a PM thinking about portfolio fit, or a PO ready to define and deliver?"

Load and apply behavioural rules from:
`{KB_PATH}/shared/personas.md`

Record persona as session variable: `USER_PERSONA` = PM | PO

Do not proceed to Step 1.1 until persona is confirmed.

## Step Chain

1. Load `1-structured-discovery/1-structured-discovery.md` — engage the user; run immediate context pre-scan after the idea is stated; ask discovery questions informed by findings
2. Load `2-challenge-deepen/2-challenge-deepen.md` — act as a critical friend, probe and sharpen the framing
3. Run `skills/assumption-mapping/assumption-mapping.skill.md` — classify known facts vs beliefs vs unknowns; rank critical assumptions; get user validation decision before proceeding
4. Load `3-kb-validation/3-kb-validation.md` — deep KB validation + codebase recon + resolve compliance/market gaps (carry unresolved 🔴 assumptions from Step 3 as flagged risks)
5. Load `4-problem-statement/4-problem-statement.md` — draft and confirm the problem statement (must include all unresolved 🔴 assumptions as flagged risks)
6. Run `skills/anti-pattern-check/anti-pattern-check.skill.md` — validate scope direction against known anti-patterns before advancing (hard-blocks on any 🔴 Critical match)
7. Load `5-existing-context/5-existing-context.md` — deep Jira/MCP artefact scan to confirm no duplicates before advancing (conditional)

## Phase Gate

ALL must be met before advancing to Phase 2 (Artefact Selection):

- [ ] Structured discovery questions answered by the user (Step 1.1 complete)
- [ ] Challenge and follow-up questions asked (Step 1.2 complete)
- [ ] Assumption map produced and user has made a validation decision on all 🔴 Critical items (Step 1.3 complete)
- [ ] Knowledge base validation completed and gaps addressed (Step 1.4 complete)
- [ ] A clear problem statement has been drafted and confirmed by the user — all unresolved 🔴 assumptions included as flagged risks (Step 1.5 complete)
- [ ] Anti-pattern check passed — no 🔴 Critical matches blocking progression (Step 1.6 complete)
- [ ] Gate outcome is recorded in the decision log

Present:
- **A**: Approve and proceed to Artefact Selection
- **B**: Request changes
