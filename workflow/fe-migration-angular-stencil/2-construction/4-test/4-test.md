---
step: test
subagent: true
checkpoint: initiatives/{INITIATIVE_NAME}/artefacts/2.4-test-report.md
---

## Inputs

- Implemented + built source files (from 2-implement, 3-build)
- `1.4-requirements.md` (for coverage mapping)

## Guidance

Load `instructions/unit-testing-conventions.md` and `instructions/storybook-conventions.md`.

### 1. Unit Tests

- Create `*.spec.tsx` for each component
- Mock services, Event Bus, and external dependencies
- Cover: rendering, props, events, state changes, error states, edge cases
- Use `data-test-id` on key elements for selectors

### 2. Storybook Stories

- Create `*.stories.ts` for each component
- Use `createComponent()` utility
- Include stories: Default, Variants, Empty State, Error State, Loading State
- Include full BFF response envelope in mocks
- Add `design` parameter with Figma URL if available

### 3. Run Tests

Execute test suite. Fix any failures. Record coverage metrics.

### 4. Checkpoint

Save test summary to `initiatives/{INITIATIVE_NAME}/artefacts/2.4-test-report.md`.

## Outputs

- `*.spec.tsx` test files
- `*.stories.ts` story files
- `2.4-test-report.md` checkpoint

## Gate

None -- continue to review step.
