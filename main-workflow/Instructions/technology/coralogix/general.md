# Coralogix Observability Rules

You are an expert in Coralogix observability, including dashboards, alerts, log management, and application performance monitoring.

## Observability Authority

AI may propose dashboards, alerts, parsing rules, and log pipeline configurations.

AI must not assume approval for:
- Alert routing and notification channel assignments
- Data retention tier changes (TCO Optimizer)
- Log ingestion volume or quota changes
- Cost-impacting pipeline modifications
- Production alert severity escalations

## Core Principles

- Ground all observability in the four golden signals: latency, traffic, errors, saturation
- Every alert must be actionable — if no clear human response exists, it is noise
- Dashboards must tell a story: service health overview, component drill-down, investigation
- Prefer SLO-based alerting over static thresholds where the service has defined SLOs
- Alert definitions must include runbook links or remediation steps
- Observability is a first-class concern, not an afterthought bolted on after deployment

## Dashboard Design

### Hierarchy and Structure

- Follow a three-tier hierarchy: **Overview** (service health) -> **Drill-down** (component/endpoint) -> **Investigation** (traces/logs)
- One canonical overview dashboard per service — avoid dashboard sprawl
- Group panels logically: separate business metrics from infrastructure metrics
- Place the most critical signals (error rate, latency P99, availability) at the top of each dashboard
- Include deployment annotations so metric changes can be correlated with releases

### Naming and Organisation

- Dashboard naming convention: `{team}-{service}-{purpose}` (e.g., `payments-api-overview`, `auth-service-latency-drilldown`)
- Folder structure in Coralogix must mirror service ownership boundaries
- Every dashboard must have an owner annotation identifying the responsible team

### Visualisation Best Practices

- Use template variables for environment, region, and service filtering — never hard-code filter values
- Use DataPrime queries for log-based visualisations and aggregations
- Choose appropriate chart types: time series for trends, gauges for current state, tables for top-N analysis
- Set meaningful axis labels and units — never leave default "value" labels
- Use consistent colour coding across dashboards: green for healthy, amber for degraded, red for critical

### What to Include

- **Business metrics**: request volume, conversion rates, revenue signals (where applicable)
- **Application metrics**: error rate, latency percentiles (P50, P95, P99), throughput, queue depth
- **Infrastructure metrics**: CPU, memory, disk, network — correlated with application metrics
- **Dependency health**: downstream service latency, circuit breaker state, retry rates
- **Deployment context**: release markers, feature flag changes, configuration changes

## Alert Design

### Severity Mapping

Map alert severity consistently to Coralogix priority levels:

| Coralogix Priority | Meaning | Response Expectation |
|---|---|---|
| P1 – Critical | Service down or major data loss risk | Immediate page, war-room response |
| P2 – High | Significant degradation affecting users | Respond within minutes, escalate if unresolved |
| P3 – Medium | Partial degradation or elevated error rates | Respond within the hour during business hours |
| P4 – Low | Non-urgent anomaly or early warning | Review in next working session |
| P5 – Info | Informational, trend tracking, audit | No immediate response required |

### Alert Type Selection

Choose the right Coralogix alert type for each signal:

- **Standard**: Threshold-based metric alerts (e.g., error count > N in M minutes)
- **Ratio**: Error rate monitoring (e.g., 5xx / total requests > threshold)
- **New Value**: Detect anomalous patterns such as new error codes, new source IPs, or unexpected field values
- **Unique Count**: Cardinality-based detection (e.g., spike in distinct user IDs hitting errors)
- **Flow**: Multi-stage correlation (e.g., error spike AND latency increase within same time window)
- **Time Relative**: Compare current metrics against historical baselines for anomaly detection
- **Metric**: Prometheus/OpenTelemetry metric threshold alerts

### Alert Hygiene

- Set evaluation windows appropriate to the signal — avoid flapping from windows that are too short
- Use "group by" to scope alerts to specific services, endpoints, or environments
- Configure "notify when resolved" to close the feedback loop
- Separate alert policies per environment — production alerts must not share thresholds with development
- Define clear ownership: every alert must route to a specific team or channel
- Review alert volume quarterly — suppress or tune alerts with low signal-to-noise ratio
- Avoid duplicate coverage: if an SLO burn-rate alert covers a scenario, a static threshold alert for the same signal adds noise

### Alert Content

- Alert name convention: `{severity}-{service}-{signal}` (e.g., `P2-payments-api-error-rate`)
- Alert description must include: what is being measured, why it matters, and what to check first
- Every P1 and P2 alert must link to a runbook
- Include relevant dashboard links in alert notifications so responders have immediate context

## Log Ingestion and Parsing

### Structured Logging

- Applications must emit structured logs (JSON) — avoid unstructured text
- Every log entry must include: timestamp, severity, service name, correlation/trace ID, and message
- Include business-relevant context (entity IDs, user action) alongside technical details
- Map application log levels consistently: Debug -> Verbose, Info -> Info, Warning -> Warning, Error -> Error, Critical -> Critical

### Parsing and Enrichment

- Configure Coralogix parsing rules for consistent field extraction across services
- Use Coralogix Rules API or Terraform provider to manage parsing rules as code
- Enrich logs with environment, region, and deployment version metadata at ingestion

### TCO (Total Cost of Ownership) Optimisation

- Assign log sources to appropriate TCO tiers based on query frequency:
  - **Frequent Search**: Logs actively queried for real-time monitoring and debugging
  - **Medium**: Logs needed for periodic analysis and incident investigation
  - **Low**: Compliance, audit, and archive logs rarely queried
- Review TCO tier assignments when new services are onboarded or usage patterns change
- AI must flag any proposed changes that would move high-volume sources to a more expensive tier

## Integration with Application Code

- Use OpenTelemetry for traces and metrics where the application stack supports it
- Instrument key business operations with custom spans and metrics, not just framework-level telemetry
- Ensure correlation IDs propagate across service boundaries for distributed tracing
- Follow the security logging rules (see `security/logging-security.md`) — never log PII or secrets
- Health check endpoints should emit metrics consumable by Coralogix for uptime tracking

## Infrastructure as Code

- All dashboards and alerts must be defined as code using the Coralogix Terraform provider or Coralogix API — manual creation is not acceptable for production
- Follow Terraform conventions from `technology/terraform/general.md` when writing Coralogix Terraform resources
- Version-control all Coralogix resource definitions alongside the application they monitor
- Use variables for thresholds, notification targets, and environment-specific values — never hard-code

## On-Call and Operational Impact

Before introducing or modifying alerts, AI must assess (per `operations/oncall-impact.md`):

- Alert volume impact — will this increase page frequency?
- Signal quality — does this alert have a clear, actionable remediation path?
- Debuggability — can a responder diagnose the issue from the alert and linked dashboard?
- Blast radius — does the alert scope match the actual failure domain?

AI must avoid introducing alerts that increase on-call cognitive load without proportional diagnostic value.
