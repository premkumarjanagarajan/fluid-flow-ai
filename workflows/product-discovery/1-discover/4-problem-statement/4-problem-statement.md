---
step: problem-statement
subagent: false
---

## Inputs

- All Phase 1 context (Steps 1.1, 1.2, 1.3)
- `ANALYTICS_EVIDENCE` session variable
- `CODEBASE_FINDINGS` session variable

## Execution

Draft a clear problem statement from the evidence. Store in `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/problem-statement.md`. Label it `[DRAFT]`.

Structure the problem statement using these six fields — every field must be populated or explicitly marked `UNVALIDATED / SKIPPED — [reason]`:

**1. User Problem**
Describe the problem in user terms (not a solution). Who is struggling? What is the struggle? What happens today without this?

**2. Affected Users**
Which user groups are impacted and how severely? (e.g. casual players in Nordic markets on mobile, high-value players across all platforms)

**3. Analytics Evidence**
From `ANALYTICS_EVIDENCE`: quantified user pain, funnel drop-off, metric trends, error rates, NPS signals, support ticket volume. Include source and date range.
If `ANALYTICS_EVIDENCE = UNVALIDATED`, state: *"No analytics data provided. This is an accepted risk — evidence gap flagged."*

**4. Codebase Context**
From `CODEBASE_FINDINGS`: what capability exists today, what is in-flight, and what integration complexity is implied.
If `CODEBASE_FINDINGS = SKIPPED`, state: *"No codebase check performed — user opted out."*
If `EXISTS_FULLY` or `IN_PROGRESS`, this field becomes a **blocker note** requiring user resolution before the gate passes.

**5. Markets & Platforms**
Which markets and platforms are in scope. Regulatory jurisdictions to note.

**6. Constraints & Gaps**
Regulatory requirements, technical dependencies, team capacity, deadlines, and any knowledge gaps deferred with named owner.

Present the drafted problem statement to the user and wait for explicit confirmation that it is accurate and complete.

### Adjacent Opportunities (runs once, after problem statement is confirmed)

After confirmation, surface 2 adjacent opportunities that the confirmed problem statement opens up but that are outside the current scope.

Phrase as:
"One last thing before we move forward. The problem we've confirmed opens up two adjacent questions worth being aware of — not for now, but so they don't get lost:
- [Adjacent opportunity 1]
- [Adjacent opportunity 2]

These aren't in scope today. Do you want to note them anywhere, or shall we move forward?"

Rules:
- These must be genuine strategic adjacencies — not scope creep disguised as insight
- They must follow directly from the confirmed problem statement — not be generic observations
- The user can dismiss them in one word — do not push. Log them if asked.
- This is the aperture-expanding moment. It signals that Product Buddy thinks beyond the ticket.

## Outputs

- `problem-statement.md` `[DRAFT]`

## Gate

User confirms the problem statement is accurate and complete. All six fields are either populated or explicitly acknowledged.
