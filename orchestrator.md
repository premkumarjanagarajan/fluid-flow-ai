# Orchestrator

Display:

```
═══════════════════════════════════════════════════
  FLUID-FLOW AI v0.9.1 WORKFLOW ACTIVATED
  All development follows the unified lifecycle.
  Reading workflow instructions now...
═══════════════════════════════════════════════════
```

## Init

Launch **`ff-init`** (`skills/ff-init/ff-init.md`). Pass the workspace root folder paths and whether the user explicitly invoked `/ff-init` (force flag). Parse the returned payload, store session variables, and continue to Triage — or halt if blocked.

---

## Triage

1. Read all `{FF_CORE_PATH}/workflow/*/wf-*.md` frontmatter to know available workflows. **Exclude** any workflow where `orchestrator-listed: false` — these are entered via their own slash commands, not through the orchestrator menu.
2. Check `{DEPT_FF_PATH}/initiatives/` for any existing initiative folders with incomplete `metadata/state.md`
3. **Detect JIRA keys**: Scan the user's message for JIRA issue keys (pattern: `[A-Z]+-\d+`). If any are found and the Atlassian MCP is available, read each issue to understand context — then **immediately** load `skills/jira-ff-assisted/jira-ff-assisted.md` and flag every detected issue before continuing. Store the keys as `JIRA_KEYS[]` for the session.
4. **Route**: If an existing incomplete initiative matches the request, confirm with the user and resume from the last completed stage in its `metadata/state.md`. Otherwise treat as **New** and run all stages (1-4).

---

## Stage 1: Workflow Selection

Present workflows grouped by source. Suggest best match with `-->`, using `TECH_STACK` and `DEPARTMENT` to inform the suggestion. **Wait for user choice.**

```
-------------------------------------------
  AVAILABLE WORKFLOWS
-------------------------------------------

  Core:
    {N}. {workflow-name} -- {description}  {--> if suggested}

  Department:
    {N}. {workflow-name} -- {description}  {--> if suggested}

  Reply with number or name.
-------------------------------------------
```

- **Core**: workflows shipped with `fluid-flow-ai` (`{FF_CORE_PATH}/workflow/`)
- **Department**: workflows added by the department repo (`{DEPT_FF_PATH}/workflows/`)

## Stage 2: Initiative Creation (new only)

1. Load `{FF_CORE_PATH}/templates/branch-template.md` for naming convention
2. Generate a suggested name based on user's request and the template pattern
3. Present a multi-choice question using the IDE question tool (Cursor: `AskQuestion` / VS Code: `vscode_askQuestions`):
   - **A**: `{suggested-name}` (generated)
   - **B**: Other (user provides custom name)
4. Create the initiative folder structure inside the department repo:
   ```
   {DEPT_FF_PATH}/initiatives/{chosen-name}/
     metadata/
       state.md
       audit.md
       analytics.md
     artefacts/
   ```
5. Store `INITIATIVE_NAME` for the session

**Artifacts location**: All workflow step outputs are saved to `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/`. Workflow step files reference this path via the `DEPT_FF_PATH` and `INITIATIVE_NAME` session variables.

## Stage 3: Workflow Routing

1. Load `{FF_CORE_PATH}/workflow/{selected}/wf-{selected}.md`
2. Execute phase->step chain: each `{N}-{phase}.md` defines its steps, each `{N}-{step}.md` is loaded and executed in order
3. **After every step completes**: run `primitives/human-gate.md`, then `primitives/state-manager.md` and `primitives/analytics.md`
4. **After the last step of each phase** (phase transition or workflow end): additionally run `primitives/kb-compliance.md`

## Stage 4: Completion

Post-implementation actions, executed in order:

1. **VAPT**: Load `primitives/vapt.md`. Run the vulnerability assessment and penetration testing. Must pass its human gate (Critical/High findings) before proceeding.
2. **Risk Report**: Load `primitives/risk-report.md`. Generate the change risk report at `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/operations/risk-report.md`.
3. **Reverse Engineering Update** (brownfield only): Load `skills/reverse-engineering/reverse-engineering.md` to refresh project-level documentation with the new changes. Update the **Commit** and **Branch** fields in `reverse-engineering-timestamp.md` to the current HEAD, and append a new entry to the Update History.
4. **Analytics Reconciliation**: Load `primitives/analytics.md` to finalise initiative-level timing and metrics.
5. **Commit**: Present summary + conventional commit --> **wait for approval** --> commit.
6. **PR**: Push branch, create PR, attach risk report, present link.
7. **Retrospective** (recommended): After PR, suggest: "Run a workflow retrospective? Load `skills/retrospective/retrospective.md` for continuous improvement analysis." This is optional — the user may decline.

---

**Rules**:
- Never auto-commit. Never skip stages. Wait for user approval at gates.
- All initiative artifacts are stored in the department fluid-flow repository (`DEPT_FF_PATH`), never in the core repository.
- **After every step**: run `primitives/human-gate.md`, then `primitives/state-manager.md` and `primitives/analytics.md`.
- **After the last step of each phase** (phase transition): additionally run `primitives/kb-compliance.md`.

## Autonomous Skills

The following skills fire **immediately** when their trigger condition is met — at any stage, in any workflow step. They are not deferred or batched. When the trigger occurs, the AI loads and executes the skill before continuing with whatever it was doing.

| Skill | Trigger | Behaviour |
|-------|---------|-----------|
| `skills/jira-ff-assisted/jira-ff-assisted.md` | **Immediately after** the AI reads, creates, or edits any JIRA issue — for any reason. The first trigger is typically Triage (step 3 detects JIRA keys in the user's message). Subsequent triggers: initiative creation referencing a ticket, tasks-to-issues, completion, or any ad-hoc JIRA interaction. | Add the `ff-assisted` label to the issue. Non-blocking — failures never halt the workflow. |
