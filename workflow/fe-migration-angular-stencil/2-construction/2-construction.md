---
phase: construction
steps: 5
---

# Phase 2: Construction

Goal: implement the approved plan with verified builds.

KB note: `ai-governance/content-validation.md` applies to all generated code. `security/*.md` should be pre-loaded if the widget handles user data or authentication.

## Step Chain

1. Load `1-scaffold/1-scaffold.md` -- branch, scaffold, deps
2. Load `2-implement/2-implement.md` -- code generation
3. Load `3-build/3-build.md` -- verify compilation
4. Load `4-test/4-test.md` -- unit tests + Storybook stories
5. Load `5-review/5-review.md` -- requirements check + user local review

## Phase Gate

User must confirm local review passes before Phase 3.

Present:
- **A**: Approve and proceed to QA
- **B**: Request changes (loops back to relevant step)
