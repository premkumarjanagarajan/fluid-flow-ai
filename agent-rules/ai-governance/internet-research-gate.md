# Internet Research Gate

## Purpose

Controls access to external internet research during a Product Buddy session. Internet access is permitted — but only with explicit human approval and full audit logging. This gate ensures external data is intentional, traceable, and never silently used in artefacts.

## Trigger

This gate fires whenever the agent is asked to — or considers — accessing external internet sources for:

- Competitor analysis or benchmarking
- Market sizing or industry research
- External regulatory or standards references not available in the KB
- Any URL, article, or web source outside of Betsson-owned systems

**If no approval has been granted for internet research in the current session, the agent MUST present this gate before proceeding.**

---

## Gate Protocol

### Step 1 — Present the gate

Display the following before taking any internet action:

```
───────────────────────────────────────────────────────────
  INTERNET RESEARCH GATE
───────────────────────────────────────────────────────────

  I can search the internet for the following:

    Topic:   {what will be searched}
    Reason:  {why this is relevant to the current artefact}
    Risk:    External sources may be incomplete, biased,
             or outdated. Findings will be clearly marked
             as external research in the artefact.

  This action will be logged in the initiative audit trail.

  A) Approve — proceed with internet research
  B) Skip — mark as "research required" in the artefact
  C) I'll provide the information — paste it here instead
───────────────────────────────────────────────────────────
```

Wait for the user's explicit response. Do not proceed until A, B, or C is selected.

---

### Step 2 — On Approve (A)

1. Perform the internet research using available search tools
2. Present findings to the user as a clearly labelled block:
   ```
   ── EXTERNAL RESEARCH FINDINGS ──────────────────────────
   Source(s): {URL(s) used}
   Query:     {search terms used}
   Summary:   {2–5 sentences summarising what was found}
   ────────────────────────────────────────────────────────
   ```
3. Ask the user to confirm the findings are relevant before incorporating them into the artefact
4. **Log to `audit.md`** immediately after the search:
   ```
   [ISO-8601] Internet Research Gate: APPROVED
   Topic: {topic searched}
   Query: {exact search terms used}
   Sources: {URL(s) retrieved}
   Summary: {brief summary of findings}
   Approved by: {user name or "session user"}
   Used in: {artefact section where findings will appear}
   ```

### Step 3 — On Skip (B)

1. Record `COMPETITOR_CONTEXT = research required` (or equivalent field) in session state
2. Flag the gap in the artefact with: `⚠ Competitor research required — not completed during discovery`
3. **Log to `audit.md`**:
   ```
   [ISO-8601] Internet Research Gate: SKIPPED
   Topic: {topic}
   Decision: User chose to defer — flagged as research required in artefact
   ```

### Step 4 — On User Provides (C)

1. Accept the pasted information as the evidence source
2. Record it as `COMPETITOR_CONTEXT = user-provided`
3. **Log to `audit.md`**:
   ```
   [ISO-8601] Internet Research Gate: USER-PROVIDED
   Topic: {topic}
   Source: User-provided content (pasted directly into session)
   Content: {brief summary of what was provided}
   ```

---

## Audit Requirement

**Every internet research gate event — whether approved, skipped, or user-provided — MUST be logged to `audit.md`.** No exceptions. This creates a complete record of what external data informed the artefact and who made the decision.

## Scope

This gate applies to:
- Product Buddy discovery sessions
- Any agent operating under Fluid Flow governance

This gate does NOT apply to:
- Reading from Betsson-internal systems via MCP (Jira, Confluence, Figma, Slack)
- KB retrieval from `betsson-kb-docs`
- Reading files within the workspace

## Non-Blocking Rule

If no internet search tool is available in the current environment, skip Step 2 execution and automatically offer the user option C (provide information manually). Do not block the session.
