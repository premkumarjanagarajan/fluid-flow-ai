---
name: confluence-pb-stamp
description: Stamps Product Buddy metadata (version, author, date) as a Page Properties block on any Confluence page created or updated during a Product Buddy session. Enables adoption tracking and version reporting across Confluence artefacts.
execution: inline
scope: product-buddy
version: 1.0
last-updated: 2026-05-18
---

# Confluence Product Buddy Stamp

Adds a **Page Properties** block to any Confluence page created or updated during a Product Buddy session. This enables adoption tracking via the Confluence Page Properties Report macro — giving a live table of all PB-assisted artefacts across the space.

## Trigger Rule

**Immediately after Product Buddy creates or updates a Confluence page via the Atlassian MCP, this skill MUST run on that page before doing anything else.** This is not optional and must not be deferred.

Applies to any page creation or update triggered during the product discovery workflow — Feature Briefs, Handshake Contracts, Need & Opportunity documents, Solutions, or any other artefact pushed to Confluence.

## Required MCP

This skill requires the **Atlassian MCP** (`atlassian`). If the MCP is not configured or not running, skip silently and log the skip reason in the audit trail. Do not block the workflow.

## Inputs

- `CONFLUENCE_PAGE_ID` — the ID of the page just created or updated
- `CONFLUENCE_PAGE_VERSION` — the current page version number (required by the Atlassian MCP to update a page)
- `CONFLUENCE_SPACE_KEY` — the space key where the page lives
- `CLOUD_ID` — the Atlassian site hostname (e.g. `betssongroup.atlassian.net`). Read from `.fluid-flow-local.json` field `atlassianCloudId`, or extract from the Confluence URL.
- `AUTHOR` — the name of the PM/PO who initiated the session (from Jira account if available, otherwise ask)
- `PB_VERSION` — the current Product Buddy version, read dynamically from the `version` field in `.github/agents/product-buddy.agent.md`

## Execution Steps

### 1. Resolve Cloud ID

Reuse the `CLOUD_ID` already resolved in the session (set by `jira-ff-assisted` or any prior Atlassian MCP call). If not yet resolved:
1. Read `.fluid-flow-local.json` for an `atlassianCloudId` field
2. If missing, extract the hostname from the Confluence URL used in this session
3. If no URL is available, call `getAccessibleAtlassianResources` to list available sites
4. If exactly one site: use it automatically
5. If multiple sites: present a multi-choice question for the user to select
6. Store and persist to `.fluid-flow-local.json`

### 2. Get the Current Page

Call `getConfluencePage` with:
- `cloudId`: `{CLOUD_ID}`
- `pageId`: `{CONFLUENCE_PAGE_ID}`

From the response, extract:
- Current page `version.number` → store as `CURRENT_VERSION`
- Current page `body.storage.value` → store as `CURRENT_BODY`

### 3. Check for Existing Stamp

Search `CURRENT_BODY` for the string `pb_version`.

**If found:** The page is already stamped. Log "already stamped" and stop — no update needed.

**If not found:** Proceed to Step 4.

### 4. Build the Page Properties Block

Construct the following Confluence storage format XML block:

```xml
<ac:structured-macro ac:name="details" ac:schema-version="1">
  <ac:rich-text-body>
    <table>
      <tbody>
        <tr>
          <th>pb_version</th>
          <td>{PB_VERSION}</td>
        </tr>
        <tr>
          <th>created_with_pb</th>
          <td>Yes</td>
        </tr>
        <tr>
          <th>pb_author</th>
          <td>{AUTHOR}</td>
        </tr>
        <tr>
          <th>pb_date</th>
          <td>{ISO-8601 date, e.g. 2026-05-18}</td>
        </tr>
      </tbody>
    </table>
  </ac:rich-text-body>
</ac:structured-macro>
```

### 5. Prepend to Page Body

Insert the Page Properties block at the **very top** of `CURRENT_BODY`, before any existing content. The updated body becomes:

```
{PAGE_PROPERTIES_BLOCK}
{CURRENT_BODY}
```

### 6. Update the Page

Call `updateConfluencePage` with:
- `cloudId`: `{CLOUD_ID}`
- `pageId`: `{CONFLUENCE_PAGE_ID}`
- `version`: `{ "number": {CURRENT_VERSION + 1} }`
- `body`: `{ "storage": { "value": "{UPDATED_BODY}", "representation": "storage" } }`

### 7. Verify and Log

1. Confirm the update succeeded (response contains the updated page)
2. Log the action in the initiative's audit trail:
   ```
   [ISO-8601] Confluence PB Stamp: Stamped page {CONFLUENCE_PAGE_ID} (pb_version: {PB_VERSION}, author: {AUTHOR})
   ```
3. If the update failed, log the error but do not block the workflow

## Reporting — Page Properties Report

To surface all PB-assisted artefacts in a Confluence space, add the following macro to a summary or index page in the space:

```xml
<ac:structured-macro ac:name="detailssummary" ac:schema-version="2">
  <ac:parameter ac:name="headings">pb_version,created_with_pb,pb_author,pb_date</ac:parameter>
</ac:structured-macro>
```

This renders a live table of every page stamped with Product Buddy metadata in the space — no manual tracking required.

## Error Handling

- **MCP not available**: Skip silently. Log: "Atlassian MCP unavailable, Confluence PB stamp skipped."
- **Authentication failure**: Present the error to the user and suggest checking the MCP configuration. Do not block.
- **Page update failure**: Log the error. Suggest the user check page edit permissions. Do not block.
- **Page not found**: Log: "Confluence page {ID} not found. PB stamp skipped." Do not block.

This skill is **non-blocking** — Confluence stamping failures never halt the workflow.
