---
step: plan
subagent: false
---

## Inputs

- Feature specification at `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/spec.md`
- Constitution at `../../knowledge-core/constitution.md`
- Brownfield context from `{DEPT_FF_PATH}/initiatives/_project/reverse-engineering/` (if available)

## Guidance

1. **Setup**: Resolve `SHELL_TYPE` from session variables. Run the appropriate script from workflow root:
   - **bash**: `../../scripts/bash/setup-plan.sh --json`
   - **powershell**: `../../scripts/powershell/setup-plan.ps1 -Json`

   Parse JSON for FEATURE_SPEC, IMPL_PLAN, SPECS_DIR, BRANCH.

2. **Load context**: Read FEATURE_SPEC and `../../knowledge-core/constitution.md`. Load IMPL_PLAN template (already copied).

3. **Load brownfield context** (if available):
   - Check if `{DEPT_FF_PATH}/initiatives/_project/reverse-engineering/` exists
   - If found, load: `architecture.md`, `code-structure.md`, `technology-stack.md`, `dependencies.md`, `api-documentation.md`
   - Use this context to generate plans consistent with the existing codebase

4. **Execute plan workflow**: Follow the structure in IMPL_PLAN template to:
   - Fill Technical Context (mark unknowns as "NEEDS CLARIFICATION")
   - Fill Constitution Check section from constitution
   - Evaluate gates (ERROR if violations unjustified)
   - Phase 0: Generate research.md (resolve all NEEDS CLARIFICATION)
   - Phase 1: Generate data-model.md, contracts/, quickstart.md
   - Phase 1: Update agent context by running the agent script
   - Re-evaluate Constitution Check post-design

5. **Stop and report**: Command ends after Phase 2 planning. Report IMPL_PLAN path and generated artifacts.

### Phase 0: Outline & Research

1. **Extract unknowns from Technical Context**:
   - For each NEEDS CLARIFICATION -> research task
   - For each dependency -> best practices task
   - For each integration -> patterns task

2. **Generate and dispatch research agents**:
   For each unknown: Task: "Research {unknown} for {feature context}"
   For each technology choice: Task: "Find best practices for {tech} in {domain}"

3. **Consolidate findings** in `research.md`:
   - Decision: [what was chosen]
   - Rationale: [why chosen]
   - Alternatives considered: [what else evaluated]

### Phase 1: Design & Contracts

**Prerequisites:** `research.md` complete

1. **Extract entities from feature spec** -> `data-model.md`:
   - Entity name, fields, relationships
   - Validation rules from requirements
   - State transitions if applicable

2. **Generate API contracts** from functional requirements:
   - For each user action -> endpoint
   - Use standard REST/GraphQL patterns
   - Output OpenAPI/GraphQL schema to `/contracts/`

3. **Agent context update** (use `SHELL_TYPE` from session):
   - **bash**: Run `../../scripts/bash/update-agent-context.sh <agent-type>`
   - **powershell**: Run `../../scripts/powershell/update-agent-context.ps1 -AgentType <agent-type>`

## Key rules

- Use relative paths
- ERROR on gate failures or unresolved clarifications

## Outputs

- `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/plan.md`
- `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/research.md`
- `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/data-model.md`
- `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/contracts/`

## Gate

STOP until the user approves the implementation plan and its generated artifacts.
