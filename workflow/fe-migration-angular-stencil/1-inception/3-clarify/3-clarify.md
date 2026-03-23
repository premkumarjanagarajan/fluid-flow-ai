---
step: clarify
subagent: false
---

## Inputs

- `1.2-analysis-summary.md` (from 2-analyze)
- User-provided screenshots (desktop + mobile)

## Guidance

### 1. Request Screenshots

Ask the user for screenshots of the current widget:
- Desktop (standard review viewport)
- Mobile (standard review viewport)
- Figma link or design mockup is equally acceptable

If user cannot provide screenshots, proceed with code analysis but note which visual details could not be confirmed.

### 2. Surface Gaps

After reviewing analysis + screenshots, identify gaps grouped by category:

- **Data/Props**: unclear data sources, missing contracts, ambiguous state management
- **Visual/Layout**: unconfirmed responsive behaviour, unclear states (loading, empty, error)
- **Behaviour**: event handling ambiguities, feature flag dependencies, config dependencies
- **Out-of-scope**: functionality that should not be migrated

Present all gaps as a numbered list. Max 10 questions. Be specific -- include Angular file name and line where ambiguity was found.

### 3. Wait for Answers

Do not make assumptions. Every gap must be explicitly resolved by the user.

## Outputs

- Resolved gaps (stored in session context for next steps)
- Confirmed visual structure from screenshots

## Gate

STOP until all gaps are answered. If no gaps exist, skip directly to next step.
