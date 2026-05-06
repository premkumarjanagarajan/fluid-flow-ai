---
phase: artefact-selection
steps: 8
---

# Phase 2: Artefact Selection

> Phase 2 exists to decide the right level of structure — not to default into documentation.

Goal: determine the correct artefact type based on problem clarity, solution certainty, and delivery complexity.

Load `knowledge/Layer 1 – Global Company Knowledge (Shared)/global-principles-guardrails/product-governance/operational-hierarchy.md` at the start of this phase.

## Step Chain

1. Load `1-new-vs-existing/1-new-vs-existing.md` — determine if this is new work or extends existing context
2. Load `2-existing-routing/2-existing-routing.md` — route existing work to the correct path (conditional: only if Step 2.1 = Existing)
3. Load `3-discovery-necessity/3-discovery-necessity.md` — the most important gate: is discovery still needed?
4. Load `4-feature-definition/4-feature-definition.md` — is the problem clear enough for a Feature Brief?
5. Load `5-delivery-size/5-delivery-size.md` — Epic(s) or User Story?
6. Load `6-phasing/6-phasing.md` — staged or single delivery?
7. Load `7-load-template/7-load-template.md` — load the canonical template for the confirmed artefact type
8. Load `8-depth-guidance/8-depth-guidance.md` — prevent over- or under-splitting

## Phase Gate

ALL must be met before advancing to Phase 3 (Define):

- [ ] Correct artefact type selected and confirmed by the user
- [ ] Existing context reused where possible (Step 1.5 results applied)
- [ ] No unnecessary artefacts created
- [ ] Depth of breakdown justified
- [ ] Traceability intact — artefact links back to its parent
- [ ] No forced Feature Briefs — artefact type matches actual level of understanding

**Re-entry rule:** When JPD discovery is completed and a Solution is approved, re-enter at Phase 2 (Artefact Selection). Never jump directly from JPD to Feature Brief without re-evaluating.

Present:
- **A**: Approve and proceed to Define
- **B**: Request changes
