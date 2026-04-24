---
step: tests-and-stories
subagent: false
quality-gate: all tests pass
skills:
  - skills/development/frontend/generate-tests/generate-tests.skill.md
  - skills/development/frontend/generate-stories/generate-stories.skill.md
---

## Inputs

- Implemented and reviewed component files from Phase 3
- Content mocks from `2-discovery/2-content-mocks/`
- Local repository instruction files for testing and story tooling (e.g. `.github/instructions/storybook.instructions.md` or equivalent)

## Guidance

Load and execute both skills in sequence:

1. **Tests** — Load and execute `skills/development/frontend/generate-tests/generate-tests.skill.md`
   - Unit tests covering all props and events per local framework conventions
   - E2E tests covering user interactions
   - Accessibility validation (WCAG 2.1 AA)

2. **Stories** — Load and execute `skills/development/frontend/generate-stories/generate-stories.skill.md`
   - Stories using content mocks from Phase 2
   - Stories for all states: default, loading, error, empty, success
   - Variant coverage matching Figma design
   - Use the local story tooling (e.g. Storybook, Ladle, or equivalent)

## Quality Gate

| Criterion | Threshold |
|-----------|-----------|
| All tests | Pass |
| Story coverage | All states and variants covered |
| Accessibility | WCAG 2.1 AA compliant |

**PASS** → Proceed to `2-final-code-review/` (optional) or mark component ready for PR.  
**FAIL** → Fix component bugs or test issues. Re-run this step.

## Output

- Test files at canonical paths in the repository
- Story files at canonical paths in the repository
