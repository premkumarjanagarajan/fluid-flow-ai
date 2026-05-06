---
step: figma-design-analysis
subagent: false
quality-gate: readiness score 8+/10
skill: skills/design/figma-analysis/figma-analysis.skill.md
---

## Inputs

- Figma design URL with node-id
- Output from `1-jira-analysis/` (component name, domain, purpose)
- Access to Figma via Figma MCP

## Guidance

Load and execute `skills/design/figma-analysis/figma-analysis.skill.md` against the provided Figma design URL.

Assess:
- Design system token usage (no hardcoded values — tokens or equivalent per local conventions)
- Auto Layout or equivalent layout discipline compliance
- Component instance integrity (no detached components)
- Responsive design patterns
- Variant coverage

## Quality Gate

| Criterion | Threshold |
|-----------|-----------|
| Readiness score | 8+/10 |

**PASS** → Record score, proceed to `3-jira-figma-alignment/`.  
**FAIL** → Document non-tokenized values, detached components, or missing layouts. Block progression. Escalate to Designer to fix issues in Figma, then re-run.

## Output

Structured report per the skill's output definition. Save to: `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/figma-to-code/figma-design-analysis-{component-name}-{timestamp}.md`.
