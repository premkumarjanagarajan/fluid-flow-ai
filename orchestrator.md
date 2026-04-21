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

Launch **`ff-init`** (`skills/ff-init/ff-init.md`). Pass the workspace root folder paths and whether the user explicitly invoked `/ff-init` (force flag). Parse the returned payload, store session variables, and continue — or halt if blocked.

---

## Knowledge Loading (after Init, before Triage)

Read `agent-rules/manifest.md` and execute the **boot loading** sequence:

1. **Agent Rules (always):** Load all files listed under "Always Load — Agent Rules" (7 files). These govern AI behavior for the entire session — loaded once, not re-read per step.

2. **Enterprise KB (always):** Launch `skills/kb-retrieval/kb-retrieval.skill.md` as a subagent. Request the "Always Load — Enterprise KB" topics from the manifest (ISO 9001 process discipline). Store the returned content for the session.

3. **Local KB (if configured):** If `LOCAL_KB_MANIFEST` is set (detected by ff-init), read `{DEPT_FF_PATH}/knowledge-base-local/manifest.md` and load all files under its "Always Load" section.

This is a one-time boot load. Conditional knowledge (security, tech-specific, department overlay) is loaded per step during Stage 3 — see the manifest for trigger rules.

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

1. Load `{FF_CORE_PATH}/skills/branch-creation/branch-creation.md` for naming convention
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
2. Execute phase→step chain: each `{N}-{phase}.md` defines its steps, each `{N}-{step}.md` is loaded and executed in order
3. **Before each step**: check `agent-rules/manifest.md` conditional sections. If the step's domain matches a trigger (security, infrastructure, tech-specific via `TECH_STACK`, department via `DEPARTMENT`), load the matching agent-rules files and launch `skills/kb-retrieval/kb-retrieval.skill.md` for the matching enterprise KB topics. If `LOCAL_KB_MANIFEST` is set and its manifest has conditional sections matching the step domain, load those too.
4. **After every step completes**: run `primitives/human-gate.md`, then `primitives/state-manager.md` and `primitives/analytics.md`
5. **After the last step of each phase** (phase transition or workflow end): additionally run `primitives/kb-compliance.md`

## Stage 4: Completion

Load `skills/completion/completion.md` and execute the full completion sequence.

**Skip condition**: If the active workflow has `domain: product` in its frontmatter (e.g. `product-buddy`), skip Stage 4 entirely — product workflows do not touch source code.

The completion skill handles: evaluation pause, VAPT, risk report, reverse engineering update (brownfield), analytics reconciliation, commit/PR artifact generation, consolidated human gate, commit & push, and optional retrospective. See the skill file for the full protocol.

---

**Rules**:
- Never auto-commit. Never skip stages. Wait for user approval at gates.
- All initiative artifacts are stored in the department fluid-flow repository (`DEPT_FF_PATH`), never in the core repository.
- **Before each step**: check manifest conditionals and load matching knowledge (see Stage 3).
- **After every step**: run `primitives/human-gate.md`, then `primitives/state-manager.md` and `primitives/analytics.md`.
- **After the last step of each phase** (phase transition): additionally run `primitives/kb-compliance.md`.

## Autonomous Skills

The following skills fire **immediately** when their trigger condition is met — at any stage, in any workflow step. They are not deferred or batched. When the trigger occurs, the AI loads and executes the skill before continuing with whatever it was doing.

| Skill | Trigger | Behaviour |
|-------|---------|-----------|
| `skills/jira-ff-assisted/jira-ff-assisted.md` | **Immediately after** the AI reads, creates, or edits any JIRA issue — for any reason. The first trigger is typically Triage (step 3 detects JIRA keys in the user's message). Subsequent triggers: initiative creation referencing a ticket, tasks-to-issues, completion, or any ad-hoc JIRA interaction. | Add the `ff-assisted` label to the issue. Non-blocking — failures never halt the workflow. |
