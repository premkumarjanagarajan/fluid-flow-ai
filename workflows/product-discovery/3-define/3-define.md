---
phase: define
steps: 1
---

## Pre-Flight Check (runs before the step chain)

Before building the artefact, run `skills/anti-pattern-check/anti-pattern-check.skill.md` against the confirmed scope and problem statement from Phase 1.

- If any 🔴 Critical anti-pattern is found: **hard stop** — return to Phase 1 to resolve before continuing
- If only 🟡 Significant matches: surface, get explicit user acknowledgement, then proceed
- If clean: proceed to Step Chain

## Step Chain

| # | Step | Folder | Conditional |
|---|------|--------|-------------|
| 1 | Build Artefact | `1-build-artefact/` | No |

## Phase Gate

- [ ] Anti-pattern check passed before Define began (pre-flight complete)
- [ ] Feature Brief (or selected artefact) is complete and conforms to the template
- [ ] Section Progress Log shows every section confirmed by the human
- [ ] Product impact statement produced and embedded in success criteria section
- [ ] Full artefact reviewed by the human after assembly
- [ ] Market applicability confirmed against available market and jurisdiction sources
- [ ] Compliance and accessibility touchpoints identified or explicitly marked N/A
- [ ] All scope gaps flagged — none omitted silently
- [ ] No tech-stack-specific implementation detail included
- [ ] Peer review completed
- [ ] Feature Brief merged to the repository
- [ ] Area Director or Head of Area has approved via PR review
