# Fluid Flow v1.0 — Workflow Rename & Fast-Track Conversion

## Spec Metadata

- **Depends on**: Fluid Flow v1.0 Workspace spec (already implemented)
- **Status**: Implemented
- **Date**: 2026-03-15

---

## 1. What This Spec Covers

Two changes applied on top of the v1.0 workspace implementation:

1. **Rename**: `workflow/initiative/` → `workflow/multi-workspace/` to eliminate naming confusion with the `initiatives/` artifact folder
2. **Fast-Track Workflow**: Full conversion of the pre-v0.9 fast-track command-based workflow into the v0.9 phase/step structure

---

## 2. Initiative → Multi-Workspace Rename

### 2.1 Problem

v1.0 introduced a workflow called `initiative` at `workflow/initiative/wf-initiative.md`. However, Fluid Flow already uses the term "initiative" for the `initiatives/` folder structure that stores per-request artifacts (state.md, audit.md, analytics.md). The overlap causes confusion — "initiative workflow" could mean the workflow definition or an initiative's lifecycle.

### 2.2 Change

| Before | After |
|--------|-------|
| `workflow/initiative/` | `workflow/multi-workspace/` |
| `wf-initiative.md` | `wf-multi-workspace.md` |
| `workflow-name: initiative` | `workflow-name: multi-workspace` |

All file references in README.md and step files updated. Spec files (fluid-flow-v1-spec.md, fluid-flow-v1-adr.md, fluid-flow-v1-summary_1.md) left unchanged as historical reference documents.

### 2.3 Impact

- The orchestrator discovers workflows via `workflow/*/wf-*.md` — the rename is automatic
- No changes to the orchestrator, primitives, or knowledge base
- The workflow's 5 phases (scope, decompose, contracts, sequence, seed) are unchanged

---

## 3. Fast-Track Workflow Conversion

### 3.1 Source

The fast-track workflow existed on the `feat/sample-addons` branch in the old pre-v0.9 format:

```
main-workflow/workflows/fast-track/
  commands/
    fasttrack.specify.md
    fasttrack.clarify.md
    fasttrack.plan.md
    fasttrack.tasks.md
    fasttrack.checklist.md
    fasttrack.analyze.md
    fasttrack.implement.md
    fasttrack.constitution.md
    fasttrack.taskstoissues.md
  memory/
    constitution.md
  templates/
    spec-template.md
    plan-template.md
    tasks-template.md
    checklist-template.md
    agent-file-template.md
  scripts/
    bash/     (5 scripts)
    powershell/ (5 scripts)
```

This format used Cursor-specific frontmatter (`description`, `handoffs`), `$ARGUMENTS` placeholders, shared memory loading (`../../shared/memory/load-shared-memory.md`), and direct analytics file updates. None of these patterns exist in v0.9.

### 3.2 Conversion Strategy

Each old command was mapped to a v0.9 step file following these principles:

| Old Pattern | v0.9 Equivalent |
|------------|----------------|
| Cursor frontmatter (`description`, `handoffs`) | v0.9 step frontmatter (`step`, `subagent`) |
| `$ARGUMENTS` | `## Inputs` section |
| Shared memory loading | Removed — v0.9 uses tiered KB loading via manifest.md |
| Direct analytics updates | Removed — v0.9 analytics primitive runs automatically after each step |
| Direct state.md updates | Removed — v0.9 state-manager primitive runs automatically after each step |
| Direct audit.md appends | Removed — v0.9 state-manager primitive handles audit logging |
| Shell detection per command | Removed — v0.9 Stage 0 handles shell detection once |
| Feature branch creation | Removed — v0.9 Stage 4 handles initiative/branch creation |
| Script-based prerequisite checks | Scripts preserved in `workflow/fast-track/scripts/` for optional use |
| "Continue to next stage" handoffs | Removed — v0.9 orchestrator handles step sequencing via phase chain |
| `specs/{BRANCH_NAME}/` output paths | `initiatives/{INITIATIVE_NAME}/artefacts/` with `{phase}.{step}-` prefix |

### 3.3 Resulting Structure

```
workflow/fast-track/
  wf-fast-track.md                      -- workflow definition
  knowledge-core/
    constitution.md                     -- project principles template
  templates/
    spec-template.md                    -- feature specification structure
    plan-template.md                    -- implementation plan structure
    tasks-template.md                   -- task breakdown structure
    checklist-template.md               -- requirements quality checklist structure
    agent-file-template.md              -- agent context file structure
  scripts/
    bash/                               -- check-prerequisites, common, create-new-feature, setup-plan, update-agent-context
    powershell/                         -- same scripts, PowerShell variants
  1-inception/
    1-inception.md                      -- phase: 4 steps
    1-specify/
      1-specify.md                      -- create feature spec from natural language
    2-clarify/
      2-clarify.md                      -- resolve spec ambiguities (conditional)
    3-plan/
      3-plan.md                         -- technical plan, research, data model, contracts
    4-tasks/
      4-tasks.md                        -- decompose plan into executable tasks
  2-quality/
    2-quality.md                        -- phase: 2 steps
    1-checklist/
      1-checklist.md                    -- generate requirements quality checklists
    2-analyze/
      2-analyze.md                      -- cross-artifact consistency analysis (read-only)
  3-construction/
    3-construction.md                   -- phase: 1 step
    1-implement/
      1-implement.md                    -- execute all tasks, TDD approach
```

