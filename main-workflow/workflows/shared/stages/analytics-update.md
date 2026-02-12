# Analytics Update Instructions

# This instruction file is referenced by BOTH workflows (Spec-Kit and AWS AI-DLC)
# via the shared command fluid-flow.update-docs.md.
# It defines how to update the feature analytics file after the final steps of each workflow.

## Purpose

Finalise the feature analytics file with completion data, stage durations, and work metrics.
This data enables understanding of:
- **Throughput**: How much work is completed using the workflow
- **Cycle Time**: How long it takes to complete the full development cycle (end-to-end)
- **Stage Efficiency**: Which stages take the longest and where bottlenecks occur
- **Rework Rate**: How often change requests occur (indicates requirement quality)
- **Workflow Comparison**: Compare Spec-Kit vs AWS AI-DLC effort for similar features

---

## Analytics File Location

```
main-workflow/analytics/{BRANCH_NAME}.md
```

This file is created during the entry point (Stage 1: Branch Creation) and updated here after the workflow completes.

---

## Step 1: Load Existing Analytics File

1. Read `main-workflow/analytics/{BRANCH_NAME}.md`
2. If the file does not exist, this is an error -- log in audit.md and create a minimal analytics file using the format from `../commands/fluid-flow.md` (Analytics File Format section)

---

## Step 2: Gather Completion Data

Collect the following data from the feature directory:

### From `specs/{BRANCH_NAME}/state.md`:
- Current stage (should be final stage)
- All completed checkboxes (count stages executed vs skipped)
- Workflow type (Spec-Kit or AWS AI-DLC)

### From `specs/{BRANCH_NAME}/audit.md`:
- All timestamps (to calculate stage durations)
- Count of user interactions (total AI interactions)
- Count of approval entries (approval gates passed)
- Count of "Request Changes" or revision entries (change requests / rework cycles)
- Count of clarification questions asked (clarification rounds)

### From the feature directory (`specs/{BRANCH_NAME}/`):
- Count all `.md` files recursively (artifacts generated)
- List all stages that have output directories/files (stages executed)

---

## Step 3: Calculate Metrics

### Duration Calculations
- **Entry Point Duration**: Time from Branch Creation start to Workflow Routing completion
- **Workflow Duration**: Time from first workflow stage to last workflow stage completion
- **End-to-End Duration**: Time from Branch Creation start to this analytics update
- **Per-Stage Duration**: For each stage in the timeline, calculate `Completed - Started`

### Work Metrics
- **Total AI Interactions**: Count all `**User Input**:` entries in audit.md
- **Approval Gates Passed**: Count all approval-related entries in audit.md
- **Change Requests**: Count entries where user chose "Request Changes" or similar revision actions
- **Clarification Rounds**: Count entries related to clarification questions
- **Artifacts Generated**: Count all files created in `specs/{BRANCH_NAME}/`
- **Stages Executed**: Count stages with `[x]` in state.md
- **Stages Skipped**: Count stages marked as skipped or not executed

### Rework Rate
- **Rework Cycles**: Total number of "Request Changes" choices across all stages
- **Rework Rate**: `Rework Cycles / Stages Executed` (as percentage)

---

## Step 4: Update the Analytics File

Update `main-workflow/analytics/{BRANCH_NAME}.md` with all gathered data:

1. **Metadata section**: Set `Completed` timestamp and `Total Duration`
2. **Stage Timeline table**: Fill in all stage rows with timestamps, durations, and status
3. **Work Metrics section**: Update all counters with actual values
4. **Effort Breakdown table**: Fill in per-phase metrics
5. **Cycle Summary section**: Populate all duration fields and rework count

### Workflow-Specific Stage Rows

**For Spec-Kit**, append these rows to the Stage Timeline:

| Stage | Started | Completed | Duration | Status |
|-------|---------|-----------|----------|--------|
| Specify | | | | |
| Clarify | | | | Executed / Skipped |
| Plan | | | | |
| Tasks | | | | |
| Checklist | | | | Executed / Skipped |
| Implement | | | | |

**For AWS AI-DLC**, append these rows to the Stage Timeline:

| Stage | Started | Completed | Duration | Status |
|-------|---------|-----------|----------|--------|
| Requirements Analysis | | | | |
| Onboarding Presentations | | | | Executed / Skipped |
| User Stories | | | | Executed / Skipped |
| Workflow Planning | | | | |
| Application Design | | | | Executed / Skipped |
| Units Generation | | | | Executed / Skipped |
| Functional Design | | | | Executed / Skipped |
| NFR Requirements | | | | Executed / Skipped |
| NFR Design | | | | Executed / Skipped |
| Infrastructure Design | | | | Executed / Skipped |
| Code Generation | | | | |
| Onboarding Update | | | | Executed / Skipped |
| Build and Test | | | | |

### Effort Breakdown Per Phase

**For Spec-Kit**:

| Phase | Interactions | Approvals | Duration |
|-------|-------------|-----------|----------|
| Entry Point | [count] | [count] | [duration] |
| Specification | [count] | [count] | [duration] |
| Planning | [count] | [count] | [duration] |
| Implementation | [count] | [count] | [duration] |

**For AWS AI-DLC**:

| Phase | Interactions | Approvals | Duration |
|-------|-------------|-----------|----------|
| Entry Point | [count] | [count] | [duration] |
| Inception | [count] | [count] | [duration] |
| Construction | [count] | [count] | [duration] |

---

## Step 5: Log Analytics Update

1. **MANDATORY**: Log the analytics update in `specs/{BRANCH_NAME}/audit.md`:

```markdown
## Analytics Finalisation
**Timestamp**: [ISO timestamp]
**AI Response**: "Updated feature analytics at main-workflow/analytics/{BRANCH_NAME}.md"
**Context**: Post-Implementation - Analytics Update
**Summary**:
- End-to-End Duration: [duration]
- Stages Executed: [count]
- Total AI Interactions: [count]
- Rework Cycles: [count]

---
```

---

## Suggested Analytics Insights

The analytics data collected enables the following insights when reviewed across multiple features:

### Individual Feature Insights
- **Bottleneck identification**: Which stages consistently take the longest?
- **Rework hotspots**: Which stages generate the most change requests?
- **Workflow fit**: Was the chosen workflow appropriate for the feature complexity?

### Cross-Feature Insights (manual review of `main-workflow/analytics/` folder)
- **Average cycle time** by workflow type
- **Average rework rate** across features
- **Stage duration trends** over time (are stages getting faster with practice?)
- **Workflow selection patterns**: Which workflow is chosen more often and for what types of work?
- **JIRA correlation**: Map analytics to JIRA tickets for project-level reporting

### Recommended Review Cadence
- After every 5 completed features, review the analytics folder for patterns
- Use the data to refine workflow selection guidance
- Identify stages that could be simplified or made optional
