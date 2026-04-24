---
name: modify-component-code
description: Modifies an existing UI component safely, enforcing breaking-change detection for public components in microfrontend or library contexts. Creates versioned components when props/interface changes would break consumers.
execution: inline
scope: shared
version: v0.2
last-updated: 24/04/2026
dependencies:
  mcps:
  - mcps/figma.md
  - mcps/atlassian.md
---

# Modify Component Code

Modifies an existing UI component following local repository conventions, with strict safety rules to protect consumers in microfrontend and library contexts.

---

## When to Use

- When a JIRA task, Figma update, or user request requires changing an existing component rather than creating a new one
- When existing component discovery (from `generate-component-code` or `component-discovery`) has identified the component to be updated

---

## Inputs

- Target component file path(s)
- Description of the required change (from JIRA, Figma analysis, or user instruction)
- Output from JIRA analysis (optional but recommended)
- Output from Figma analysis (optional but recommended)
- Local repository instruction files (`.github/instructions/` or equivalent)

---

## Instructions

### Step 1 - Load Local Instruction Files

Before making any changes, read all relevant local repository instruction files. These define:
- Framework and component model (StencilJS, React, Vue, Angular, Web Components, etc.)
- Component versioning conventions
- Breaking-change policy
- CSS / styling approach
- Documentation format requirements

### Step 2 - Determine Component Visibility (Public or Private)

This check is **mandatory** before any modification that touches the component's props, events, slots, or any other part of its public interface.

Run the following checks in order. Stop as soon as a definitive answer is found.

#### 2a. Inspect Component Source Code

Search the component file for explicit visibility markers:

- `@public` / `@private` JSDoc annotations
- Exported vs. non-exported declarations
- Comments such as `// public API`, `// internal`, `/* @internal */`
- Framework-specific patterns (e.g. StencilJS `@Prop()` exposed on the element vs. internal state)

If a clear **public** or **private** indicator is found -> record the result and skip 2b and 2c.

#### 2b. Inspect Stories File

If no clear marker was found in the source, locate the component's Storybook (or equivalent) stories file and look for:

- Story metadata: `status: 'public'`, `status: 'private'`, `access: 'internal'`
- Tags or decorators indicating the component is experimental, stable, deprecated, or internal
- Story title namespace hints (e.g. `Internal/MyComponent` vs. `Components/MyComponent`)

If a clear indicator is found -> record the result and skip 2c.

#### 2c. Ask the User

If neither the source code nor the stories file provided a clear answer, **stop and ask the user**:

> "I could not determine whether **[ComponentName]** is a public or private component. Please confirm:
> - **Public** - it is consumed by other applications, microfrontends, or distributed as part of a library.
> - **Private** - it is only used internally within this single application or feature."

Do **not** proceed with interface-affecting changes until this is confirmed.

---

### Step 3 - Classify the Change

Determine whether the requested modification is a **breaking change** to the component's public interface:

| Change Type | Breaking? |
|---|---|
| Adding a new optional prop with a default value | No |
| Adding a new required prop (no default) | **Yes** |
| Removing an existing prop | **Yes** |
| Renaming an existing prop | **Yes** |
| Changing a prop's type in an incompatible way | **Yes** |
| Changing a prop's default value | **Potentially** - flag for review |
| Removing an existing event, slot, or CSS variable | **Yes** |
| Adding new events, slots, or CSS variables | No (additive) |
| Changing internal logic / styling only | No |

If the change is **not breaking**, or the component is **private** -> skip to [Step 5 - Implement the Change](#step-5--implement-the-change).

If the change is **breaking** and the component is **public** -> continue to Step 4.

---

### Step 4 - Handle Breaking Changes on Public Components

Public components must **never have their existing interface broken**. Follow this versioning protocol:

#### 4a. Determine the Next Version Number

Scan the codebase for existing versioned files of this component:

```
MyComponent.tsx         -> v1 (current, implicit)
MyComponent_v2.tsx      -> v2
MyComponent_v3.tsx      -> v3  <- next would be v4
```

Determine the next version suffix (e.g. `_v2`, `_v3`, `_v4`, ...).

#### 4b. Create the New Versioned Component

- Copy the current component to a new file: `[ComponentName]_vN.[ext]`
- Apply the requested breaking changes to the **new** versioned file only
- Update the component tag name / class name / display name to include the version suffix:
  - Web Components / StencilJS: `my-component` -> `my-component-v2`
  - React / Vue: `MyComponent` -> `MyComponent_v2`
- Update all internal imports, styles, and documentation references within the new file
- Create or update the stories file for the new version

#### 4c. Mark the Previous Version as Deprecated

In the **original** component file, add deprecation markers:

Add a `@deprecated` JSDoc block at the top of the component class or function:

```ts
/**
 * @deprecated
 * This component is deprecated. Use `MyComponent_v2` instead.
 * It will be removed in a future major release.
 */
```

If the framework supports it, emit a runtime deprecation warning on mount or construction:

```ts
// Inside constructor / connectedCallback / useEffect / onMounted:
console.warn('[MyComponent] is deprecated. Please migrate to MyComponent_v2.');
```

In the stories file for the old component, mark it as deprecated or move it to an `Internal/` or `Deprecated/` namespace.

#### 4d. Produce a Migration Note

After creating the versioned component, output a migration summary:

```
## Migration: MyComponent -> MyComponent_vN

**Reason**: [describe the breaking change]

**Changed interface**:
- Prop `oldPropName` -> renamed to `newPropName`
- Prop `removedProp` -> removed; use `alternativeProp` instead
- Event `old-event` -> renamed to `new-event`

**Steps for consumers**:
1. Replace `<my-component>` with `<my-component-vN>`
2. Rename prop `oldPropName` to `newPropName`
3. [additional steps as needed]
```

---

### Step 5 - Implement the Change

With visibility confirmed and versioning handled (if required), implement the modification:

1. Apply only the changes identified in the delta - do not refactor unrelated code
2. Use design tokens - no hardcoded values
3. Update component documentation to reflect the change
4. Update or add tests as required by local conventions
5. If a Figma design was updated, verify the implementation matches using Figma analysis output (metadata and screenshot only - not generated code)

### Step 6 - Verify with Figma Code (if Figma was updated - after changes)

Only after implementing the changes:
- Request Figma-generated code for the modified component
- Compare implementation against Figma output
- Document any remaining gaps

### Step 7 - Self-Validate

Before finalising:
- Confirm no existing prop names, types, events, slots, or CSS variables were silently changed in a public component without following the versioning protocol
- Review against all loaded instruction files
- Confirm no regressions in existing behaviour

---

## What NOT to Do

- Do NOT modify a public component's interface without versioning - this breaks consumers
- Do NOT skip the visibility check - always determine public/private before touching the interface
- Do NOT guess visibility - if it cannot be determined from code or stories, ask the user
- Do NOT use hardcoded design values - always use tokens
- Do NOT forget to mark the old component version as `@deprecated`
- Do NOT refactor code beyond the scope of the requested change
- Do NOT ignore local instruction files - they define all conventions for this codebase

---

## Output

- Modified or newly versioned component file(s) at canonical paths per local repository structure
- Updated component documentation
- Deprecation markers added to the previous version (if a new version was created)
- Migration note (if a breaking change created a new version)
- Change summary (what was added / removed / modified)
- Figma verification gaps (if Figma was involved)
- Self-validation checklist result
