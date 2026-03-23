---
phase: inception
steps: 8
---

# Phase 1: Inception

Goal: planning, requirements gathering, and architectural decisions. Determine WHAT to build and WHY.

KB note: `ai-governance/overconfidence-prevention.md` and `ai-governance/no-assumption-policy.md` are critical during this phase.

Workspace Detection and Reverse Engineering are handled by the orchestrator before this workflow is invoked. Their artifacts are available at:
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/workspace-detection.md`
- `{LOCAL_REPO_PATH}/initiatives/_project/reverse-engineering/` (if brownfield)

## Step Chain

1. Load `1-technical-scoping/1-technical-scoping.md` -- engineering discovery (OPTIONAL, user opt-in)
2. Load `2-onboarding-presentations/2-onboarding-presentations.md` -- stakeholder presentations (CONDITIONAL)
3. Load `3-requirements-analysis/3-requirements-analysis.md` -- requirements gathering (ALWAYS, adaptive depth)
4. Load `4-user-stories/4-user-stories.md` -- user story development (CONDITIONAL)
5. Load `5-bdd-specification/5-bdd-specification.md` -- BDD scenario specification (CONDITIONAL)
6. Load `6-workflow-planning/6-workflow-planning.md` -- execution plan (ALWAYS)
7. Load `7-application-design/7-application-design.md` -- component and service design (CONDITIONAL)
8. Load `8-units-generation/8-units-generation.md` -- work unit decomposition (CONDITIONAL)

## Phase Gate

User must approve the execution plan and any application design artifacts before Phase 2 begins.

Present:
- **A**: Approve and proceed to Construction
- **B**: Request changes
