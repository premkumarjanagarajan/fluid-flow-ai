---
step: oncall-impact
subagent: false
---

# On-call & Operational Impact

**On-call and operational impact assessment**

## Inputs

- Failure Modes analysis complete
- Construction artifacts (design, code, infrastructure)
- Change Risk Report (if generated)

## Guidance

### Purpose

AI must assess the operational impact of the change on on-call engineers and incident response. The goal is to avoid introducing solutions that increase cognitive load or reduce diagnosability.

### Required Assessment

Document the following:

- **Alert volume impact** — Will this change increase the number or frequency of alerts? Are alerts actionable?
- **Debuggability** — Can incidents be diagnosed quickly? Are logs and metrics sufficient?
- **Log signal-to-noise ratio** — Will new logs add useful signal or increase noise?
- **Incident blast radius** — What is the scope of impact when this component fails?

### Critical Rules — Avoid

AI must avoid introducing solutions that:

- **Increase on-call cognitive load** — Complex runbooks, unclear alert messages, or too many alerts
- **Reduce diagnosability** — Missing logs, opaque error messages, or insufficient tracing
- **Hide failures** — Silent failures, swallowed exceptions, or lack of error propagation

### ADR Alignment

Reference `../../../knowledge-core/adrs-technical-principles.md` for observability and operational principles.

## Outputs

- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/operations/oncall-impact-assessment.md`

## Gate

1. Present completion summary of on-call and operational impact assessment.
2. Wait for user acknowledgment before proceeding to Operations Planning.
