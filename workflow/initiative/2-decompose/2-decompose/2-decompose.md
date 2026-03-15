---
step: decompose
subagent: false
---

## Context Loading

| Load | Do NOT Load |
|------|------------|
| `ff-workspace.yaml` from each involved workspace (if accessible) | Per-repo RE from all repos |
| `domain-catalog.yaml` (for domains without a workspace) | `reverse-engineering/combined-architecture.md` |
| Approved `artefacts/1.1-domain-impact.md` | `reverse-engineering/combined-c4.md` |
| | `reverse-engineering/incident-learnings.md` |

The decompose step works from workspace composition files and the domain catalog. Per-repo architecture detail is not needed to define per-workspace scope.

## Inputs

- Approved `artefacts/1.1-domain-impact.md`
- `ff-workspace.yaml` from each confirmed domain's workspace (if available)
- `domain-catalog.yaml` for repos without a workspace

## Guidance

Break the initiative into per-workspace scope. Define what each workspace builds, consumes, and publishes.

### 1. Read Workspace Configurations

For each confirmed domain:
- If `ff-workspace.yaml` exists: read it for repo list, team, and type detail
- If no workspace: fall back to domain catalog key repos

### 2. Decompose Per-Workspace

For each confirmed domain/workspace:
- Define what that workspace **builds** (new features, services, endpoints)
- Define what it **consumes** (events, APIs, schemas from other workspaces)
- Define what it **publishes** (events, APIs, schemas for other workspaces)
- Identify the **primary team** responsible

### 3. Identify Shared Contract Responsibilities

For cross-workspace contracts:
- Determine which workspace owns the contract definition
- Determine which workspaces consume the contract
- Flag contracts that need new schemas vs extensions to existing ones

### 4. Present Decomposition

Present the per-workspace decomposition for human review.

## Outputs

- `artefacts/2.1-workspace-decomposition.md`

### Output Template

```markdown
# Workspace Decomposition

**Initiative**: {INITIATIVE_NAME}
**Date**: {ISO_TIMESTAMP}

## Per-Workspace Scope

### {Workspace Name} ({domain})
- **Team**: {team-name}
- **Builds**:
  - {Feature/service/endpoint description}
- **Consumes**:
  - {Event/API/schema from other workspace}
- **Publishes**:
  - {Event/API/schema for other workspaces}
- **Key repos**: {repo1}, {repo2}
- **Estimated complexity**: {Low / Medium / High}

{Repeat for each workspace.}

## Shared Contract Ownership

| Contract | Owner Workspace | Consumers | New / Extension |
|----------|----------------|-----------|-----------------|
| {contract-name} | {workspace} | {workspace, workspace} | {New / Extension} |

## Dependencies Between Workspaces

```mermaid
flowchart LR
    {workspace-dependency-graph}
```

## Decision Required

[ ] Confirm per-workspace scope
[ ] Confirm contract ownership assignments
[ ] Adjust any team assignments
```

## Gate

STOP. Present via `primitives/human-gate.md`. The human must approve the per-workspace decomposition before proceeding to contract design.
