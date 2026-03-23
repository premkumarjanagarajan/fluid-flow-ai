---
phase: construction
steps: 7
---

# Phase 2: Construction

Goal: implement the approved plan through per-unit functional design, NFR analysis, infrastructure design, code generation, build and test.

KB note: `ai-governance/content-validation.md` applies to all generated code. `security/*.md` should be pre-loaded if the feature handles user data, authentication, or infrastructure changes.

## Step Chain

1. Load `1-functional-design/1-functional-design.md` -- detailed business logic design per unit
2. Load `2-nfr-requirements/2-nfr-requirements.md` -- non-functional requirements analysis
3. Load `3-nfr-design/3-nfr-design.md` -- non-functional requirements design
4. Load `4-infrastructure-design/4-infrastructure-design.md` -- infrastructure and deployment design
5. Load `5-code-generation/5-code-generation.md` -- code generation per unit
6. Load `6-build-and-test/6-build-and-test.md` -- build verification and test execution
7. Load `7-onboarding-update/7-onboarding-update.md` -- update onboarding materials

## Per-Unit Loop

Steps 1-5 execute as a loop for each unit defined during Inception. Build and Test (step 6) and Onboarding Update (step 7) execute once after all units are complete.

## Phase Gate

User must confirm build passes and test coverage meets requirements before Phase 3.

Present:
- **A**: Approve and proceed to Operations
- **B**: Request changes (loops back to relevant step)
