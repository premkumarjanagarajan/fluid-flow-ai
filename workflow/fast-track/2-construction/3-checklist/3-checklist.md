---
step: checklist
subagent: false
---

## Inputs

- User's checklist request describing domain/focus area
- Feature artifacts at `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/` (spec.md, plan.md, tasks.md)

## Guidance

### Checklist Purpose: "Unit Tests for English"

Checklists are **UNIT TESTS FOR REQUIREMENTS WRITING** - they validate the quality, clarity, and completeness of requirements in a given domain.

**NOT for verification/testing**:
- Not "Verify the button clicks correctly"
- Not "Test error handling works"

**FOR requirements quality validation**:
- "Are visual hierarchy requirements defined for all card types?" (completeness)
- "Is 'prominent display' quantified with specific sizing/positioning?" (clarity)
- "Are accessibility requirements defined for keyboard navigation?" (coverage)

### Execution Steps

1. **Setup**: Resolve `SHELL_TYPE` from session variables. Run the appropriate script from workflow root:
   - **bash**: `../../scripts/bash/check-prerequisites.sh --json`
   - **powershell**: `../../scripts/powershell/check-prerequisites.ps1 -Json`

   Parse JSON for FEATURE_DIR and AVAILABLE_DOCS list.

2. **Clarify intent (dynamic)**: Derive up to THREE initial contextual clarifying questions. They MUST:
   - Be generated from the user's phrasing + extracted signals from spec/plan/tasks
   - Only ask about information that materially changes checklist content
   - Be skipped individually if already unambiguous

   Generation algorithm:
   1. Extract signals: feature domain keywords, risk indicators, stakeholder hints, explicit deliverables
   2. Cluster signals into candidate focus areas (max 4) ranked by relevance
   3. Formulate questions from archetypes: scope refinement, risk prioritization, depth calibration, audience framing, boundary exclusion, scenario class gap

3. **Understand user request**: Combine user input + clarifying answers:
   - Derive checklist theme (e.g., security, review, deploy, ux)
   - Consolidate explicit must-have items
   - Map focus selections to category scaffolding

4. **Load feature context**: Read from FEATURE_DIR:
   - spec.md: Feature requirements and scope
   - plan.md (if exists): Technical details, dependencies
   - tasks.md (if exists): Implementation tasks
   Use progressive disclosure: load only necessary portions relevant to focus areas.

5. **Generate checklist** - Create "Unit Tests for Requirements":
   - Create checklists/ directory if it doesn't exist
   - Generate unique checklist filename using short, descriptive name (e.g. `ux.md`, `api.md`, `security.md`)
   - Number items sequentially starting from CHK001
   - Each run creates a NEW file (never overwrites existing checklists)

   **Category Structure** - Group items by requirement quality dimensions:
   - Requirement Completeness, Clarity, Consistency
   - Acceptance Criteria Quality
   - Scenario Coverage, Edge Case Coverage
   - Non-Functional Requirements
   - Dependencies & Assumptions
   - Ambiguities & Conflicts

   **Item Pattern**:
   - Question format asking about requirement quality
   - Focus on what's WRITTEN (or not written) in the spec/plan
   - Include quality dimension in brackets [Completeness/Clarity/Consistency/etc.]
   - Reference spec section `[Spec §X.Y]` when checking existing requirements
   - Use `[Gap]` marker when checking for missing requirements
   - MINIMUM: >=80% of items MUST include at least one traceability reference

   **PROHIBITED**: Any item testing implementation behavior ("Verify", "Test", "Confirm" + system behavior)
   **REQUIRED**: Items testing requirements quality ("Are [requirements] defined/specified/documented for [scenario]?")

6. **Structure Reference**: Generate using `../../templates/checklist-template.md` for formatting.

7. **Report**: Output full path to created checklist, item count, focus areas, depth level.

## Examples

### Correct (testing requirements quality)

- `- [ ] CHK001 - Are the number and layout of featured episodes explicitly specified? [Completeness, Spec §FR-001]`
- `- [ ] CHK002 - Are hover state requirements consistently defined for all interactive elements? [Consistency, Spec §FR-003]`

### Prohibited (testing implementation -- never use)

- `- [ ] CHK001 - Verify landing page displays 3 episode cards [Spec §FR-001]`
- `- [ ] CHK002 - Test hover states work correctly on desktop [Spec §FR-003]`

Prohibited patterns: any item starting with "Verify", "Test", "Confirm", "Check" + system behavior. No references to code execution, rendering, clicking, or loading.

### Example Checklist: UX (`ux.md`)

```markdown
- [ ] CHK001 - Are visual hierarchy requirements defined with measurable criteria? [Clarity, Spec §FR-1]
- [ ] CHK002 - Is the number and positioning of UI elements explicitly specified? [Completeness, Spec §FR-1]
- [ ] CHK003 - Are interaction state requirements (hover, focus, active) consistently defined? [Consistency]
- [ ] CHK004 - Are accessibility requirements specified for all interactive elements? [Coverage, Gap]
- [ ] CHK005 - Is fallback behavior defined when images fail to load? [Edge Case, Gap]
- [ ] CHK006 - Can "prominent display" be objectively measured? [Measurability, Spec §FR-4]
```

## Outputs

- `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/checklists/{domain}.md`

## Gate

STOP until the user acknowledges the checklist. Multiple runs can create additional checklists for different domains.
