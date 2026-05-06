---
phase: quality
steps: 2
---

# Phase 4: Quality

Goal: generate comprehensive tests and Storybook stories, then optionally run a final code review before the PR.

## Step Chain

1. Load `1-tests-and-stories/1-tests-and-stories.md` — create unit tests, E2E tests, and Storybook stories
2. Load `2-final-code-review/2-final-code-review.md` — final validation of the complete implementation *(optional but recommended)*

## Phase Gate

Step 1 is mandatory:
- Tests & Stories: **all tests pass**

Step 2 is optional:
- Final Code Review: all issues resolved *(recommended before PR)*

Present:
- **A**: Tests pass, skip final review — component ready for PR
- **B**: Tests pass, run final review — load Step 2
- **C**: Tests fail — fix component bugs, re-run Step 1
