---
step: analyze
subagent: false
---

## Inputs

- `artefacts/1.1-spec.md` — feature specification
- `artefacts/1.3-plan.md` — implementation plan
- `artefacts/1.4-tasks.md` — task breakdown
- `workflow/fast-track/knowledge-core/constitution.md` — project principles (if populated)

## Guidance

Perform non-destructive cross-artifact consistency and quality analysis. This step is **read-only** — no files are modified.

### 1. Load Artifacts Progressively

Load minimal necessary context from each artifact:
- **spec.md**: overview, functional/non-functional requirements, user stories, edge cases
- **plan.md**: architecture, data model references, phases, constraints
- **tasks.md**: task IDs, descriptions, phase grouping, parallel markers, file paths
- **constitution.md**: principle names and MUST/SHOULD normative statements

### 2. Build Semantic Models

Create internal representations (not included in output):
- **Requirements inventory**: each requirement with a stable key
- **Task coverage mapping**: map each task to requirements/stories
- **Constitution rule set**: extract principles and normative statements

### 3. Detection Passes

Limit to 50 findings total. Run these detection passes:

| Pass | What it detects | Severity |
|------|----------------|----------|
| **Duplication** | Near-duplicate requirements | HIGH |
| **Ambiguity** | Vague adjectives lacking measurable criteria, unresolved placeholders | HIGH |
| **Underspecification** | Requirements with verbs but missing outcomes, tasks referencing undefined components | MEDIUM |
| **Constitution Alignment** | Requirements or plan elements conflicting with MUST principles | CRITICAL |
| **Coverage Gaps** | Requirements with zero tasks, tasks with no mapped requirement | HIGH |
| **Inconsistency** | Terminology drift, data entities referenced in plan but absent in spec, conflicting requirements | MEDIUM-HIGH |

### 4. Produce Analysis Report

Output a structured markdown report (no file writes):

```markdown
## Specification Analysis Report

| ID | Category | Severity | Location(s) | Summary | Recommendation |
|----|----------|----------|-------------|---------|----------------|
| A1 | ... | ... | ... | ... | ... |

**Coverage Summary:**
| Requirement Key | Has Task? | Task IDs | Notes |

**Metrics:**
- Total Requirements / Total Tasks / Coverage %
- Ambiguity Count / Duplication Count / Critical Issues Count
```

### 5. Provide Next Actions

- If CRITICAL issues exist: recommend resolving before implementation
- If only LOW/MEDIUM: user may proceed with awareness
- Suggest specific remediation commands

### 6. Offer Remediation

Ask: "Would you like me to suggest concrete remediation edits for the top N issues?" — do NOT apply them automatically.

## Outputs

- Analysis report (presented in conversation, not written to file — read-only analysis)

## Gate

STOP. Present via `primitives/human-gate.md`.
- If CRITICAL issues: must resolve before construction
- If no critical issues: recommend proceeding to construction
