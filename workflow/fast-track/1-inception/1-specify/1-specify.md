---
step: specify
subagent: false
---

## Inputs

- User prompt (natural language feature description)

## Guidance

Create a feature specification from the user's natural language description. Focus on WHAT users need and WHY — avoid HOW to implement.

### 1. Load Context

- Load `workflow/fast-track/templates/spec-template.md` for required sections
- If brownfield: load `reverse-engineering/business-overview.md`, `architecture.md`, `code-structure.md`, `api-documentation.md`, `component-inventory.md` to inform the spec

### 2. Parse Feature Description

1. Extract key concepts: actors, actions, data, constraints
2. If empty: ERROR "No feature description provided"

### 3. Generate Specification

Fill the spec template with concrete details from the feature description:

- **User Scenarios & Testing**: clear user flows and acceptance scenarios
- **Functional Requirements**: each requirement must be testable, use FR-NNN IDs
- **Success Criteria**: measurable, technology-agnostic outcomes
- **Key Entities**: if data is involved, identify entities and relationships

Guidelines:
- Make informed guesses based on context and industry standards
- Document assumptions in the Assumptions section
- Mark unclear aspects with `[NEEDS CLARIFICATION: specific question]` — **maximum 3 markers**
- Prioritize clarifications by impact: scope > security/privacy > user experience > technical details

### 4. Specification Quality Validation

After writing the spec, validate against quality criteria:

1. Create a quality checklist at `initiatives/{INITIATIVE_NAME}/artefacts/1.1-spec-quality-checklist.md`:
   - No implementation details (languages, frameworks, APIs)
   - Focused on user value and business needs
   - Requirements are testable and unambiguous
   - Success criteria are measurable and technology-agnostic
   - All acceptance scenarios defined
   - Edge cases identified
   - Scope clearly bounded

2. Run validation — if items fail (max 3 iterations):
   - List failing items and specific issues
   - Update the spec to address each issue
   - Re-run until all pass

3. If `[NEEDS CLARIFICATION]` markers remain (max 3):
   - Present each as a structured question with options table
   - Wait for user responses
   - Update spec with answers

### 5. Write Outputs

Write the specification to `initiatives/{INITIATIVE_NAME}/artefacts/1.1-spec.md`.

## Outputs

- `artefacts/1.1-spec.md` — feature specification
- `artefacts/1.1-spec-quality-checklist.md` — specification quality validation

## Gate

STOP. Present via `primitives/human-gate.md`.

- If `[NEEDS CLARIFICATION]` markers remain or gaps exist: recommend clarify step next
- If specification is complete: recommend plan step next
