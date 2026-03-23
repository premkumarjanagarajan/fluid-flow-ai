---
step: onboarding-update
subagent: false
---

# Onboarding Update

**Update onboarding materials post-implementation**

## Inputs

- Current unit context:
  - Requirements and user stories (if present)
  - Unit design outputs under `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/{unit-name}/`
  - Code changes (modified/created files)
- Current onboarding decks (if present)
- Reverse engineering artifacts if this is brownfield

## Guidance

### Purpose

Keep onboarding materials accurate as the system evolves, for both engineers and product managers.

### Step 1: Load Inputs (Mandatory)

- The current unit context (requirements, user stories, unit design outputs, code changes)
- Current onboarding decks (if present)
- Reverse engineering artifacts if this is brownfield

### Step 2: Determine Update Scope (Mandatory)

Classify the unit change:
- Feature added or changed
- API/contract change (endpoints, events, schemas)
- User-visible workflow change
- Operational impact change (alerts, dashboards, runbooks)
- Pure refactor (candidate for skip, must justify)

Record the classification in the unit's documentation summary.

### Step 3: Update Feature Registry (Mandatory)

Update or add the feature entry in:
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/features/features-registry.md`

Rules:
- Keep entries short and scannable
- Include impacted components and interfaces
- Update onboarding touchpoints for both decks
- Link to relevant unit docs and any updated artifacts

### Step 4: Update Engineer Onboarding Deck (Mandatory when not skipped)

Update only impacted sections. At minimum, ensure:
- Service inventory remains accurate
- Key flows updated if workflows changed (Mermaid + text alternative)
- Dev workflow updated if build/run/test changes
- Observability and on-call notes updated if operational impact changed
- Glossary updated for any new terms

Location: `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/onboarding/engineers/onboarding-engineers.md`

### Step 5: Update Product Onboarding Deck (Mandatory when not skipped)

Update only impacted sections. At minimum, ensure:
- Capabilities reflect the change
- Journeys reflect the change
- Dependencies/constraints updated if relevant
- Release/operations notes updated if needed
- Glossary updated for new terms

Location: `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/onboarding/product/onboarding-product.md`

### Step 6: Build sli-dev Outputs (Conditional)

If the repository includes sli-dev build scripts/config:
- Run the configured build to generate HTML/PDF outputs
- Store outputs under:
  - `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/onboarding/slides/engineers/`
  - `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/onboarding/slides/product/`

If build is not configured, document the recommended build commands in:
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/onboarding/README.md`

### Step 7: Content Validation (Mandatory)

Before writing updates:
- Validate Mermaid syntax
- Provide text alternatives for diagrams
- Ensure sli-dev Markdown compatibility
- Ensure internal links are relative and valid

## Outputs

- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/features/features-registry.md`
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/onboarding/engineers/onboarding-engineers.md`
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/onboarding/product/onboarding-product.md`
- Slides outputs (conditional)

## Gate

1. **Completion Announcement** (mandatory):

```markdown
# 📚 Onboarding Update Complete - <unit-name>

## Updated
- Feature registry: `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/features/features-registry.md`
- Engineer onboarding: `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/onboarding/engineers/onboarding-engineers.md`
- Product onboarding: `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/onboarding/product/onboarding-product.md`

## Summary
- What changed in this unit (1-5 bullets)
- Which sections were updated (1-5 bullets)
- Any follow-up recommendations (optional)

> **📋 <u>REVIEW REQUIRED:</u>**
> Please examine the updated onboarding materials at:
> - Engineer deck source: `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/onboarding/engineers/onboarding-engineers.md`
> - Product deck source: `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/onboarding/product/onboarding-product.md`

> **🚀 <u>WHAT'S NEXT?</u>**
>
> **You may:**
>
> 🔧 **Request Changes** - Ask for modifications to the onboarding updates based on your review
> ✅ **Continue to Next Stage** - Approve onboarding updates and proceed
```

2. **Wait for explicit user approval** before proceeding. Log the user's response and mark the stage as complete for this unit.
