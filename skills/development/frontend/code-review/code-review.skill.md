---
name: code-review
description: Reviews UI component code, tests, and stories for compliance with local repository guidelines, design system standards, accessibility, and performance. Produces categorised findings with concrete remediation steps.
execution: inline
scope: shared
version: v0.1
last-updated: 24/04/2026
---

# Code Review

Performs a comprehensive code review of UI component implementation, tests, and stories. Guidelines, design system conventions, and framework patterns are determined by local repository instruction files — this skill is framework agnostic.

---

## When to Use

- After component code generation, before test and story generation (intermediate review)
- After tests and stories are generated (final review before PR)
- On-demand for any code quality check

---

## Inputs

- Component file paths (implementation, styles, tests, stories, documentation)
- Local repository instruction files (`.github/instructions/` or equivalent)
- Output files from earlier workflow phases (Figma analysis, JIRA analysis, alignment check) — for context

---

## Instructions

### 1. Load Local Instruction Files

Before reviewing any code, read all relevant local instruction files:
- General / root guidelines
- Framework-specific component patterns
- CSS / styling standards
- Documentation format requirements
- Testing patterns
- Story patterns (if reviewing stories)

### 2. Review Component Implementation

Check:
- Component structure and organisation order per local conventions
- Props, events, methods, and lifecycle hooks implemented correctly
- Encapsulation approach (Shadow DOM, CSS Modules, scoped styles, etc.) per local rules
- Render / template patterns and conditional rendering
- Inter-component communication patterns (event-bus, Context, props drilling, etc.)
- Code comments and documentation annotations

### 3. Review Styles

Check:
- Design token usage — no hardcoded color, spacing, or sizing values
- CSS variable / custom property policy compliance
- Responsive layout approach matches local conventions (container queries, media queries, Grid, etc.)
- No forbidden patterns per local CSS instructions
- Mobile-first approach where required

### 4. Review Tests

Check:
- Unit tests cover all props, variants, and states
- E2E / integration tests cover user interaction workflows
- Accessibility is validated (WCAG 2.1 AA)
- Edge cases (empty, error, long content) are tested
- Event listener cleanup / memory safety is tested

### 5. Review Stories (if applicable)

Check:
- Follows local story template patterns
- ArgTypes / controls configured correctly
- All component events wired to actions
- All variants and states covered
- Mock data used (not fabricated placeholders)
- Documentation integrated

### 6. Performance Review

Check:
- No unnecessary rerenders (where applicable)
- Event listener cleanup on component unmount / disconnect
- Efficient list rendering (key props or equivalent) where applicable
- No memory leak patterns

### 7. Breaking Change Detection (for public components)

- Identify if any public API (props, events, methods, slots) has been removed, renamed, or had its type changed
- If breaking changes exist: flag them explicitly, verify they follow the local breaking change policy, confirm documentation and migration guide are provided

### Findings Categorisation

Categorise every finding:
| Severity | Meaning |
|----------|---------|
| **Must Fix** | Blocks the PR — violates a hard rule in instruction files |
| **Should Fix** | Strong recommendation — risk of regression or guideline violation |
| **Consider** | Improvement opportunity — not blocking |

Provide for each finding:
- File path and location (line or section)
- What the issue is
- Why it matters (link to instruction file rule)
- Concrete remediation step

---

## What NOT to Do

- ❌ Approve hardcoded design values (colors, spacing, sizing)
- ❌ Approve missing event listener cleanup
- ❌ Approve components without tests
- ❌ Skip breaking change detection for public components
- ❌ Give vague feedback — always provide specific file location and remediation

---

## Output

- Findings report categorised by severity (Must Fix / Should Fix / Consider)
- Each finding with file location, issue, rationale, and remediation
- Breaking change summary (if applicable)
- Overall verdict: Approved ✅ / Changes Requested ❌
