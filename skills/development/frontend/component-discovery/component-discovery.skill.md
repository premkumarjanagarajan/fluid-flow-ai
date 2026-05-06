---
name: component-discovery
description: Searches the codebase for existing components before starting new development. Prevents duplication, identifies extension opportunities, audits nested component requirements, and validates placement rules.
execution: inline
scope: shared
version: v0.1
last-updated: 24/04/2026
---

# Component Discovery

Searches the codebase for existing components similar to the one being built. Prevents unnecessary duplication, identifies extension opportunities, validates placement, and documents all nested component requirements.

---

## When to Use

- After JIRA-Figma alignment check passes and before component code generation
- Whenever a new component is being considered

---

## Inputs

- Component name and description (from JIRA analysis and Figma analysis outputs)
- Codebase access
- Local repository structure documentation or instruction files

---

## Instructions

### 1. Search for Similar Components

Search across the codebase:
- By component name (exact and partial matches)
- By functionality description and UI pattern (button, card, dialog, accordion, etc.)
- In both public (design system / shared library) and private (domain-specific) locations

### 2. Analyse Similar Components Found

For each similar component discovered:
- Review its props, variants, and current functionality
- Identify whether the required new functionality fits within the existing component's scope
- Assess whether a new variant or extended prop could satisfy the requirement

### 3. Discover and Document Nested Components

Identify all components the new component will nest or compose:
- For each nested component: find its location, read its documentation, extract props / events / slots
- Check accessibility (public/private, same domain vs shared library)
- Document correct usage patterns from stories or documentation if available
- Verify nested components originate from an allowed source per local rules (same domain, shared library, etc.)

### 4. Make Recommendation

| Decision | When |
|----------|------|
| **Extend existing** | Functionality fits within the existing component's purpose; a new variant or prop would satisfy the requirement |
| **Create new** | Functionality is distinct, domain-specific, or extending would violate the existing component's scope |

Include:
- Placement recommendation (which layer/domain the component belongs to)
- Naming suggestion following local conventions
- List of required nested components with usage guidance

### 5. Verify Placement Rules

Confirm the recommended placement complies with local repository layer/domain rules (e.g. shared design system vs domain-specific microfrontend vs service layer).

---

## What NOT to Do

- ❌ Recommend creating a new component when extending an existing one would work
- ❌ Suggest placement without checking domain ownership rules
- ❌ Skip nested component analysis — missing nested components block implementation
- ❌ Recommend using nested components from disallowed sources

---

## Output

Structured discovery report containing:
- Search results (similar components found or not found)
- Extend-vs-create recommendation with reasoning
- Placement recommendation
- Full nested component list with props, events, slots, and usage patterns
- Any nested components that do not yet exist (flagged as blockers)
