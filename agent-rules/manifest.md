# Knowledge Loading Manifest

**This is the single source of truth for all knowledge files loaded during Fluid Flow workflows.**

Knowledge is split across two locations:
- **Agent rules** (`agent-rules/`): AI behavioral rules that govern how the AI operates
- **Enterprise KB**: Organisational knowledge (standards, compliance, technology) — retrieved by topic via `agents/kb-librarian.agent.md`

All `agent-rules/` paths below are relative to this file's directory.
Enterprise KB content is retrieved by topic — the main agent describes what knowledge is needed and `agents/kb-librarian.agent.md` locates and returns the relevant content.

---

## Loading Strategy

Knowledge is enforced through two complementary layers:

1. **Pre-step (tiered loading)**: The main agent loads a subset of files into its context before executing a step. The "Always Load" set is loaded for every step. Conditional sets are loaded only when the step's domain matches.

2. **Post-phase (compliance subagent)**: After the last step of each phase (phase transitions), `primitives/kb-compliance.md` launches a dedicated subagent that loads knowledge from both agent-rules and the enterprise KB, reviews the phase output, and returns a short PASS/FAIL verdict.

> **KB Delegation Rule**: The main agent MUST NOT retrieve Enterprise KB content directly. All Enterprise KB retrieval MUST be delegated to **`agents/kb-librarian.agent.md`**, which is the sole agent authorised to read from the enterprise knowledge base. The main agent MUST describe the **topic or question** it needs answered (as listed in this manifest); the kb-librarian is responsible for locating the relevant files and returning the content. Do not guess or hard-code file paths.

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

For every step, ask `agents/kb-librarian.agent.md` to retrieve knowledge on the following topics:

- **Topic**: Process discipline, traceability, and continuous improvement (ISO 9001 quality management)

---

## Conditional: Security, Data, Identity, or Infrastructure

Load these when the change affects security, data handling, identity, or infrastructure:

From agent-rules (AI behavioral):
- Load `security/refusal-patterns.md` -- When AI must refuse to proceed
- Load `primitives/templates/vapt-report-template.md` -- VAPT output template

From enterprise KB (org standards) — **ask `agents/kb-librarian.agent.md`** for the following topics:
- **Topic**: ISO 27001 compliance framework and requirements
- **Topic**: Org security rules covering authentication/authorisation, data classification, dependency management, security logging, network boundaries, secrets management, and threat modelling

---

## Conditional: Infrastructure, Performance, or Energy (SEU-Related)

Load when the change affects infrastructure, performance, or Significant Energy Use. **Ask `agents/kb-librarian.agent.md`** for the following topic:

- **Topic**: ISO 50001 energy management standards and Significant Energy Use (SEU) controls

---

## Conditional: Technology-Specific (auto-matched from TECH_STACK)

Load engineering standards from the enterprise KB when `TECH_STACK` (detected in Stage 0A) includes a matching technology. **Ask `agents/kb-librarian.agent.md`** for the topic that matches the detected stack:

| TECH_STACK value | Topic to request from kb-librarian |
|-----------------|------------------------------------|
| `dotnet` | General engineering standards for .NET |
| `dotnet` | General engineering standards for C# |
| `terraform` | General engineering standards for Terraform |
| Any (if Coralogix used) | General engineering standards and integration guidance for Coralogix |

---

## Conditional: Department Overlay

When `DEPARTMENT` is set (from `.department-fluid-flow.json`), **ask `agents/kb-librarian.agent.md`** for the following topic:

- **Topic**: AI engineering overlay for the `{DEPARTMENT}` department, including any department-specific compliance rules, market context, and capability documentation

The kb-librarian will locate and return the overlay content. Any additional topics identified within the overlay must also be requested from `agents/kb-librarian.agent.md`.

