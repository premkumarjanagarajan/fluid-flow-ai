---
step: kb-validation
subagent: false
---

## Inputs

- Step 1.1 + 1.2 context (discovery conversation and challenge outputs)

## Guidance

> Only enter this step AFTER the user has answered the discovery questions and you have a clear understanding of the problem space.

## Execution

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

## Outputs

- Relevant market rules and compliance touchpoints surfaced
- All knowledge gaps resolved or deferred with named owner

## Gate

All gaps addressed or deferred with owner.
