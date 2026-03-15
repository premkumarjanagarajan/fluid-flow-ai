---
step: contracts
subagent: false
---

## Context Loading

| Load | Do NOT Load |
|------|------------|
| Per-repo `api-documentation.md` ONLY for repos at integration points | Full RE artifacts for all repos |
| Per-repo `dependencies.md` ONLY for repos at integration points | `reverse-engineering/combined-c4.md` |
| `reverse-engineering/combined-architecture.md` | Per-repo RE for repos not at integration points |
| Approved `artefacts/2.1-workspace-decomposition.md` | `reverse-engineering/incident-learnings.md` |

The contracts step needs API and dependency detail for repos at cross-workspace integration points only. Load per-repo RE selectively, not for every repo in every workspace.

## Inputs

- Approved `artefacts/2.1-workspace-decomposition.md`
- Per-repo RE artifacts: `api-documentation.md`, `dependencies.md` (from repos at integration points only)
- `reverse-engineering/combined-architecture.md` (from workspace, if available)

## Guidance

Design cross-workspace contracts for every integration point. Check existing RE artifacts for reusable contracts before proposing new ones.

### 1. Inventory Integration Points

From the approved decomposition, extract every cross-workspace publish/consume relationship. Each relationship needs a contract.

### 2. Check Existing Contracts

For each integration point:
- Read `api-documentation.md` from the provider repo (if available) for existing endpoints
- Read `dependencies.md` from both provider and consumer repos for existing shared libraries
- Read `combined-architecture.md` for existing data flow patterns
- Determine: can an existing contract be extended, or is a new contract required?

### 3. Propose Contract Type

For each integration point, propose:
- **Contract type**: Kafka event, REST API, gRPC, shared library, shared schema (Avro/Protobuf/OpenAPI)
- **Justification**: why this type (existing patterns, latency requirements, coupling preferences)

### 4. Draft Contract Specifications

For each contract:
- **Kafka events**: draft Avro/JSON schema with field names, types, and descriptions
- **REST APIs**: draft OpenAPI spec with endpoints, request/response schemas, status codes
- **Shared schemas**: draft schema definition with versioning strategy
- **Shared libraries**: propose package interface and dependency management

### 5. Backward Compatibility Check

For contracts that extend existing schemas:
- Verify backward compatibility (additive fields only for Avro, non-breaking changes for REST)
- Flag breaking changes that require coordinated deployment

### 6. Present Contracts

Present all proposed contracts for human review.

## Outputs

- `artefacts/3.1-cross-domain-contracts.md`

### Output Template

```markdown
# Cross-Domain Contracts

**Initiative**: {INITIATIVE_NAME}
**Date**: {ISO_TIMESTAMP}

## Contract Summary

| # | Contract | Type | Publisher | Consumer(s) | New / Extension |
|---|----------|------|-----------|-------------|-----------------|
| 1 | {name} | {Kafka/REST/gRPC/Schema} | {workspace} | {workspace, workspace} | {New / Extension} |

## Contract Specifications

### 1. {Contract Name}

- **Type**: {Kafka event / REST API / Shared schema}
- **Publisher**: {workspace} ({repo})
- **Consumer(s)**: {workspace} ({repo}), {workspace} ({repo})
- **New or Extension**: {New / Extension of {existing-contract}}
- **Backward compatible**: {Yes / No — breaking change: {description}}

#### Schema / Spec

{Draft schema in appropriate format: Avro, OpenAPI, Protobuf, or TypeScript interface}

#### Deployment Notes

{Any ordering requirements: deploy consumer before producer, schema registry update required, etc.}

{Repeat for each contract.}

## Breaking Changes

{List any breaking changes that require coordinated deployment across workspaces. If none: "No breaking changes."}

## Decision Required

[ ] Approve contract types
[ ] Approve schema designs
[ ] Confirm backward compatibility assessment
[ ] Approve breaking change plan (if any)
```

## Gate

STOP. Present via `primitives/human-gate.md`. Contract designs must be approved before sequencing, as the delivery order depends on the publish/consume chain.
