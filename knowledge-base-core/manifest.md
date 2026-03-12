# Knowledge Base Loading Manifest

**This is the single source of truth for all shared knowledge base files.**

All paths below are relative to this file's directory (`knowledge-base-core/`).
When loading these files, resolve each path relative to where this manifest is located.

---

## Loading Strategy

The knowledge base is enforced through two complementary layers:

1. **Pre-step (tiered loading)**: The main agent loads a subset of KB files into its context before executing a step. The "Always Load" set is loaded for every step. Conditional sets are loaded only when the step's domain matches.

2. **Post-step (compliance subagent)**: After every step, `primitives/kb-compliance.md` launches a dedicated subagent that loads the **entire** KB in its own context window, reviews the step output, and returns a short PASS/FAIL verdict. This catches anything the tiered pre-loading might miss -- without inflating the main conversation's context.

---

## Always Load

These files MUST be loaded at the start of every command or workflow stage:

- Load `ai-governance/ai-operating-contract.md` -- AI role, authority boundaries, decision rules
- Load `ai-governance/content-validation.md` -- Mermaid validation, character escaping, fallback rules
- Load `review/ai-self-review.md` -- Self-review checklist before finalising output
- Load `review/human-gate.md` -- Human approval requirements and safe-to-proceed rules
- Load `quality/iso9001-quality-management.md` -- Process discipline, traceability, continuous improvement
- Load `ai-governance/adr-integrity-gate.md` -- ADR compliance checking and extension rules
- Load `ai-governance/continuous-learning.md` -- Systemic issue detection, rule/ADR improvement proposals
- Load `ai-governance/overconfidence-prevention.md` -- Prevents confidence without evidence

---

## Conditional: Security, Data, Identity, or Infrastructure

Load these when the change affects security, data handling, identity, or infrastructure:

- Load `security/iso27001-compliance.md` -- ISO 27001 compliance framework
- Load `security/*.md` -- All security rules (authz-authn, data-classification, dependencies, logging-security, network-boundaries, refusal-patterns, secrets-management, security-self-review, threat-model)

---

## Conditional: Infrastructure, Performance, or Energy (SEU-Related)

Load when the change affects infrastructure, performance, or Significant Energy Use:

- Load `quality/iso50001-energy-management.md` -- ISO 50001 energy management
