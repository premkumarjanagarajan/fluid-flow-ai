# Operations

**Purpose**: Placeholder for future operational phases (deployment, monitoring, maintenance)

**Status**: This phase is currently a placeholder and will be expanded in future versions.

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
- Monitoring and observability setup (Coralogix dashboards, alerts, and log pipelines)
- Incident response procedures
- Maintenance and support workflows
- Production readiness checklists

## Current State

All build and test activities have been moved to the CONSTRUCTION phase.
The AI-DLC workflow currently ends after the Build and Test phase in CONSTRUCTION.
