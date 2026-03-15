---
step: implement
subagent: false
---

## Inputs

- `artefacts/1.4-tasks.md` — approved task breakdown
- `artefacts/1.3-plan.md` — implementation plan (tech stack, architecture, file structure)
- `artefacts/1.3-data-model.md` — entity definitions (if exists)
- `artefacts/1.3-contracts/` — API specifications (if exists)
- `artefacts/1.3-research.md` — technical decisions (if exists)
- `artefacts/1.3-quickstart.md` — integration scenarios (if exists)

## Guidance

Execute the implementation plan by processing all tasks from the task breakdown.

### 1. Check Checklists Status

If `artefacts/2.1-checklist-*.md` files exist:
- Scan all checklist files and count total/completed/incomplete items
- Present status table:

```
| Checklist | Total | Done | Incomplete | Status |
|-----------|-------|------|------------|--------|
| ux.md     | 12    | 12   | 0          | PASS   |
| test.md   | 8     | 5    | 3          | FAIL   |
```

- If any incomplete: STOP and ask "Some checklists are incomplete. Proceed anyway? (yes/no)"
- If all complete: proceed automatically

### 2. Load Implementation Context

- **Required**: tasks.md (complete task list), plan.md (tech stack, architecture)
- **If exists**: data-model.md, contracts/, research.md, quickstart.md
- If brownfield: load target repo's RE artifacts (`architecture.md`, `c4-architecture.md`, `code-structure.md`, `technology-stack.md`, `dependencies.md`)

### 3. Project Setup Verification

Create/verify ignore files based on detected tech stack:
- `.gitignore` — if git repo detected
- `.dockerignore` — if Docker detected
- `.eslintignore` / `.prettierignore` — if linters detected
- Technology-specific patterns (Node.js, Python, Java, C#, Go, Rust, etc.)

If ignore file exists: verify essential patterns, append missing critical patterns only.
If missing: create with full pattern set for detected technology.

### 4. Parse and Execute Tasks

Parse tasks.md for phases, dependencies, and parallel markers. Execute:

- **Phase by phase**: complete each phase before the next
- **Respect dependencies**: sequential tasks in order, parallel `[P]` tasks together
- **TDD approach**: test tasks before corresponding implementation tasks (when tests are present)
- **File coordination**: tasks affecting the same files run sequentially

**Execution order within each phase**:
1. Setup — project structure, dependencies, configuration
2. Tests — test infrastructure (if test tasks present)
3. Core — models, services, CLI commands, endpoints
4. Integration — database connections, middleware, external services
5. Polish — optimization, documentation

### 5. Progress Tracking

- Report progress after each completed task
- Mark completed tasks as `[X]` in tasks.md
- Halt on non-parallel task failure
- For parallel task failures: continue with successful tasks, report failures
- Provide clear error messages with debugging context

### 6. Completion Validation

After all tasks:
- Verify all required tasks are completed
- Check implemented features match the specification
- Validate tests pass and coverage meets requirements
- Confirm implementation follows the technical plan

## Outputs

- Implementation code in the target repository
- Updated `artefacts/1.4-tasks.md` with completed task markers

## Gate

STOP. Present via `primitives/human-gate.md`. Report:
- Tasks completed / total
- Test results summary
- Any remaining issues

After approval, the orchestrator proceeds to Stage 6 (Completion) for commit, PR, and risk report.
