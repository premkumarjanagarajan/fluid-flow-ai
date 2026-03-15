---
workflow-name: fast-track
workflow-description: Streamlined feature development — specification, planning, task decomposition, quality checks, and implementation
domain: general
version: v1.0
release: 2026-03-15
last-update: 2026-03-15
---

## Phases

| Phase | Name | Steps | Goal |
|-------|------|-------|------|
| 1 | Inception | 4 | Verified specification, technical plan, research, and task breakdown |
| 2 | Quality | 2 | Requirements quality checklists and cross-artifact consistency analysis |
| 3 | Construction | 1 | All tasks implemented, tested, and validated |

## Phase Chain

1. Load `1-inception/1-inception.md` -- execute all 4 steps
2. Load `2-quality/2-quality.md` -- execute all 2 steps
3. Load `3-construction/3-construction.md` -- execute 1 step

## Artifacts Location

Step outputs are saved to `initiatives/{INITIATIVE_NAME}/artefacts/` with `{phase}.{step}-` prefix.

## Shared Knowledge

Workflow-wide reference material is at `knowledge-core/` within this workflow folder:
- `constitution.md` -- project-specific principles and governance (template, filled per project)

## Templates

Step templates are at `templates/` within this workflow folder:
- `spec-template.md` -- feature specification structure
- `plan-template.md` -- implementation plan structure
- `tasks-template.md` -- task breakdown structure
- `checklist-template.md` -- requirements quality checklist structure
- `agent-file-template.md` -- agent context file structure

## Scripts

Shell scripts at `scripts/` for prerequisite checks, feature branch creation, and agent context updates:
- `bash/` -- bash variants
- `powershell/` -- PowerShell variants
