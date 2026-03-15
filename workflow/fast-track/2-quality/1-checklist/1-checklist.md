---
step: checklist
subagent: false
---

## Inputs

- `artefacts/1.1-spec.md` — feature specification
- `artefacts/1.3-plan.md` — implementation plan (if exists)
- `artefacts/1.4-tasks.md` — task breakdown (if exists)

## Guidance

Generate requirements quality checklists — "unit tests for requirements." These test whether the REQUIREMENTS are well-written, complete, and unambiguous — NOT whether the implementation works.

### 1. Clarify Intent

Derive up to 3 contextual clarifying questions based on the feature domain to determine:
- **Focus areas**: which requirement quality dimensions to prioritize (e.g. UX, API, security, performance)
- **Depth**: lightweight pre-commit sanity list vs formal release gate
- **Audience**: author self-check vs peer review vs QA

If the user provides clear context in their request, skip clarification and proceed.

### 2. Load Feature Context

From initiative artifacts:
- spec.md: requirements and scope
- plan.md: technical details and dependencies (if exists)
- tasks.md: implementation tasks (if exists)

Load only portions relevant to the selected focus areas.

### 3. Generate Checklist

Load `workflow/fast-track/templates/checklist-template.md` for structure.

**Core principle**: every item evaluates the REQUIREMENTS THEMSELVES for completeness, clarity, consistency, measurability, and coverage.

Group items by requirement quality dimensions:
- **Requirement Completeness** — are all necessary requirements documented?
- **Requirement Clarity** — are requirements specific and unambiguous?
- **Requirement Consistency** — do requirements align without conflicts?
- **Acceptance Criteria Quality** — are success criteria measurable?
- **Scenario Coverage** — are all flows/cases addressed?
- **Edge Case Coverage** — are boundary conditions defined?
- **Non-Functional Requirements** — are performance, security, accessibility specified?
- **Dependencies & Assumptions** — are they documented and validated?

**Item format**: `- [ ] CHK### Are [requirement aspect] defined/specified for [scenario]? [Quality Dimension, Spec §X.Y]`

**Traceability**: >=80% of items must reference a spec section `[Spec §X.Y]` or use markers: `[Gap]`, `[Ambiguity]`, `[Conflict]`, `[Assumption]`

**Prohibited**: items starting with "Verify", "Test", "Confirm" + implementation behavior. Items must test requirement quality, not system behavior.

### 4. Write Checklist

Write to `initiatives/{INITIATIVE_NAME}/artefacts/2.1-checklist-{domain}.md` (e.g. `2.1-checklist-ux.md`).

Each run creates a NEW file — multiple checklists for different domains are supported.

## Outputs

- `artefacts/2.1-checklist-{domain}.md` — requirements quality checklist

Report: focus areas, depth level, item count, traceability coverage.

## Gate

STOP. Present via `primitives/human-gate.md`.
- If more checklists needed for other domains: recommend re-running this step
- If ready for analysis: recommend analyze step next
