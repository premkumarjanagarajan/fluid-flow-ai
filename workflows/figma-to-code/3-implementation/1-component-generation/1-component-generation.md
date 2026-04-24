---
step: component-generation
subagent: false
quality-gate: component builds successfully
skill: skills/development/frontend/generate-component-code/generate-component-code.skill.md
---

## Inputs

- All Phase 1 and Phase 2 outputs
- Figma design URL with node-id
- Content mocks from `2-discovery/2-content-mocks/`
- **Local repository instruction files** (`.github/instructions/`) — load these first to determine:
  - Target framework (e.g. StencilJS, React, Vue, Angular)
  - Design token conventions
  - Component file structure and naming
  - CSS / styling approach
  - Documentation format

## Guidance

Load and execute `skills/development/frontend/generate-component-code/generate-component-code.skill.md`.

**Build-First rule — strictly enforced:**
1. Load all relevant local instruction files before writing any code
2. Discover nested components used by this component
   - Report any that do not yet exist
   - Read existing nested components' documentation to understand props/events
   - Verify usage patterns before building
3. Build the component from design understanding — do **NOT** use Figma's "Copy as code" output as the implementation
4. Apply design tokens, layout patterns, and conventions per local instructions
5. Create component documentation
6. **Only after the component is built**: compare with Figma code output for gap analysis

## Quality Gate

| Criterion | Threshold |
|-----------|-----------|
| Compilation | No errors |
| Styling | No errors, design tokens applied per local conventions |

**PASS** → Proceed to `2-code-review/`.  
**FAIL** → Fix errors. Review local instruction files. Re-run.

## Output

All component files created at their canonical paths in the repository.
