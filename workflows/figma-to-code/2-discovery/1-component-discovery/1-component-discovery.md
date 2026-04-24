---
step: component-discovery
subagent: false
quality-gate: no duplicates OR extend decision justified
skill: skills/development/frontend/component-discovery/component-discovery.skill.md
---

## Inputs

- Component name and domain (from JIRA / Figma analysis outputs)
- Codebase access

## Guidance

Load and execute `skills/development/frontend/component-discovery/component-discovery.skill.md`.

The skill will:
- Search for existing components with the same purpose or name
- Identify extension opportunities vs new component creation
- Discover and document all nested component requirements
- Validate correct placement per local repository domain rules

## Quality Gate

| Criterion | Threshold |
|-----------|-----------|
| Duplicate check | No duplicates found |
| If duplicate found | Extend decision explicitly justified by Developer + Architect |

**PASS** → Proceed to `2-content-mocks/`.  
**FAIL (unresolved duplicate)** → Block progression. Do not create a new component. Escalate for architectural decision.

## Output

Structured discovery report per the skill's output definition. Save to: `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/figma-to-code/component-discovery-{component-name}-{timestamp}.md`.
