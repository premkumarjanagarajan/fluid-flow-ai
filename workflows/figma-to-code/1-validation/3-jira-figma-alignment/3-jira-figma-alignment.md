---
step: jira-figma-alignment
subagent: false
quality-gate: sync score 6+/10
skill: skills/product/jira-figma-alignment-check/jira-figma-alignment-check.skill.md
---

## Inputs

- Output from `1-jira-analysis/`
- Output from `2-figma-design-analysis/`
- Access to JIRA and Figma via MCPs

## Guidance

Load and execute `skills/product/jira-figma-alignment-check/jira-figma-alignment-check.skill.md`.

Cross-validate:
- JIRA acceptance criteria vs Figma variant coverage
- Scope alignment (no features in Figma missing from JIRA and vice versa)
- State coverage (loading, error, empty, success represented in both)
- Missing acceptance criteria for designed states

## Quality Gate

| Criterion | Threshold |
|-----------|-----------|
| Sync score | 6+/10 |

**PASS** → Record score, proceed to Phase 2 (Discovery).  
**FAIL** → Document mismatches. Block progression. Escalate to Designer + Product Owner to align artefacts, then re-run.

## Output

Structured report per the skill's output definition. Save to: `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/figma-to-code/jira-figma-alignment-{component-name}-{timestamp}.md`.
