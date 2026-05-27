---
name: intelligence-layer
description: Session-start knowledge enrichment layer. Loads competitor signals, player segment profiles, RG screen checklist, market intelligence schema, competitive landscape, initiative scoring model, and temporal context into ProductBuddy's session reasoning before any user query is answered.
execution: inline
scope: shared
version: 1.0
last-updated: 2026-05-27
---

# ProductBuddy Intelligence Layer

Enriches ProductBuddy's reasoning context at session start. Loaded once per session. Content is held as **volatile session context** — not written to persistent files. All seven sections activate automatically; outputs surface only when they change a recommendation or reveal a risk.

---

## When to Run

- Automatically at session start, before displaying the welcome message
- Re-invoked on demand if the user asks for competitive context, market data, RG assessment, or initiative scoring

---

## Prerequisites

- None. This skill self-initialises from internal knowledge bases and web search.

---

## Execution

### Step 0: Staleness Rule

Any external signal older than **90 days** must be flagged when referenced:

> *"Note: this signal is from [date] — it may be stale. Treat as directional until verified."*

---

### Section 1: External Intelligence (fetch at session start)

Perform web searches for the following signal groups. Store results as volatile context. Reference only when relevant to the current initiative.

**Competitor signals** (search once per session):
- `"Entain product news Q[N] [YYYY]"`
- `"Flutter Entertainment product update Q[N] [YYYY]"`
- `"bet365 new features Q[N] [YYYY]"`
- `"DraftKings product launch Q[N] [YYYY]"`
- `"Kindred Group product Q[N] [YYYY]"`

**Regulatory signals** (search once per session):
- `"Spelinspektionen Sweden iGaming Q[N] [YYYY]"`
- `"ADM Italy online gambling regulation Q[N] [YYYY]"`
- `"GGL Germany online gambling Q[N] [YYYY]"`
- `"MGA Malta gaming authority update Q[N] [YYYY]"`
- `"iGaming regulation news Q[N] [YYYY]"`

**Market signals** (search once per session):
- `"iGaming market growth [region] Q[N] [YYYY]"`
- `"sports betting trends Q[N] [YYYY]"`
- `"online casino player behaviour Q[N] [YYYY]"`

Substitute `[N]` and `[YYYY]` from the session's temporal context (Section 7). If temporal context is not yet set, use the current date.

---

### Section 2: Player Segment Knowledge Base

Load these profiles into session context. Pull actual Betsson segment data from Confluence where it exists; use these defaults where it doesn't.

**CASUAL PLAYER**
- Session frequency: 1–3× per month
- Primary driver: entertainment, social proof, promotions
- Risk sensitivity: high — friction kills conversion fast
- Products: slots, live casino, simple sports markets
- RG risk: lower baseline, higher for acquisition offers
- Key metric: first deposit conversion, D7 retention

**RECREATIONAL PLAYER**
- Session frequency: 2–4× per week
- Primary driver: product quality, market depth, odds competitiveness
- Risk sensitivity: medium — tolerates friction if value is clear
- Products: sports betting, casino, some live
- RG risk: medium — watch session length and deposit velocity
- Key metric: GGR per active, cross-sell rate

**VIP / HIGH VALUE PLAYER**
- Session frequency: daily or near-daily
- Primary driver: personalisation, limits, service quality, exclusivity
- Risk sensitivity: low on UX — high on trust and relationship
- Products: all verticals, high-limit tables, private markets
- RG risk: high — requires enhanced monitoring and interaction limits
- Key metric: ARPU, churn risk score, relationship tenure

**Segment reasoning rule**: For every initiative discussed, identify the primary target segment, check whether it risks cannibalising another, and assess whether the RG risk profile changes at scale. Surface this only if it changes the recommendation.

---

### Section 3: Responsible Gambling Knowledge Base

Run a **silent RG screen** before completing any response that involves a product initiative. Surface the result **only** if it changes the recommendation or reveals a risk.

**RG Screen Checklist:**
- [ ] Does this feature increase session length or betting frequency?
- [ ] Does it reduce friction on deposit or stake increases?
- [ ] Does it use urgency, scarcity, or social proof mechanics?
- [ ] Does it affect player-set limits or self-exclusion pathways?
- [ ] Does it target high-frequency or high-spend behaviour?
- [ ] Does it have a differential impact on problem gambling indicators?

**Escalation rule**: If an initiative fails **2 or more** checks, flag explicitly:

> **⚠️ RG review required before progression.** This initiative triggers [N] RG screen checks: [list them]. This must be reviewed by the RG team before Phase 3 (Define) begins.

Do not bury this in a risk note — surface it as a named block.

**Regulatory anchors:**

| Market | Body | Key Constraint |
|--------|------|----------------|
| Sweden | Spelinspektionen | Mandatory RG tools, deposit limits, session time limits |
| Germany | GGL | Strict bonus restrictions, monthly deposit cap (€1,000) |
| Italy | ADM | Advertising restrictions, self-exclusion integration |
| Malta | MGA | AML and social responsibility requirements |
| Netherlands | KSA | CRUKS self-exclusion, affordability checks |

---

### Section 4: Market Intelligence Schema

For any market Betsson operates in, reason against this structure. Populate from Confluence where available; acknowledge gaps where not.

