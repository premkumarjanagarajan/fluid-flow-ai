---
step: clarify
subagent: false
---

## Inputs

- Feature specification at `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/spec.md`
- User arguments (if any)

## Guidance

Goal: Detect and reduce ambiguity or missing decision points in the active feature specification and record the clarifications directly in the spec file.

This step always runs before the plan step. Even when no critical ambiguities are detected, generate a small set of targeted questions to surface hidden assumptions and sharpen the spec. If the user explicitly skips clarification mid-session (e.g., exploratory spike), warn that downstream rework risk increases and log the skip in the audit trail.

1. Resolve `SHELL_TYPE` from session variables. Run the appropriate script from workflow root:
   - **bash**: `../../scripts/bash/check-prerequisites.sh --json --paths-only`
   - **powershell**: `../../scripts/powershell/check-prerequisites.ps1 -Json -PathsOnly`

   Parse minimal JSON for FEATURE_DIR and FEATURE_SPEC.

2. Load the current spec file. Perform a structured ambiguity & coverage scan using this taxonomy. For each category, mark status: Clear / Partial / Missing.

   Taxonomy categories:
   - Functional Scope & Behavior (core user goals, out-of-scope declarations, user roles)
   - Domain & Data Model (entities, attributes, relationships, identity rules, state transitions, data volume)
   - Interaction & UX Flow (critical user journeys, error/empty/loading states, accessibility)
   - Non-Functional Quality Attributes (performance, scalability, reliability, observability, security, compliance)
   - Integration & External Dependencies (external services, data formats, protocol assumptions)
   - Edge Cases & Failure Handling (negative scenarios, rate limiting, conflict resolution)
   - Constraints & Tradeoffs (technical constraints, rejected alternatives)
   - Terminology & Consistency (canonical glossary, deprecated terms)
   - Completion Signals (acceptance criteria testability, Definition of Done indicators)
   - Misc / Placeholders (TODO markers, ambiguous adjectives lacking quantification)

3. Generate a prioritized queue of candidate clarification questions (maximum 5). Constraints:
   - Maximum 10 total questions across the whole session
   - Each question must be answerable with: a short multiple-choice selection (2-5 options), OR a short-phrase answer (<=5 words)
   - Only include questions whose answers materially impact architecture, data modeling, task decomposition, test design, UX, operations, or compliance
   - Ensure category coverage balance: highest impact unresolved categories first
   - Favor clarifications that reduce downstream rework risk

4. Sequential questioning loop (interactive):
   - Present EXACTLY ONE question at a time
   - For multiple-choice questions: provide `**Recommended:** Option [X] - <reasoning>`, then all options as a table
   - For short-answer questions: provide `**Suggested:** <proposed answer> - <brief reasoning>`
   - If user replies with "yes", "recommended", or "suggested", use the previously stated recommendation/suggestion
   - After user answers: validate the response, record in working memory, move to next question
   - Stop when: all critical ambiguities resolved, user signals completion, or 5 questions reached

5. Integration after EACH accepted answer:
   - Ensure a `## Clarifications` section exists in the spec (create if missing)
   - Under it, create/use a `### Session YYYY-MM-DD` subheading
   - Append: `- Q: <question> → A: <final answer>`
   - Apply the clarification to the appropriate spec section using this mapping:

     | Clarification Type | Target Spec Section |
     |--------------------|---------------------|
     | Functional behavior | Functional Requirements |
     | Data shape / entities | Data Model / Key Entities |
     | Non-functional attribute | Quality Attributes / Non-Functional Requirements |
     | Edge case / failure | Edge Cases & Error Handling |
     | Terminology | Normalize term across all sections |

   - Keep each inserted clarification minimal and testable (avoid narrative drift)
   - Preserve heading hierarchy; do not reorder unrelated sections
   - If clarification invalidates an earlier statement, replace it (no obsolete contradictory text)
   - Save the spec file AFTER each integration

6. Validation (after each write plus final pass):
   - Clarifications section contains exactly one bullet per accepted answer
   - Total asked questions <= 5
   - Updated sections contain no lingering vague placeholders
   - Markdown structure valid
   - Terminology consistency across updated sections

7. Write the updated spec back to `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/spec.md`.

8. Report completion: number of questions asked, path to updated spec, sections touched, coverage summary table with statuses:

   | Category | Status |
   |----------|--------|
   | Functional Scope & Behavior | Resolved / Deferred / Clear / Outstanding |
   | ... | ... |

   **Status definitions**:
   - **Resolved**: Ambiguity addressed by a clarification answer in this session
   - **Clear**: No ambiguity detected; spec is sufficient
   - **Deferred**: Item exceeds question quota or is better suited for the planning step; logged with rationale
   - **Outstanding**: Ambiguity detected but not addressed (question quota exhausted)

Behavior rules:
- If no critical ambiguities are found, still generate up to 3 questions targeting the highest-impact assumption gaps (scope boundaries, edge cases, or data constraints) to improve spec quality before planning.
- If spec file missing, instruct user to run the specify step first.
- Never exceed 5 total asked questions.
- Respect user early termination signals ("stop", "done", "proceed").

## Outputs

- Updated `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/spec.md` with clarifications integrated

## Gate

STOP after the questioning loop ends. Present coverage summary and wait for user acknowledgement.
