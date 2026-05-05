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

## Outputs

- `problem-statement.md` `[DRAFT]`

## Gate

User confirms the problem statement is accurate and complete. All six fields are either populated or explicitly acknowledged.
