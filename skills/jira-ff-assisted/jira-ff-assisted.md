# JIRA "FF Assisted" Flag

Marks a JIRA issue with the **`ff-assisted`** label to indicate that Fluid Flow AI participated in the development lifecycle for this card.

## Trigger Rule

**Immediately after the AI reads, creates, or edits any JIRA issue — for any reason — it MUST run this skill on that issue before doing anything else.** This is not optional and must not be deferred.

The most common trigger is the very first message: when the user references a JIRA ticket key to start work, the AI reads that ticket during triage. That read triggers this skill.

## JIRA Key Detection

A JIRA issue key matches the pattern `[A-Z]+-\d+` (e.g. `DIT-322`, `DAA-235`, `GXD-1732`).

Scan for JIRA keys in:
- The user's initial message
- Any user message during the session
- Initiative names (e.g. `DAA-235-feature-name`)
- Branch names (e.g. `daa-235-add-user-auth`)
- Commit messages or PR descriptions

When a key is detected and the AI reads that issue from JIRA, this skill fires.

## Trigger Points

These are the concrete moments when this skill MUST run:

| When | What happens |
|------|-------------|
| **Triage** | User's request contains a JIRA key → AI reads the issue → **flag it immediately** |
| **Initiative creation** | Initiative name references a JIRA key → **flag it** |
| **Tasks-to-issues** | AI creates JIRA issues → **flag each one after creation** |
| **Any workflow step** | AI reads or edits a JIRA issue for any reason → **flag it** |
| **Completion** | PR or commit references a JIRA key → **flag it** |

## Required MCP

This skill requires the **Atlassian MCP** (`atlassian`). If the MCP is not configured or not running, skip silently and log the skip reason in the audit trail. Do not block the workflow.

## Mechanism

The flag is implemented as a **JIRA label** (`ff-assisted`) rather than a custom field. Labels are available on all issue types and projects without requiring JIRA admin access to create custom fields.

If a dedicated "FF Assisted" custom field exists in the project (checkbox or select type), prefer using it. Otherwise, fall back to the label approach (which is the default).

## Inputs

- `JIRA_ISSUE_KEY` — the issue key (e.g. `DIT-322`, `DAA-235`)
- `CLOUD_ID` — the Atlassian site hostname (e.g. `betssongroup.atlassian.net`). Read from `.fluid-flow-local.json` field `atlassianCloudId`, or use the site hostname from the JIRA URL the user provides.

## Execution Steps

### 1. Resolve Cloud ID

Check if `CLOUD_ID` is already stored in the session. If not:
1. Read `.fluid-flow-local.json` for an `atlassianCloudId` field
2. If missing, extract the hostname from the JIRA URL the user provided (e.g. `betssongroup.atlassian.net` from `https://betssongroup.atlassian.net/browse/DAA-235`)
3. If no URL is available, call `getAccessibleAtlassianResources` via the Atlassian MCP to list available sites
4. If exactly one site: use it automatically
5. If multiple sites: present a multi-choice question for the user to select
6. Store the chosen `CLOUD_ID` in the session and persist it to `.fluid-flow-local.json`:
   ```json
   {
     "localRepoPath": "...",
     "name": "...",
     "atlassianCloudId": "{cloud-id}"
   }
   ```

### 2. Get the Issue

Call `getJiraIssue` with:
- `cloudId`: `{CLOUD_ID}`
- `issueIdOrKey`: `{JIRA_ISSUE_KEY}`
- `responseContentFormat`: `"markdown"`

From the response, check the `fields.labels` array.

### 3. Check Existing Flag

**If `"ff-assisted"` is already in the labels array**: log "already flagged" and stop — no update needed.

**If `"ff-assisted"` is NOT in the labels array**: proceed to Step 4.

### 4. Add the `ff-assisted` Label

Call `editJiraIssue` with:
- `cloudId`: `{CLOUD_ID}`
- `issueIdOrKey`: `{JIRA_ISSUE_KEY}`
- `fields`: `{ "labels": [{existing-labels}, "ff-assisted"] }`

Preserve any existing labels by including them in the array alongside the new `ff-assisted` entry.

### 5. Verify and Log

1. Confirm the update succeeded (the response includes `"ff-assisted"` in the labels)
2. Log the action in the initiative's audit trail:
   ```
   [ISO-8601] JIRA FF Assisted: Flagged {JIRA_ISSUE_KEY} (label: ff-assisted)
   ```
3. If the update failed, log the error but do not block the workflow

## Custom Field Upgrade Path

If a JIRA admin later creates a dedicated "FF Assisted" custom field:
1. Update this skill to discover the field via `getJiraIssueTypeMetaWithFields`
2. Set the custom field value instead of (or in addition to) the label
3. The label approach remains as a universal fallback

## Error Handling

- **MCP not available**: Skip silently. Log: "Atlassian MCP unavailable, FF Assisted flag skipped."
- **Authentication failure**: Present the error to the user and suggest checking the MCP configuration. Do not block.
- **Label update failure**: Log the error. Suggest the user check field permissions. Do not block.
- **Issue not found**: Log: "JIRA issue {KEY} not found. FF Assisted flag skipped." Do not block.

This skill is **non-blocking** — JIRA flagging failures never halt the workflow.
