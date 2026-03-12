# Orchestrator

Display:

```
═══════════════════════════════════════════════════
  FLUID-FLOW AI v0.9 WORKFLOW ACTIVATED
  All development follows the unified lifecycle.
  Reading workflow instructions now...
═══════════════════════════════════════════════════
```

## MCP Check

1. Read `.cursor/mcp.json` or `.vscode/mcp.json` (depending on IDE)
2. For each configured server, verify it is running and accessible
3. Report status:

```
  MCP Status:
    {server-name}: OK | FAIL ({error})
```

4. If any server fails: present a multi-choice question using the IDE question tool (Cursor: `AskQuestion` / VS Code: `vscode_askQuestions`):
   - **A**: Continue without failed server(s)
   - **B**: Stop and fix

   > **Tool note**: `vscode_askQuestions` and `AskQuestion` are deferred tools. You **must** load them via `tool_search_tool_regex` before calling them.

---

## Triage

1. Read all `workflow/*/wf-*.md` frontmatter to know available workflows
2. Check `initiatives/` for any existing initiative folders with incomplete `metadata/state.md`
3. Based on the user's prompt, classify the intent:

| Intent | Criteria | Action |
|--------|----------|--------|
| **Question** | No development needed | Answer directly. Stop here. |
| **Continue** | Matches an existing incomplete initiative | Confirm with user, run Stages 0-2, then resume from last completed stage in its `metadata/state.md` |
| **New** | Development request, no matching initiative | Run all stages (0-6) |

---

## Stage 0: Shell Detection

Load `skills/shell-detection/shell-detection.md`. Store `SHELL_TYPE`.

## Stage 1: Workspace Detection

1. Scan for source code (`src/`, `package.json`, `*.csproj`, `go.mod`, etc.)
2. Classify: **greenfield** or **brownfield**

## Stage 2: Reverse Engineering (brownfield, run-once)

**Skip if**: greenfield or `reverse-engineering/reverse-engineering-timestamp.md` exists.

Load `skills/reverse-engineering/reverse-engineering.md`. **Wait for user approval.**

**Continue stops here** -- resume the ongoing initiative from its last completed stage.

## Stage 3: Workflow Selection

Present workflows grouped by source. Suggest best match with `-->`. **Wait for user choice.**

```
-------------------------------------------
  AVAILABLE WORKFLOWS
-------------------------------------------

  Core:
    {N}. {workflow-name} -- {description}  {--> if suggested}

  Local:
    {N}. {workflow-name} -- {description}  {--> if suggested}

  Reply with number or name.
-------------------------------------------
```

- **Core**: workflows shipped with this repository (`workflow/`)
- **Local**: workflows added by the working repository (future support)

## Stage 4: Initiative Creation (new only)

1. Load `templates/branch-template.md` for naming convention
2. Generate a suggested name based on user's request and the template pattern
3. Present a multi-choice question using the IDE question tool (Cursor: `AskQuestion` / VS Code: `vscode_askQuestions`):
   - **A**: `{suggested-name}` (generated)
   - **B**: Other (user provides custom name)
4. Create the initiative folder structure:
   ```
   initiatives/{chosen-name}/
     metadata/
       state.md
       audit.md
       analytics.md
   ```
5. Store `INITIATIVE_NAME` for the session

## Stage 5: Workflow Routing

1. Load `workflow/{selected}/wf-{selected}.md`
2. Execute phase->step chain: each `{N}-{phase}.md` defines its steps, each `{N}-{step}.md` is loaded and executed in order

## Stage 6: Completion

1. **Commit**: present summary + conventional commit --> **wait for approval** --> commit
2. **PR**: push branch, create PR, present link
3. **Risk Report**: generate at `initiatives/{BRANCH_NAME}/operations/risk-report.md`, attach to PR

---

**Rules**:
- Never auto-commit. Never skip stages. Wait for user approval at gates.
- **After every stage/step**: run `primitives/state-manager.md`, `primitives/analytics.md`, and `primitives/kb-compliance.md`.