### 3.4 Workflow Definition

```yaml
workflow-name: fast-track
workflow-description: Streamlined feature development — specification, planning, task decomposition, quality checks, and implementation
domain: general
version: v1.0
```

### 3.5 Phase Summary

| Phase | Name | Steps | Goal |
|-------|------|-------|------|
| 1 | Inception | 4 | Verified specification, technical plan, research, and task breakdown |
| 2 | Quality | 2 | Requirements quality checklists and cross-artifact consistency analysis |
| 3 | Construction | 1 | All tasks implemented, tested, and validated |

### 3.6 Step Details

#### 1-specify: Feature Specification
- **Input**: natural language feature description
- **Process**: parse description → extract concepts → generate spec from template → validate quality → resolve up to 3 clarifications
- **Output**: `artefacts/1.1-spec.md`, `artefacts/1.1-spec-quality-checklist.md`
- **Key principle**: focus on WHAT and WHY, not HOW. No implementation details.

#### 2-clarify: Resolve Ambiguities (Conditional)
- **Input**: spec from specify step
- **Process**: scan 10 categories for ambiguity → generate max 5 questions → ask one at a time → integrate answers into spec after each
- **Output**: updated `artefacts/1.1-spec.md`
- **Skip if**: no critical ambiguities detected

#### 3-plan: Technical Plan
- **Input**: approved spec, constitution, brownfield RE artifacts
- **Process**: fill technical context → constitution check → Phase 0 research (resolve unknowns) → Phase 1 design (data model, contracts, quickstart) → re-evaluate constitution
- **Output**: `artefacts/1.3-plan.md`, `artefacts/1.3-research.md`, `artefacts/1.3-data-model.md`, `artefacts/1.3-contracts/`, `artefacts/1.3-quickstart.md`

#### 4-tasks: Task Decomposition
- **Input**: approved plan, spec, data model, contracts
- **Process**: extract user stories with priorities → generate tasks organized by story → dependency graph → validate completeness
- **Output**: `artefacts/1.4-tasks.md`
- **Task format**: `- [ ] T001 [P?] [US1?] Description with file path`
- **Phase structure**: Setup → Foundational → User Stories (priority order) → Polish

#### 1-checklist: Requirements Quality Checklists
- **Input**: spec, plan, tasks
- **Process**: clarify focus areas → load context → generate checklist items that test REQUIREMENTS quality, not implementation
- **Output**: `artefacts/2.1-checklist-{domain}.md` (one per domain, multiple runs supported)
- **Key principle**: "unit tests for requirements" — items ask "Are requirements X specified?" not "Does the system do X?"

#### 2-analyze: Cross-Artifact Analysis (Read-Only)
- **Input**: spec, plan, tasks, constitution
- **Process**: build semantic models → run 6 detection passes (duplication, ambiguity, underspecification, constitution alignment, coverage gaps, inconsistency) → severity assignment → produce analysis report
- **Output**: analysis report presented in conversation (no file writes)
- **Max 50 findings**, aggregated overflow

#### 1-implement: Implementation
- **Input**: approved tasks, plan, data model, contracts, research, quickstart
- **Process**: check checklists → load context → verify project setup (ignore files) → parse and execute tasks phase by phase → TDD approach → progress tracking → completion validation
- **Output**: implementation code, updated tasks.md with completion markers
- **Execution order per phase**: Setup → Tests → Core → Integration → Polish

### 3.7 What Was NOT Converted

- `fasttrack.taskstoissues.md` — converts tasks to GitHub/Jira issues. Not a workflow step; could be a future skill.
- `fasttrack.constitution.md` — interactive constitution builder. The template is preserved at `knowledge-core/constitution.md`; the interactive builder could be a future skill.

### 3.8 Scripts Preserved

The original bash and PowerShell scripts were copied as-is to `workflow/fast-track/scripts/`. They are not required by the v0.9 orchestrator (which handles shell detection, branch creation, etc. at the stage level) but are available for optional use by steps that reference them.

---

## 4. Available Workflows After This Change

| Workflow | Domain | Description |
|----------|--------|-------------|
| `fast-track` | general | Streamlined feature development — specify, plan, tasks, quality, implement |
| `fe-migration-angular-stencil` | front-end | Angular to StencilJS migration with structured analysis and implementation |
| `multi-workspace` | orchestration | Cross-workspace planning — domain impact, contracts, delivery sequence, spec stubs |

---

## 5. What Did NOT Change

- Orchestrator lifecycle (Stages 0-6)
- All primitives (human-gate, state-manager, analytics, kb-compliance)
- Knowledge-base-core (manifest.md, tiered loading, compliance subagent)
- The fe-migration-angular-stencil workflow
- Skills (shell-detection, reverse-engineering, branch-creation, workspace-setup, conflict-detection)
- Initiative folder structure
- Entry points (.cursor/rules/instructions.mdc, .github/copilot-instructions.md)
- Context loading strategy (manifest.md § Workspace Artifacts)
