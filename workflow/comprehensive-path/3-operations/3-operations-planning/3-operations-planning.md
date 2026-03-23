---
step: operations-planning
subagent: false
---

# Operations Planning

**Operational readiness and future scope planning**

## Inputs

- Failure Modes analysis complete
- On-call Impact assessment complete
- All construction artifacts
- Change Risk Report (if generated) at `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/operations/risk-report.md`

## Guidance

### Purpose

Placeholder for future operational phases (deployment, monitoring, maintenance). This step consolidates operational readiness findings and documents future scope.

**Status**: This phase is currently a placeholder and will be expanded in future versions.

### Change Risk Report (Implemented)

The Change Risk Report is generated automatically at the end of the Construction phase (after Build and Test). It produces a structured CAB-grade risk analysis at `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/operations/risk-report.md` that includes:

- Executive summary with risk level and approval recommendation
- Detailed technical risk analysis (infrastructure, operational, execution risks)
- LiveOps / NOC monitoring recommendations (pre-change, during, post-change)
- Rollback strategy with decision thresholds
- AI confidence score with breakdown

The report is enriched with full AI-DLC lifecycle context (requirements, designs, NFRs, infrastructure, test results) rather than relying solely on the git diff.

To regenerate after changes: **`/fluid-flow.risk-report`** (supports full and delta modes)

### Operability is Mandatory

Any production-impacting change must consider:

- **Logging** — Structured logs, correlation IDs, appropriate log levels
- **Metrics** — Key business and technical metrics, SLO/SLI alignment
- **Alerting** — Actionable alerts with correct severity mapping
- **Failure recovery** — Retry, circuit breaker, graceful degradation

**If omitted**, AI must explain why (e.g., change is non-production, or explicitly out of scope).

### Observability Platform — Coralogix

When the project uses Coralogix, all dashboard, alert, and log management decisions must follow the rules in `../../../../knowledge-base-core/technology/coralogix/general.md`. This includes:

- Dashboard design following the three-tier hierarchy (overview, drill-down, investigation)
- Alert design with correct severity mapping and alert type selection
- Structured logging with TCO tier assignments
- All Coralogix resources defined as code (Terraform or API)

### Future Scope

The Operations phase will eventually include:

- Deployment planning and execution
- Monitoring and observability setup (Coralogix dashboards, alerts, and log pipelines — expanding on risk report recommendations)
- Incident response procedures
- Maintenance and support workflows
- Production readiness checklists

### Current State

Build, test, and risk reporting are handled in the CONSTRUCTION phase.
The AI-DLC workflow currently ends after the Risk Report stage in CONSTRUCTION.
This Operations Planning step consolidates findings and prepares for future expansion.

## Outputs

- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/operations/operations-readiness-summary.md` (optional)

## Gate

1. Present the completion message:

```markdown
# 🔧 Operations Planning Complete

**Operational readiness assessment**:
- Failure modes: [summary]
- On-call impact: [summary]
- Change Risk Report: [location if generated]

> **📋 <u>**REVIEW REQUIRED:**</u>**  
> Please examine the operational artifacts at: `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/operations/`

> **🚀 <u>**WHAT'S NEXT?**</u>**
>
> **You may:**
>
> 🔧 **Request Changes** — Ask for modifications to the operational assessment
> ✅ **Approve & Proceed to Completion** — Approve the operational assessment and complete the workflow

---
```

2. **Wait for explicit user approval** before the orchestrator's Stage 7 (Completion) runs.
