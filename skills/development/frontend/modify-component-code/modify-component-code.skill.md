---
name: modify-component-code
description: Modifies existing UI component code based on updated Figma designs or JIRA requirements, preserving existing behaviour while applying targeted changes using local repository conventions.
execution: inline
scope: shared
version: v0.1
last-updated: 24/04/2026
dependencies:
  mcps:
  - mcps/figma.md
  - mcps/atlassian.md
---

# Modify Component Code

Updates an existing UI component based on changed Figma designs or updated JIRA requirements. Framework and design system conventions are determined by the local repository's instruction files.

---

## When to Use

- When a Figma design has been updated and the existing component needs to reflect changes
- When new acceptance criteria or variants are added to an existing JIRA ticket
- When a component needs to be extended (new props, states, or variants) without being rebuilt from scratch

---

## Inputs

- Existing component file paths
- JIRA ticket key (updated ticket or change request)
- Figma design URL (updated design, with node-id)
- Output from JIRA analysis (if applicable)
- Output from Figma analysis (if applicable)
- Local repository instruction files (`.github/instructions/` or equivalent)

---

## Instructions

### 1. Load Local Instruction Files

Before modifying any code, read all relevant local repository instruction files to understand:
- Target framework conventions
- Design token naming and usage
- Component structure rules
- Breaking change policy for public components

### 2. Understand the Delta

Identify exactly what has changed before touching any code:
- Compare updated JIRA requirements against the current implementation
- Compare updated Figma design against the current component (use Figma MCP — metadata and screenshot only, not generated code)
- Produce a change summary: what is added, removed, or modified

### 3. Check for Breaking Changes

For any publicly exposed component API (props, events, slots, methods):
- Identify if any changes remove, rename, or alter the signature of existing public API
- If breaking changes are required: document them, flag for review, follow local breaking change policy before proceeding

### 4. Apply Changes (Build-First)

> ⚠️ Do not use Figma-generated code to drive the implementation. Build from design understanding, then verify.

1. Apply only the changes identified in the delta — do not refactor unrelated code
2. Update design token usage as needed (no hardcoded values)
3. Update documentation to reflect changes
4. Update variant prop values, CSS, and tests if affected

### 5. Verify with Figma Code (after changes)

Only after implementing the changes:
- Request Figma-generated code for the modified component
- Compare implementation against Figma output
- Identify any gaps still remaining

### 6. Self-Validate

- Review modified files against local instruction files
- Confirm no regressions in existing behaviour
- Check that tests still pass (or update them to reflect the changes)

---

## What NOT to Do

- ❌ Refactor code beyond the scope of the requested change
- ❌ Introduce breaking changes without following the local breaking change policy
- ❌ Use Figma-generated code as the implementation source
- ❌ Apply hardcoded design values — always use tokens

---

## Output

- Modified component files at their existing canonical paths
- Updated documentation reflecting the changes
- Change summary (what was added / removed / modified)
- Breaking change notice (if applicable)
- Verification gaps from Figma comparison (if any)
