# Knowledge Loading Manifest

**This is the single source of truth for all knowledge files loaded during Fluid Flow workflows.**

Knowledge is split across two locations:
- **Agent rules** (`agent-rules/`): AI behavioral rules that govern how the AI operates
- **Enterprise KB** (`$KB_PATH/knowledge/`): Organisational knowledge (standards, compliance, technology)

All `agent-rules/` paths below are relative to this file's directory.
All `$KB_PATH/` paths reference the enterprise KB repo (resolved during Stage 0B workspace detection).

---

## Loading Strategy

Knowledge is enforced through two complementary layers:

1. **Pre-step (tiered loading)**: The main agent loads a subset of files into its context before executing a step. The "Always Load" set is loaded for every step. Conditional sets are loaded only when the step's domain matches.

2. **Post-phase (compliance subagent)**: After the last step of each phase (phase transitions), `primitives/kb-compliance.md` launches a dedicated subagent that loads knowledge from both agent-rules and the enterprise KB, reviews the phase output, and returns a short PASS/FAIL verdict.

---

## Always Load — Agent Rules

These files MUST be loaded at the start of every command or workflow stage:

- Load `ai-governance/ai-operating-contract.md` -- AI role, authority boundaries, decision rules
- Load `ai-governance/content-validation.md` -- Mermaid validation, character escaping, fallback rules
- Load `review/ai-self-review.md` -- Self-review checklist before finalising output
- Load `review/human-gate.md` -- Human approval requirements and safe-to-proceed rules
- Load `ai-governance/adr-integrity-gate.md` -- ADR compliance checking and extension rules
- Load `ai-governance/continuous-learning.md` -- Systemic issue detection, rule/ADR improvement proposals
- Load `ai-governance/no-assumption-policy.md` -- No assumptions, ask for missing info, evidence required

---

## Always Load — Enterprise KB

These org knowledge files are loaded for every step (resolve paths using `$KB_PATH`):

- Load `$KB_PATH/knowledge/shared/global/quality/iso9001-quality-management.md` -- Process discipline, traceability, continuous improvement

---

## Conditional: Security, Data, Identity, or Infrastructure

Load these when the change affects security, data handling, identity, or infrastructure:

From agent-rules (AI behavioral):
- Load `security/refusal-patterns.md` -- When AI must refuse to proceed
- Load `primitives/templates/vapt-report-template.md` -- VAPT output template

From enterprise KB (org standards, resolve paths using `$KB_PATH`):
- Load `$KB_PATH/knowledge/shared/global/security/iso27001-compliance.md` -- ISO 27001 compliance framework
- Load `$KB_PATH/knowledge/shared/global/security/*.md` -- All org security rules (authz-authn, data-classification, dependencies, logging-security, network-boundaries, secrets-management, threat-model)

---

## Conditional: Infrastructure, Performance, or Energy (SEU-Related)

Load when the change affects infrastructure, performance, or Significant Energy Use:

- Load `$KB_PATH/knowledge/shared/global/quality/iso50001-energy-management.md` -- ISO 50001 energy management

---

## Conditional: Technology-Specific (auto-matched from TECH_STACK)

Load engineering standards from the enterprise KB when `TECH_STACK` (detected in Stage 0A) includes a matching technology (resolve paths using `$KB_PATH`):

| TECH_STACK value | Load from enterprise KB |
|-----------------|----------------------|
| `dotnet` | `$KB_PATH/knowledge/shared/engineering-standards/dotnet/general.md` |
| `dotnet` | `$KB_PATH/knowledge/shared/engineering-standards/csharp/general.md` |
| `terraform` | `$KB_PATH/knowledge/shared/engineering-standards/terraform/general.md` |
| Any (if Coralogix used) | `$KB_PATH/knowledge/shared/engineering-standards/coralogix/general.md` |

---

## Conditional: Department Overlay

When `DEPARTMENT` is set (from `.department-fluid-flow.json`), load the department overlay:

- Load `$KB_PATH/knowledge/departments/{DEPARTMENT}/engineering/ai/overlay.md`

The overlay specifies additional knowledge sources to load (compliance, market files, capability docs).
