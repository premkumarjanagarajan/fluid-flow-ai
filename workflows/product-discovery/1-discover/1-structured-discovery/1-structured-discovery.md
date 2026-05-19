---
step: structured-discovery
subagent: false
---

## Inputs

- User's topic or idea (from the triggering message or prompt argument)

## Guidance

Begin every discovery session by engaging the user in a structured conversation. Ask questions ONE AT A TIME or in small focused groups. Do not overwhelm with a wall of questions. Listen, reflect back, and ask follow-up questions based on the answers. Act as a critical friend — challenge vague, solution-focused, or assumption-heavy answers.

## Execution

### Question 1

**What's the idea?** — In your own words, describe what you're thinking about.

---

### Immediate Context Pre-Scan (runs after question 1, before question 2)

> Do NOT wait for the full discovery conversation before scanning. The moment the PO states their idea, run all three scans in parallel as background tasks. Present the findings as a "What I Already Know" brief before asking question 2.

Launch three parallel background lookups using the topic/keywords from the PO's answer:

**Scan A — KB pre-scan** (KB Librarian subagent, `skills/kb-retrieval/kb-retrieval.skill.md`)
- Does this topic appear in the department KB, shared KB, or any existing coverage?
- Are there past problem statements, initiative folders, or session notes under `{DEPT_FF_PATH}/initiatives/` related to this?
- Are there any relevant skills, templates, or prompts that apply to this topic?

**Scan B — Codebase pre-scan** (Explore subagent, read-only)
- Does this capability exist in the codebase — fully, partially, or as a feature flag?
- Is there any in-flight work (open branches, open PRs, draft implementations) related to this?
- What systems or services would this touch based on the stated idea?

> Note: This is a lightweight background scan. No `CODE_RECON_PERMITTED` consent needed at this stage — it's read-only orientation, not a full reverse-engineering run. The deeper opt-in recon happens at Step 1.3.

**Scan C — Past artefacts pre-scan** (MCP — Atlassian, conditional on `MCP_SERVERS_OK[]`)
- Search Jira for existing Big Bets, Needs & Opportunities, Solutions, or Epics with related keywords.
- Search Confluence for any past discovery sessions, product briefs, or decisions on this topic.
- Note: if MCP is unavailable, ask the PO: *"Are you aware of any existing Jira tickets, briefs, or prior work on this topic I should know about before we continue?"*

**Present findings as a "What I Already Know" brief** before question 2:

```
Before I ask more questions, here's what I found on "[idea topic]":

KB coverage: [what exists / what's missing]
Codebase: [exists fully / exists partially / in-flight work found / not found]
Past work: [existing artefacts found with references / nothing found]

[If anything significant was found]: "This changes how I'll ask the next questions. Let me continue with that in mind."
[If nothing found]: "No prior work found — this looks genuinely new. Let me continue."
```

Store scan results as session context. Use findings to tailor questions 2–8.

---

### Reframe Moment (runs once, after idea is stated, before Question 1)

After the context pre-scan, offer ONE unexpected reframe of the problem before asking any questions.

Rules:
- Reframe must challenge the assumption embedded in how the idea was stated
- It must be specific to the idea — never generic
- It is not a question — it is a perspective offered as a provocation
- Phrase it as: "Before we explore this — one angle worth considering: [reframe]. Does that change anything for you?"
- If the user dismisses it, accept and move on. If they engage, explore for no more than 2 exchanges before moving to Question 1.
- The reframe should draw on context scan findings where possible — make it informed, not generic

The reframe is the signal that Product Buddy is a thinking partner, not a form.

---

### Questions 2–8 (informed by pre-scan findings)

2. **What problem does this solve?** — Who is struggling, and what is the struggle? What happens today without this?
   - If the user describes a solution rather than a problem, flag the **"Solution in Problem Statement"** anti-pattern. Ask: *"That sounds like a solution — what's the user problem behind it?"*
   - If the pre-scan found existing capability: *"I found [X] already exists in the codebase. Is the problem that it doesn't work, doesn't go far enough, or is this a different angle entirely?"*

3. **Who are the users?** — Which user groups are most affected? (e.g. casual players, high-value players, mobile users, desktop users, new users, returning users)

4. **What evidence supports this?** — Is there user research, analytics, customer feedback, support tickets, competitor analysis, or A/B test results?
   - If the user provides evidence, record it. Then ask: *"Can you share analytics data — a metric, funnel, or dashboard screenshot from Amplitude, Mixpanel, Looker, or Power BI? Paste it here and I'll interpret it."* Record as `ANALYTICS_EVIDENCE`.
   - If none: flag as a gap. *"Discovery without evidence increases risk."*
   - **Competitor analysis:** If the user mentions competitor research, market benchmarking, or asks Product Buddy to research what competitors offer, invoke the **Internet Research Gate** (`agent-rules/ai-governance/internet-research-gate.md`) immediately. Do not proceed past this point until the gate resolves (Approved / Skipped / User-Provided). The gate handles disclosure, approval, and audit logging.
   - **Before moving on, ask both enrichment questions:**
     - *"Shall I run a deeper codebase check — beyond the quick scan — to look at integration points and in-flight work in detail?"* Record as `CODE_RECON_PERMITTED = true/false`.
     - *"Do you have analytics data to share (Amplitude, Mixpanel, Looker, Power BI)? Paste a metric or dashboard link and I'll interpret it."* Record as `ANALYTICS_EVIDENCE` or `UNVALIDATED`.

5. **What markets and platforms?** — Which markets are in scope? Which platforms (desktop, mobile web, native app)? Any regulatory jurisdictions to consider?

6. **What happens if we don't do this?** — What is the cost of inaction? Who feels the pain?

7. **What constraints do you already know?** — Deadlines, dependencies, regulatory requirements, technical limitations, team capacity?
   - If the pre-scan found in-flight work: *"I found [X] is already in progress. Is this a continuation, a competing approach, or something separate?"*

8. **Is this new or does it connect to existing work?** — Does this relate to an existing Big Bet, Need & Opportunity, or Solution?
   - If the pre-scan found existing artefacts: *"I found [artefact references]. Are any of these what you're building on, or is this separate?"*

---

## Outputs

- Pre-scan context brief presented to the user
- All 8 discovery questions answered
- `ANALYTICS_EVIDENCE` recorded or flagged as `UNVALIDATED`
- `CODE_RECON_PERMITTED` recorded
- Summary of what was heard, confirmed by the user

## Gate

User confirms the summary is accurate.
