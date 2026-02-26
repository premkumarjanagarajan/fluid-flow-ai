# BDD Specification - Detailed Steps

## Purpose
**Convert user stories and acceptance criteria into living Gherkin specifications**

BDD Specification focuses on:
- Translating user story acceptance criteria into concrete Gherkin scenarios
- Establishing a shared business language (ubiquitous language) across teams
- Producing living documentation that bridges business requirements and technical tests
- Creating an executable specification contract that drives implementation and verification
- Enabling outside-in development by defining system behaviour before code is written

## Prerequisites
- User Stories must be complete (stories.md and personas.md available)
- Requirements Analysis recommended (provides domain language and business rules)
- Workflow Planning must indicate BDD Specification stage should execute

---

## Intelligent Assessment Guidelines

**WHEN TO EXECUTE BDD SPECIFICATION**: Use this assessment before proceeding:

### High Priority Execution (ALWAYS Execute)
- **User Stories with Acceptance Criteria**: Any stories that define "given/when/then" style conditions
- **Complex Business Rules**: Features with multiple scenario paths, edge cases, or decision branches
- **External Stakeholder Validation**: Work requiring business or QA sign-off via readable specifications
- **Regulated or Compliance Scenarios**: Features where traceability from requirement to test is mandatory
- **Cross-Team Collaboration**: Work spanning multiple teams where shared language is critical
- **APIs and Contracts**: Services consumed externally where behaviour contracts must be explicit

### Medium Priority Execution (Assess Complexity)
- **Backend Business Logic**: Internal logic with multiple conditional paths affecting outcomes
- **Integration Scenarios**: Multi-service interactions where sequence and state matter
- **Data Transformation Rules**: ETL, validation, or enrichment with defined input/output expectations
- **Security Behaviour**: Authentication, authorisation, or rate limiting flows

### Skip Only For Simple Cases
- **Pure Infrastructure Changes**: No business behaviour involved
- **Refactoring**: Zero functional change, covered by existing tests
- **Simple CRUD with no business rules**: Trivial create/read/update/delete with no conditional logic
- **Developer Tooling or Build Process**: CI/CD, scripting, non-functional tooling

### Default Decision Rule
**When in doubt, include BDD Specification.** The overhead of Gherkin scenarios is typically outweighed by:
- Reduced ambiguity during implementation
- Clearer acceptance criteria for QA
- Executable regression safety net
- Shared team vocabulary that reduces rework

---

# PART 1: PLANNING

## Step 1: Validate BDD Specification Need (MANDATORY)

**CRITICAL**: Before proceeding, perform this assessment:

### Assessment Process
1. **Analyze story context**:
   - Review `specs/{BRANCH_NAME}/inception/user-stories/stories.md`
   - Identify stories with multiple acceptance criteria or scenario paths
   - Assess whether business stakeholders would benefit from readable specs
   - Determine if QA team requires executable specifications

2. **Apply assessment criteria** above

3. **Document the assessment decision**:
   - Create `specs/{BRANCH_NAME}/inception/plans/bdd-specification-assessment.md`
   - Include reasoning for why BDD adds value for this feature
   - Reference specific assessment criteria that apply
   - List the BDD framework to be used (see Step 3 questions)

4. **Proceed only if justified**:
   - BDD must add clear value beyond what unit tests already provide
   - Assessment must show concrete traceability or collaboration benefit

### Assessment Documentation Template
```markdown
# BDD Specification Assessment

## Request Analysis
- **Feature**: [Brief summary]
- **Stories Analyzed**: [Count of stories reviewed]
- **Scenario Complexity**: [Simple / Moderate / Complex]
- **Stakeholders Requiring Readable Specs**: [List]

## Assessment Criteria Met
- [ ] High Priority: [List applicable criteria]
- [ ] Medium Priority: [List applicable criteria with justification]
- [ ] Expected Benefits: [List specific value BDD adds]

## Decision
**Execute BDD Specification**: [Yes / No]
**Reasoning**: [Detailed justification]

## BDD Framework Selected
- **Framework**: [SpecFlow / Cucumber / pytest-bdd / Behave / other]
- **Language**: [Feature file language, typically English]
- **Tag Strategy**: [Proposed tagging approach]
```

---

## Step 2: Create BDD Specification Plan

- Assume the role of a BDD coach and test architect
- Generate a comprehensive plan with step-by-step execution checklist
- Each step and sub-step should have a checkbox `[ ]`
- Focus on translating each user story's acceptance criteria into Gherkin scenarios
- Map which stories produce which feature files

---

## Step 3: Generate Context-Appropriate Questions

**DIRECTIVE**: Thoroughly analyse the user stories and requirements to identify ALL areas where clarification would improve scenario quality. Be proactive in asking questions.

**CRITICAL**: Default to asking questions when there is ANY ambiguity about business behaviour, test data, or scenario scope.

**See `../memory/common/question-format-guide.md` for question formatting rules**

- EMBED questions using `[Answer]:` tag format
- Focus on ambiguities that would affect scenario correctness or completeness

**Question categories to evaluate** (consider ALL categories):

