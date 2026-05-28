---
step: build-artefact
subagent: false
---

## Inputs

- Confirmed artefact type + loaded template from Phase 2
- All Phase 1 discovery context

## AI Role

- Build the Feature Brief **collaboratively with the human**, working through each section one at a time using the loaded template as the mandatory structure.
- Cross-reference available market and jurisdiction documentation for market applicability and scope boundaries.
- Check available compliance and accessibility sources for governance implications.
- Flag any scope gaps — dependencies, constraints, or open questions not yet resolved.
- Always write in **British English** with a **proactive tone of voice**.

## Section-by-Section Walkthrough

At the start of Define, load the template and begin at the Header. Walk through every section sequentially (Header, then Sections 1–16). For each section:

1. **Present the section** — Display the heading and briefly explain what it covers and why it matters.
2. **Ask guiding questions** — Pose focused questions to help the human articulate the content for this section. Do not rush — give the human space to think.
3. **Handle the human's response:**
   - **Human provides content** → Accept as written. Ask only: *"Would you like to refine the wording, or shall we continue?"* Do not rewrite unless explicitly asked.
   - **Human asks Product Buddy to draft** → Draft based on available context. Present and ask the human to confirm, amend, or refine.
   - **Human skips** → Mark as `N/A — [reason provided by the human]`. If no reason is given, ask for one.
4. **Log the continuation** — When the human says "continue", record that the section was reviewed. Maintain a running **Section Progress Log**:
   ```
   ### Section Progress Log
   | Section | Status | Confirmed |
   |---------|--------|-----------|
   | Header  | Completed | ✅ |
   | S1      | Completed | ✅ |
   | S2      | Skipped — [reason] | ✅ |
   | ...     | ...    | ... |
   ```
5. **Move to the next section** — Only advance when the human explicitly confirms (e.g. "continue", "next", "move on").

### Success Criteria Section — Product Impact Required

When the walkthrough reaches the **Success Criteria** section:

Run `skills/product-impact/product-impact.skill.md` before drafting this section.

Do not accept qualitative goals ("improve UX", "increase engagement") as success criteria. The product-impact skill converts the user's intent into a measurable impact statement that forms the content of this section. Carry the confirmed output directly into the Feature Brief.

If the user tries to skip or defer this section, state: *"Success criteria are a gate requirement — this section cannot be marked N/A. Let me guide you through it quickly."*

## After All Sections

1. Present the **full artefact** from the top — all sections assembled.
2. Ask the human to **review the entire document** from start to finish.
3. Wait for confirmation before proceeding to the checkpoint.
4. If changes are requested, revisit the specific sections, apply changes, and present the updated brief again.

## Review Checkpoints

Before submitting for peer review, prompt the user to confirm each dimension:

| Review Dimension | Prompt | Owner |
|-----------------|--------|-------|
| **Tech Review** | Has Engineering reviewed the feasibility and technical constraints? Are there architectural dependencies or risks? | Engineering Lead |
| **RG Review** | Does this feature have Responsible Gaming implications? Has the RG team been consulted? | RG Team |
| **Experience Fit** | Does this fit the intended user experience? Has UX/Design reviewed the proposed behaviour? | UX/Design |
| **Research & Data Feed** | Is there research, analytics, or customer insight supporting this direction? If not, is that an accepted risk? | Product / Data |
| **MVP & Future Iteration** | Is this scoped as an MVP? What is explicitly deferred to future iterations? Is the iteration path clear? | Product |
| **Brand Rollout Plan** | Which brands and markets will this roll out to first? Is a phased rollout needed? Are there brand-specific constraints? | Product / Commercial |

For each: *"Have you thought about [dimension]? Who owns this review, and has it happened?"*

If the user confirms a dimension is not applicable, record it as `N/A — [reason]`. If a review is pending, flag it as an open item that must be resolved before the Feature Brief can be approved.

## AI Review

Before submitting for peer review, run `skills/review-document/review-document.skill.md` against the completed artefact. Present the review report to the user and resolve any flagged issues before creating the PR.

## Checkpoint

Create Pull Request and wait for peer review, Area Director or Head of Area approval, and decision log entry before advancing. Ask the user to confirm these conditions explicitly.

## Outputs

- Completed artefact (Feature Brief or selected type)
- Section Progress Log
- Review dimension confirmations
- PR created for peer review

## Gate

- [ ] Artefact complete and conforms to the template
- [ ] Peer review completed
- [ ] Artefact merged to the repository
- [ ] Area Director or Head of Area approved via PR review
