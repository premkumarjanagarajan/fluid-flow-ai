# VAPT — Vulnerability Assessment & Penetration Testing

Performs a structured, AI-assisted security assessment of all generated code and infrastructure prior to deployment. Runs as a **dedicated subagent** to avoid bloating the main conversation context with the full security knowledge base and analysis.

**Trigger**: Runs during Stage 5 (Completion), before the risk report and commit/PR steps.

---

## When to Run

Always. VAPT is executed for every initiative, but depth scales with risk (see Conditional Depth below).

---

## How It Works

Launch a **dedicated subagent** with its own context window. The subagent loads all security knowledge, analyses the generated code, and returns a structured VAPT report. The main conversation never loads the full security KB — only the subagent does.

---

## Subagent Prompt

The parent agent must launch a single subagent with the following inputs:

1. **Initiative path**: `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/`
2. **Artefacts to review**: list of all files created or modified during the initiative (code, config, infrastructure)
3. **Spec summary**: 2-3 sentence summary of the feature scope, data handled, and entry points (from `spec.md`)
4. **Brownfield context path** (if applicable): `{DEPT_FF_PATH}/initiatives/_project/reverse-engineering/`
5. **Security knowledge paths**:
   - Org standards: `$KB_PATH/knowledge/shared/global/security/` (all files)
   - AI behavioral: `agent-rules/security/refusal-patterns.md`
6. **Report template**: `primitives/templates/vapt-report-template.md`
7. **Report output path**: `{DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/security/vapt-report.md`

The subagent prompt MUST instruct the agent to:

- Read all security knowledge files from both sources
- Read all artefacts (spec, plan, tasks, code) from the initiative
- If brownfield, read `architecture.md`, `dependencies.md`, `api-documentation.md` from reverse-engineering
- Determine VAPT depth (Full or Lite) based on the conditional depth table
- Execute the full assessment (Steps 1-5 below)
- Generate the VAPT report at the output path using the template
- **Return ONLY a structured verdict** (see format below)

**Do NOT** ask the subagent to return the full analysis. All detailed findings go into the report file. Only the verdict comes back to the main conversation.

---

## Conditional Depth

The subagent determines depth based on these signals:

| Signal | Source | Depth |
|--------|--------|-------|
| Complexity Assessment = High | `metadata/state.md` | Full (VA + PT) |
| New authentication or authorisation logic | spec.md / code | Full (VA + PT) |
| External API or third-party integrations | plan.md | Full (VA + PT) |
| Data classification = Sensitive / PII / PHI | `$KB_PATH/knowledge/shared/global/security/data-classification.md` | Full (VA + PT) |
| Infrastructure changes (cloud resources, IAM, networking) | plan.md | Full (VA + PT) |
| Low-complexity UI or config-only change | spec.md | Lite (VA only) |

---

## Subagent Assessment Steps

### Step 1: Vulnerability Assessment (VA)

Analyse all generated code and configuration for:

**VA-1: Static Code Analysis (SAST)** — injection flaws, insecure deserialisation, weak cryptography, insecure randomness, path traversal, XXE, open redirects, error information disclosure

**VA-2: Dependency Scanning** — packages with active CVEs, significantly outdated, or unmaintained/deprecated

**VA-3: Secret and Credential Scanning** — hardcoded API keys, tokens, passwords, private keys, connection strings, Base64-encoded credential patterns

**VA-4: Configuration Review** — debug mode in production, overly permissive CORS, missing security headers, insecure storage, over-permissive IAM, unencrypted transport, default credentials

**VA-5: Data Classification Compliance** — cross-reference data handled against `data-classification.md`, verify each class is handled per its requirements

### Step 2: Penetration Testing Simulation (PT) — Full Depth Only

**Skipped for Lite depth.**

**PT-1: Attack Surface Mapping** — enumerate all entry points (APIs, CLI, file uploads, WebSockets, webhooks, admin interfaces)

**PT-2: Authentication & Authorisation Testing** — horizontal/vertical privilege escalation, auth bypass, IDOR, missing function-level access control, session fixation

**PT-3: Injection Testing** — SQL, NoSQL, command, template, header, GraphQL injection vectors

**PT-4: API Abuse Scenarios** — rate limiting bypass, mass assignment, parameter tampering, improper HTTP method handling, business logic abuse

**PT-5: Infrastructure Threats** — network boundary violations, security group misconfigs, unencrypted data in transit, logging gaps, lateral movement risks

### Step 3: OWASP Top 10 Coverage Matrix

Map all findings to OWASP Top 10 (2021): A01-A10.

### Step 4: Generate VAPT Report

Write the report to the output path using the template.

### Step 5: Return Verdict

Return the structured verdict to the parent agent.

---

## Verdict Format

The subagent must return exactly this structure:

```
VAPT: PASS | FINDINGS

Depth: Full | Lite
Critical: {count}
High: {count}
Medium: {count}
Low: {count}
Informational: {count}

Report: {report output path}
```

Example PASS:

```
VAPT: PASS

Depth: Lite
Critical: 0
High: 0
Medium: 0
Low: 1
Informational: 2

Report: {DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/security/vapt-report.md
```

Example FINDINGS:

```
VAPT: FINDINGS

Depth: Full
Critical: 1
High: 2
Medium: 3
Low: 0
Informational: 1

Top findings:
- [CRITICAL] VAPT-001: Hardcoded API key in config/production.json
- [HIGH] VAPT-003: Missing authentication on /api/admin/users endpoint
- [HIGH] VAPT-005: SQL injection vector in search query parameter

Report: {DEPT_FF_PATH}/initiatives/{INITIATIVE_NAME}/security/vapt-report.md
```

---

## On PASS (no Critical or High)

Present the summary to the user and proceed to the next completion step:

```
VAPT complete — no critical or high findings.
Medium: {n}, Low: {n}, Informational: {n}
Full report: {report path}
```

## On FINDINGS (Critical or High present)

The main agent must apply the human gate:

| Severity | Gate Behaviour |
|----------|----------------|
| **Critical** | **MANDATORY STOP** — present findings, require explicit human risk-acceptance or remediation confirmation before continuing |
| **High** | Present findings and ask: "Remediate before proceeding, or proceed with documented residual risk?" Wait for response |

**Critical findings prompt**:

```
## VAPT — Critical Findings Detected

The assessment identified {n} Critical severity finding(s) requiring resolution
or explicit risk acceptance before proceeding.

**Critical Findings**:
{list from verdict}

**Options**:
1. Remediate and re-run VAPT
2. Accept risk (requires documented justification and human sign-off)

This stage cannot proceed without human approval.
```

**High findings prompt**:

```
## VAPT — High Severity Findings

The assessment identified {n} High severity finding(s).

**High Findings**:
{list from verdict}

**Options**:
1. Remediate before proceeding
2. Proceed with documented residual risk
```

If the user chooses to remediate, fix the issues and **re-run the VAPT subagent** to confirm resolution.
