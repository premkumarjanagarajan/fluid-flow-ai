---
step: seed
subagent: false
---

## Context Loading

| Load | Do NOT Load |
|------|------------|
| Approved `artefacts/4.1-delivery-sequence.md` | Per-repo RE artifacts |
| Approved `artefacts/3.1-cross-domain-contracts.md` | `reverse-engineering/combined-architecture.md` |
| Approved `artefacts/2.1-workspace-decomposition.md` | `reverse-engineering/combined-c4.md` |
| Approved `artefacts/1.1-domain-impact.md` | `reverse-engineering/incident-learnings.md` |

The seed step works entirely from the initiative's own approved artifacts. No workspace-level or per-repo RE is needed — all relevant information has already been distilled into the initiative artifacts by prior steps.

## Inputs

- Approved `artefacts/4.1-delivery-sequence.md`
- Approved `artefacts/3.1-cross-domain-contracts.md`
- Approved `artefacts/2.1-workspace-decomposition.md`
- Approved `artefacts/1.1-domain-impact.md`

## Guidance

Generate per-workspace spec stubs that can be distributed to each workspace's team. Each stub is designed to be the starting input for that workspace's own lifecycle.

### 1. Generate Spec Stubs

For each in-scope workspace, create a markdown spec stub containing:

**a. Feature Description** — scoped to this workspace only
- What this workspace builds, from the decomposition
- Business context from the domain impact analysis

**b. Contract Responsibilities**
- Which contracts this workspace publishes (with draft schemas from contracts step)
- Which contracts this workspace consumes (with expected schemas)
- Schema locations and versioning notes

**c. Dependencies on Other Workspaces**
- Which workspaces must deliver before this one can start (from sequence)
- Which workspaces are waiting on this one
- Integration testing requirements

**d. Delivery Phase**
- Which phase this workspace is in (from sequence)
- Can development start immediately, or is it blocked on a prior phase?

**e. Suggested Workflow Path**
- Based on the scope complexity, suggest which workflow in the target workspace would be appropriate
- If the workspace has an `ff-workspace.yaml`: read available workflows
- If no workspace exists: suggest standard Fluid Flow lifecycle

### 2. Write Stubs

Write each stub to `artefacts/5.1-workspace-stubs/{workspace-name}.md`.

### 3. Generate Distribution Summary

Create a summary showing which stubs go to which teams and what action each team needs to take.

### 4. Present Stubs

Present all stubs for human review before distribution.

## Outputs

- `artefacts/5.1-workspace-stubs/{workspace-name}.md` (one per workspace)
- `artefacts/5.1-distribution-summary.md`

### Stub Template

```markdown
# Initiative Spec Stub: {INITIATIVE_NAME}

**Target Workspace**: {workspace-name}
**Domain**: {domain}
**Team**: {team-name}
**Generated**: {ISO_TIMESTAMP}
**Delivery Phase**: {phase-number} — {phase-name}

## Feature Description

{Scoped description of what this workspace builds for the initiative.}

## Contract Responsibilities

### Publishes
{List of contracts this workspace publishes, with draft schemas.}

### Consumes
{List of contracts this workspace consumes, with expected schemas.}

## Dependencies

### Blocked By
{List of workspaces that must deliver before this workspace can start.}

### Blocks
{List of workspaces waiting on this workspace.}

## Integration Testing

{What integration tests are needed with other workspaces. Which environments, which contracts to verify.}

## Suggested Workflow

{Recommended workflow for this workspace's lifecycle: e.g. "fe-migration-angular-stencil" for front-end repos, or "standard lifecycle" for general work.}

## Next Steps

1. Copy this stub to `{workspace}/initiatives/{type}/{initiative-name}/`
2. Start the Fluid Flow lifecycle in the target workspace
3. Use this stub as the initial input for the first workflow step
```

### Distribution Summary Template

```markdown
# Distribution Summary

**Initiative**: {INITIATIVE_NAME}
**Date**: {ISO_TIMESTAMP}
**Total Workspaces**: {N}

## Distribution Plan

| Workspace | Team | Phase | Stub Location | Status |
|-----------|------|-------|---------------|--------|
| {workspace} | {team} | {phase} | artefacts/5.1-workspace-stubs/{workspace}.md | Ready |

## Action Required Per Team

### {Team Name} — {Workspace Name}
- Receive stub: `{workspace}.md`
- Copy to workspace initiatives folder
- Start lifecycle when Phase {N} dependencies are met
```

## Gate

STOP. Present via `primitives/human-gate.md`. This is the final step of the initiative workflow. After approval, stubs are ready for distribution to workspace teams.
