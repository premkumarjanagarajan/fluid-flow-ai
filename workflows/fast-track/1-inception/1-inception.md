---
phase: inception
steps: 4
---

# Phase 1: Inception

Goal: produce a complete specification, implementation plan, and quality analysis before any code is written.

KB note: `ai-governance/no-assumption-policy.md` is critical during this phase -- ask when uncertain, do not assume.

## Step Chain

1. Load `1-specify/1-specify.md` -- create or update the feature specification
2. Load `2-clarify/2-clarify.md` -- resolve ambiguities and surface hidden assumptions in the spec (always runs)
3. Load `3-plan/3-plan.md` -- create the implementation plan
4. Load `4-analyze/4-analyze.md` -- cross-artifact consistency analysis (spec vs plan)

## Phase Gate

User must approve the plan and analysis report before Phase 2 begins.

Present:
- **A**: Approve and proceed to Construction
- **B**: Request changes
