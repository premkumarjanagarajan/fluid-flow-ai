---
step: tasks
subagent: false
---

## Inputs

- `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/plan.md` (required)
- `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/spec.md` (required)
- `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/data-model.md` (optional)
- `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/contracts/` (optional)
- `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/research.md` (optional)

## Guidance

1. **Setup**: Resolve `SHELL_TYPE` from session variables. Run the appropriate script from workflow root:
   - **bash**: `../../scripts/bash/check-prerequisites.sh --json`
   - **powershell**: `../../scripts/powershell/check-prerequisites.ps1 -Json`

   Parse FEATURE_DIR and AVAILABLE_DOCS list. All paths must be relative.

2. **Load design documents**: Read from FEATURE_DIR:
   - **Required**: plan.md (tech stack, libraries, structure), spec.md (user stories with priorities)
   - **Optional**: data-model.md (entities), contracts/ (API endpoints), research.md (decisions), quickstart.md (test scenarios)

3. **Execute task generation workflow**:
   - Load plan.md and extract tech stack, libraries, project structure
   - Load spec.md and extract user stories with their priorities (P1, P2, P3, etc.)
   - If data-model.md exists: Extract entities and map to user stories
   - If contracts/ exists: Map endpoints to user stories
   - If research.md exists: Extract decisions for setup tasks
   - Generate tasks organized by user story
   - Generate dependency graph showing user story completion order
   - Create parallel execution examples per user story
   - Validate task completeness (each user story has all needed tasks, independently testable)

4. **Generate tasks.md**: Use `../../templates/tasks-template.md` as structure, fill with:
   - Correct feature name from plan.md
   - Phase 1: Setup tasks (project initialization)
   - Phase 2: Foundational tasks (blocking prerequisites for all user stories)
   - Phase 3+: One phase per user story (in priority order from spec.md)
   - Each phase includes: story goal, independent test criteria, tests (if requested), implementation tasks
   - Final Phase: Polish & cross-cutting concerns
   - All tasks must follow the strict checklist format
   - Clear file paths for each task

5. **Report**: Output path to generated tasks.md and summary:
   - Total task count, task count per user story
   - Parallel opportunities identified
   - Suggested MVP scope (typically just User Story 1)

## Task Generation Rules

**CRITICAL**: Tasks MUST be organized by user story to enable independent implementation and testing.

**Tests are OPTIONAL**: Only generate test tasks if explicitly requested.

### Checklist Format (REQUIRED)

Every task MUST strictly follow this format:

```text
- [ ] [TaskID] [P?] [Story?] Description with file path
```

**Format Components**:
1. **Checkbox**: ALWAYS start with `- [ ]`
2. **Task ID**: Sequential number (T001, T002, T003...)
3. **[P] marker**: Include ONLY if task is parallelizable
4. **[Story] label**: REQUIRED for user story phase tasks only ([US1], [US2], etc.)
5. **Description**: Clear action with exact file path

### Phase Structure

- **Phase 1**: Setup (project initialization)
- **Phase 2**: Foundational (blocking prerequisites)
- **Phase 3+**: User Stories in priority order (P1, P2, P3...)
  - Within each story: Tests (if requested) → Models → Services → Endpoints → Integration
  - Each phase should be a complete, independently testable increment
- **Final Phase**: Polish & Cross-Cutting Concerns

## Examples

### Checklist Format

**Correct**:
- `- [ ] T005 [P] Implement authentication middleware in src/middleware/auth.py`
- `- [ ] T012 [P] [US1] Create User model in src/models/user.py`

**Wrong**:
- `- [ ] Create User model` -- missing Task ID, Story label, and file path
- `T001 [US1] Create model` -- missing checkbox and file path

## Outputs

- `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/tasks.md`

## Gate

STOP until the user approves the task breakdown.
