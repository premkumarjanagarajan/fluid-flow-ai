---
workflow-name: comprehensive-path
workflow-description: Full enterprise SDLC with structured requirements analysis, application design, per-unit construction, and operations planning
domain: general
version: v0.2
release: 16/03/2026
last-update: 16/03/2026
---

## When to Use

| Criteria | Comprehensive-Path | Consider Fast-Track Instead |
|----------|--------------------|-----------------------------|
| Scope | Multi-feature, cross-cutting, platform-level | Single feature, bug fix, small enhancement |
| Complexity | High; novel domain, many unknowns, regulatory | Low-to-medium; well-understood patterns |
| Team | Multi-team coordination, onboarding needed | Solo developer or small team |
| Unknowns | Many; requires research, spikes, ADRs | Few; existing patterns cover it |
| Operations | Needs failure-mode analysis, runbooks, on-call impact | No special ops planning needed |
| NFRs | Performance, scalability, reliability are first-class concerns | NFRs are minimal or inherited from platform |

## Adaptive Workflow Principle

The workflow adapts to the work, not the other way around. The AI intelligently assesses what steps are needed based on:
1. User's stated intent and clarity
2. Existing codebase state (greenfield vs brownfield)
3. Complexity and scope of change
4. Risk and impact assessment

Many inception and construction steps are **CONDITIONAL** -- they execute only when the context warrants them. The Workflow Planning step (1-6) produces an `execution-plan.md` that explicitly declares which downstream steps to run or skip.

## Session Variables (provided by orchestrator)

| Variable | Source | Used by |
|----------|--------|---------|
| `SHELL_TYPE` | Stage 0 (shell detection) | Steps using scripts |
| `LOCAL_REPO_PATH` | Stage 3 (local repo detection) | All steps (artifact paths) |
| `INITIATIVE_NAME` | Stage 5 (initiative creation) | All steps (artifact paths) |

Artifact root: `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/`

## Phases

| Phase | Name | Steps | Goal |
|-------|------|-------|------|
| 1 | Inception | 8 | Complete requirements, user stories, designs, and execution plan |
| 2 | Construction | 7 | Per-unit functional design, NFR analysis, code generation, build, and test |
| 3 | Operations | 3 | Failure mode analysis, on-call impact assessment, and operational readiness |

## Step Breakdown

### Phase 1: Inception

| # | Step | Conditional | Skip Condition | Key Outputs | Gate |
|---|------|-------------|----------------|-------------|------|
| 1 | **Technical Scoping** | Yes -- user opt-in | User declines the opt-in prompt | `technical-scoping-report.md` | User approves report |
| 2 | **Onboarding Presentations** | Yes | No brownfield context or no stakeholder audience identified | `onboarding-engineers.md`, `onboarding-product.md`, `features-registry.md` | User approves |
| 3 | **Requirements Analysis** | No -- always runs | N/A | `requirements.md`, `requirement-verification-questions.md` | User approves requirements |
| 4 | **User Stories** | Yes | Pure refactoring, isolated bug fixes, infra-only, developer tooling, documentation | `stories.md`, `personas.md`, `user-stories-assessment.md` | User approves stories |
| 5 | **BDD Specification** | Yes | Workflow Planning indicates skip; simple CRUD, pure infra, refactoring | `.feature` files, `bdd-strategy.md`, `step-catalogue.md` | User approves feature files |
| 6 | **Workflow Planning** | No -- always runs | N/A | `execution-plan.md` (controls all downstream conditional steps) | User approves execution plan |
| 7 | **Application Design** | Yes | Execution plan indicates skip | `components.md`, `services.md`, `component-methods.md`, `component-dependency.md` | User approves design |
| 8 | **Units Generation** | Yes | Execution plan indicates skip | `unit-of-work.md`, `unit-of-work-dependency.md`, `unit-of-work-story-map.md` | User approves units |

### Phase 2: Construction

| # | Step | Conditional | Per-Unit Loop? | Key Outputs | Gate |
|---|------|-------------|----------------|-------------|------|
| 1 | **Functional Design** | Yes -- execution plan | Yes | `business-logic-model.md`, `business-rules.md`, `domain-entities.md`, `bdd-step-mapping.md` | User approves per unit |
| 2 | **NFR Requirements** | Yes -- execution plan | Yes | `nfr-requirements.md`, `tech-stack-decisions.md` | User approves |
| 3 | **NFR Design** | Yes -- execution plan | Yes | `nfr-design-patterns.md`, `logical-components.md` | User approves |
| 4 | **Infrastructure Design** | Yes -- execution plan | Yes | `infrastructure-design.md`, `deployment-architecture.md` | User approves |
| 5 | **Code Generation** | No -- always runs | Yes | Application code, documentation | User approves |
| 6 | **Build and Test** | No -- always runs | No (once after all units) | `build-and-test-summary.md`, `coverage-improvement-plan.md` | User confirms build passes |
| 7 | **Onboarding Update** | Yes | No (once after all units) | Updated `features-registry.md`, `onboarding-engineers.md`, `onboarding-product.md` | User approves |

