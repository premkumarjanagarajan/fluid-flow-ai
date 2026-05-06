---
name: jira-figma-alignment-check
description: Cross-validates JIRA requirements against Figma designs to catch scope mismatches, missing states, and acceptance criteria gaps before development begins.
execution: inline
scope: shared
version: v0.1
last-updated: 24/04/2026
dependencies:
  mcps:
  - mcps/atlassian.md
  - mcps/figma.md
---

# JIRA-Figma Alignment Check

Verifies that JIRA ticket requirements and Figma designs are synchronized. Catches discrepancies early to prevent misalignment that causes rework, confusion about source of truth, and wasted development effort.

---

## When to Use

- After both JIRA Analysis and Figma Analysis have passed
- Before component discovery or implementation begins
- Whenever requirements or designs have been updated independently

---

## Inputs

- Output from JIRA analysis (acceptance criteria, requirements)
- Output from Figma analysis (variant list, states, responsive behavior)
- Access to JIRA via Atlassian MCP
- Access to Figma via Figma MCP

> ⚠️ **Do not request Figma-generated code.** Analyze metadata, screenshot, and requirements only.

---

## Instructions

### 1. Cross-Reference Component Scope
- Extract feature description from JIRA
- Extract component functionality from Figma metadata
- Verify component type matches (button vs card vs input, etc.)
- Check feature scope: all JIRA features are visible in the design
- Identify features in design but not documented in JIRA

### 2. Variant & States Alignment
- Extract required variants from JIRA acceptance criteria
- List all variants shown in Figma
- Verify every JIRA-mentioned variant exists in the design
- Check all design variants are documented in JIRA
- Validate interactive states: hover, focus, disabled, error, success, loading

### 3. Responsive Behavior Sync
- Check if JIRA mentions mobile/tablet/desktop requirements
- Verify Figma shows responsive variants for mentioned contexts
- Identify breakpoint mismatches
- Flag responsive behavior shown in design but not documented in JIRA

### 4. User Interaction Alignment
- List user interactions from JIRA (clicks, hovers, keyboard, etc.)
- Check if design shows corresponding interaction states
- Verify loading/error states if async operations are mentioned
- Validate focus states if keyboard navigation is required

### 5. Acceptance Criteria Coverage
For EVERY acceptance criterion:
- Can it be verified from the design? (YES / NO / PARTIAL)
- Which design elements support this AC?
- What is missing from the design to validate this AC?

### 6. Sync Score

Score 1–10 based on:
| Dimension | Weight |
|-----------|--------|
| Acceptance criteria coverage in design | 30% |
| Variant/state coverage | 25% |
| Component scope alignment | 20% |
| Responsive behavior match | 15% |
| User interaction alignment | 10% |

**Threshold: 6+/10 required to proceed.**

| Score | Status | Action |
|-------|--------|--------|
| 9–10 | 🟢 Perfect sync | Proceed immediately |
| 6–8 | 🟡 Minor gaps | Fix critical discrepancies, document minor gaps, proceed |
| <6 | 🔴 Major misalignment | Stop — schedule alignment meeting, update JIRA and/or design, re-run |

---

## What NOT to Do

- ❌ Proceed if major scope mismatches exist
- ❌ Assume undocumented features are intentional
- ❌ Skip checking each acceptance criterion against the design
- ❌ Ignore missing critical states (error, loading, disabled)

---

## Output

Structured report containing:
- Alignment table by category (scope, variants, responsive, interactions, ACs)
- Acceptance criteria coverage table (per AC: coverage status + design elements)
- List of mismatches with severity (blocking / minor)
- Sync score with breakdown
- Recommendation (proceed / fix and re-run) with escalation path (Designer + Product Owner)
