---
workflow-name: multi-workspace
workflow-description: Cross-boundary planning — scope analysis across repos, domains, or workspaces with contract design and spec generation
domain: orchestration
version: v1.0
release: 2026-03-15
last-update: 2026-03-15
---

## Phases

| Phase | Name | Steps | Goal |
|-------|------|-------|------|
| 1 | Scope | 1 | Targets identified (repos, domains, or workspaces), integration points found |
| 2 | Decompose | 1 | Per-target scope definitions |
| 3 | Contracts | 1 | Cross-boundary contract designs |
| 4 | Sequence | 1 | Target dependency order and phase plan |
| 5 | Seed | 1 | Per-target spec stubs ready for distribution |

## Phase Chain

1. Load `1-scope/1-scope/1-scope.md`
2. Load `2-decompose/2-decompose/2-decompose.md`
3. Load `3-contracts/3-contracts/3-contracts.md`
4. Load `4-sequence/4-sequence/4-sequence.md`
5. Load `5-seed/5-seed/5-seed.md`

## Artifacts Location

Step outputs are saved to `initiatives/{INITIATIVE_NAME}/artefacts/` with `{phase}.{step}-` prefix.

Initiative artifacts always live in the workspace/repo where the initiative was created — even when the initiative spans external repos or domains. The seed step generates stubs for distribution to other targets.

## Scope Modes

The scope step lets the user choose how to define what the initiative spans:

| Mode | When to use |
|------|------------|
| **A) Repos in this workspace** | Initiative spans repos already in `ff-workspace.yaml` |
| **B) Domains from catalog** | Initiative spans org-level domains — uses `domain-catalog.yaml` |
| **C) Named repos** | User knows exactly which repos — lists them directly |
| **D) AI-analysed** | User describes the scope and the AI identifies targets |

## External Inputs

- `domain-catalog.yaml` — org-level domain registry (optional, Mode B only)
- `ff-workspace.yaml` — workspace composition (if exists)
- `ff-workspace.yaml` files from other workspaces (read via filesystem or GitHub MCP, for cross-workspace initiatives)

## What This Workflow Does NOT Do

This workflow does not produce code. It produces the inputs each target needs to start its own lifecycle:
- Scope analysis across repos, domains, or workspaces
- Per-target scope definitions
- Cross-boundary contract designs
- Delivery sequence
- Spec stubs for distribution to target teams

## What Humans Own

The AI **cannot** negotiate priorities, resolve resource conflicts, or decide deployment timing. These remain entirely human decisions. The AI proposes affected targets and contracts; the human validates and adjusts.
