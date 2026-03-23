---
step: units-generation
subagent: false
---

## Inputs

**CONDITIONAL**: This step executes when the execution plan indicates Units Planning/Generation should run.

- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/requirements/` (recommended)
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/user-stories/stories.md` (recommended)
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/application-design/` (required: components.md, component-methods.md, services.md, component-dependency.md)
- Execution plan must indicate Design phase (Units Planning/Generation) should execute

## Guidance

**Overview**: This stage decomposes the system into manageable units of work through two integrated parts:
- **Part 1 - Planning**: Create decomposition plan with questions, collect answers, analyze for ambiguities, get approval
- **Part 2 - Generation**: Execute approved plan to generate unit artifacts

**DEFINITION**: A unit of work is a logical grouping of stories for development purposes. For microservices, each unit becomes an independently deployable service. For monoliths, the single unit represents the entire application with logical modules.

**Terminology**: Use "Service" for independently deployable components, "Module" for logical groupings within a service, "Unit of Work" for planning context.

---

### PART 1: PLANNING

#### Step 1: Create Unit of Work Plan

- Generate plan with checkboxes `[ ]` for decomposing system into units of work
- Focus on breaking down the system into manageable development units
- Each step and sub-step should have a checkbox `[ ]`

#### Step 2: Include Mandatory Unit Artifacts in Plan

**ALWAYS** include these mandatory artifacts in the unit plan:
- `[ ]` Generate `unit-of-work.md` with unit definitions and responsibilities
- `[ ]` Generate `unit-of-work-dependency.md` with dependency matrix
- `[ ]` Generate `unit-of-work-story-map.md` mapping stories to units
- `[ ]` **Greenfield only**: Document code organization strategy in `unit-of-work.md` (see code-generation for structure patterns)
- `[ ]` Validate unit boundaries and dependencies
- `[ ]` Ensure all stories are assigned to units

#### Step 3: Generate Context-Appropriate Questions

**DIRECTIVE**: Analyze the requirements, stories, and application design to generate ONLY questions relevant to THIS specific decomposition problem. Use the categories below as inspiration, NOT as a mandatory checklist. Skip entire categories if not applicable.

- EMBED questions using `[Answer]:` tag format
- Focus on ambiguities and missing information specific to this context
- Generate questions only where user input is needed for decision-making

**See `../../knowledge-core/question-format-guide.md` for question formatting rules**

**Example question categories** (adapt as needed):
- **Story Grouping** - Only if multiple stories exist and grouping strategy is unclear
- **Dependencies** - Only if multiple units likely and integration approach is ambiguous
- **Team Alignment** - Only if team structure or ownership is unclear
- **Technical Considerations** - Only if scalability/deployment requirements differ across units
- **Business Domain** - Only if domain boundaries or bounded contexts are unclear
- **Code Organization (Greenfield multi-unit only)** - Ask deployment model and directory structure preferences

#### Step 4: Store UOW Plan

- Save as `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/plans/unit-of-work-plan.md`
- Include all `[Answer]:` tags for user input
- Ensure plan covers all aspects of system decomposition

#### Step 5: Request User Input

- **MANDATORY**: Ask the user to fill `[Answer]:` tags directly in the plan document (see `../../knowledge-core/question-format-guide.md`).
- Wait for the user to confirm completion before proceeding.
- Emphasize importance of decomposition decisions
- Provide clear instructions on completing the `[Answer]:` tags

#### Step 6: Collect Answers

- Wait for user to provide answers to all questions using `[Answer]:` tags in the document
- Do not proceed until ALL `[Answer]:` tags are completed
- Review the document to ensure no `[Answer]:` tags are left blank

#### Step 7: ANALYZE ANSWERS (MANDATORY)

Before proceeding, you MUST carefully review all user answers for:
- **Vague or ambiguous responses**: "mix of", "somewhere between", "not sure", "depends"
- **Undefined criteria or terms**: References to concepts without clear definitions
- **Contradictory answers**: Responses that conflict with each other
- **Missing generation details**: Answers that lack specific guidance
- **Answers that combine options**: Responses that merge different approaches without clear decision rules

#### Step 8: MANDATORY Follow-up Questions

If the analysis in step 7 reveals ANY ambiguous answers, you MUST:
- Add specific follow-up questions to the plan document using `[Answer]:` tags
- DO NOT proceed to approval until all ambiguities are resolved
- Examples of required follow-ups:
  - "You mentioned 'mix of A and B' - what specific criteria should determine when to use A vs B?"
  - "You said 'somewhere between A and B' - can you define the exact middle ground approach?"
  - "You indicated 'not sure' - what additional information would help you decide?"
  - "You mentioned 'depends on complexity' - how do you define complexity levels?"

#### Step 9: Request Approval

- Ask: "**Unit of work plan complete. Review the plan in `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/plans/unit-of-work-plan.md`. Ready to proceed to generation?**"
- DO NOT PROCEED until user confirms

---

### PART 2: GENERATION

#### Step 10: Load Unit of Work Plan

- `[ ]` Read the complete plan from `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/plans/unit-of-work-plan.md`
- `[ ]` Identify the next uncompleted step (first `[ ]` checkbox)
- `[ ]` Load the context and requirements for that step

#### Step 11: Execute Current Step

- `[ ]` Perform exactly what the current step describes
- `[ ]` Generate unit artifacts as specified in the plan
- `[ ]` Follow the approved decomposition approach from Planning
- `[ ]` Use the criteria and boundaries specified in the plan

**Artifact locations**:
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/application-design/unit-of-work.md`
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/application-design/unit-of-work-dependency.md`
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/application-design/unit-of-work-story-map.md`