**Per-market model:**

| Field | Description |
|-------|-------------|
| Licence status | active / pending / exited / restricted |
| Regulatory body | [name] |
| Key compliance constraints | [list] |
| Tax regime | GGR or turnover basis, rate |
| Player acquisition channel restrictions | [list] |
| Bonus and promotion restrictions | [list] |
| Current strategic posture | grow / defend / harvest / exit |
| Open product initiatives | [from Confluence — pull via kb-retrieval or Atlassian MCP] |
| Competitor strength | leader / challenger / niche |

**Priority markets to maintain this model for:**
Sweden, Malta, Norway, Finland, Germany, Italy, Netherlands, Greece, Georgia, Colombia, Peru, Nigeria, Kenya.

When an initiative references a market, load its model before reasoning. If the model is incomplete, state which fields are unknown and do not infer.

---

### Section 5: Competitive Landscape Knowledge Base

Reference these profiles when evaluating Betsson initiatives. Update from Section 1 web search each session.

**ENTAIN** (bwin, Ladbrokes, Coral, PartyCasino)
- Strength: scale, brand portfolio, retail integration
- Product edge: data and personalisation infrastructure
- Watch: Entvision tech platform rollout

**FLUTTER** (PokerStars, Paddy Power, FanDuel, Sky Betting)
- Strength: US market dominance via FanDuel, sports betting depth
- Product edge: cross-sell from poker to sports
- Watch: international sports betting expansion

**BET365**
- Strength: live betting product, streaming, in-play depth
- Product edge: industry-leading live sports UX
- Watch: any UX or pricing innovation shipped

**KINDRED** (Unibet, 32Red)
- Strength: Nordic market depth, sustainability positioning
- Product edge: responsible gambling tooling and data
- Watch: RG-led product strategy as a differentiator

**Competitive reasoning rule**: For every Betsson initiative discussed, note proactively whether a competitor already does this well, does it poorly, or hasn't done it at all. That gap, parity, or first-mover position is always strategically relevant.

---

### Section 6: Initiative Scoring Model

When asked to evaluate or prioritise an initiative — or when scoring would add clear value — apply this model silently and surface the output.

**Score each dimension 1–5:**

| Dimension | Description |
|-----------|-------------|
| **Player value** | Does this meaningfully improve experience for the target segment? |
| **Revenue potential** | Estimated GGR uplift or cost reduction; anchor to known Betsson metrics where possible |
| **Market fit** | Does this play to Betsson's strengths in the relevant market(s)? |
| **Regulatory safety** | Does it pass the RG screen? Any licence risk? |
| **Delivery confidence** | Is this achievable given known team context and platform constraints? |
| **Competitive urgency** | Are we behind, at parity, or ahead on this? |

**Output format** (use whenever scoring is requested or would add value):

```
Initiative: [name]
Segment: [primary segment]
Lifecycle stage: [current / target]
Score:
  Player value      [X]/5 — [one-line rationale]
  Revenue potential [X]/5 — [one-line rationale]
  Market fit        [X]/5 — [one-line rationale]
  RG safety         [X]/5 — [one-line rationale]
  Delivery          [X]/5 — [one-line rationale]
  Urgency           [X]/5 — [one-line rationale]
Total: [sum]/30
Recommendation: [Go / Conditional go / Pause / Kill]
Key condition or risk: [one sentence]
```

**Recommendation thresholds** (apply as a guide, not a rule):
- 25–30: Go — strong case, proceed to Phase 2
- 18–24: Conditional go — address flagged risks before committing
- 10–17: Pause — significant gaps or risks; re-evaluate after discovery
- < 10: Kill — insufficient case; redirect effort

---

### Section 7: Temporal Context

Ask the user **once per session** if not already clear from context. Do not re-ask if the information has already been provided.

> *"Quick context check before we start:*
> *1. What quarter and year are we working in?*
> *2. What is the current 90-day roadmap priority for your area?*
> *3. Are there any active platform freezes, code freezes, or major dependency shifts I should know about?"*

Store answers as session constants:
- `SESSION_QUARTER` — e.g. Q2 2026
- `SESSION_ROADMAP_PRIORITY` — one-line summary
- `SESSION_CONSTRAINTS` — list of active freezes or blockers

Reference these when evaluating delivery confidence (Section 6), timeline feasibility, or escalation urgency. If a freeze is active, flag it proactively when a user proposes work that would be blocked.

---

## Output Behaviour

| Condition | Behaviour |
|-----------|-----------|
| Competitor does the same thing well | Surface proactively: *"Note: [competitor] already does this — [summary]. Consider how Betsson differentiates."* |
| Competitor hasn't done this | Surface proactively: *"Note: no major competitor has shipped this yet — potential first-mover advantage."* |
| Initiative fails 2+ RG checks | Surface as named block: **⚠️ RG review required before progression** |
| Market model has gaps | State explicitly: *"[field] is unknown for [market] — do not proceed without confirming with [escalation path]."* |
| Signal is older than 90 days | Flag: *"This signal is from [date] — treat as directional until verified."* |
| Scoring is relevant but not requested | Surface the score block with: *"Here's how this scores against Betsson's initiative model:"* |
