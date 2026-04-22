# Cross-References

Verify that all dependency links between building blocks resolve to files that actually exist on disk. The **target** parameter (`core`, `department`, or `both`) controls which repos to check.

---

## What to Check

### Core (`{FF_CORE_PATH}`)

#### 1. Workflow dependencies

Read every `wf-*.md` file in `workflows/`. For each, parse the `dependencies` block from the YAML frontmatter:

- `dependencies.skills[]` → each path must exist on disk
- `dependencies.mcps[]` → each path must exist on disk (check with and without `.md` extension)
- `dependencies.agents[]` → each path must exist on disk
- `dependencies.primitives[]` → each path must exist on disk

#### 2. Orchestrator references

Read `orchestrator.md`. Extract all file paths referenced in the body (skills, primitives, templates). Verify each exists on disk.

#### 3. Slash commands

Read every file in `.github/prompts/` and `.cursor/commands/`. Each should reference a skill, workflow, or other file. Verify the referenced file exists.

#### 4. Skill cross-references

Read every main skill file. If a skill's body references another skill (e.g. "load `skills/kb-retrieval/kb-retrieval.skill.md`"), verify the target exists.

#### 5. Workflow step references

For each workflow, read the phase files (`{N}-{phase}.md`). Each lists step files to load. Verify every referenced step file exists.

### Department (`{DEPT_FF_PATH}`)

#### 6. Department workflow dependencies

Same as core check #1, but for `{DEPT_FF_PATH}/workflows/`. Department workflows may reference both local skills (`{DEPT_FF_PATH}/skills/`) and core skills (`{FF_CORE_PATH}/skills/`) — validate both.

#### 7. Department slash commands

Read every file in `{DEPT_FF_PATH}/.github/prompts/` and `{DEPT_FF_PATH}/.cursor/commands/`. Verify the referenced file exists — it may point to a department skill/workflow or a core one.

#### 8. Department config references

Read `{DEPT_FF_PATH}/.department-fluid-flow.json`. If `workflows[]` lists workflow names, verify each corresponding `wf-*.md` file exists under `{DEPT_FF_PATH}/workflows/`.

#### 9. Local KB manifest references

If `knowledge-base-local/manifest.md` exists, verify every file path listed in the "Always Load" section exists on disk.

---

## Output

Record every broken link as:

```
{source_file} | Broken Ref | references {target_path} — not found | Remove or update reference
```

Pass all findings to `report.md` for presentation.
