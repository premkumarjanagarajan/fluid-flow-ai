---
step: application-design
subagent: false
---

## Inputs

**CONDITIONAL**: This step executes when the execution plan indicates Application Design should run.

- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/requirements/requirements.md` (required)
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/user-stories/stories.md` (required)
- Execution plan must indicate Application Design stage should execute

## Guidance

**Purpose**: High-level component identification and service layer design.

Application Design focuses on:
- Identifying main functional components and their responsibilities
- Defining component interfaces (not detailed business logic)
- Designing service layer for orchestration
- Establishing component dependencies and communication patterns

**Note**: Detailed business logic design happens later in Functional Design (per-unit, CONSTRUCTION phase).

### Architecture Escalation

If design crosses:
- Domain boundaries
- Data ownership boundaries
- Regulatory boundaries

AI must escalate and invoke the ADR Integrity Gate. See `../../knowledge-core/adrs-technical-principles.md`.

### Step-by-Step Execution

#### Step 1: Analyze Context

- Read `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/requirements/requirements.md` and `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/user-stories/stories.md`
- Identify key business capabilities and functional areas
- Determine design scope and complexity

#### Step 2: Create Application Design Plan

- Generate plan with checkboxes `[ ]` for application design
- Focus on components, responsibilities, methods, business rules, and services
- Each step and sub-step should have a checkbox `[ ]`

#### Step 3: Include Mandatory Design Artifacts in Plan

**ALWAYS** include these mandatory artifacts in the design plan:
- `[ ]` Generate components.md with component definitions and high-level responsibilities
- `[ ]` Generate component-methods.md with method signatures (business rules detailed later in Functional Design)
- `[ ]` Generate services.md with service definitions and orchestration patterns
- `[ ]` Generate component-dependency.md with dependency relationships and communication patterns
- `[ ]` Validate design completeness and consistency

#### Step 4: Generate Context-Appropriate Questions

**DIRECTIVE**: Analyze the requirements and stories to generate ONLY questions relevant to THIS specific application design. Use the categories below as inspiration, NOT as a mandatory checklist. Skip entire categories if not applicable.

- EMBED questions using `[Answer]:` tag format
- Focus on ambiguities and missing information specific to this context
- Generate questions only where user input is needed for design decisions

**See `../../knowledge-core/question-format-guide.md` for question formatting rules**

**Example question categories** (adapt as needed):
- **Component Identification** - Only if component boundaries or organization is unclear
- **Component Methods** - Only if method signatures need clarification (detailed business rules come later)
- **Service Layer Design** - Only if service orchestration or boundaries are ambiguous
- **Component Dependencies** - Only if communication patterns or dependency management is unclear
- **Design Patterns** - Only if architectural style or pattern choice needs user input

#### Step 5: Store Application Design Plan

- Save as `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/plans/application-design-plan.md`
- Include all `[Answer]:` tags for user input
- Ensure plan covers all design aspects

#### Step 6: Request User Input

- **MANDATORY**: Offer the user the choice between **Answer Manually** or **AI Best Judgement** mode (see `../../knowledge-core/question-format-guide.md` for full details):
  - **Answer Manually**: Ask user to fill `[Answer]:` tags directly in the plan document
  - **AI Best Judgement**: AI fills all `[Answer]:` tags with best judgement, adds `[Reasoning]:` for each, flags low-confidence answers; user reviews and overrides as needed
- Emphasize importance of design decisions
- Provide clear instructions on completing the `[Answer]:` tags (or how to review AI-generated answers)

#### Step 7: Collect Answers

- **Answer Manually**: Wait for user to provide answers to all questions using `[Answer]:` tags in the document
- **AI Best Judgement**: Wait for user to confirm review of AI-generated answers is complete
- Do not proceed until ALL `[Answer]:` tags are completed
- Review the document to ensure no `[Answer]:` tags are left blank

#### Step 8: ANALYZE ANSWERS (MANDATORY)

Before proceeding, you MUST carefully review all user answers for:
- **Vague or ambiguous responses**: "mix of", "somewhere between", "not sure", "depends"
- **Undefined criteria or terms**: References to concepts without clear definitions
- **Contradictory answers**: Responses that conflict with each other
- **Missing design details**: Answers that lack specific guidance
- **Answers that combine options**: Responses that merge different approaches without clear decision rules

#### Step 9: MANDATORY Follow-up Questions

If the analysis in step 8 reveals ANY ambiguous answers, you MUST:
- Add specific follow-up questions to the plan document using `[Answer]:` tags
- DO NOT proceed to approval until all ambiguities are resolved
- Examples of required follow-ups:
  - "You mentioned 'mix of A and B' - what specific criteria should determine when to use A vs B?"
  - "You said 'somewhere between A and B' - can you define the exact middle ground approach?"
  - "You indicated 'not sure' - what additional information would help you decide?"
  - "You mentioned 'depends on complexity' - how do you define complexity levels?"

#### Step 10: Generate Application Design Artifacts

- Execute the approved plan to generate design artifacts
- Create `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/application-design/components.md` with:
  - Component name and purpose
  - Component responsibilities
  - Component interfaces
- Create `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/application-design/component-methods.md` with:
  - Method signatures for each component
  - High-level purpose of each method
  - Input/output types
  - Note: Detailed business rules will be defined in Functional Design (per-unit, CONSTRUCTION phase)
- Create `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/application-design/services.md` with:
  - Service definitions
  - Service responsibilities
  - Service interactions and orchestration
- Create `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/application-design/component-dependency.md` with:
  - Dependency matrix showing relationships
  - Communication patterns between components
  - Data flow diagrams

---

### Critical Rules

- **DOMAIN LANGUAGE FIRST**: Establish component and service vocabulary before detailed design
- **MANDATORY ANSWER ANALYSIS**: Always analyse answers for ambiguities before proceeding
- **NO PROCEEDING WITH AMBIGUITY**: Vague design language leads to inconsistent implementation
- **EXPLICIT APPROVAL REQUIRED**: User must approve the application design plan before artifact generation
- **HIGH-LEVEL ONLY**: Do not define detailed business logic here; that belongs in Functional Design (CONSTRUCTION phase)

## Outputs

- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/plans/application-design-plan.md`
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/application-design/components.md`
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/application-design/component-methods.md`
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/application-design/services.md`
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/application-design/component-dependency.md`

## Gate

**Completion Criteria**:
- All planning questions answered and ambiguities resolved
- Application design plan explicitly approved by user
- All mandatory design artifacts generated
- User explicitly approves the application design

**Present completion message**:
```markdown
# 🏗️ Application Design Complete

[AI-generated summary of application design artifacts created in bullet points]

> **📋 <u>**REVIEW REQUIRED:**</u>**  
> Please examine the application design artifacts at: `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/application-design/`

> **🚀 <u>**WHAT'S NEXT?**</u>**
>
> **You may:**
>
> 🔧 **Request Changes** - Ask for modifications to the application design if required
> [IF Units Generation is skipped:]
> 📝 **Add Units Generation** - Choose to include **Units Generation** stage (currently skipped)
> ✅ **Approve & Continue** - Approve design and proceed to **[Units Generation/CONSTRUCTION PHASE]**
```

Do not proceed until the user explicitly approves the application design.
