---
phase: discovery
steps: 2
---

# Phase 2: Discovery

Goal: confirm the component doesn't already exist in the codebase and gather all content requirements before implementation starts.

## Step Chain

1. Load `1-component-discovery/1-component-discovery.md` — scan for existing components, validate placement and naming
2. Load `2-content-mocks/2-content-mocks.md` — extract all text content and generate typed mock data structures

## Phase Gate

Both gates must pass before Phase 3 begins:
- Component Discovery: **no duplicates** OR extend decision explicitly justified
- Content Mocks: **coverage complete** across all states

Present:
- **A**: All gates pass — proceed to Phase 3 (Implementation)
- **B**: Duplicate found without justification — escalate to Developer + Architect before proceeding
- **C**: Content incomplete — return to Designer + PO to fill gaps, then re-run Step 2
