# Glossary Lookup

Looks up domain terminology, offer types, market rules, or product governance definitions in the Knowledge Base.

---

## When to Run

- User asks for a definition of a term, concept, or artefact type
- User needs to clarify a governance concept, market rule, or compliance term
- A term referenced by the user needs canonical resolution before proceeding

---

## Prerequisites

- Access to the Knowledge Base at `knowledge/Layer 1 – Global Company Knowledge (Shared)/`
- The term or concept to look up is provided by the user or prompt

---

## Execution

### Step 1: Check Aliases

Check the Terminology & Aliases table in the Product Buddy agent for canonical mappings. If the term matches an alias, resolve it to the canonical name first before searching.

### Step 2: Search the Knowledge Base

Search under `knowledge/Layer 1 – Global Company Knowledge (Shared)/` across:

- `global-principles-guardrails/` — governance, hierarchy, and framework definitions
- `canonical-templates/` — artefact type definitions and field descriptions
- `markets/` — market-specific rules and terminology
- `responsible-ai-audit-compliance/` — compliance and jurisdiction definitions

### Step 3: Return a Structured Answer

Return a concise, clear answer including:

- **Definition** — What the term means in the Betsson product context
- **Where it's used** — Which artefact type, phase, or governance context it applies to
- **Source** — The Knowledge Base file path where the definition was found

### Step 4: Handle Not Found

If the term is not found in the Knowledge Base, state this explicitly. Do not guess. Suggest who to ask:

- Governance or hierarchy terms → Product Governance or Head of Area
- Compliance or regulatory terms → Compliance team or Legal
- Market-specific terms → Market Operations
- Engineering or integration terms → Engineering Lead

---

## Outputs

| Output | Format | Description |
|--------|--------|-------------|
| Definition answer | Inline chat response | Definition, context, and source path |
