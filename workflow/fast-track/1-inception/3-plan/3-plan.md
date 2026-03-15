---
step: plan
subagent: false
---

## Inputs

- `artefacts/1.1-spec.md` — approved feature specification
- `workflow/fast-track/knowledge-core/constitution.md` — project principles (if populated)

## Guidance

Generate a technical implementation plan with research, data model, and API contracts.

### 1. Load Context

- Read the approved specification
- Load `workflow/fast-track/knowledge-core/constitution.md` for project principles
- Load `workflow/fast-track/templates/plan-template.md` for plan structure
- If brownfield: load `reverse-engineering/architecture.md`, `code-structure.md`, `technology-stack.md`, `dependencies.md`, `api-documentation.md`

### 2. Fill Technical Context

From the spec and brownfield context:
- Identify tech stack (from existing project or propose based on requirements)
- Identify dependencies and integration points
- Mark unknowns as "NEEDS CLARIFICATION"

### 3. Constitution Check

If `constitution.md` is populated:
- Validate planned approach against each principle
- Flag any violations with justification or ERROR if unjustified

### 4. Phase 0 — Research

For each unknown or NEEDS CLARIFICATION in the technical context:
1. Research the topic and evaluate options
2. Document in `artefacts/1.3-research.md`:
   - **Decision**: what was chosen
   - **Rationale**: why chosen
   - **Alternatives considered**: what else was evaluated

### 5. Phase 1 — Design & Contracts

With research complete:
1. **Data Model** — extract entities from spec, define fields, relationships, validation rules, state transitions → `artefacts/1.3-data-model.md`
2. **API Contracts** — for each user action, define endpoints using standard REST/GraphQL patterns → `artefacts/1.3-contracts/` (OpenAPI or GraphQL schemas)
3. **Quickstart** — integration guide for the feature → `artefacts/1.3-quickstart.md`

### 6. Re-evaluate Constitution

After design, re-check against constitution principles. Document any post-design adjustments.

### 7. Write Implementation Plan

Write the complete plan to `artefacts/1.3-plan.md` using the plan template.

## Outputs

- `artefacts/1.3-plan.md` — implementation plan
- `artefacts/1.3-research.md` — technical research and decisions
- `artefacts/1.3-data-model.md` — entity definitions
- `artefacts/1.3-contracts/` — API contract specifications
- `artefacts/1.3-quickstart.md` — integration guide

## Gate

STOP. Present via `primitives/human-gate.md`. Report branch, plan path, and generated artifacts.
