---
name: jira-analysis
description: Analyzes JIRA tickets for clarity, completeness, and testable acceptance criteria. Provides a readiness score and blocks progression if quality is insufficient.
execution: inline
scope: shared
version: v0.1
last-updated: 24/04/2026
dependencies:
  mcps:
  - mcps/atlassian.md
---

# JIRA Analysis

Validates JIRA tickets for clear, complete, and testable requirements before development begins. Assesses acceptance criteria quality, identifies gaps, and provides a readiness score to prevent rework.

---

## When to Use

- Before starting any implementation work from a JIRA ticket
- As the first step in any Figma-to-code or feature development workflow
- When requirements quality needs to be assessed

---

## Inputs

- JIRA ticket key (e.g., `ARC-315`, `GX-1234`)
- Access to JIRA via Atlassian MCP

---

## Instructions

### 1. Ticket Completeness Assessment
- Verify title is clear and descriptive
- Check description explains WHAT needs to be built and WHY
- Validate issue type is correctly categorized (Story/Task/Bug)
- Confirm assignee and priority are set
- Check for user story format: "As a [user], I want [goal], so that [benefit]"

### 2. Requirements Clarity Analysis
- Extract all functional requirements from description
- Identify user interactions and behaviors
- Document edge cases, error states, loading states
- Verify responsive behavior requirements
- Check for missing scenarios

### 3. Acceptance Criteria Evaluation (CRITICAL)
- Count total number of acceptance criteria
- Rate quality of each criterion (Good ✅ / Needs Work ⚠️ / Missing ❌)
- Verify criteria are specific and measurable
- Check criteria are testable
- Ensure coverage of all scenarios

Good criteria format:
```
Given [context/state]
When [action/event]
Then [expected outcome]
```

### 4. Design & Documentation Links
- Verify Figma design link is present
- Check design shows all variants and states
- Validate supporting documentation links
- Confirm technical specs if needed

### 5. Feature Flag & Release Strategy
- Check feature flag name documented
- Verify rollout strategy defined
- Confirm target scope listed

### 6. Readiness Score

Score 1–10 based on:
| Dimension | Weight |
|-----------|--------|
| Acceptance criteria quality | 40% |
| Requirements clarity | 25% |
| Design link present | 15% |
| Feature flag / release strategy | 10% |
| Technical requirements | 10% |

**Threshold: 6+/10 required to proceed.**

| Score | Status | Action |
|-------|--------|--------|
| 8–10 | 🟢 Green | Proceed with development |
| 6–7 | 🟡 Yellow | Get clarifications, update ticket, then proceed if score ≥ 6 |
| <6 | 🔴 Red | Return for requirement refinement — do not proceed |

---

## What NOT to Do

- ❌ Proceed without testable acceptance criteria
- ❌ Accept vague requirements ("button should work")
- ❌ Skip validation if Figma design link is missing
- ❌ Assume missing information — flag it explicitly

---

## Output

Structured report containing:
- Ticket completeness summary
- Acceptance criteria table with quality ratings
- Score breakdown by dimension
- Final readiness score
- Recommendation (proceed / clarify / return for refinement)
- Blocking issues with specific questions to resolve
