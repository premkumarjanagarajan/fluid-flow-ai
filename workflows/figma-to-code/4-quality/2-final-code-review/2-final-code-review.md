---
step: final-code-review
subagent: false
quality-gate: all issues resolved
conditional: true
skill: skills/development/code-review/code-review.skill.md
---

## Inputs

- All component files: implementation, tests, and stories
- Repository guidelines: all `.github/instructions/` files

## Guidance

This step is **optional but strongly recommended** before raising a PR.

Load and execute `skills/development/code-review/code-review.skill.md` against the complete implementation including tests and stories.

Review the full picture for:
- Test coverage quality and completeness
- Story coverage completeness and accuracy
- Documentation completeness
- Final guideline compliance check
- No regressions introduced during test/story generation

## Quality Gate

| Criterion | Threshold |
|-----------|-----------|
| Final guideline violations | Zero unresolved |
| Documentation | Complete |
| Test coverage | Adequate |

**PASS** → Component is ready for PR.  
**FAIL** → Fix issues and re-run this step.

## Completion Summary

When this step passes (or is skipped), present the full deliverables list:

```
🎉 Workflow Complete - Component Ready for PR

**Deliverables:**
- Component: [path/to/component.tsx]
- Tests: [path/to/tests]
- Stories: [path/to/stories]
- Documentation: [path/to/readme-notes.md]
- Content Mocks: [path/to/content-mocks.md]

**Next Steps:**
1. Create pull request
2. Request human code review
3. Deploy with feature flag
```
