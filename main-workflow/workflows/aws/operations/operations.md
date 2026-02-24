# Operations

**Purpose**: Placeholder for future operational phases (deployment, monitoring, maintenance)

**Status**: This phase is currently a placeholder and will be expanded in future versions.

## Change Risk Report (Implemented)

The Change Risk Report is generated automatically at the end of the Construction phase (after Build and Test). It produces a structured CAB-grade risk analysis at `specs/{BRANCH_NAME}/operations/risk-report.md` that includes:

- Executive summary with risk level and approval recommendation
- Detailed technical risk analysis (infrastructure, operational, execution risks)
- LiveOps / NOC monitoring recommendations (pre-change, during, post-change)
- Rollback strategy with decision thresholds
- AI confidence score with breakdown

The report is enriched with full AI-DLC lifecycle context (requirements, designs, NFRs, infrastructure, test results) rather than relying solely on the git diff.

To regenerate after changes: **`/fluid-flow.risk-report`** (supports full and delta modes)

## Operability is Mandatory
Any production-impacting change must consider:
- Logging
- Metrics
- Alerting
- Failure recovery

If omitted, AI must explain why.

## Observability Platform

When the project uses Coralogix, all dashboard, alert, and log management decisions must follow the rules in `../../../Instructions/technology/coralogix/general.md`. This includes:
- Dashboard design following the three-tier hierarchy (overview, drill-down, investigation)
- Alert design with correct severity mapping and alert type selection
- Structured logging with TCO tier assignments
- All Coralogix resources defined as code (Terraform or API)

## Future Scope

The Operations phase will eventually include:
- Deployment planning and execution
- Monitoring and observability setup (expanding on risk report recommendations)
- Incident response procedures
- Maintenance and support workflows
- Production readiness checklists

## Current State

Build, test, and risk reporting are handled in the CONSTRUCTION phase.
The AI-DLC workflow currently ends after the Risk Report stage in CONSTRUCTION.
