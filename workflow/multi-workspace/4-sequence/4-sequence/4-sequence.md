---
step: sequence
subagent: false
---

## Context Loading

| Load | Do NOT Load |
|------|------------|
| Approved `artefacts/3.1-cross-domain-contracts.md` | Per-repo RE artifacts |
| Approved `artefacts/2.1-workspace-decomposition.md` | `reverse-engineering/combined-architecture.md` |
| | `reverse-engineering/combined-c4.md` |
| | `reverse-engineering/incident-learnings.md` |

The sequence step works entirely from the already-approved decomposition and contract artifacts. No workspace-level or per-repo RE is needed.

## Inputs

- Approved `artefacts/3.1-cross-domain-contracts.md`
- Approved `artefacts/2.1-workspace-decomposition.md`

## Guidance

Determine the delivery order across workspaces based on the publish/consume chain. Identify parallelisable work and propose a phased delivery plan.

### 1. Build Dependency Graph

From the approved contracts:
- Map each contract's publisher and consumer(s)
- Build a directed dependency graph: consumers depend on publishers
- Shared schemas/contracts are the root — they must ship first

### 2. Determine Delivery Phases

Apply topological sort to the dependency graph:
- **Phase 1**: shared contracts and schemas (no dependencies)
- **Phase 2**: publishers (depend on shared contracts)
- **Phase 3**: consumers (depend on publishers)
- Within each phase: identify parallelisable work (workspaces with no inter-dependency)

### 3. Identify Critical Path

The longest chain through the dependency graph is the critical path. Highlight it — delays on the critical path delay the entire initiative.

### 4. Risk Assessment

For each phase:
- What blocks if this phase is delayed?
- What can proceed independently?
- Are there fallback strategies (e.g. mock contracts for parallel development)?

### 5. Present Delivery Sequence

Present the phased delivery plan for human review. The human adjusts for team capacity, sprint boundaries, and priorities.

## Outputs

- `artefacts/4.1-delivery-sequence.md`

### Output Template

```markdown
# Delivery Sequence

**Initiative**: {INITIATIVE_NAME}
**Date**: {ISO_TIMESTAMP}

## Dependency Graph

```mermaid
flowchart TD
    {dependency-graph-showing-workspace-order}
```

## Delivery Phases

### Phase 1: {name} (e.g. "Shared Contracts")
- **Workspaces**: {workspace1}, {workspace2}
- **Deliverables**: {what ships in this phase}
- **Dependencies**: None (root phase)
- **Parallelisable**: {Yes — workspaces are independent / No}

### Phase 2: {name} (e.g. "Publishers")
- **Workspaces**: {workspace1}
- **Deliverables**: {what ships in this phase}
- **Dependencies**: Phase 1 complete
- **Parallelisable**: {Yes/No}

### Phase 3: {name} (e.g. "Consumers")
- **Workspaces**: {workspace1}, {workspace2}
- **Deliverables**: {what ships in this phase}
- **Dependencies**: Phase 2 complete
- **Parallelisable**: {Yes/No}

{Add more phases as needed.}

## Critical Path

{Description of the critical path through the dependency graph. Which workspaces are on the critical path and why.}

## Risk Assessment

| Risk | Impact | Mitigation |
|------|--------|------------|
| {risk-description} | {which phases/workspaces affected} | {mitigation strategy} |

## Decision Required

[ ] Approve delivery sequence
[ ] Adjust for team capacity or sprint boundaries
[ ] Confirm critical path assessment
```

## Gate

STOP. Present via `primitives/human-gate.md`. The sequence determines how spec stubs are generated in the next step.
