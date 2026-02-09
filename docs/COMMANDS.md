# Command Reference

This document provides a complete reference for every command and stage in Fluid Flow Pro.

---

## Table of Contents

- [Spec-Kit Commands](#spec-kit-commands)
  - [/speckit.specify](#speckitspecify)
  - [/speckit.clarify](#speckitclarify)
  - [/speckit.plan](#speckitplan)
  - [/speckit.tasks](#speckittasks)
  - [/speckit.checklist](#speckitchecklist)
  - [/speckit.implement](#speckitimplement)
  - [/speckit.analyze](#speckitanalyze)
  - [/speckit.taskstoissues](#speckittaskstoissues)
  - [/speckit.constitution](#speckitconstitution)
- [AWS AI-DLC Stages](#aws-ai-dlc-stages)
  - [Inception Phase](#inception-phase)
  - [Construction Phase](#construction-phase)
  - [Operations Phase](#operations-phase)
- [Shared Stages](#shared-stages)
- [Automation Scripts](#automation-scripts)

---

## Spec-Kit Commands

All Spec-Kit commands follow a consistent pattern:
1. Load shared memory files (AI operating contract, content validation, review gates, ISO 9001, ADR integrity gate, continuous learning, overconfidence prevention)
2. Load security rules if the change affects security, data, identity, or infrastructure
3. Load ISO 50001 energy management if the change affects infrastructure, performance, or energy (SEU-related)
4. Read and update `state.md` and `audit.md`
5. Execute the command logic
6. Write artifacts to `specs/{BRANCH_NAME}/`

---

### /speckit.specify

**Purpose**: Convert a natural-language feature description into a structured specification.

**File**: `main-workflow/workflows/spec-kit/commands/speckit.specify.md`

**Input**: The feature description provided after the command (e.g., `/speckit.specify Add user authentication with JWT`)

**Process**:
1. Detect existing feature context via `check-prerequisites.sh`
2. Update state tracking to "Spec-Kit - Specification"
3. Analyse the feature description
4. Generate a structured specification including:
   - User scenarios and personas
   - Functional requirements
   - Non-functional requirements
   - Success criteria
   - Technology constraints
   - Edge cases and error handling
5. Validate content before writing
6. Write `spec.md` to the feature directory

**Output**: `specs/{BRANCH_NAME}/spec.md`

**Handoffs**:
- `/speckit.plan` -- Build a technical plan from the specification
- `/speckit.clarify` -- Clarify underspecified areas

---

### /speckit.clarify

**Purpose**: Identify underspecified areas in the current spec and resolve them through targeted questions.

**File**: `main-workflow/workflows/spec-kit/commands/speckit.clarify.md`

**Input**: Optional arguments; operates on the existing `spec.md`

**Process**:
1. Read the current specification
2. Identify up to 5 underspecified or ambiguous areas
3. Ask highly targeted clarification questions
4. Encode answers back into the specification
5. Update `spec.md` with resolved ambiguities

**Output**: Updated `specs/{BRANCH_NAME}/spec.md`

**Handoff**: `/speckit.plan`

---

### /speckit.plan

**Purpose**: Generate an implementation plan with architecture decisions, data models, and API contracts.

**File**: `main-workflow/workflows/spec-kit/commands/speckit.plan.md`

**Input**: Optional arguments (e.g., technology stack preferences)

**Process**:
1. Run `setup-plan.sh` to prepare context
2. Load `spec.md` and the constitution template
3. Load brownfield context (architecture, code structure) if available
4. Generate the implementation plan including:
   - Architecture decisions
   - Data models and entity definitions
   - API contracts and endpoints
   - Dependency maps
   - Technology stack selections
   - File structure recommendations
5. Write the plan and related artifacts

**Output**: `specs/{BRANCH_NAME}/plan.md` (plus optional `data-model.md`, `contracts/`)

**Handoffs**:
- `/speckit.tasks` -- Break the plan into tasks
- `/speckit.checklist` -- Create quality checklists

---

### /speckit.tasks

**Purpose**: Break the implementation plan into an ordered, dependency-aware task list.

**File**: `main-workflow/workflows/spec-kit/commands/speckit.tasks.md`

**Input**: Optional arguments

**Process**:
1. Run `check-prerequisites.sh` to verify context
2. Load design documents (plan, spec, data model, contracts)
3. Generate the task list:
   - Tasks follow the Spec-Kit checklist format with task IDs (T001, T002, ...) and optional `[P]` (parallelizable) and `[US#]` (user story) labels
   - Tasks are ordered by dependencies
   - File path references for each task
   - Tasks are grouped by user story phase; validation is captured as "Independent Test" criteria at the user-story level

**Output**: `specs/{BRANCH_NAME}/tasks.md`

**Handoffs**:
- `/speckit.analyze` -- Run consistency analysis
- `/speckit.implement` -- Start implementation

---

### /speckit.checklist

**Purpose**: Generate domain-specific quality checklists that act as "unit tests for requirements."

**File**: `main-workflow/workflows/spec-kit/commands/speckit.checklist.md`

**Input**: The domain to generate a checklist for (e.g., "UX", "security", "accessibility")

**Concept**: Checklists validate the **quality, clarity, and completeness** of requirements in a given domain. They are NOT verification/testing checklists for implementation.

**Process**:
1. Analyse the feature specification and plan
2. Generate checklist items specific to the requested domain
3. Each item validates whether requirements adequately address a concern
4. Write the checklist to the checklists directory

**Output**: `specs/{BRANCH_NAME}/checklists/{domain}.md`

---

### /speckit.implement

**Purpose**: Execute the task list with progress tracking and approval gates.

**File**: `main-workflow/workflows/spec-kit/commands/speckit.implement.md`

**Input**: Optional arguments

**Process**:
1. Run `check-prerequisites.sh` with `--require-tasks --include-tasks`
2. Check checklist status (if checklists exist):
   - Generate a status table showing pass/fail per checklist
   - Warn if any checklists have incomplete items
3. Process tasks in dependency order:
   - Execute each task according to its specification
   - Track progress with checkbox updates
   - Present approval gates at critical points
4. Generate code in the workspace root (never in `specs/`)

**Output**: Application code in the workspace root, updated `tasks.md` with progress

---

### /speckit.analyze

**Purpose**: Perform cross-artifact consistency and quality analysis.

**File**: `main-workflow/workflows/spec-kit/commands/speckit.analyze.md`

**Input**: Optional arguments

**Process**:
1. Load `spec.md`, `plan.md`, and `tasks.md`
2. Analyse for:
   - Requirements-to-plan traceability gaps
   - Plan-to-tasks coverage gaps
   - Contradictions between artifacts
   - Missing acceptance criteria
   - Dependency ordering issues
3. Report findings without modifying files

**Output**: Analysis report presented to the user (non-destructive)

---

### /speckit.taskstoissues

**Purpose**: Convert tasks into GitHub issues.

**File**: `main-workflow/workflows/spec-kit/commands/speckit.taskstoissues.md`

**Input**: Optional arguments

**Process**:
1. Read `tasks.md`
2. Convert each task to a GitHub issue with:
   - Labels
   - Dependencies
   - Acceptance criteria
   - Priority metadata
3. Create issues via the GitHub MCP server

**Output**: GitHub issues created in the repository

---

### /speckit.constitution

**Purpose**: Create or update the project constitution from interactive or provided principle inputs.

**File**: `main-workflow/workflows/spec-kit/commands/speckit.constitution.md`

**Input**: Optional principle inputs

**Process**:
1. Load existing constitution or start from template
2. Gather principles interactively or from provided inputs
3. Update the constitution document
4. Ensure all dependent templates stay in sync with the updated constitution

**Output**: Updated constitution file

**Handoff**: `/speckit.specify`

---

## AWS AI-DLC Stages

AWS AI-DLC stages are not invoked as slash commands. They are executed automatically by the workflow engine based on the execution plan created during Workflow Planning.

### Inception Phase

#### Requirements Analysis (Always -- Adaptive Depth)

**Purpose**: Analyse intent and gather requirements.

**Depth levels**:
| Level | When Used | Scope |
|-------|-----------|-------|
| **Minimal** | Simple, clear request | Document intent analysis only |
| **Standard** | Normal complexity | Functional and non-functional requirements |
| **Comprehensive** | Complex, high-risk | Detailed requirements with traceability |

**Approval**: Required before proceeding.

---

#### Onboarding Presentations (Conditional)

**Purpose**: Generate sli-dev onboarding presentations for engineers and product managers.

**Execute when**: Brownfield project with RE artifacts, or existing presentations are stale.

**Outputs**:
- `specs/{BRANCH_NAME}/inception/onboarding/engineers/onboarding-engineers.md`
- `specs/{BRANCH_NAME}/inception/onboarding/product/onboarding-product.md`

**Approval**: Required before proceeding.

---

#### User Stories (Conditional)

**Purpose**: Generate user stories with personas and acceptance criteria.

**Two-part process**:
1. **Planning**: Create story plan with questions, collect answers, analyse for ambiguities
2. **Generation**: Execute approved plan to generate stories and personas

**Execute when**: User-facing changes, multiple personas, complex business requirements.

**Skip when**: Pure refactoring, simple bug fixes, infrastructure-only changes, documentation updates.

**Approval**: Required after each part.

---

#### Workflow Planning (Always)

**Purpose**: Determine which Construction stages to execute and at what depth.

**Process**:
1. Analyse all prior context (RE artifacts, requirements, user stories)
2. Determine which stages are needed
3. Set depth level for each stage
4. Create multi-package change sequence (brownfield)
5. Generate workflow visualisation (Mermaid)
6. Present recommendations with user override option

**Approval**: Required -- user can modify the execution plan.

---

#### Application Design (Conditional)

**Purpose**: Define component methods, business rules, and service layer design.

**Execute when**: New components/services needed, business rules require definition.

**Skip when**: Changes within existing component boundaries, no new components.

**Approval**: Required before proceeding.

---

#### Units Generation (Conditional)

**Purpose**: Decompose the system into units of work with dependency ordering.

**Execute when**: Multiple units needed, complex system requiring structured breakdown.

**Skip when**: Single simple unit, no decomposition needed.

**Approval**: Required before proceeding.

---

### Construction Phase

#### Per-Unit Loop

For each unit of work, the following stages execute in sequence. A unit is completed fully before the next unit starts.

##### Functional Design (Conditional)

**Purpose**: Detailed design of data models, business logic, and rules.

**Execute when**: New data models, complex business logic, business rules need definition.

**Completion**: Standardised 2-option message (Request Changes / Continue).

##### NFR Requirements (Conditional)

**Purpose**: Non-functional requirements assessment and technology selection.

**Execute when**: Performance, security, scalability concerns exist.

**Completion**: Standardised 2-option message.

##### NFR Design (Conditional)

**Purpose**: Design NFR patterns and incorporate them into the solution.

**Execute when**: NFR Requirements was executed.

**Completion**: Standardised 2-option message.

##### Infrastructure Design (Conditional)

**Purpose**: Map infrastructure services and deployment architecture.

**Execute when**: Cloud resources, deployment architecture, or infrastructure changes needed.

**Completion**: Standardised 2-option message.

##### Code Generation (Always)

**Purpose**: Generate code, tests, and implementation artifacts.

**Two-part process**:
1. **Planning**: Create detailed code generation plan with explicit steps
2. **Generation**: Execute approved plan to generate code

**Completion**: Standardised 2-option message.

##### Onboarding Update (Conditional)

**Purpose**: Update feature registry and onboarding presentations.

**Execute when**: Feature, API, operational, or conceptual changes.

**Skip when**: Pure refactor with no behaviour change (must be explicitly justified).

**Completion**: Standardised 2-option message.

---

#### Build and Test (Always)

**Purpose**: Generate comprehensive build and test instructions.

**Outputs** (in `build-and-test/` subdirectory):
- `build-instructions.md`
- `unit-test-instructions.md`
- `integration-test-instructions.md`
- `performance-test-instructions.md`
- `build-and-test-summary.md`

**Approval**: Required before proceeding to Operations.

---

#### Test Coverage Delta (Conditional)

**Purpose**: Compare current coverage against Phase 1 baseline.

**Execute when**: Baseline exists at `specs/_project/reverse-engineering/test-coverage-analysis.md`.

**Output**: `specs/{BRANCH_NAME}/construction/coverage-improvement-plan.md`

---

#### Reverse Engineering Update (Always -- Final Step)

**Purpose**: Incrementally update all RE artifacts to reflect implementation changes.

**Updates all artifacts** in `specs/_project/reverse-engineering/`:
- Business overview, architecture, C4 model, code structure, API docs
- Component inventory, technology stack, dependencies
- Code quality assessment, test coverage analysis
- Timestamp file with change summary

---

### Operations Phase

**Status**: Placeholder for future expansion.

**Planned**: Deployment planning, monitoring setup, incident response, maintenance workflows, production readiness checklists.

---

## Shared Stages

These stages are used by both workflows via the shared entry point.

| Stage | File | Description |
|-------|------|-------------|
| Workspace Detection | `shared/stages/workspace-detection.md` | Scan workspace, determine greenfield/brownfield |
| Reverse Engineering | `shared/stages/reverse-engineering.md` | Full codebase analysis (run-once) |
| Reverse Engineering Update | `shared/stages/reverse-engineering-update.md` | Incremental RE artifact update |
| Test Coverage Analysis | `shared/stages/test-coverage-analysis.md` | Baseline and delta coverage analysis |

---

## Automation Scripts

Located in `main-workflow/workflows/spec-kit/scripts/bash/`:

### create-new-feature.sh

**Purpose**: Create numbered feature branches and initialise feature directories.

**Usage**:
```bash
./create-new-feature.sh --json --short-name "add-user-auth" "Add user authentication with JWT"
```

**Flags**:
| Flag | Description |
|------|-------------|
| `--json` | Output structured JSON for programmatic parsing |
| `--short-name "<name>"` | Specify the branch short name |

**Output** (JSON mode):
```json
{
  "BRANCH_NAME": "001-add-user-auth",
  "SPEC_FILE": "specs/001-add-user-auth/spec.md",
  "FEATURE_NUM": "001"
}
```

### check-prerequisites.sh

**Purpose**: Validate that feature context exists before commands execute.

**Usage**:
```bash
./check-prerequisites.sh --json --paths-only
./check-prerequisites.sh --json --require-tasks --include-tasks
```

**Flags**:
| Flag | Description |
|------|-------------|
| `--json` | Output structured JSON |
| `--paths-only` | Only return FEATURE_DIR and BRANCH_NAME |
| `--require-tasks` | Fail if tasks.md does not exist |
| `--include-tasks` | Include task content in output |

### setup-plan.sh

**Purpose**: Prepare the plan template and context for the planning command.

**Usage**:
```bash
./setup-plan.sh --json
```

### common.sh

**Purpose**: Shared utilities sourced by other scripts.
