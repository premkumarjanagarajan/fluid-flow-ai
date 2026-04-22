---
step: specify
subagent: false
---

## Inputs

- User's feature description (from the triggering message)
- Brownfield context from `{DEPT_FF_PATH}/initiatives/_project/reverse-engineering/` (if available)

## Guidance

The text the user typed is the feature description. Do not ask the user to repeat it unless they provided an empty command.

1. **Detect existing feature context**: Resolve `SHELL_TYPE` from session variables. Run the appropriate script from workflow root:
   - **bash**: `../../scripts/bash/check-prerequisites.sh --json --paths-only`
   - **powershell**: `../../scripts/powershell/check-prerequisites.ps1 -Json -PathsOnly`

   Parse the output to get FEATURE_DIR and BRANCH_NAME.

2. **Load brownfield context** (if available):
   - Check if `{DEPT_FF_PATH}/initiatives/_project/reverse-engineering/` exists
   - If found, load: `business-overview.md`, `architecture.md`, `code-structure.md`, `api-documentation.md`, `component-inventory.md`
   - Use this context to write more informed specifications

3. Load `../../templates/spec-template.md` to understand required sections.

4. Follow this execution flow:
   1. Parse user description from Input
      If empty: ERROR "No feature description provided"
   2. Extract key concepts from description
      Identify: actors, actions, data, constraints
   3. For unclear aspects:
      - Identify possible interpretations and propose clearly labeled options (include a recommended option only if you can justify it from provided context)
      - Do not silently guess or assume. If user input is needed, mark with `[NEEDS CLARIFICATION: specific question]`
      - Only mark with [NEEDS CLARIFICATION: specific question] if:
        - The choice significantly impacts feature scope or user experience
        - Multiple reasonable interpretations exist with different implications
        - No reasonable default exists
      - **LIMIT: Maximum 3 [NEEDS CLARIFICATION] markers total**
      - Prioritize clarifications by impact: scope > security/privacy > user experience > technical details
   4. Fill User Scenarios & Testing section
      If no clear user flow: ERROR "Cannot determine user scenarios"
   5. Generate Functional Requirements
      Each requirement must be testable
      If proposing defaults, record them as **provisional** in the Assumptions section and require explicit user approval before treating them as final
   6. Define Success Criteria
      Create measurable, technology-agnostic outcomes
      Include both quantitative metrics and qualitative measures
      Each criterion must be verifiable without implementation details
   7. Identify Key Entities (if data involved)
   8. Return: SUCCESS (spec ready for planning)

5. Write the specification to `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/spec.md` using the template structure.

6. **Specification Quality Validation**: After writing the initial spec, validate it against quality criteria:

   a. **Create Spec Quality Checklist**: Generate a checklist file at `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/checklists/requirements.md` with validation items covering:
      - Content Quality (no implementation details, focused on user value, written for non-technical stakeholders)
      - Requirement Completeness (testable, unambiguous, measurable success criteria)
      - Feature Readiness (clear acceptance criteria, user scenarios cover primary flows)

   b. **Run Validation Check**: Review the spec against each checklist item. Document specific issues found.

   c. **Handle Validation Results**:
      - **If all items pass**: Mark checklist complete and proceed
      - **If items fail (excluding [NEEDS CLARIFICATION])**: List failing items, update spec, re-run validation (max 3 iterations)
      - **If [NEEDS CLARIFICATION] markers remain**: Extract markers (max 3), present options to user in table format, wait for responses, update spec

   d. **Update Checklist**: After each validation iteration, update the checklist with current pass/fail status

7. Report completion with spec file path, checklist results, and readiness for the next phase.

## Quick Guidelines

- Focus on **WHAT** users need and **WHY**.
- Avoid HOW to implement (no tech stack, APIs, code structure).
- Written for business stakeholders, not developers.

### Section Requirements

- **Mandatory sections**: Must be completed for every feature
- **Optional sections**: Include only when relevant; remove entirely when not applicable

### For AI Generation

1. **Propose options, don’t guess**: When details are missing, propose options or mark `[NEEDS CLARIFICATION]`
2. **Document assumptions**: If you propose a default, record it as **provisional** in the Assumptions section and request user approval
3. **Limit clarifications**: Maximum 3 [NEEDS CLARIFICATION] markers
4. **Prioritize clarifications**: scope > security/privacy > user experience > technical details
5. **Think like a tester**: Every vague requirement should fail the "testable and unambiguous" checklist item

### Success Criteria Guidelines

Success criteria must be:
1. **Measurable**: Include specific metrics (time, percentage, count, rate)
2. **Technology-agnostic**: No mention of frameworks, languages, databases, or tools
3. **User-focused**: Describe outcomes from user/business perspective
4. **Verifiable**: Can be tested/validated without knowing implementation details

## Examples

### Success Criteria

**Good** (measurable, technology-agnostic, user-focused):
- "Users can complete checkout in under 3 minutes"
- "95% of searches return results in under 1 second"

**Bad** (implementation-focused -- do not use):
- "API response time is under 200ms" -- too technical; use a user-facing metric instead
- "Redis cache hit rate above 80%" -- technology-specific; describe the user outcome

## Outputs

- `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/spec.md`
- `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/checklists/requirements.md`

## Gate

STOP until the specification passes quality validation and the user acknowledges the result.
