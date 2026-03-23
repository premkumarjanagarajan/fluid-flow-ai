---
step: code-generation
subagent: false
---

# Code Generation

**Code generation per unit**

This stage generates code for each unit of work through two integrated parts:
- **Part 1 - Planning**: Create detailed code generation plan with explicit steps
- **Part 2 - Generation**: Execute approved plan to generate code, tests, and artifacts

**Note**: For brownfield projects, "generate" means modify existing files when appropriate, not create duplicates.

## Inputs

- Unit Design Generation must be complete for the unit
- NFR Implementation (if executed) must be complete for the unit
- All unit design artifacts must be available
- Unit is ready for code generation

**Read from**:
- Unit design artifacts from previous construction steps
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/{unit-name}/functional-design/bdd-step-mapping.md` (if BDD Specification was executed)
- `{LOCAL_REPO_PATH}/initiatives/_project/reverse-engineering/code-structure.md` (brownfield only)

## Guidance

### Part 1: Planning

#### Step 1: Analyze Unit Context

- [ ] Read unit design artifacts from Unit Design Generation
- [ ] Read unit story map to understand assigned stories
- [ ] Identify unit dependencies and interfaces
- [ ] Validate unit is ready for code generation

#### Step 2: Create Detailed Unit Code Generation Plan

- [ ] Determine code location (see Critical Rules for structure patterns)
- [ ] **Brownfield only**: Review reverse engineering code-structure.md for existing files to modify
- [ ] Document exact paths (never specs/ or artefacts/ for application code)
- [ ] Create explicit steps for unit generation:
  - Project Structure Setup (greenfield only)
  - Business Logic Generation
  - Business Logic Unit Testing
  - Business Logic Summary
  - API Layer Generation
  - API Layer Unit Testing
  - API Layer Summary
  - Repository Layer Generation
  - Repository Layer Unit Testing
  - Repository Layer Summary
  - Database Migration Scripts (if data models exist)
  - BDD Step Definitions Generation (if BDD Specification was executed — see note below)
  - Documentation Generation (API docs, README updates)
  - Deployment Artifacts Generation
- [ ] Number each step sequentially
- [ ] Include story mapping references
- [ ] Add checkboxes [ ] for each step

#### Step 3: Include Unit Generation Context

- [ ] For this unit, include:
  - Stories implemented by this unit
  - Dependencies on other units/services
  - Expected interfaces and contracts
  - Database entities owned by this unit
  - Service boundaries and responsibilities

#### Step 4: Create Unit Plan Document

- [ ] Save complete plan as `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/plans/{unit-name}-code-generation-plan.md`
- [ ] Include step numbering (Step 1, Step 2, etc.)
- [ ] Include unit context and dependencies
- [ ] Include story traceability
- [ ] Ensure plan is executable step-by-step
- [ ] Emphasize that this plan is the single source of truth for Code Generation

#### Step 5: Summarize Unit Plan

- [ ] Provide summary of the unit code generation plan to the user
- [ ] Highlight unit generation approach
- [ ] Explain step sequence and story coverage
- [ ] Note total number of steps and estimated scope

#### Step 6–9: Approval Flow

- [ ] Wait for explicit user approval of the unit code generation plan
- [ ] Approval must cover the entire plan and generation sequence
- [ ] If user requests changes, update the plan and repeat approval process

### Part 2: Generation

#### Step 10: Load Unit Code Generation Plan

- [ ] Read the complete plan from `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/plans/{unit-name}-code-generation-plan.md`
- [ ] Identify the next uncompleted step (first [ ] checkbox)
- [ ] Load the context for that step (unit, dependencies, stories)

#### Step 11: Execute Current Step

- [ ] Verify target directory from plan
- [ ] **Brownfield only**: Check if target file exists
- [ ] Generate exactly what the current step describes:
  - **If file exists**: Modify it in-place (never create `ClassName_modified.java`, `ClassName_new.java`, etc.)
  - **If file doesn't exist**: Create new file
- [ ] Write to correct locations:
  - **Application Code**: Workspace root per project structure
  - **Documentation**: `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/{unit-name}/code/` (markdown only)
  - **Build/Config Files**: Workspace root
- [ ] Follow unit story requirements
- [ ] Respect dependencies and interfaces

#### Step 12: Update Progress

- [ ] Mark the completed step as [x] in the unit code generation plan
- [ ] Mark associated unit stories as [x] when their generation is finished
- [ ] **Brownfield only**: Verify no duplicate files created (e.g., no `ClassName_modified.java` alongside `ClassName.java`)
- [ ] Save all generated artifacts

#### Step 13: Continue or Complete Generation

- [ ] If more steps remain, return to Step 10
- [ ] If all steps complete, proceed to present completion message

### Critical Rules

#### Code Location Rules

- **Application code**: Workspace root only (NEVER artefacts/)
- **Documentation**: `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/{unit-name}/code/` (markdown summaries)

**Structure patterns by project type**:
- **Brownfield**: Use existing structure (e.g., `src/main/java/`, `lib/`, `pkg/`)
- **Greenfield single unit**: `src/`, `tests/`, `config/` in workspace root
- **Greenfield multi-unit (microservices)**: `{unit-name}/src/`, `{unit-name}/tests/`
- **Greenfield multi-unit (monolith)**: `src/{unit-name}/`, `tests/{unit-name}/`

#### Brownfield File Modification Rules

- Check if file exists before generating
- If exists: Modify in-place (never create copies like `ClassName_modified.java`)
- If doesn't exist: Create new file
- Verify no duplicate files after generation (Step 12)

#### BDD Step Definitions Rules (Conditional — when BDD Specification was executed)

- **Source**: Read `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/{unit-name}/functional-design/bdd-step-mapping.md` before generating step definitions
- **Location**: Step definition files are application code — place them in the workspace root under the project's existing test structure (e.g., `tests/steps/`, `src/test/java/.../steps/`, `Features/StepDefinitions/`)
- **One class per feature file**: Group step definitions by the feature file they serve to keep them cohesive and maintainable
- **No duplicate steps**: Before generating a new step definition, check the step catalogue (`{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/bdd/step-catalogue.md`) for existing equivalent steps
- **Binding only, no assertions in steps**: Step definitions wire Gherkin language to service/domain calls; assertions belong in the domain/service layer, not the step body
- **Hooks**: Generate `Before` / `After` hooks for test setup and teardown only if the BDD plan specifies shared state requirements
- **Documentation**: Generate a markdown summary at `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/{unit-name}/code/bdd-step-definitions-summary.md` listing all generated step definition files and the Gherkin steps they implement

#### Planning Phase Rules

- Create explicit, numbered steps for all generation activities
- Include story traceability in the plan
- Document unit context and dependencies
- Get explicit user approval before generation

#### Generation Phase Rules

- **NO HARDCODED LOGIC**: Only execute what's written in the unit plan
- **FOLLOW PLAN EXACTLY**: Do not deviate from the step sequence
- **UPDATE CHECKBOXES**: Mark [x] immediately after completing each step
- **STORY TRACEABILITY**: Mark unit stories [x] when functionality is implemented
- **RESPECT DEPENDENCIES**: Only implement when unit dependencies are satisfied

## Outputs

- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/plans/{unit-name}-code-generation-plan.md`
- Application code in workspace root
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/{unit-name}/code/` (documentation)

## Gate

1. **Completion Announcement** (mandatory):

```markdown
# 💻 Code Generation Complete - [unit-name]
```

2. **AI Summary** (optional): Provide structured bullet-point summary
   - **Brownfield**: Distinguish modified vs created files (e.g., "• Modified: `src/services/user-service.ts`", "• Created: `src/services/auth-service.ts`")
   - **Greenfield**: List created files with paths (e.g., "• Created: `src/services/user-service.ts`")
   - List tests, documentation, deployment artifacts with paths
   - Keep factual, no workflow instructions

3. **Formatted Workflow Message** (mandatory):

```markdown
> **📋 <u>**REVIEW REQUIRED:**</u>**  
> Please examine the generated code at:
> - **Application Code**: [actual-workspace-path]
> - **Documentation**: `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/[unit-name]/code/`

> **🚀 <u>**WHAT'S NEXT?**</u>**
>
> **You may:**
>
> 🔧 **Request Changes** - Ask for modifications to the generated code based on your review  
> ✅ **Continue to Next Stage** - Approve code generation and proceed to **Build & Test**

---
```

4. **Wait for explicit user approval** before proceeding. If user requests changes, update the code and repeat the approval process.
