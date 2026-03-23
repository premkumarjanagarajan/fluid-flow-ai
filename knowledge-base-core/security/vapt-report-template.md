# VAPT Report Template

Use this template when generating `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/security/vapt-report.md` during the VAPT primitive.

---

```markdown
# VAPT Report: {INITIATIVE_NAME}

## Report Header

| Field | Value |
|-------|-------|
| **Initiative** | {INITIATIVE_NAME} |
| **Branch** | {BRANCH_NAME} |
| **JIRA Ticket** | {JIRA_TICKET | N/A} |
| **Assessment Date** | [ISO timestamp] |
| **Assessment Depth** | Full / Lite |
| **Assessor** | AI-Assisted (Fluid Flow VAPT Primitive) |

---

## Executive Summary

**Overall Risk Rating**: Critical / High / Medium / Low / Clear

| Severity | Count |
|----------|-------|
| Critical | 0 |
| High | 0 |
| Medium | 0 |
| Low | 0 |
| Informational | 0 |
| **Total** | **0** |

**Risk Narrative**:
[2-3 sentence summary of the most significant risks identified, the attack surface assessed, and the overall security posture of this feature.]

---

## Vulnerability Assessment Findings

> Covers: SAST, Dependency Scanning, Secret Scanning, Configuration Review, Data Classification Compliance.

| ID | Category | Severity | CVSS (approx) | Location | Description | Remediation |
|----|----------|----------|---------------|----------|-------------|-------------|
| VA-001 | [Category] | Critical / High / Medium / Low / Info | [0.0–10.0] | [File/Component] | [Description] | [Recommended fix] |

> If no VA findings: **No vulnerability assessment findings identified.**

---

## Penetration Test Findings

> Covers: Attack Surface Mapping, AuthN/AuthZ Testing, Injection Testing, API Abuse, Infrastructure Threats.
> Omitted for Lite depth assessments.

| ID | Attack Vector | Severity | Entry Point | Description | Remediation |
|----|---------------|----------|-------------|-------------|-------------|
| PT-001 | [Attack type] | Critical / High / Medium / Low / Info | [Endpoint/Interface] | [Description] | [Recommended fix] |

> If no PT findings: **No penetration test findings identified.**

---

## Attack Surface Inventory

| Entry Point | Method | Auth Required | Data Accepted | Trust Boundary |
|-------------|--------|---------------|---------------|----------------|
| [Path/Interface] | [GET/POST/etc.] | Yes / No | [Data types] | [Internal/External/Public] |

---

## OWASP Top 10 (2021) Coverage Matrix

| # | Category | Tested | Status | Finding IDs |
|---|----------|--------|--------|-------------|
| A01 | Broken Access Control | Yes / No | Pass / Finding | |
| A02 | Cryptographic Failures | Yes / No | Pass / Finding | |
| A03 | Injection | Yes / No | Pass / Finding | |
| A04 | Insecure Design | Yes / No | Pass / Finding | |
| A05 | Security Misconfiguration | Yes / No | Pass / Finding | |
| A06 | Vulnerable & Outdated Components | Yes / No | Pass / Finding | |
| A07 | Identification & Authentication Failures | Yes / No | Pass / Finding | |
| A08 | Software & Data Integrity Failures | Yes / No | Pass / Finding | |
| A09 | Security Logging & Monitoring Failures | Yes / No | Pass / Finding | |
| A10 | Server-Side Request Forgery | Yes / No | Pass / Finding | |

---

## Remediation Priority List

### Critical Findings — Must Resolve or Risk-Accept Before Proceeding

| ID | Finding | Recommended Fix | Re-test Criteria |
|----|---------|-----------------|------------------|
| | | | |

### High Findings — Remediate or Document Residual Risk

| ID | Finding | Recommended Fix | Re-test Criteria |
|----|---------|-----------------|------------------|
| | | | |

---

## Residual Risk Statement

**Scope Limitations**:
- [What was not assessed — e.g., runtime behaviour, third-party SaaS internals, infrastructure not yet provisioned]

**Assumptions**:
- [Assumptions made — e.g., "assumed TLS termination at load balancer layer"]

**Items Requiring Specialist Human Review**:
- [Areas where AI assessment is insufficient — e.g., cryptographic protocol design, compliance certification, live infrastructure pen testing]

---

## Sign-Off Gate

> Must be completed by a human reviewer before the feature proceeds.

- [ ] All Critical findings resolved or explicitly risk-accepted
- [ ] All High findings resolved or documented with a remediation timeline
- [ ] VAPT report reviewed and approved
- [ ] Residual risks acknowledged

**Approved by**: ___________________________
**Approval Date**: ___________________________
**Notes**: ___________________________
```
