---
step: tasks-to-issues
subagent: false
---

## Inputs

- `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/tasks.md` (required)
- JIRA project key (from initiative name, user input, or `.fluid-flow-local.json`)
- Atlassian MCP (required for JIRA operations)

## Guidance

Convert approved tasks from `tasks.md` into JIRA issues. This step creates a traceable link between the task breakdown and the team's issue tracker.

### Execution Steps

1. **Load tasks.md**: Parse the task breakdown. Extract task IDs (T001, T002, etc.), descriptions, phase grouping, and any user story labels.

2. **Resolve JIRA context**:
   - Check if the initiative references a JIRA epic or parent (e.g. from initiative name like `DAA-235-feature-name`)
   - Read `.fluid-flow-local.json` for `atlassianCloudId` if available
   - If JIRA project key or parent is unknown, ask the user: "Which JIRA project and (optionally) parent epic should these tasks be created under?"

3. **Map tasks to JIRA issues**:
   - For each task: create a JIRA issue (type: Task or Sub-task as appropriate)
   - Set summary from task description (truncate if needed for JIRA limits)
   - Set description to include full task text and reference to `tasks.md`
   - Link to parent epic if provided
   - Preserve task ID in the JIRA issue (e.g. in description or a custom field) for traceability

4. **Invoke jira-ff-assisted skill**: After creating each issue, load `skills/jira-ff-assisted/jira-ff-assisted.md` and flag the new issue with the `ff-assisted` label. Non-blocking.

5. **Update tasks.md**: Append a `## JIRA Mapping` section (or update existing) with:
   ```markdown
   ## JIRA Mapping
   | Task ID | JIRA Key |
   |---------|----------|
   | T001    | PROJ-123 |
   | T002    | PROJ-124 |
   ```

6. **Report**: Output the mapping table and link to the JIRA board/filter for the created issues.

### Skip Condition

If the Atlassian MCP is not available or the user declines JIRA integration, skip this step. Log: "Tasks-to-issues skipped (no JIRA connection)." Proceed to Checklist. Do not block the workflow.

### Optional: User Choice

Present the user with: "Create JIRA issues from the task breakdown?" (A: Yes, B: No / Skip). If B, skip and proceed.

## Outputs

- Updated `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/tasks.md` with JIRA Mapping section
- JIRA issues created in the target project

## Gate

STOP until the user acknowledges the JIRA mapping (or confirms skip). Then proceed to Checklist.
