---
name: generate-component-code
description: Generates production-ready UI component code from Figma designs and JIRA requirements, using Build-First approach and local repository instruction files to determine framework, tokens, and conventions.
execution: inline
scope: shared
version: v0.1
last-updated: 24/04/2026
dependencies:
  mcps:
  - mcps/figma.md
  - mcps/atlassian.md
---

# Generate Component Code

Generates a production-ready UI component from Figma design analysis and JIRA requirements. Framework, design system tokens, and coding conventions are entirely determined by the local repository's instruction files — this skill is framework agnostic.

---

## When to Use

- After validation (JIRA analysis, Figma analysis, alignment check), discovery, and mock data generation are complete
- When implementing a new UI component from a Figma design

---

## Inputs

- Output from JIRA analysis
- Output from Figma analysis
- Output from JIRA-Figma alignment check
- Output from component discovery
- Mock data file (from extract-and-generate-mock-data skill)
- Figma design URL with node-id
- Local repository instruction files (`.github/instructions/` or equivalent)

---

## Instructions

### Critical: Build-First, Verify-Later

> ⚠️ **Do not request Figma-generated code first.** Build from design understanding. Use Figma-generated code only after the component is built, to check for gaps.

### 1. Load Local Instruction Files

Before writing any code, read all relevant local repository instruction files. These define:
- Target framework (e.g. StencilJS, React, Vue, Angular, Web Components)
- Design token naming and usage patterns
- Component file structure and naming conventions
- CSS / styling approach (CSS custom properties, Tailwind, CSS Modules, etc.)
- Documentation format requirements
- Testing patterns

Discover instruction files from `.github/instructions/` or the local repository's equivalent directory. Load at minimum:
- General / root guidelines file
- Framework-specific patterns file
- CSS / styling standards file
- Documentation format file

### 2. Discover Nested Components

Before implementing, identify all nested components the new component will use:
- Search the codebase for existing components that match the nested roles
- For each found nested component: read its documentation to understand props, events, and slots
- Report any nested components that do not exist yet (they must be built first or the implementation plan adjusted)
- Verify nested component origin complies with local rules (same domain, shared library, etc.)

### 3. Build from Design Understanding

Using JIRA requirements, Figma analysis output, and the loaded instruction files:
1. Implement the component structure following local conventions
2. Apply design tokens from the local design system (no hardcoded values)
3. Implement responsive layouts using the approach defined in local instructions (e.g. container queries, media queries, CSS Grid)
4. Implement all required variants, states, and interactions
5. Add component documentation per local documentation format

### 4. Verify with Figma Code (after build)

Only now:
- Request Figma-generated code for the component
- Compare your implementation against Figma output
- Identify gaps or missed functionality
- Document findings in the component's documentation file

### 5. Self-Validate

Before finalising:
- Review generated code against all loaded instruction files
- Check for common violations per local conventions
- Fix any non-compliance

---

## What NOT to Do

- ❌ Request Figma-generated code before building the component
- ❌ Use hardcoded design values (colors, spacing, sizing) — always use tokens
- ❌ Ignore local instruction files — they define all conventions for this codebase
- ❌ Skip nested component discovery

---

## Output

- All component files created at canonical paths per local repository structure
- Component documentation written per local format
- Summary of Figma verification gaps (if any)
- Self-validation checklist result
