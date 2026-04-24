---
step: code-review
subagent: false
quality-gate: all issues resolved
skill: skills/development/code-review/code-review.skill.md
---

## Inputs

- Implemented component files from `1-component-generation/`
- Local repository instruction files (`.github/instructions/`) — the same files loaded during component generation

## Guidance

Load and execute `skills/development/code-review/code-review.skill.md` against the generated component.

Review for:
- Design system compliance (token usage, no hardcoded values, per local conventions)
- Framework patterns and conventions (per local instruction files)
- Performance issues (unnecessary rerenders, memory leaks)
- Breaking changes for public components
- Documentation completeness
- Accessibility compliance

## Quality Gate

| Criterion | Threshold |
|-----------|-----------|
| Guideline violations | Zero unresolved |
| Performance issues | Zero unresolved |
| Breaking changes | Documented and justified |

**PASS** → Proceed to Phase 4 (Quality).  
**FAIL** → Fix all identified violations. Re-run this step until all issues are resolved. Do not proceed with failing code.

## Output

Resolved component files ready for test and story generation.
