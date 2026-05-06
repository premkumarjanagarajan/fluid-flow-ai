---
step: jira-analysis
subagent: false
quality-gate: score 6+/10
skill: skills/product/jira-analysis/jira-analysis.skill.md
---

## Inputs

- JIRA ticket key (e.g., `ARC-315`)
- Access to JIRA via Atlassian MCP

## Guidance

Load and execute `skills/product/jira-analysis/jira-analysis.skill.md` against the provided JIRA ticket.

Assess:
- Ticket quality and completeness
- Presence of testable acceptance criteria
- Figma design link presence
- Feature flag strategy defined

## Quality Gate

| Criterion | Threshold |
|-----------|-----------|
| Quality score | 6+/10 |

**PASS** → Record score, proceed to `2-figma-design-analysis/`.  
**FAIL** → Document specific deficiencies, block progression. Escalate to Product Owner to update ticket, then re-run.

## Output

Structured report per the skill's output definition. Save to: `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/figma-to-code/jira-analysis-{component-name}-{timestamp}.md`.
