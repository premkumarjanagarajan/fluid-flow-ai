# Change Risk Report Generation

**Purpose**: Generate a structured risk analysis report for CAB (Change Advisory Board) reviewers by analysing the complete git diff against the base branch, enriched with all context accumulated during the AI-DLC lifecycle.

**Execute when**: After Build and Test completes in the AWS AI-DLC workflow, or on demand via the `/fluid-flow.risk-report` command.

---

## Context Enrichment Strategy

Unlike a standalone git-diff-only analysis, the AI-DLC risk report leverages the full lifecycle context. Before analysing the diff, gather:

| Source | What It Provides |
|--------|-----------------|
| Requirements Analysis | Business justification, criticality, stakeholder impact |
| User Stories | Expected behaviour, acceptance criteria, user journeys affected |
| Workflow Planning | Execution plan, risk levels assigned during planning |
| Application Design | Component boundaries, dependencies, architectural decisions |
| NFR Design | Performance targets, security requirements, scalability constraints |
| Infrastructure Design | Resource changes, scaling implications, cost impact |
| ADR Decisions | Architectural rationale, trade-offs accepted |
| Build and Test | Test results, coverage gaps, confidence level |
| Git Diff | Actual code, configuration, and infrastructure changes |

---

## Step 1: Gather Inputs

### 1.1 Obtain the Git Diff

Run the following command to capture the full feature diff against the base branch:

```bash
git diff main...HEAD
```

If the base branch is not `main`, determine the correct base from the branch creation context or ask the user.

If the diff is extremely large (exceeding context limits), summarise by file and focus on high-risk areas:
- Infrastructure-as-code changes (Terraform, CloudFormation, CDK)
- Security-related changes (IAM, network, secrets, authentication)
- Database schema changes
- Configuration changes (environment variables, feature flags)
- Public API surface changes

### 1.2 Gather Lifecycle Context

Load the following from `specs/{BRANCH_NAME}/`:

1. **Requirements**: `inception/requirements/` — business context, criticality
2. **User Stories**: `inception/user-stories/` — acceptance criteria, personas
3. **Workflow Plan**: `inception/plans/` — execution plan, risk assessment
4. **Application Design**: `inception/application-design/` — component design, ADR compliance
5. **NFR Design**: `construction/{unit-name}/nfr-design/` — performance, security, scalability
6. **Infrastructure Design**: `construction/{unit-name}/infrastructure-design/` — resource topology
7. **Build and Test Summary**: `construction/build-and-test/build-and-test-summary.md` — test results
8. **Feature Registry**: `features/features-registry.md` — feature scope

If any artifact does not exist (stage was skipped), note it as unavailable and proceed with what is available.

### 1.3 Load Existing Knowledge

If reverse engineering artifacts exist at `specs/_project/reverse-engineering/`:
- Load `architecture.md` for baseline system understanding
- Load `technology-stack.md` for dependency context
- Load `code-quality-assessment.md` for quality baseline

---

## Step 2: Analyse and Generate Report

Using the git diff as the primary input and the lifecycle context as enrichment, generate the risk report following the structure below.

### Analysis Rules

When analysing, check for:

1. Infrastructure-as-code changes
2. Security impact (IAM, network, secrets, authentication, authorisation)
3. Network or access changes
4. Scaling changes (instance sizes, replica counts, auto-scaling)
5. Cost implications (new resources, sizing changes, data transfer)
6. Downtime risks (stateful changes, migrations, DNS)
7. Data loss risk (schema changes, storage modifications, retention)
8. Dependency impact (upstream and downstream services)
9. Observability gaps (missing metrics, alerts, dashboards)
10. Compliance implications (data handling, retention, access controls)

Think step-by-step like a production incident reviewer and identify hidden risks that developers might miss.

If information is missing, explicitly state:

> Assumption based on typical production environments and available lifecycle context.

Where lifecycle context exists (requirements, NFR design, etc.), use it to validate or refine the analysis rather than relying solely on assumptions.

---

## Step 3: Report Structure

Generate the report at `specs/{BRANCH_NAME}/operations/risk-report.md` following this exact structure:

