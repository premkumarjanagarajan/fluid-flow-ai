---
name: hypothesis-validation
description: Converts a flagged assumption into a structured validation plan — defining what to test, how to test it, what success looks like, and when to act on the result.
execution: inline
scope: workflow-local
version: 1.0
last-updated: 2026-05-22
---

# Hypothesis Validation

Takes a specific assumption — typically a 🔴 or 🟡 item from the assumption map — and produces a concrete validation plan. Covers both lightweight discovery validation (user interviews, data pull, spike) and structured experiment design (A/B test, controlled rollout).

---

## When to Run

- After `assumption-mapping` produces 🔴 Critical items the user has chosen to validate (not accept as risk)
- When the user asks "how do we test this?", "can we validate this assumption?", "should we run an A/B test?"
- Before committing to a solution that depends on an unvalidated belief
- During Define phase when a success criterion relies on an unproven assumption

---

## Prerequisites

- A specific assumption to validate — either from `ASSUMPTION_RISKS[]` or provided by the user
- A rough sense of whether this is a problem-space or solution-space assumption (helps determine the right validation method)

---

## Execution

### Step 1: State the Assumption Clearly

If the assumption isn't already clearly stated, ask the user to express it in this form:

> *"We believe [X] will happen / is true. If we're wrong, [consequence]."*

Example: *"We believe Casino users abandon the bonus flow at step 3 because the CTA is unclear. If we're wrong, fixing the CTA won't reduce drop-off."*

Restate the assumption in this form before proceeding. Confirm with the user.

---

### Step 2: Classify the Assumption Type

| Type | Definition | Typical Validation Method |
|------|------------|--------------------------|
| **Problem assumption** | We believe users have this problem or behave this way | User interviews, session recordings, analytics deep-dive |
| **Solution assumption** | We believe this feature/change will solve the problem | Prototype test, usability study, controlled experiment |
| **Market assumption** | We believe this market/segment will respond this way | Market data, compliance check, pilot in one market |
| **Technical assumption** | We believe the system can support this | Engineering spike, feasibility review, proof of concept |
| **Business assumption** | We believe this will produce a measurable business outcome | A/B test, staged rollout with hold-out group |

Ask if unsure: *"Is this a belief about the problem (user behaviour), the solution (whether it works), or the expected business outcome?"*

---

### Step 3: Recommend a Validation Method

Based on the assumption type, recommend the appropriate method:

#### Option A — Qualitative Validation (fast, lightweight)
Use when: the assumption is about user behaviour, motivations, or pain points

```markdown
### Validation Plan — Qualitative

**Method:** [User interviews / Session replay review / Support ticket analysis / Survey]
**Who to involve:** [UX researcher / PO / CS team]
**What to ask / look for:**
- [Question or signal 1]
- [Question or signal 2]
**Sample:** [Number of users / sessions to review]
**Timeline:** [Estimated effort — e.g. 3 interviews over 1 week]

**What confirms the assumption:**
[What you'd need to hear/see to treat this as validated]

**What disproves it:**
[What you'd hear/see that means the assumption is wrong]
```

#### Option B — Data Validation (evidence-based)
Use when: analytics or existing data can answer the question without new research

```markdown
### Validation Plan — Data

**Metric to pull:** [Specific metric, funnel step, or cohort]
**Tool:** [Power BI / Qlik / Analytics platform]
**Time period:** [e.g. last 90 days]
**Segmentation:** [Market / user type / device]

**What confirms the assumption:**
[Threshold or pattern that validates the belief — e.g. "Drop-off at step 3 > 40% across all markets"]

**What disproves it:**
[Data pattern that means the assumption is wrong]

**Data owner:** [Who to request this from]
```

#### Option C — Experiment (A/B Test or Controlled Rollout)
Use when: the assumption is about whether a change produces a measurable outcome

```markdown
### Validation Plan — Experiment

**Hypothesis:**
We believe that [change] will cause [measurable outcome] for [user segment].

**Control:** [Current state / behaviour — what users see today]
**Variant:** [Proposed change — what the test group sees]

**Primary metric:** [The single metric that decides the outcome]
**Secondary metrics:** [Supporting signals to watch]

**Sample guidance:**
- Minimum detectable effect: [% change we care about — e.g. +5% conversion]
- Confidence level: 95% (standard)
- Estimated sample size: [calculated or "requires Data team input"]
- Estimated duration: [days/weeks at current traffic volume]

**Statistical significance threshold:** p < 0.05

**Rollout approach:**
- [ ] Feature flag controlled
- [ ] Market: [which market(s) to test in first]
- [ ] Exposure: [% of eligible users in test]

**Decision framework:**
| Result | Action |
|--------|--------|
| Variant significantly outperforms control | Ship to 100% |
| No significant difference | Investigate further or kill |
| Control significantly outperforms variant | Kill variant — assumption is wrong |
| Inconclusive (underpowered) | Extend duration or increase sample |

**Rollback trigger:**
[Signal that stops the experiment early — e.g. "NGR drop > 10% in variant group"]

**Owner:** [Who runs and monitors the experiment]
**Review date:** [When results will be read]
```

#### Option D — Technical Spike
Use when: the assumption is about technical feasibility

```markdown
### Validation Plan — Technical Spike

**Question to answer:**
[Specific technical question — e.g. "Can CW support multi-step wagering with a real-time eligibility check?"]

**Spike scope:**
[What engineering should explore — time-boxed, no production code]

**Timebox:** [e.g. 2 days]
**Output:** [What the spike should produce — e.g. "Go/no-go recommendation with estimated effort"]

**Owner:** [Engineering lead or squad]
**Decision date:** [When the spike result feeds back into the product decision]
```

---

### Step 4: Present the Validation Plan

Output the appropriate plan as a `[DRAFT]` and ask:

> *"Does this validation plan work for you? Once confirmed, I'd recommend completing this before we finalise the Feature Brief success criteria — otherwise we're writing success criteria for an unvalidated assumption."*

---

### Step 5: Link Back to the Session

After the plan is confirmed:

- If the assumption was in `ASSUMPTION_RISKS[]`, update its status from "Being validated" to the plan reference
- If the validation is blocking progress on the Feature Brief, surface this explicitly: *"This assumption is critical enough that I'd recommend pausing the Feature Brief until the validation is complete. Do you want to proceed with a risk-accepted placeholder, or pause?"*

---

## Outputs

| Output | Format | Description |
|--------|--------|-------------|
| Validation plan | Inline `[DRAFT]` | Method-appropriate plan with owner, timeline, and decision framework |
| Updated `ASSUMPTION_RISKS[]` | Session variable | Assumption status updated to "Validation plan in place" |

---

## Rules

- Never recommend skipping validation for a 🔴 Critical assumption without the user explicitly accepting the risk
- The primary metric for an experiment must be measurable and agreed before the experiment runs — never define it after
- A rollback trigger is mandatory for any experiment touching live campaign logic, wallets, or regulated markets
- Never set a success threshold of "any improvement" — require a minimum detectable effect
- If data validation is recommended, always name the data owner — do not leave it unassigned