**Per-Unit Loop**: Steps 1-5 execute as a loop for each unit defined during Inception (step 8). Build and Test (step 6) and Onboarding Update (step 7) execute once after all units are complete.

### Phase 3: Operations

| # | Step | Conditional | Key Outputs | Gate |
|---|------|-------------|-------------|------|
| 1 | **Failure Modes & Resilience** | No | `failure-modes-analysis.md` | User acknowledges |
| 2 | **On-call & Operational Impact** | No | `oncall-impact-assessment.md` | User acknowledges |
| 3 | **Operations Planning** | No | `operations-readiness-summary.md` | User approves |

> **Note**: Phase 3 is partially implemented. Future versions will expand with deployment planning, monitoring setup, and maintenance workflows.

## Artifact Flow

```mermaid
flowchart TD
    A([User Request])

    subgraph INC["Phase 1: Inception"]
        B["1. Technical Scoping (optional)"]
        C["2. Onboarding (optional)"]
        D["3. Requirements Analysis"]
        E["4. User Stories (conditional)"]
        F["5. BDD Specification (conditional)"]
        G["6. Workflow Planning"]
        H["7. Application Design (conditional)"]
        I["8. Units Generation (conditional)"]

        B --> C
        C --> D
        D -- requirements.md --> E
        E -- "stories.md, personas.md" --> F
        F -- ".feature files" --> G
        G -- execution-plan.md --> H
        G -- execution-plan.md --> I
        H -- "components.md, services.md" --> I
    end

    subgraph CON["Phase 2: Construction"]
        subgraph LOOP["Per-Unit Loop"]
            L1["1. Functional Design (conditional)"]
            L2["2. NFR Requirements (conditional)"]
            L3["3. NFR Design (conditional)"]
            L4["4. Infrastructure Design (conditional)"]
            L5["5. Code Generation"]

            L1 --> L2 --> L3 --> L4 --> L5
        end
        N1["6. Build & Test (once, all units)"]
        N2["7. Onboarding Update (conditional)"]

        LOOP --> N1 --> N2
    end

    subgraph OPS["Phase 3: Operations"]
        O1["1. Failure Modes & Resilience"]
        O2["2. On-call & Operational Impact"]
        O3["3. Operations Planning"]

        O1 --> O2 --> O3
    end

    A --> B
    I -- unit-of-work.md ==> LOOP
    N2 ==> O1
    O3 ==> Z["Orchestrator Stage 7\nCommit · PR · Risk Report"]
```

## Execution Plan as Control Plane

The **Workflow Planning** step (1-6) is the control plane for this workflow. Its output (`execution-plan.md`) determines:

- Which optional inception steps (4, 5, 7, 8) should run
- Which construction steps (1, 2, 3, 4) should run per unit
- The depth level for each step (shallow/standard/deep)
- Rationale for each include/skip decision

All conditional steps check the execution plan before running. If the execution plan says skip, the step logs the skip and moves on.

## Exit Criteria

When the comprehensive-path workflow completes (Phase 3 gate passed), the orchestrator expects:

1. **Artifacts produced** (at minimum):
   - `requirements.md` -- approved requirements
   - `execution-plan.md` -- approved execution plan
   - Application code -- all units implemented
   - `build-and-test-summary.md` -- build passes, tests pass
   - `failure-modes-analysis.md` -- failure modes assessed
   - `oncall-impact-assessment.md` -- operational impact assessed

2. **Code delivered**: All units implemented and tested per the execution plan

3. **Ready for**: Orchestrator Stage 7 (commit, PR, risk report)

## Workflow-Specific Resources

| Resource | Path (relative to workflow root) | Purpose |
|----------|----------------------------------|---------|
| Knowledge core | `knowledge-core/` | ADRs, depth levels, error handling, session continuity, terminology |
| ADR guidance | `knowledge-core/adrs-technical-principles.md` | Architecture Decision Record principles |
| Depth levels | `knowledge-core/depth-levels.md` | Shallow/standard/deep analysis calibration |

## Phase Chain

1. Load `1-inception/1-inception.md` -- execute steps 1-8 (respecting conditional logic and execution plan)
2. Load `2-construction/2-construction.md` -- execute steps 1-7 (per-unit loop for steps 1-5)
3. Load `3-operations/3-operations.md` -- execute steps 1-3
