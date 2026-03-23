---
step: implement
subagent: false
---

## Inputs

- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/tasks.md` (required)
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/plan.md` (required)
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/data-model.md` (optional)
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/contracts/` (optional)
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/research.md` (optional)
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/checklists/` (optional)
- Brownfield context from `{LOCAL_REPO_PATH}/initiatives/_project/reverse-engineering/` (if available)

## Guidance

1. Resolve `SHELL_TYPE` from session variables. Run the appropriate script from workflow root:
   - **bash**: `../../scripts/bash/check-prerequisites.sh --json --require-tasks --include-tasks`
   - **powershell**: `../../scripts/powershell/check-prerequisites.ps1 -Json -RequireTasks -IncludeTasks`

   Parse FEATURE_DIR and AVAILABLE_DOCS list. All paths must be relative.

2. **Check checklists status** (if checklists/ exists):
   - Scan all checklist files; count total, completed, and incomplete items
   - Create a status table
   - **If any checklist is incomplete**: STOP and ask user whether to proceed anyway
   - **If all complete**: Automatically proceed

3. **Load brownfield context** (if available):
   - Check if `{LOCAL_REPO_PATH}/initiatives/_project/reverse-engineering/` exists
   - If found, load: `architecture.md`, `c4-architecture.md`, `code-structure.md`, `technology-stack.md`, `dependencies.md`
   - Use this context to generate code consistent with the existing codebase

4. Load and analyze the implementation context:
   - **REQUIRED**: Read tasks.md for the complete task list and execution plan
   - **REQUIRED**: Read plan.md for tech stack, architecture, and file structure
   - **IF EXISTS**: Read data-model.md, contracts/, research.md, quickstart.md

5. **Project Setup Verification**:

   Detect and create/verify ignore files. If an ignore file already exists, verify it contains the essential patterns and append only missing critical ones.

   | Detection | File to create/verify |
   |-----------|-----------------------|
   | `git rev-parse --git-dir` | `.gitignore` |
   | `Dockerfile*` present | `.dockerignore` |
   | `.eslintrc*` or `eslint.config.*` present | `.eslintignore` or eslint config ignores |
   | `.prettierrc*` present | `.prettierignore` |
   | `*.tf` present | `.terraformignore` |
   | `package.json` present (publishing) | `.npmignore` |
   | Helm charts present | `.helmignore` |

   **Technology-specific essential ignore patterns**:

   | Technology | Essential Patterns |
   |------------|--------------------|
   | Node.js | `node_modules/`, `dist/`, `.env`, `*.log`, `coverage/` |
   | Python | `__pycache__/`, `*.pyc`, `.venv/`, `venv/`, `*.egg-info/`, `.env` |
   | Java | `target/`, `*.class`, `*.jar`, `.gradle/`, `build/` |
   | C# / .NET | `bin/`, `obj/`, `*.user`, `*.suo`, `packages/` |
   | Go | `vendor/` (if not using modules), binary outputs |
   | Ruby | `.bundle/`, `vendor/bundle/`, `*.gem`, `.env` |
   | PHP | `vendor/`, `.env`, `composer.lock` (for libraries) |
   | Rust | `target/`, `Cargo.lock` (for libraries) |
   | Kotlin | `build/`, `.gradle/`, `*.class` |
   | Docker | `.git`, `node_modules/`, `__pycache__/`, `*.md`, `.env` |
   | Terraform | `.terraform/`, `*.tfstate*`, `crash.log` |

6. Parse tasks.md structure and extract:
   - Task phases: Setup, Tests, Core, Integration, Polish
   - Task dependencies: Sequential vs parallel execution rules
   - Task details: ID, description, file paths, parallel markers [P]

7. Execute implementation following the task plan:
   - **Phase-by-phase execution**: Complete each phase before moving to the next
   - **Respect dependencies**: Run sequential tasks in order, parallel tasks [P] can run together
   - **Follow TDD approach**: Execute test tasks before their corresponding implementation tasks
   - **File-based coordination**: Tasks affecting the same files must run sequentially
   - **Validation checkpoints**: Verify each phase completion before proceeding

8. Implementation execution rules:
   - **Setup first**: Initialize project structure, dependencies, configuration
   - **Tests before code**: Write tests for contracts, entities, and integration scenarios
   - **Core development**: Implement models, services, CLI commands, endpoints
   - **Integration work**: Database connections, middleware, logging, external services
   - **Polish and validation**: Unit tests, performance optimization, documentation

9. Progress tracking and error handling:
   - Report progress after each completed task
   - Halt execution if any non-parallel task fails
   - For parallel tasks [P], continue with successful tasks, report failed ones
   - Mark completed tasks as [X] in the tasks file

10. Completion validation:
    - Verify all required tasks are completed
    - Check that implemented features match the original specification
    - Validate that tests pass and coverage meets requirements
    - Report final status with summary of completed work

11. **Post-Implementation Documentation**:
    Present to the user:
    ```
    ## Implementation Complete

    All tasks have been executed.

    **Next step**: Update project-level documentation (test coverage delta, reverse engineering artifacts).

    Ready to proceed with documentation updates?
    ```

## Outputs

- All files created/modified as specified in the task plan
- Updated `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/tasks.md` with completed task checkboxes

## Gate

STOP until all tasks are completed and the user confirms the implementation is satisfactory.
