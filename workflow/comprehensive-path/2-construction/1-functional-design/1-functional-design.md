---
step: functional-design
subagent: false
---

# Functional Design

**Detailed business logic design per unit**

## Inputs

- Units Generation must be complete
- Unit of work artifacts must be available
- Application Design recommended (provides high-level component structure)
- Execution plan must indicate Functional Design stage should execute

**Read from**:
- `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/application-design/unit-of-work.md`
- `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/application-design/unit-of-work-story-map.md`

## Guidance

### Purpose

Functional Design focuses on:
- Detailed business logic and algorithms for the unit
- Domain models with entities and relationships
- Detailed business rules, validation logic, and constraints
- Technology-agnostic design (no infrastructure concerns)

**Note**: This builds upon high-level component design from Application Design (INCEPTION phase)

### Step 1: Analyze Unit Context

- Read unit definition from `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/application-design/unit-of-work.md`
- Read assigned stories from `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/application-design/unit-of-work-story-map.md`
- Understand unit responsibilities and boundaries

### Step 2: Create Functional Design Plan

- Generate plan with checkboxes [] for functional design
- Focus on business logic, domain models, business rules
- Each step should have a checkbox []

### Step 3: Generate Context-Appropriate Questions

**DIRECTIVE**: Thoroughly analyze the unit definition and functional design artifacts to identify ALL areas where clarification would improve the functional design. Be proactive in asking questions to ensure comprehensive understanding.

**CRITICAL**: Default to asking questions when there is ANY ambiguity or missing detail that could affect functional design quality. It's better to ask too many questions than to make incorrect assumptions.

- EMBED questions using [Answer]: tag format
- Focus on ANY ambiguities, missing information, or areas needing clarification
- Generate questions wherever user input would improve functional design decisions
- **When in doubt, ask the question** - overconfidence leads to poor designs

**Question format**: See `../../../knowledge-core/question-format-guide.md`

**Question categories to consider** (evaluate ALL categories):
- **Business Logic Modeling** - Ask about core entities, workflows, data transformations, and business processes
- **Domain Model** - Ask about domain concepts, entity relationships, data structures, and business objects
- **Business Rules** - Ask about decision rules, validation logic, constraints, and business policies
- **Data Flow** - Ask about data inputs, outputs, transformations, and persistence requirements
- **Integration Points** - Ask about external system interactions, APIs, and data exchange
- **Error Handling** - Ask about error scenarios, validation failures, and exception handling
- **Business Scenarios** - Ask about edge cases, alternative flows, and complex business situations
- **BDD Coverage** (if BDD Specification was executed) - Ask which BDD scenarios from `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/bdd/features/` directly exercise this unit's business logic, and whether any new edge-case scenarios should be added to the feature files based on the logic being designed

### Step 4: Store Plan

- Save as `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/plans/{unit-name}-functional-design-plan.md`
- Include all [Answer]: tags for user input

### Step 5: Collect and Analyze Answers

- **MANDATORY**: Wait for user to complete all [Answer]: tags (see `../../knowledge-core/question-format-guide.md`).
- Wait for the user to confirm completion before proceeding.
- **MANDATORY**: Carefully review ALL responses for vague or ambiguous answers
- **CRITICAL**: Add follow-up questions for ANY unclear responses - do not proceed with ambiguity
- Look for responses like "depends", "maybe", "not sure", "mix of", "somewhere between"
- Create clarification questions file if ANY ambiguities are detected
- **Do not proceed until ALL ambiguities are resolved**

### Step 6: Generate Functional Design Artifacts

- Create `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/{unit-name}/functional-design/business-logic-model.md`
- Create `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/{unit-name}/functional-design/business-rules.md`
- Create `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/{unit-name}/functional-design/domain-entities.md`
- **If BDD Specification was executed**: Create `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/{unit-name}/functional-design/bdd-step-mapping.md`
  - Map each Gherkin `Given / When / Then` step from the relevant feature files to the specific domain entity, business rule, or service method that implements it
  - Identify any BDD scenarios that cannot be mapped (gaps) and flag them for scenario update or new scenario creation
  - This artifact is the technical contract between the Gherkin specification and the implementation, and is used by Code Generation to produce accurate step definitions

## Outputs

- `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/plans/{unit-name}-functional-design-plan.md`
- `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/{unit-name}/functional-design/business-logic-model.md`
- `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/{unit-name}/functional-design/business-rules.md`
- `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/{unit-name}/functional-design/domain-entities.md`
- `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/{unit-name}/functional-design/bdd-step-mapping.md` (if BDD Specification was executed)

## Gate

1. **Completion Announcement** (mandatory):

```markdown
# 🔧 Functional Design Complete - [unit-name]
```

2. **AI Summary** (optional): Provide structured bullet-point summary of functional design
   - Format: "Functional design has created [description]:"
   - List key business logic models and entities (bullet points)
   - List business rules and validation logic defined
   - Mention domain model structure and relationships
   - DO NOT include workflow instructions ("please review", "let me know", "proceed to next phase", "before we proceed")
   - Keep factual and content-focused

3. **Formatted Workflow Message** (mandatory):

```markdown
> **📋 <u>**REVIEW REQUIRED:**</u>**  
> Please examine the functional design artifacts at: `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/[unit-name]/functional-design/`

> **🚀 <u>**WHAT'S NEXT?**</u>**
>
> **You may:**
>
> 🔧 **Request Changes** - Ask for modifications to the functional design based on your review  
> ✅ **Continue to Next Stage** - Approve functional design and proceed to **NFR Requirements**

---
```

4. **Wait for explicit user approval** before proceeding. If user requests changes, update the design and repeat the approval process.
