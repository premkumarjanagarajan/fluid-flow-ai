---
workflow-name: multi-workspace
workflow-description: Cross-workspace planning — domain impact analysis, contract design, and workspace spec generation
domain: orchestration
version: v1.0
release: 2026-03-15
last-update: 2026-03-15
---

## Phases

| Phase | Name | Steps | Goal |
|-------|------|-------|------|
| 1 | Scope | 1 | Domains identified, key repos mapped, integration points found |
| 2 | Decompose | 1 | Per-workspace scope definitions |
| 3 | Contracts | 1 | Cross-workspace contract designs |
| 4 | Sequence | 1 | Workspace dependency order and phase plan |
| 5 | Seed | 1 | Per-workspace spec stubs ready for distribution |

## Phase Chain

1. Load `1-scope/1-scope/1-scope.md`
2. Load `2-decompose/2-decompose/2-decompose.md`
3. Load `3-contracts/3-contracts/3-contracts.md`
4. Load `4-sequence/4-sequence/4-sequence.md`
5. Load `5-seed/5-seed/5-seed.md`

## Artifacts Location

Step outputs are saved to `initiatives/{INITIATIVE_NAME}/artefacts/` with `{phase}.{step}-` prefix.

## External Inputs

- `domain-catalog.yaml` — org-level domain registry (must be accessible in workspace or provided)
- `ff-workspace.yaml` files from involved workspaces (read via filesystem or GitHub MCP)

## What This Workflow Does NOT Do

This workflow does not produce code. It produces the inputs each workspace needs to start its own lifecycle:
- Domain impact analysis
- Per-workspace scope definitions
- Cross-workspace contract designs
- Delivery sequence
- Spec stubs for distribution to workspace teams

## What Humans Own

The AI **cannot** negotiate priorities, resolve resource conflicts, or decide deployment timing. These remain entirely human decisions. The AI proposes affected domains and contracts; the human validates and adjusts.