#### Step 12: Update Progress

- `[ ]` Mark the completed step as `[x]` in the unit of work plan
- `[ ]` Save all generated artifacts

#### Step 13: Continue or Complete

- `[ ]` If more steps remain, return to Step 10
- `[ ]` If all steps complete, verify units are ready for design stages
- `[ ]` Mark Units Generation stage as complete

---

### Critical Rules

**Planning Phase Rules**
- Generate ONLY context-relevant questions
- Use `[Answer]:` tag format for all questions
- Analyze all answers for ambiguities before proceeding
- Resolve ALL ambiguities with follow-up questions
- Get explicit user approval before generation

**Generation Phase Rules**
- **NO HARDCODED LOGIC**: Only execute what's written in the unit of work plan
- **FOLLOW PLAN EXACTLY**: Do not deviate from the step sequence
- **UPDATE CHECKBOXES**: Mark `[x]` immediately after completing each step
- **USE APPROVED APPROACH**: Follow the decomposition methodology from Planning
- **VERIFY COMPLETION**: Ensure all unit artifacts are complete before proceeding

## Outputs

- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/plans/unit-of-work-plan.md`
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/application-design/unit-of-work.md`
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/application-design/unit-of-work-dependency.md`
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/application-design/unit-of-work-story-map.md`

## Gate

**Completion Criteria**:
- All planning questions answered and ambiguities resolved
- User approval obtained for the plan
- All steps in unit of work plan marked `[x]`
- All unit artifacts generated according to plan
- Units verified and ready for per-unit design stages

**Present completion message**:
```markdown
# 🔧 Units Generation Complete

[AI-generated summary of units and decomposition created in bullet points]

> **📋 <u>**REVIEW REQUIRED:**</u>**  
> Please examine the units generation artifacts at: `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/application-design/`

> **🚀 <u>**WHAT'S NEXT?**</u>**
>
> **You may:**
>
> 🔧 **Request Changes** - Ask for modifications to the units generation if required
> ✅ **Approve & Continue** - Approve units and proceed to **CONSTRUCTION PHASE**
```

Do not proceed until the user explicitly approves the units generation.
