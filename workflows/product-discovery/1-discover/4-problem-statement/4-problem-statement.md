---
step: problem-statement
subagent: false
---

## Inputs

- All Phase 1 context (Steps 1.1, 1.2, 1.3)

## Execution

Draft a clear problem statement from the evidence. Store in `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/problem-statement.md`. Label it `[DRAFT]`.

The problem statement should:
- Describe the user problem (not a solution)
- Identify affected user groups
- Reference supporting evidence
- Note markets and platforms in scope
- Acknowledge constraints and knowledge gaps resolved

Present the drafted problem statement to the user and wait for explicit confirmation that it is accurate and complete.

## Outputs

- `problem-statement.md` `[DRAFT]`

## Gate

User confirms the problem statement is accurate and complete.
