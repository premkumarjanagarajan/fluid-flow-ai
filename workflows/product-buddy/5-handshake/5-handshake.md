---
phase: handshake
steps: 1
---

> The Handshake phase represents a **formal contract** between Product and Engineering.
> The Handshake **must not be initiated** unless all delivery artefacts are complete and ready.
> This is a **hard gate**. Do not allow bypassing or partial compliance.

Handshake is **not** the place to discover scope, define requirements, or invent delivery structure.

Handshake exists to:
- Confirm shared understanding
- Lock delivery intent
- Establish clear ownership and commitments

The Handshake phase can only be initiated when Epics, User Stories, and their corresponding Test Cases are fully defined and ready for delivery.

## Step Chain

| # | Step | Folder | Conditional |
|---|------|--------|-------------|
| 1 | Handshake Contract | `1-handshake-contract/` | No |

## Pre-Entry Conditions (ALL required)

- [ ] Feature Brief is approved and merged (Phase 3 gate passed)
- [ ] Decision log entry is completed with rationale and decision-maker (Phase 4 gate passed)
- [ ] All flagged conflicts from the Decide phase acknowledged or resolved
- [ ] No outstanding delivery artefacts are missing or incomplete
- [ ] No unresolved scope or dependency blockers remain

If scope is still changing, Handshake is not allowed. Return to **Define** (Phase 3) or **Artefact Selection** (Phase 2) as appropriate.

## Phase Gate

- [ ] All pre-entry conditions met
- [ ] Delivery artefact readiness validated
- [ ] Handshake contract drafted, reviewed, and confirmed by both Product and Engineering

## Flow Closing Gate (ALL must be met to close the Discovery flow)

- [ ] All pre-entry conditions verified and confirmed
- [ ] Handshake contracts drafted and reviewed
- [ ] Product reviewer has approved and merged
- [ ] Engineering reviewer has approved and merged
- [ ] All required artefacts are linked and versioned
- [ ] No unresolved open questions blocking inception

If any condition fails, the Handshake remains open. Do not close or advance the flow.
