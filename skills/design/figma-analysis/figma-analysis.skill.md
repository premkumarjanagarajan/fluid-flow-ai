---
name: figma-analysis
description: Analyzes Figma designs for completeness, design token coverage, layout discipline, and component instance integrity. Provides a readiness score and blocks progression if design quality is insufficient.
execution: inline
scope: shared
version: v0.1
last-updated: 24/04/2026
dependencies:
  mcps:
  - mcps/figma.md
---

# Figma Analysis

Validates Figma designs against design system requirements before development begins. Analyzes design completeness, token coverage, layout implementation, and component instance integrity to prevent design issues from causing rework.

---

## When to Use

- After JIRA analysis, before starting implementation
- As part of any Figma-to-code workflow
- When assessing whether a design is ready for handoff

---

## Inputs

- Figma design URL with node-id
- Access to Figma via Figma MCP

---

## Instructions

> ⚠️ **Do not request Figma-generated code first.** Analyze metadata, screenshot, and design structure only. Generated code is only used later during verification after analysis is complete.

### 1. Component Identification
- Identify component type (button, input, card, accordion, etc.)
- Determine target domain based on functionality
- Assess complexity level (simple / medium / complex)
- Validate naming conventions per local repository rules

### 2. Layout Discipline (CRITICAL)
- Verify all responsive layouts use the local design system's layout mechanism (e.g. Auto Layout in Figma)
- Document flex-direction and justify/align settings
- Flag any grouped elements without layout constraints as a CRITICAL issue
- Check wrapping behavior for smaller container sizes

### 3. Design Token Coverage (CRITICAL)
- Verify ZERO non-tokenized style properties — every value must reference a design system token
- Confirm all colors, spacing, and typography are mapped to tokens defined in the local design system
- Verify all referenced tokens actually exist in the local CSS/token stylesheet

### 4. Component Instance Integrity (CRITICAL)
- Verify NO detached component instances
- Confirm all instances reference the design system component library
- Identify Figma-only layout wrappers (these become HTML markup, not new components)

### 5. Variant Analysis
- List all design variants shown
- Map variants to component props
- Verify all necessary states are covered (default, hover, focus, disabled, error, loading, empty, success)
- Identify missing variants

### 6. Responsive Behavior
- Document breakpoints needed
- Verify mobile/tablet/desktop variants exist where required
- Confirm mobile-first approach is feasible

### 7. Interactive States
- Check hover, focus, active, disabled states are defined
- Verify focus indicators for accessibility
- Document animation/transition requirements

### 8. Readiness Score

Score 1–10 based on:
| Dimension | Weight |
|-----------|--------|
| Layout discipline (Auto Layout or equivalent) | 20% |
| Design token coverage | 30% |
| Component instance integrity | 20% |
| Variant completeness | 15% |
| Interactive states | 10% |
| Documentation clarity | 5% |

**Threshold: 8+/10 required to proceed.**

| Score | Status | Action |
|-------|--------|--------|
| 8–10 | 🟢 Green | Proceed to implementation |
| <8 | 🔴 Red | Block — fix design issues before proceeding |

**Blocking conditions (regardless of score):**
- Missing layout constraints on responsive wrappers
- Non-tokenized style properties (raw hardcoded values)
- Detached component instances
- Tokens referenced in design that don't exist in the codebase

---

## What NOT to Do

- ❌ Proceed if any critical designer requirement fails
- ❌ Accept non-tokenized values (hardcoded colors, sizes)
- ❌ Approve detached component instances
- ❌ Skip layout discipline validation

---

## Output

Structured report containing:
- Component identification summary
- Critical requirements pass/fail status
- Token coverage analysis
- Variant mapping table
- Readiness score with breakdown
- Blocking issues with Designer escalation path
- Recommendation (proceed / block and fix)