- **BDD Framework** — Which framework is in use (SpecFlow, Cucumber, pytest-bdd, Behave, Karate)? What is the target language for step definitions (C#, Java, Python, JavaScript)?
- **Feature File Organisation** — One feature file per user story? Per epic? Per domain? How should feature files be named and organised in the repository?
- **Scenario Granularity** — Should scenarios be written at the UI/API/service level? What is the appropriate level of abstraction (avoid over-specifying implementation details)?
- **Given/When/Then Language** — What domain terms and ubiquitous language should be used? Are there existing step definition libraries to reuse?
- **Background and Shared Steps** — Are there common preconditions shared across scenarios that should use a `Background:` block?
- **Scenario Outlines** — Which scenarios have repetitive structure that benefits from a `Scenario Outline:` with an `Examples:` table?
- **Test Data Strategy** — How should test data be managed? Static fixtures, dynamic generation, or external test data files?
- **Tagging Strategy** — What tags are required? (e.g., `@smoke`, `@regression`, `@wip`, `@unit-name`, story IDs, NFR categories)
- **Negative and Edge Case Scenarios** — Which failure paths and edge cases must be explicitly specified as scenarios?
- **Integration vs Isolation** — Should scenarios test isolated units or end-to-end flows? Where does this BDD suite sit in the test pyramid?

---

## Step 4: Include Mandatory BDD Artifacts in Plan

**ALWAYS** include these mandatory artifacts in the BDD plan:
- `[ ]` Generate `features/` directory with `.feature` files, one per epic or story group
- `[ ]` Generate `bdd-strategy.md` with framework choice, tagging convention, and test data approach
- `[ ]` Generate `step-catalogue.md` listing all steps with their intended domain meaning
- `[ ]` Ensure each scenario follows Given/When/Then structure
- `[ ]` Ensure each scenario maps back to at least one user story (traceability)
- `[ ]` Ensure all acceptance criteria from user stories are covered by at least one scenario

---

## Step 5: Present Scenario Structure Options

Include different approaches for organising feature files:
- **Story-Based**: One feature file per user story (high granularity, easy traceability)
- **Epic-Based**: One feature file per epic or capability (fewer files, broader scope)
- **Domain-Based**: Feature files organised around bounded contexts or business domains
- **Flow-Based**: Feature files follow end-to-end user journeys across multiple stories

Explain trade-offs and recommend the best fit based on the project context.

---

## Step 6: Store BDD Plan

- Save the complete plan with embedded questions to `specs/{BRANCH_NAME}/inception/plans/bdd-specification-plan.md`
- Include all `[Answer]:` tags for user input
- Ensure plan includes story-to-scenario traceability matrix

---

## Step 7: Request User Input

- **MANDATORY**: Offer the user the choice between **Answer Manually** or **AI Best Judgement** mode (see `../memory/common/question-format-guide.md` for full details):
  - **Answer Manually**: Ask user to fill in all `[Answer]:` tags directly in the plan document
  - **AI Best Judgement**: AI fills all `[Answer]:` tags with best judgement, adds `[Reasoning]:` for each, flags low-confidence answers; user reviews and overrides as needed
- Emphasise importance of domain language decisions — incorrect ubiquitous language is costly to change later
- Provide clear instructions on how to complete the `[Answer]:` tags

---

## Step 8: Collect Answers

- Wait for user to provide answers to all questions
- Do not proceed until ALL `[Answer]:` tags are completed
- Review the document to ensure no `[Answer]:` tags are left blank

---

## Step 9: ANALYSE ANSWERS (MANDATORY)

Before proceeding, carefully review all user answers for:
- **Vague or ambiguous responses**: "mix of", "somewhere between", "not sure", "depends", "maybe"
- **Undefined domain terms**: Business language without clear definitions
- **Contradictory answers**: Scenario scope that conflicts with story boundaries
- **Missing test data details**: Scenarios that imply specific data states without defining them
- **Ambiguous step reuse**: Steps described with overlapping or inconsistent meanings

---

## Step 10: MANDATORY Follow-up Questions

If Step 9 reveals ANY ambiguous answers:
- Create a separate clarification questions file using `[Answer]:` tags
- DO NOT proceed to approval until ALL ambiguities are completely resolved
- Examples of required follow-ups:
  - "You said 'mix of story-based and epic-based' — what specific criteria determine when to use each?"
  - "You mentioned 'standard test data' — can you define what that data set contains?"
  - "You indicated 'not sure about tagging' — are there existing tags in the test suite to align with?"

---

## Step 11: Log Approval Prompt

- Before asking for approval, log the prompt with timestamp in `specs/{BRANCH_NAME}/audit.md`
- Include the complete approval prompt text
- Use ISO 8601 timestamp format

---

## Step 12: Wait for Explicit Approval of Plan

- Do not proceed until the user explicitly approves the BDD specification approach
- If user requests changes, update the plan and repeat the approval process

---

## Step 13: Record Approval Response

- Log the user's approval response with timestamp in `specs/{BRANCH_NAME}/audit.md`
- Include the exact user response text
- Mark the approval status clearly

---

# PART 2: GENERATION

## Step 14: Load BDD Specification Plan

- `[ ]` Read the complete plan from `specs/{BRANCH_NAME}/inception/plans/bdd-specification-plan.md`
- `[ ]` Identify the next uncompleted step (first `[ ]` checkbox)
- `[ ]` Load user stories from `specs/{BRANCH_NAME}/inception/user-stories/stories.md`
- `[ ]` Load requirements from `specs/{BRANCH_NAME}/inception/requirements/` (if available)

---

## Step 15: Execute Current Step

- `[ ]` Perform exactly what the current step describes
- `[ ]` Write Gherkin scenarios using the approved domain language and ubiquitous terms
- `[ ]` Maintain traceability by adding story ID comments above each scenario:
  ```gherkin
  # Story: US-001 — As a user I want to...
  Scenario: [Title]
    Given ...
    When ...
    Then ...
  ```
- `[ ]` Apply agreed tagging strategy to every scenario
- `[ ]` Use `Scenario Outline:` with `Examples:` for parameterised cases

---

## Step 16: Update Progress

- `[ ]` Mark the completed step as `[x]` in the BDD specification plan
- `[ ]` Update `specs/{BRANCH_NAME}/state.md` current status
- `[ ]` Save all generated artifacts

---

## Step 17: Continue or Complete Generation

- `[ ]` If more steps remain, return to Step 14
- `[ ]` If all steps complete, verify all mandatory artifacts are generated:
  - All `.feature` files present in `specs/{BRANCH_NAME}/inception/bdd/features/`
  - `bdd-strategy.md` written
  - `step-catalogue.md` written
  - All user story acceptance criteria covered

---

## Step 18: Log Approval Prompt

- Before asking for approval, log the prompt with timestamp in `specs/{BRANCH_NAME}/audit.md`

---

## Step 19: Present Completion Message

Present completion message in this structure:

1. **Completion Announcement** (mandatory): Always start with this:

```markdown
# BDD Specification Complete
```

2. **AI Summary** (optional): Provide structured bullet-point summary
   - List feature files generated with scenario counts
   - Summarize tagging strategy applied
   - Note any stories where BDD coverage gaps were identified
   - DO NOT include workflow instructions ("please review", "let me know", "proceed to next phase")
   - Keep factual and content-focused

3. **Formatted Workflow Message** (mandatory): Always end with this exact format:

```markdown
> **REVIEW REQUIRED:**
> Please examine the BDD artifacts at: `specs/{BRANCH_NAME}/inception/bdd/`
> - Feature files: `specs/{BRANCH_NAME}/inception/bdd/features/`
> - Strategy: `specs/{BRANCH_NAME}/inception/bdd/bdd-strategy.md`
> - Step catalogue: `specs/{BRANCH_NAME}/inception/bdd/step-catalogue.md`



> **WHAT'S NEXT?**
>
> **You may:**
>
> **Request Changes** - Ask for modifications to the scenarios, domain language, or structure
> **Approve & Continue** - Approve BDD Specification and proceed to **Workflow Planning**

---
```

---

## Step 20: Wait for Explicit Approval of Generated Scenarios

- Do not proceed until the user explicitly approves the generated feature files
- If user requests changes, update scenarios and repeat the approval process

---

## Step 21: Record Approval Response

- Log the user's approval response with timestamp in `specs/{BRANCH_NAME}/audit.md`
- Include the exact user response text
- Mark the approval status clearly

---

## Step 22: Update Progress

- Mark BDD Specification stage complete in `specs/{BRANCH_NAME}/state.md`
- Update the "Current Status" section
- Prepare for transition to Workflow Planning

---

# CRITICAL RULES

## Planning Phase Rules
- **DOMAIN LANGUAGE FIRST**: Establish ubiquitous language before writing any Gherkin
- **MANDATORY ANSWER ANALYSIS**: Always analyse answers for ambiguities before proceeding
- **NO PROCEEDING WITH AMBIGUITY**: Vague step language leads to poor step reuse and brittle tests
- **EXPLICIT APPROVAL REQUIRED**: User must approve the BDD plan before generation starts

## Generation Phase Rules
- **NO IMPLEMENTATION DETAILS IN GHERKIN**: Scenarios describe behaviour, not code — avoid referencing classes, methods, or database tables
- **ONE BEHAVIOUR PER SCENARIO**: Each scenario tests exactly one business outcome
- **REUSE STEPS**: Before writing a new step, check `step-catalogue.md` for an existing equivalent
- **FOLLOW PLAN EXACTLY**: Do not deviate from the approved step sequence
- **UPDATE CHECKBOXES**: Mark `[x]` immediately after completing each step
- **STORY TRACEABILITY**: Every scenario must reference at least one story ID in a comment

## Completion Criteria
- All planning questions answered and ambiguities resolved
- BDD plan explicitly approved by user
- All steps in BDD specification plan marked `[x]`
- All mandatory artifacts generated (`.feature` files, `bdd-strategy.md`, `step-catalogue.md`)
- Every user story acceptance criterion covered by at least one scenario
- Generated feature files explicitly approved by user
