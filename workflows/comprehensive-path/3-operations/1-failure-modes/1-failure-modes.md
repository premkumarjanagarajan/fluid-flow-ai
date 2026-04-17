---
step: failure-modes
subagent: false
---

# Failure Modes & Resilience

**Failure mode and resilience analysis**

## Inputs

- Build and Test must be complete
- All construction artifacts available (functional design, NFR design, infrastructure design, code)
- Change Risk Report (if generated) at `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/operations/risk-report.md`

## Guidance

### Purpose

AI must consider and document failure modes and resilience characteristics for the implemented change. This analysis informs operational readiness and on-call planning.

### Required Analysis

Document the following for the unit/initiative:

- **Partial failure scenarios** — What happens when a component fails partially? Which operations degrade vs. fail completely?
- **Dependency unavailability** — How does the system behave when external dependencies (APIs, databases, queues) are unavailable?
- **Timeout behaviour** — How are timeouts configured? What happens when timeouts are exceeded?
- **Retry strategies** — Where are retries applied? What are the backoff and max-attempt policies?
- **Data inconsistency risks** — What are the risks of partial writes, out-of-order processing, or stale reads?

### Critical Rule

**If failure modes are unknown**, AI must state this explicitly in the output and recommend areas for further investigation or testing.

### ADR Alignment

Reference `../../../knowledge-core/adrs-technical-principles.md` for resilience and fault-tolerance principles when documenting failure modes.

## Outputs

- `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/operations/failure-modes-analysis.md`

## Gate

1. Present completion summary of failure modes and resilience analysis.
2. Wait for user acknowledgment before proceeding to On-call Impact.
