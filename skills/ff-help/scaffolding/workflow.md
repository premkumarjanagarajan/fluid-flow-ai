# Scaffolding: Workflow

Create a custom workflow in the department repo.

---

## Guided Creation

Ask **one question at a time**:

1. **"Describe the process from start to finish — what are the main stages?"**
   — Guide the user to think in terms of logical phases (e.g. planning, execution, validation).

2. **For each stage**: "What steps happen during this stage? What does each step produce?"

3. **"Are any of these steps optional?"**
   — Some may only apply in certain scenarios.

---

## Scaffold

Once gathered:

1. Create `{DEPT_FF_PATH}/workflows/{workflow-name}/wf-{workflow-name}.md` with YAML frontmatter:

```markdown
---
workflow-name: {workflow-name}
workflow-description: {one-line description}
domain: {domain}
version: v0.1
release: {today's date}
last-update: {today's date}
---

## When to Use

{Description of when this workflow is the right choice.}

## Session Variables (provided by orchestrator)

| Variable | Source | Used by |
|----------|--------|---------|
| `SHELL_TYPE` | Stage 0 (shell detection) | Steps using scripts |
| `DEPT_FF_PATH` | Stage 0 (local repo detection) | All steps (artifact paths) |
| `INITIATIVE_NAME` | Stage 3 (initiative creation) | All steps (artifact paths) |

Artifact root: `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/`

## Phases

| Phase | Name | Steps | Goal |
|-------|------|-------|------|
{one row per phase}

## Phase Chain

{numbered list: Load phase-file → execute steps}
```

2. Create phase directories: `{N}-{phase-name}/`

3. Create step files inside each phase: `{N}-{step-name}/{N}-{step-name}.md`

4. Optionally create `knowledge-core/` for workflow-specific principles

5. Optionally create `templates/` for artifact generation

Explain: "The orchestrator discovers department workflows automatically. Next time you run `/fluid-flow`, this workflow will appear in the selection list."

After scaffolding, return to the caller (Completion).
