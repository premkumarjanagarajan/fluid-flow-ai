# Knowledge Loading Manifest

**This is the single source of truth for all knowledge files loaded during Fluid Flow workflows.**

Knowledge is split across three locations:
- **Agent rules** (`agent-rules/`): AI behavioral rules that govern how the AI operates
- **Enterprise KB** (`betsson-kb-docs`): Organisational knowledge (standards, compliance, technology) — retrieved by topic via `skills/kb-retrieval/kb-retrieval.skill.md`
- **Local KB** (`{DEPT_FF_PATH}/knowledge-base-local/`): Optional department-specific knowledge — loaded from the department repo's manifest if configured

All `agent-rules/` paths below are relative to this file's directory.
Enterprise KB content is retrieved by topic — the orchestrator launches `skills/kb-retrieval/kb-retrieval.skill.md` as a subagent, describing what knowledge is needed. The skill navigates the KB overlay map and returns the relevant content.

---

## Loading Strategy

Knowledge is enforced through three complementary mechanisms:

1. **Boot loading (once, after Init)**: The orchestrator loads the "Always Load" sets into context once at session start. These govern the entire session and are not re-loaded per step.

2. **Per-step conditional loading (before each step)**: Before executing a workflow step, the orchestrator checks the conditional sections below. If the step's domain matches a trigger, the matching files and KB topics are loaded.

3. **Post-phase compliance (subagent)**: After the last step of each phase, `primitives/kb-compliance.md` launches a dedicated subagent that loads the full knowledge stack (agent-rules + enterprise KB + local KB), reviews the phase output, and returns a PASS/FAIL verdict.

> **KB Delegation Rule**: The main agent MUST NOT read from `betsson-kb-docs` directly. All Enterprise KB retrieval MUST be delegated to `skills/kb-retrieval/kb-retrieval.skill.md` running as a subagent. The main agent describes the **topic or question**; the skill navigates the overlay map and returns content with source citations.

---

## Always Load — Agent Rules (boot)

These files are loaded **once at session boot** (after Init, before Triage). They govern AI behavior for the entire session:

- Load `ai-governance/ai-operating-contract.md` -- AI role, authority boundaries, decision rules
- Load `ai-governance/content-validation.md` -- Mermaid validation, character escaping, fallback rules
- Load `review/ai-self-review.md` -- Self-review checklist before finalising output
- Load `review/human-gate.md` -- Human approval requirements and safe-to-proceed rules
- Load `ai-governance/adr-integrity-gate.md` -- ADR compliance checking and extension rules
- Load `ai-governance/continuous-learning.md` -- Systemic issue detection, rule/ADR improvement proposals
- Load `ai-governance/no-assumption-policy.md` -- No assumptions, ask for missing info, evidence required

---

## Always Load — Enterprise KB (boot)

At session boot, launch `skills/kb-retrieval/kb-retrieval.skill.md` as a subagent to retrieve:

- **Topic**: Process discipline, traceability, and continuous improvement (ISO 9001 quality management)

---

## Always Load — Local KB (boot, if configured)

If `LOCAL_KB_MANIFEST` is set (detected by ff-init), read `{DEPT_FF_PATH}/knowledge-base-local/manifest.md` and load all files under its "Always Load" section. The local KB may also define conditional sections — these follow the same per-step matching rules as the conditional sections below.

---

## Conditional: Security, Data, Identity, or Infrastructure

Load these **before a step** when the step affects security, data handling, identity, or infrastructure:

From agent-rules (AI behavioral):
- Load `security/refusal-patterns.md` -- When AI must refuse to proceed
- Load `primitives/templates/vapt-report-template.md` -- VAPT output template

From enterprise KB — launch `skills/kb-retrieval/kb-retrieval.skill.md` for:
- **Topic**: ISO 27001 compliance framework and requirements
- **Topic**: Org security rules covering authentication/authorisation, data classification, dependency management, security logging, network boundaries, secrets management, and threat modelling

---

## Conditional: Infrastructure, Performance, or Energy (SEU-Related)

Load **before a step** when the step affects infrastructure, performance, or Significant Energy Use. Launch `skills/kb-retrieval/kb-retrieval.skill.md` for:

- **Topic**: ISO 50001 energy management standards and Significant Energy Use (SEU) controls

---

## Conditional: Technology-Specific (auto-matched from TECH_STACK)

Load **before a step** when `TECH_STACK` (detected during Init) includes a matching technology. Launch `skills/kb-retrieval/kb-retrieval.skill.md` for the topic that matches:

| TECH_STACK value | Topic to request from kb-retrieval |
|-----------------|------------------------------------|
| `dotnet` | General engineering standards for .NET |
| `dotnet` | General engineering standards for C# |
| `terraform` | General engineering standards for Terraform |
| Any (if Coralogix used) | General engineering standards and integration guidance for Coralogix |

---

## Conditional: Department Overlay

When `DEPARTMENT` is set (from `.department-fluid-flow.json`), load **before a step** that involves department-specific context. Launch `skills/kb-retrieval/kb-retrieval.skill.md` for:

- **Topic**: AI engineering overlay for the `{DEPARTMENT}` department, including any department-specific compliance rules, market context, and capability documentation

The kb-retrieval skill will locate and return the overlay content. Any additional topics identified within the overlay must also be requested via `skills/kb-retrieval/kb-retrieval.skill.md`.

