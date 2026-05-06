---
step: content-mocks
subagent: false
quality-gate: content coverage complete
prompt-ref: local repository .github/prompts/ (content mocks generation prompt)
---

## Inputs

- Output from `1-jira-analysis/` (acceptance criteria, user-facing text)
- Output from `2-figma-design-analysis/` (text content visible in design)
- Figma design URL with node-id

## Guidance

Execute the content mocks generation prompt from the local repository's `.github/prompts/` folder.

Extract and structure:
- All text content from JIRA and Figma
- Mock data structures suitable for the local component story/demo tooling
- Content variations: short, long, edge cases
- Coverage of all component states: default, loading, error, empty, success

**Critical:** Content mocks must be complete before Phase 3. The mock data directly informs both component implementation and component stories.

## Quality Gate

| Criterion | Threshold |
|-----------|-----------|
| State coverage | All states covered (default, loading, error, empty, success) |
| Content completeness | No gaps in text content |

**PASS** → Proceed to Phase 3 (Implementation).  
**FAIL** → Document missing states or content gaps. Return to Designer + PO to fill gaps, then re-run.

## Output

Mock data file per the skill's output definition. Save to: `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/figma-to-code/content-mocks-{component-name}-{timestamp}.md`.
