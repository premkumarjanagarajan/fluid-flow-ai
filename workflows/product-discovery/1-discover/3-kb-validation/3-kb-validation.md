---
step: kb-validation
subagent: false
---

## Inputs

- Step 1.1 + 1.2 context (discovery conversation and challenge outputs)
- `CODE_RECON_PERMITTED` session variable
- `ANALYTICS_EVIDENCE` session variable

## Guidance

> Only enter this step AFTER the user has answered the discovery questions and you have a clear understanding of the problem space.

## Execution

Run both tracks in parallel.

---

### Track A — KB Validation

Delegate all KB lookups to a **subagent** running `skills/kb-retrieval/kb-retrieval.skill.md`. This keeps overlay navigation and file reads out of the main conversation's context window.

For each topic below, launch a kb-retrieval subagent with the specific query:

- Existing coverage of the problem area (systems, overlays, department docs)
- Relevant market rules and jurisdiction variations for the identified markets
- Compliance touchpoints and regulatory constraints
- Any knowledge gaps — areas where the KB has insufficient or absent coverage

**Interactive gap-resolution loop:**
1. Present the list of identified knowledge gaps to the user.
2. For each gap, ask the user how it should be addressed (provide additional context, mark as out of scope, defer to a named source, etc.).
3. Repeat until no unresolved gaps remain.

---

### Track B — Codebase Reconnaissance (conditional)

**Run only if `CODE_RECON_PERMITTED = true`.**

Launch an **`Explore` subagent** (read-only, no code changes) with this scoped query built from the problem area and user group identified in Step 1.1:

1. Does [capability/feature area] already exist in any form in the codebase?
2. Is there any in-progress work (open branches, PRs, feature flags) related to this?
3. What are the relevant integration points, APIs, or shared services this would touch?
4. Are there existing feature flags for this area that indicate prior attempts?

The Explore subagent returns a structured result. Store as `CODEBASE_FINDINGS`:

| Field | Value |
|---|---|
| STATUS | `EXISTS_FULLY` / `EXISTS_PARTIALLY` / `IN_PROGRESS` / `NOT_FOUND` |
| Summary | Brief description of what was found |
| Integration points | Relevant systems, services, APIs |
| In-flight work | Open branches, PRs, feature flags if any |

**Routing signals for Phase 2:**
- `EXISTS_FULLY` → flag immediately: *"This capability appears to already exist in the codebase. Before we proceed, do you know about this? It may mean we need an extension, fix, or migration rather than a new initiative."*
- `IN_PROGRESS` → flag: *"There is in-flight work on this — review before proceeding to avoid duplicate effort."*
- `EXISTS_PARTIALLY` or `NOT_FOUND` → continue normally; record findings for problem statement.

> If `CODE_RECON_PERMITTED = false` — skip Track B entirely. Record `CODEBASE_FINDINGS = SKIPPED — user opted out`.

---

## Outputs

- Relevant market rules and compliance touchpoints surfaced (Track A)
- All knowledge gaps resolved or deferred with named owner (Track A)
- `CODEBASE_FINDINGS` populated (Track B) or marked SKIPPED

## Gate

All gaps addressed or deferred with owner. Codebase routing signals (if any) presented to user.
