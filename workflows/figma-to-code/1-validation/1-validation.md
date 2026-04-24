---
phase: validation
steps: 3
---

# Phase 1: Validation

Goal: validate the JIRA ticket quality, confirm the Figma design is implementation-ready, and verify alignment between both artefacts before any coding begins.

## Step Chain

1. Load `1-jira-analysis/1-jira-analysis.md` — assess ticket quality and completeness
2. Load `2-figma-design-analysis/2-figma-design-analysis.md` — assess design readiness and FDS compliance
3. Load `3-jira-figma-alignment/3-jira-figma-alignment.md` — cross-validate JIRA requirements against Figma design

## Phase Gate

All three quality gates must pass before Phase 2 begins:
- JIRA Analysis score: **6+/10**
- Figma Design readiness: **8+/10**
- Alignment sync score: **6+/10**

Present:
- **A**: All gates pass — proceed to Phase 2 (Discovery)
- **B**: One or more gates fail — address blocking issues and re-run failed step
