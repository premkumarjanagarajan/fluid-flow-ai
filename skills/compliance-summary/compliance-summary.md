---
name: compliance-summary
description: Generates a jurisdiction compliance summary in betsson-kb-docs canonical format.
execution: inline
scope: shared
version: 1.0
last-updated: 2026-04-20
---

# Prompt: Create or Refine a Jurisdiction Compliance Summary (betsson-kb-docs Canonical Format)

You are generating a jurisdiction compliance summary for the betsson-kb-docs repository.

The goal is to produce a clean, structured, AI-consumable compliance document
that can be safely referenced by Product AI and Engineering AI-DLC.

Do NOT:
- Guess legal requirements.
- Invent missing obligations.
- Over-interpret unclear legal language.

If information is incomplete:
- Add an "Open Questions" section.
- Mark Authoritative Status accordingly.

---

## Output Requirements (STRICT STRUCTURE)

The output MUST follow this exact structure:

# <Jurisdiction Name> Gaming Compliance Summary

Version:
Owner:
Last Updated:
Authoritative Status: (Authoritative / Draft / Partial)
Primary Source(s):
Applies To:
Impacts Departments:

---

## 1. Regulatory Scope

Brief description of:
- Who regulates
- What license covers
- Online vs land-based scope
- Any relevant constraints

---

## 2. Mandatory Requirements (MUST)

List ONLY hard legal requirements.

Use format:

### <Requirement Name>
Description:
Applies To:
System Impact:
UX Impact:
Technical Enforcement Notes:

---

## 3. Prohibited Behaviors (MUST NOT)

Explicitly forbidden behaviors.

Use same structured format as above.

---

## 4. Conditional Requirements (IF APPLICABLE)

Rules triggered by:
- Player age
- Market location
- High-risk classification
- Payment method
- etc.

---

## 5. Responsible Gaming Requirements

- Limits
- Time controls
- Self-exclusion
- Cooling-off
- Display requirements

Separate:
- UX obligations
- Backend obligations

---

## 6. Data, Privacy & Reporting Requirements

- Data retention
- Logging
- Regulatory reporting
- Audit trails

---

## 7. Accessibility / UX Disclosure Requirements

- Mandatory disclaimers
- Placement rules
- Language requirements
- Visibility requirements

---

## 8. Enforcement & Risk Notes

- Known regulatory focus areas
- High-risk implementation mistakes
- Areas commonly audited

---

## 9. Open Questions

Explicit unknowns requiring:
- Legal confirmation
- Further regulatory clarification

---

## 10. Change Log

- Version history

Input:
<PASTE LEGAL NOTES / LINKS / SUMMARY HERE>
