---
name: generate-tests
description: Generates comprehensive test suites for UI components — unit tests, E2E/integration tests, and accessibility validation — using local repository testing framework and conventions.
execution: inline
scope: shared
version: v0.1
last-updated: 24/04/2026
---

# Generate Tests

Creates thorough test coverage for UI components following the local repository's testing framework and conventions. Framework-agnostic — testing patterns and tools are determined by local instruction files.

---

## When to Use

- After a component has been implemented and code-reviewed
- When adding test coverage to an existing component
- As part of any implementation workflow before raising a PR

---

## Inputs

- Component file paths
- Mock data (from extract-and-generate-mock-data skill output)
- Local repository instruction files (`.github/instructions/` or equivalent)
- JIRA acceptance criteria (for test scenario coverage)
- Figma analysis output (for variant and state coverage)

---

## Instructions

### 1. Load Local Instruction Files

Before writing any tests, read all relevant local instruction files to understand:
- Testing framework and tooling (e.g. Jest, Vitest, Playwright, Cypress, Testing Library)
- Testing file naming and location conventions
- Required test types (unit, E2E, integration, visual regression)
- Mocking patterns (event bus, services, API calls)
- Coverage expectations

### 2. Unit Tests

- Test component rendering with default props
- Test each prop and variant
- Test all events (emitted and handled)
- Test conditional rendering logic
- Test edge cases (empty, null, long content)
- If helper classes exist, write dedicated unit tests for them
- Use realistic content from mock data

### 3. E2E / Integration Tests

- Test complete user interaction workflows
- Test keyboard navigation and focus management
- Test responsive behaviour at defined breakpoints
- Test with assistive technology simulation where applicable
- Test component integration with parent components or services
- Test async states (loading → success, loading → error)

### 4. Accessibility Validation

- Test WCAG 2.1 AA compliance
- Verify keyboard navigation works end-to-end
- Check focus indicators are visible and correct
- Test ARIA attributes and roles
- Test screen reader compatibility where tooling supports it

### 5. Performance Checks

- Verify no unnecessary rerenders (where applicable to the framework)
- Validate event listener cleanup (no lingering listeners after component unmount/disconnect)
- Test proper use of list keys or equivalent optimisation patterns

### 6. Self-Validate

- Review all generated test files against local instruction patterns
- Verify test coverage meets local repository standards
- Ensure all component variants and states are tested
- Fix any non-compliance before finalising

---

## What NOT to Do

- ❌ Skip unit tests for helper classes or utility functions
- ❌ Skip E2E tests for user-interactive components
- ❌ Forget accessibility validation
- ❌ Skip testing event listener cleanup / memory safety

---

## Output

- Test files at canonical paths per local repository structure
- Coverage of all variants, states, and interactions from JIRA acceptance criteria
- Accessibility validation results
- Summary of test coverage with any gaps noted
