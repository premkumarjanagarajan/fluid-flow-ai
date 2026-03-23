---
step: analyze
subagent: false
---

## Inputs

- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/spec.md` (required)
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/plan.md` (required)
- `../../knowledge-core/constitution.md` (for constitution validation)

## Guidance

**STRICTLY READ-ONLY**: Do **not** modify any files. Output a structured analysis report. Offer an optional remediation plan (user must explicitly approve before any editing).

**Constitution Authority**: The project constitution is **non-negotiable** within this analysis scope. Constitution conflicts are automatically CRITICAL.

**Inception scope**: This step runs at the end of Inception, before tasks exist. Focus on spec–plan consistency, constitution alignment, ambiguity detection, and underspecification. Task coverage analysis is not applicable.

### Execution Steps

1. **Initialize Analysis Context**: Resolve `SHELL_TYPE` from session variables. Run the appropriate script from workflow root:
   - **bash**: `../../scripts/bash/check-prerequisites.sh --json`
   - **powershell**: `../../scripts/powershell/check-prerequisites.ps1 -Json`

   Parse JSON for FEATURE_DIR and AVAILABLE_DOCS. Derive paths: SPEC, PLAN. Abort if spec.md or plan.md is missing.

2. **Load Artifacts (Progressive Disclosure)**:
   - From spec.md: Overview, Functional/Non-Functional Requirements, User Stories, Edge Cases
   - From plan.md: Architecture/stack choices, Data Model references, Phases, Technical constraints
   - From constitution: Principle names and MUST/SHOULD normative statements

3. **Build Semantic Models** (internal only):
   - Requirements inventory with stable keys
   - User story/action inventory with acceptance criteria
   - Constitution rule set

4. **Detection Passes** (limit to 50 findings total):
   - **A. Duplication Detection**: Near-duplicate requirements
   - **B. Ambiguity Detection**: Vague adjectives lacking measurable criteria, unresolved placeholders
   - **C. Underspecification**: Requirements with missing object/outcome, user stories missing acceptance criteria, plan referencing undefined components
   - **D. Constitution Alignment**: Conflicts with MUST principles, missing mandated sections
   - **E. Spec–Plan Consistency**: Terminology drift, data entity mismatches between spec and plan, conflicting requirements

5. **Severity Assignment**:
   - **CRITICAL**: Violates constitution MUST, missing core artifact, blocking inconsistency
   - **HIGH**: Duplicate/conflicting requirement, ambiguous security/performance attribute, untestable acceptance criterion
   - **MEDIUM**: Terminology drift, underspecified edge case
   - **LOW**: Style/wording improvements, minor redundancy

6. **Produce Compact Analysis Report** (Markdown, no file writes):
   - Findings table: ID, Category, Severity, Location(s), Summary, Recommendation
   - Constitution Alignment Issues
   - Metrics: Total Requirements, Ambiguity Count, Duplication Count, Critical Issues Count

7. **Provide Next Actions**:
   - If CRITICAL issues: Recommend resolving before Construction
   - If only LOW/MEDIUM: User may proceed with improvement suggestions
   - Provide explicit command suggestions

8. **Offer Remediation**: Ask user: "Would you like me to suggest concrete remediation edits for the top N issues?" (Do NOT apply automatically.)

### Operating Principles

- **Minimal high-signal tokens**: Focus on actionable findings
- **Progressive disclosure**: Load artifacts incrementally
- **Deterministic results**: Rerunning should produce consistent IDs and counts
- **NEVER modify files** (read-only analysis)
- **NEVER hallucinate missing sections**
- **Prioritize constitution violations** (always CRITICAL)

## Example

### Findings Table Row

| ID | Category | Severity | Location(s) | Summary | Recommendation |
|----|----------|----------|-------------|---------|----------------|
| A1 | Duplication | HIGH | spec.md §3.2, spec.md §4.1 | Two near-identical requirements for user notification | Merge into single requirement; keep the more precise wording |

Generate stable IDs prefixed by category initial (A = Duplication, B = Ambiguity, C = Underspec, D = Constitution, E = Consistency).

## Outputs

- Analysis report displayed to user (no file writes)
- Optional remediation plan (if user requests)

## Gate

STOP after presenting the analysis report. Wait for user to acknowledge or request remediation.