```markdown
# Change Risk Report: {BRANCH_NAME}

**Generated**: [ISO timestamp]
**Feature**: {feature_description}
**Branch**: {BRANCH_NAME}
**JIRA Ticket**: {JIRA_TICKET | null}
**Workflow**: AWS AI-DLC
**Base Branch**: {base_branch}
**Report Mode**: {Full | Delta}

---

## Change Summary

**Environment:**
**Resource / Service:**
**Change Type:**

### Detected Changes

List the significant modifications from the git diff:

- Configuration changes
- Infrastructure changes
- Code behaviour changes
- Security-related changes
- Database / data model changes
- API surface changes
- Dependency changes

---

## 1. Executive Summary for CAB Reviewers

**Risk Level:** LOW | MEDIUM | MEDIUM-HIGH | HIGH | CRITICAL

### Business Impact

**Service:**
**Criticality:** [from Requirements Analysis if available]
**Expected Downtime:**
**Rollback Complexity:**

### Key Risks

1.
2.
3.
4.

### Approval Recommendation

APPROVE | APPROVE WITH CONDITIONS | REJECT

Conditions (if any):

---

## 2. Detailed Technical Risk Analysis

### 2.1 Infrastructure / System Impact

Explain:

- What components are affected
- Performance implications [reference NFR targets if available]
- Scaling changes [reference Infrastructure Design if available]
- Cost impact
- Dependencies [reference Application Design if available]

For each major change:

**Severity:**
**Likelihood:**
**Reasoning:**

### 2.2 Operational Risks

| Risk Category | Description | Severity | Mitigation |
|---------------|-------------|----------|-----------|
| Availability | | | |
| Performance | | | |
| Security | | | |
| Financial | | | |
| Monitoring | | | |
| Dependencies | | | |
| Configuration Drift | | | |
| Compliance | | | |
| Rollback | | | |

### 2.3 Change Execution Risks

Evaluate:

- Deployment risks
- State conflicts
- Infrastructure limits
- Data migration
- Multi-region or multi-AZ implications
- Runtime failures

---

## 3. LiveOps / NOC Monitoring Recommendations

### Pre-Change Checklist

- [ ] Verify system utilisation baselines
- [ ] Notify dependent teams
- [ ] Confirm maintenance window (if required)
- [ ] Capture baseline metrics
- [ ] Verify rollback procedure tested
- [ ] Confirm monitoring dashboards accessible

### During Change

Monitor in real time:

- Service health
- Infrastructure status
- Error rates
- Traffic patterns
- Dependency failures

Define specific metrics, logs, and alerts to watch.

### Post-Change Monitoring

#### 0 to 4 hours — Critical Validation

[Specific checks for this change]

#### 4 to 24 hours — Stabilisation

[Stabilisation monitoring criteria]

#### 24 to 48 hours — Long-Term Validation

[Longer-term validation criteria]

Include suggested alerts and metric thresholds.

---

## 4. Rollback Strategy

- Whether rollback is possible (full / partial / not possible)
- Rollback procedure steps
- Partial rollback options
- Disaster recovery approach
- Decision thresholds for triggering rollback
- Estimated rollback duration

---

## 5. Additional Recommendations

- Cost monitoring and budget alerts
- Capacity planning actions
- Documentation updates needed
- Security validation steps
- Performance validation criteria
- Follow-up items for next sprint

---

## AI Confidence Score

**Score:** X / 100

### Breakdown

| Factor | Score | Explanation |
|--------|-------|-------------|
| Technical Feasibility | | |
| Risk Identification | | |
| Business Justification | | |
| Rollback Capability | | |
| Cost Awareness | | |
| Operational Complexity | | |

### Context Quality

| Input | Available | Quality |
|-------|-----------|---------|
| Git Diff | Yes / No | [assessment] |
| Requirements Analysis | Yes / No | [assessment] |
| NFR Design | Yes / No | [assessment] |
| Infrastructure Design | Yes / No | [assessment] |
| Build and Test Results | Yes / No | [assessment] |
| Reverse Engineering | Yes / No | [assessment] |

---

## Red Flags

List concerns discovered in the diff or lifecycle context.

---

## Positive Signals

List factors that reduce risk.

---

## Final CAB Recommendation

APPROVE | CONDITIONAL APPROVAL | REJECT

Provide clear justification referencing both the diff analysis and lifecycle context.
```

---

## Step 4: Present Summary to User

After generating the report, present:

```markdown
## Change Risk Report Generated

**Report**: `specs/{BRANCH_NAME}/operations/risk-report.md`
**Risk Level**: {RISK_LEVEL}
**CAB Recommendation**: {RECOMMENDATION}

### Key Risks Identified

1. [Top risk]
2. [Second risk]
3. [Third risk]

### AI Confidence

**Score**: {X}/100

| Factor | Score |
|--------|-------|
| Technical Feasibility | {score} |
| Risk Identification | {score} |
| Rollback Capability | {score} |

### Next Steps

- Review the full report at `specs/{BRANCH_NAME}/operations/risk-report.md`
- To regenerate after changes, run **`/fluid-flow.risk-report`**
- To update project documentation, run **`/fluid-flow.update-docs`**
```
