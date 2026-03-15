---
step: tasks
subagent: false
---

## Inputs

- `artefacts/1.3-plan.md` — approved implementation plan
- `artefacts/1.1-spec.md` — feature specification (for user story priorities)
- `artefacts/1.3-data-model.md` — entity definitions (if exists)
- `artefacts/1.3-contracts/` — API contracts (if exists)
- `artefacts/1.3-research.md` — technical decisions (if exists)

## Guidance

Decompose the implementation plan into an executable task breakdown organized by user story.

### 1. Load Design Documents

- **Required**: plan.md (tech stack, structure), spec.md (user stories with priorities)
- **Optional**: data-model.md, contracts/, research.md, quickstart.md

### 2. Generate Task Breakdown

Load `workflow/fast-track/templates/tasks-template.md` for structure. Organize tasks by user story:

**Phase structure**:
- **Phase 1: Setup** — project initialization, dependencies, configuration
- **Phase 2: Foundational** — blocking prerequisites for all user stories
- **Phase 3+: User Stories** — one phase per user story in priority order (P1, P2, P3...)
  - Within each story: Tests (if requested) → Models → Services → Endpoints → Integration
  - Each phase should be independently testable
- **Final Phase: Polish** — cross-cutting concerns, optimization, documentation

**Task format** (strict checklist):
```
- [ ] T001 [P?] [Story?] Description with file path
```

- `T001`: sequential ID
- `[P]`: only if parallelizable (different files, no dependencies)
- `[US1]`: required for user story phase tasks (maps to spec user stories)
- Description must include exact file path

### 3. Generate Dependency Graph

Show user story completion order and parallel opportunities.

### 4. Validate Completeness

- Every user story has all needed tasks
- Each story phase is independently testable
- All entities from data-model.md have corresponding tasks
- All endpoints from contracts/ have corresponding tasks

### 5. Write Task Breakdown

Write to `initiatives/{INITIATIVE_NAME}/artefacts/1.4-tasks.md`.

## Outputs

- `artefacts/1.4-tasks.md` — complete task breakdown

Report:
- Total task count and count per user story
- Parallel opportunities identified
- Suggested MVP scope (typically User Story 1)

## Gate

STOP. Present via `primitives/human-gate.md`. The task breakdown must be approved before quality checks or construction.
