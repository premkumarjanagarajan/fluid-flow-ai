---
step: decision-log
subagent: false
---

## Inputs

- Approved Feature Brief (or selected artefact) from Phase 3
- Phase 3 gate confirmation

## AI Role

- Draft a decision log entry using the format below.
- Summarise the prioritisation assessment against the criteria in the Product Principles (provided via authoritative references): strategic alignment, impact, effort, urgency, risk.
- Create comparison tables where multiple options or approaches exist.
- Flag any conflicts between the proposed feature and existing rules, market constraints, or active decisions in the log.

## Decision Log Entry Format

```markdown
## Decision — [Feature Name]

**Date:** YYYY-MM-DD
**Decision-maker:** [Head of Area or above]
**Status:** ✅ Final / 🔄 Revisiting / ❌ Superseded by [ref] / Deferred / Rejected

### Options Considered
| Option | Pros | Cons |
|--------|------|------|
| Option A | [Benefits] | [Drawbacks] |
| Option B | [Benefits] | [Drawbacks] |
| Option C (selected) | [Benefits] | [Drawbacks] |

### Assessment Summary
| Criterion | Rating | Notes |
|-----------|--------|-------|
| Themes | Existing Revenue / Operational-Excellence / Technical-Excellence / Business Growth / Support-Maintenance / Customer-XP | |
| Impact | High / Medium / Low | |
| Effort | High / Medium / Low | |
| Urgency | High / Medium / Low | |
| Risk | High / Medium / Low | |

### Rationale
[Summary of the decision rationale — why this option was chosen over alternatives]

### Consequences
- What this enables:
- What this prevents or limits:
- What we are accepting as a trade-off:

### Conflicts Flagged
- [conflict or rule reference, or "None"]
```

## Outputs

- Completed decision log entry
- Assessment summary table
- Conflicts list (or confirmed "None")

## Gate

- [ ] Decision log entry completed
- [ ] Decision-maker identified (Head of Area or above)
- [ ] Rationale recorded
- [ ] All flagged conflicts acknowledged or resolved
