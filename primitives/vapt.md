# VAPT — Vulnerability Assessment & Penetration Testing

Perform a structured, AI-assisted security assessment of all generated code and infrastructure prior to deployment. The VAPT primitive identifies vulnerabilities and simulates adversarial attack scenarios. All findings are proposals for human action — the AI never self-approves, remediates silently, or makes compliance decisions.

**Trigger**: Runs after the Construction phase completes (implementation done), before the orchestrator's Stage 7 Completion actions (risk report, commit/PR). This is a primitive because it executes automatically as part of the lifecycle.

---

## Prerequisites

- Implementation is complete and all code artifacts exist
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/` exists with metadata and artefacts
- Brownfield context at `{LOCAL_REPO_PATH}/initiatives/_project/reverse-engineering/` (if available)

---

## Conditional Depth

VAPT is **always executed** but depth scales with risk:

| Signal | Source | Depth |
|--------|--------|-------|
| Complexity Assessment = High | `metadata/state.md` | Full (VA + PT) |
| New authentication or authorisation logic | spec.md / code | Full (VA + PT) |
| External API or third-party integrations | plan.md | Full (VA + PT) |
| Data classification = Sensitive / PII / PHI | `knowledge-base-core/security/data-classification.md` | Full (VA + PT) |
| Infrastructure changes (cloud resources, IAM, networking) | plan.md | Full (VA + PT) |
| Low-complexity UI or config-only change | spec.md | Lite (VA only) |

Record the determined depth (`Full` or `Lite`) in the VAPT report header.

---

## Step 1: Load Context

1. Read `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/spec.md` — feature scope, data handled, entry points
2. Read `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/plan.md` (if exists) — tech stack, architecture, dependencies
3. Read `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/tasks.md` (if exists) — implemented components
4. If brownfield, load from `{LOCAL_REPO_PATH}/initiatives/_project/reverse-engineering/`:
   - `architecture.md`, `dependencies.md`, `api-documentation.md`
5. Load security knowledge from `knowledge-base-core/security/`:
   - `threat-model.md`, `authz-authn.md`, `data-classification.md`, `secrets-management.md`
   - `network-boundaries.md`, `logging-security.md`, `dependencies.md`, `iso27001-compliance.md`

---

## Step 2: Vulnerability Assessment (VA)

Analyse all generated code and configuration for the following classes. For each finding, record: ID, category, severity, CVSS score (approximate), affected file/component, description, and remediation guidance.

### VA-1: Static Code Analysis (SAST)

| Check | Description |
|-------|-------------|
| Injection flaws | SQL, NoSQL, LDAP, OS command, expression injection in input-handling code |
| Insecure deserialisation | Untrusted data passed to deserialisation functions |
| Weak cryptography | MD5, SHA1, DES, hardcoded IVs, insufficient key lengths |
| Insecure randomness | `Math.random()`, `rand()`, or equivalent used for security-sensitive values |
| Path traversal | User-controlled input used in file system operations |
| XXE | XML parsers configured without disabling external entities |
| Open redirects | User-controlled redirect targets without validation |
| Error information disclosure | Stack traces, internal paths, or DB errors returned to clients |

### VA-2: Dependency Scanning

- Identify all packages and frameworks from `package.json`, `requirements.txt`, `pom.xml`, `go.mod`, or equivalent
- Flag dependencies with active CVEs, significantly outdated with known security history, or unmaintained/deprecated
- Record: dependency name, version (if detectable), advisory reference

### VA-3: Secret and Credential Scanning

Scan all generated files for hardcoded secrets:
- API keys, tokens, passwords, private keys
- Connection strings with embedded credentials
- Base64-encoded credential patterns
- Common secret format patterns (`sk_live_`, `AKIA`, `-----BEGIN RSA PRIVATE KEY-----`)

### VA-4: Configuration Review

| Check | Description |
|-------|-------------|
| Debug/verbose mode in production config | `DEBUG=true`, verbose logging of sensitive data |
| Overly permissive CORS | `Access-Control-Allow-Origin: *` on authenticated endpoints |
| Missing security headers | CSP, HSTS, X-Frame-Options, X-Content-Type-Options |
| Insecure storage config | Unencrypted buckets, publicly accessible storage, missing encryption at rest |
| Over-permissive IAM | Wildcard (`*`) actions or resources in IAM policies |
| Unencrypted transport | HTTP where HTTPS required, TLS < 1.2 |
| Default credentials | Default usernames/passwords left unchanged |

### VA-5: Data Classification Compliance

Cross-reference data handled by the feature against `knowledge-base-core/security/data-classification.md`:
- Identify all data classes processed (PII, PHI, financial, credentials, etc.)
- Verify each class is handled per its classification requirements
- Flag mismatches between classification requirements and implementation

---

## Step 3: Penetration Testing Simulation (PT) — Full Depth Only

Act as an adversary. Map all entry points and simulate attacks. **Skipped for Lite depth.**

### PT-1: Attack Surface Mapping

Enumerate all entry points and present as a table:

| Entry Point | Method | Auth Required | Data Accepted | Trust Boundary |
|-------------|--------|---------------|---------------|----------------|

Covers: HTTP/API endpoints, CLI arguments, file upload handlers, WebSocket connections, background job triggers, webhook callbacks, admin interfaces.

### PT-2: Authentication & Authorisation Testing

| Attack | Description |
|--------|-------------|
| Horizontal privilege escalation | User A accessing User B's resources via ID manipulation |
| Vertical privilege escalation | Low-privilege user invoking admin operations |
| Authentication bypass | JWT `alg:none`, token reuse, missing auth on secondary endpoints |
| Insecure direct object reference | Sequential/predictable IDs allowing enumeration |
| Missing function-level access control | Internal APIs reachable without authentication |
| Session fixation / hijacking | Tokens not rotated after login, long-lived tokens without rotation |

### PT-3: Injection Testing

| Vector | Target |
|--------|--------|
| SQL injection | Database query construction using user input |
| NoSQL injection | MongoDB `$where`, `$regex` operator abuse |
| Command injection | Shell calls with user-controlled arguments |
| Template injection | SSTI in server-side rendering |
| Header injection | CRLF injection in response headers |
| GraphQL injection | Introspection abuse, query depth attacks |

### PT-4: API Abuse Scenarios

| Scenario | Description |
|----------|-------------|
| Rate limiting bypass | Repeated requests to exhaustible resources without throttling |
| Mass assignment | Posting unexpected fields that get persisted |
| Parameter tampering | Altering price, quantity, role, or status fields |
| Improper HTTP method handling | Sending PUT/DELETE to GET-only endpoints |
| Business logic abuse | Skipping required workflow steps, replaying completed actions |

### PT-5: Infrastructure Threats

When infrastructure code is present:

| Check | Description |
|-------|-------------|
| Network boundary violations | Resources in public subnets that should be private |
| Security group misconfigurations | Overly permissive inbound rules (0.0.0.0/0 on non-public ports) |
| Unencrypted data in transit | Internal service communication without TLS |
| Logging and monitoring gaps | Missing audit trails or flow logs for security-sensitive paths |
| Lateral movement risks | Excessive cross-service IAM trust relationships |

---

## Step 4: OWASP Top 10 Coverage Matrix

Map all findings to the OWASP Top 10 (2021):

| # | Category | Tested | Status | Finding IDs |
|---|----------|--------|--------|-------------|
| A01 | Broken Access Control | Yes/No | Pass / Finding | |
| A02 | Cryptographic Failures | Yes/No | Pass / Finding | |
| A03 | Injection | Yes/No | Pass / Finding | |
| A04 | Insecure Design | Yes/No | Pass / Finding | |
| A05 | Security Misconfiguration | Yes/No | Pass / Finding | |
| A06 | Vulnerable & Outdated Components | Yes/No | Pass / Finding | |
| A07 | Identification & Authentication Failures | Yes/No | Pass / Finding | |
| A08 | Software & Data Integrity Failures | Yes/No | Pass / Finding | |
| A09 | Security Logging & Monitoring Failures | Yes/No | Pass / Finding | |
| A10 | Server-Side Request Forgery | Yes/No | Pass / Finding | |

---

## Step 5: Generate VAPT Report

Create directory `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/security/` if it does not exist.

Generate the report at: `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/security/vapt-report.md`

Follow the template at `knowledge-base-core/security/vapt-report-template.md`.

---

## Step 6: Severity Triage & Human Gate

| Overall Risk | Gate Behaviour |
|--------------|----------------|
| **Critical findings** | **MANDATORY STOP** — present findings and require explicit human risk-acceptance or confirmation of remediation before continuing |
| **High findings** | Present findings and ask: "Remediate before proceeding, or proceed with documented residual risk?" Wait for response |
| **Medium findings only** | Log in report, present summary, proceed |
| **Low / Informational only** | Log in report, proceed |
| **No findings** | Present clean result, proceed |

**Critical findings prompt**:

```
## VAPT — Critical Findings Detected

The assessment identified [n] Critical severity finding(s) requiring resolution
or explicit risk acceptance before proceeding.

**Critical Findings**:
[List each with ID, description, and recommended remediation]

**Options**:
1. Remediate and re-run VAPT
2. Accept risk (requires documented justification and human sign-off)

This stage cannot proceed without human approval.
```

**High findings prompt**:

```
## VAPT — High Severity Findings

The assessment identified [n] High severity finding(s).

**High Findings**:
[List each with ID, description, and recommended remediation]

**Options**:
1. Remediate before proceeding
2. Proceed with documented residual risk
```
