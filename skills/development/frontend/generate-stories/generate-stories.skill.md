---
name: generate-stories
description: Generates interactive component stories (Storybook or equivalent) using mock data, covering all variants and states, with event wiring and documentation integration.
execution: inline
scope: shared
version: v0.1
last-updated: 24/04/2026
dependencies:
  mcps:
  - mcps/figma.md
---

# Generate Stories

Creates interactive component stories for the local repository's story tooling (e.g. Storybook, Ladle, or equivalent). Covers all variants and states using mock data, with event wiring and documentation integration. Story patterns are determined by local instruction files.

---

## When to Use

- After a component has been implemented and code-reviewed
- When adding or updating Storybook / story documentation for an existing component
- As part of any implementation workflow before raising a PR

---

## Inputs

- Component file paths
- Mock data file (from extract-and-generate-mock-data skill output)
- Local repository instruction files (`.github/instructions/` or equivalent)
- Figma design URL (for design reference links)
- Component documentation file (e.g. `readme-notes.md` or equivalent)

---

## Instructions

### 1. Load Local Instruction Files

Before writing any stories, read all relevant local instruction files to understand:
- Story tooling and version (e.g. Storybook, Ladle)
- Story file naming and location conventions
- Story template patterns and utility functions (e.g. `createComponent()`)
- ArgTypes / controls configuration approach
- Event wiring patterns
- How to mock services or inter-component communication (e.g. event-bus)
- Documentation integration approach

### 2. Check for Mock Data

- Look for mock data output from the extract-and-generate-mock-data skill
- If found: use mock data objects for all story args — do not fabricate content
- If not found: extract content from component documentation or use realistic placeholders

### 3. Implement Stories

Following local story patterns:
1. Use the local story template / utility pattern
2. Configure argTypes / controls for all component props
3. Wire all component events to story actions (for interactive inspection)
4. Add Figma design links in story parameters if Figma URL is available
5. Integrate component documentation
6. Create a default story and additional stories for:
   - All primary variants (per Figma analysis output)
   - All key states: loading, error, empty, success
   - Edge cases: short content, long content
   - Interactive scenarios where applicable

### 4. Service / Communication Mocking

If the component communicates with external services or uses inter-component messaging (e.g. event-bus, Context API, Redux):
- Follow local instruction files for the correct mocking approach
- Provide interactive controls in the story to simulate responses (success / error)
- Do not leave mocked interactions without response callbacks

### 5. Self-Validate

- Review all generated story files against local story instruction patterns
- Verify all events are wired to actions
- Confirm all story variants use realistic content from mock data
- Ensure documentation is integrated
- Fix any non-compliance before finalising

---

## What NOT to Do

- ❌ Use fabricated or Lorem ipsum content when mock data is available
- ❌ Forget to mock external communication if the component depends on it
- ❌ Skip any design variant or component state
- ❌ Hardcode story data when a separate mock file should be used

---

## Output

- Story files at canonical paths per local repository structure
- Stories covering all variants, states, and edge cases
- Event wiring and documentation integration in place
- Figma design reference links added where applicable
