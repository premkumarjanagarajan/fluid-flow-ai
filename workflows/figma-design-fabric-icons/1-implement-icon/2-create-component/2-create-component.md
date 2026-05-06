---
step: create-component
subagent: false
---

## Inputs

- Icon name, category, and SVG path data from `1-setup/`
- Jira ID and branch name from `1-setup/`
- Naming conventions and component template from `.github/instructions/fabric-icons.instructions.md`

## Guidance

Apply all rules from `.github/instructions/fabric-icons.instructions.md` automatically.

### 4. Create Icon Component

Create the TSX file at the appropriate path:
- Generic: `icons/generic/{name}.tsx`
- Branded: `icons/branded/{name}.tsx`

Use the component template defined in the instructions file. Apply the SVG path data resolved in Step 1.

### 5. Update Models Enum

Add the new icon entry to:
```
types/models/fabric-icons-icon.models.ts
```

Follow the existing enum key naming convention.

### 6. Update Stories Enum

Add the new icon to the appropriate list in:
```
fabric-icons-icon.all.stories.ts
```
- Generic icons → `GenericIconList`
- Branded icons → `BrandedIconList`

## Auto-Generated Files

**Do not edit or commit `components.d.ts` files.** These are auto-generated and must be excluded.

## Completion

After completing all three sub-steps, summarise all files created/modified. Then present the Phase 1 gate prompt as defined in `1-implement-icon.md`.
