# Technical Scoping & Engineering Discovery

**Assume the role** of a senior engineer and technical architect

**Optional Stage**: Executes only when the team opts in. Always prompted at the start of the Comprehensive Path.

---

## Purpose

Assess the engineering complexity, scope, and structure of the incoming request **before** any requirements, stories, or design work begins. For large or ambiguous initiatives, produce a decomposition recommendation that breaks the input into independently deliverable sub-initiatives — each assigned to the right workflow (Fast-Track or Comprehensive Path).

This stage is advisory. All outputs are proposals for human review and approval. The AI does not make final scope or decomposition decisions.

---

## Opt-In Gate

Before executing, present the following prompt and **wait for the user's response**:

```markdown
## Technical Scoping & Engineering Discovery (Optional)

Would you like the AI to run a **Technical Scoping & Engineering Discovery** analysis
before proceeding to Requirements Analysis?

This stage will:
- Assess the engineering size and complexity of the request
- Identify affected systems, services, and domains
- Recommend whether to proceed as a single initiative or decompose into sub-initiatives
- For each proposed sub-initiative, recommend the appropriate workflow (Fast-Track or Comprehensive Path)

Reply **YES** to run Technical Scoping, or **NO** to proceed directly to Requirements Analysis.
```

- If the user replies **NO** (or equivalent): log the decision in `audit.md`, mark stage as `Skipped` in `state.md`, and proceed to Requirements Analysis
- If the user replies **YES** (or equivalent): continue with the execution steps below

---

## Prerequisites

- Branch Creation must be complete
- Workspace Detection must be complete
- Reverse Engineering artifacts loaded as context (if brownfield)

---

## Execution Steps

### Step 1: Load Context

**IF brownfield project**:
- Load `specs/_project/reverse-engineering/architecture.md`
- Load `specs/_project/reverse-engineering/component-inventory.md`
- Load `specs/_project/reverse-engineering/technology-stack.md`
- Load `specs/_project/reverse-engineering/business-overview.md` (if exists)

Use these artifacts to understand the existing system boundary, domain ownership, and integration topology when evaluating the incoming request.

---

### Step 2: Request Classification

Classify the incoming request on two axes:

#### 2.1 Initiative Size

| Size | Signals |
|------|---------|
| **Story** | Single, well-defined user-facing change; one component; clear acceptance criteria; no cross-system impact |
| **Feature** | Multiple related changes; one or two components; some integration work; bounded scope |
| **Initiative** | Multiple features with a shared business goal; spans several components or services; may require phased delivery and decomposition into sub-initiatives |

> **Note**: If the request appears larger than an Initiative (e.g. multi-quarter, cross-domain, multiple teams with no shared boundary), flag this explicitly in the scoping report and recommend that the team scope it down to Initiative level before proceeding. Fluid Flow operates at Initiative level and below.

#### 2.2 Engineering Clarity

| Clarity | Signals |
|---------|---------|
| **High** | Specific, actionable, implementation path is obvious |
| **Medium** | General direction is clear, but several design decisions remain open |
| **Low** | Ambiguous goals, multiple possible approaches, unknowns dominate |

Record both classifications in the scoping report.

---

### Step 3: Technical Scope Signals

Identify which systems, services, and domains are likely affected. For each, note:
- Whether it is **directly changed** or **indirectly impacted**
- Which team(s) own it (if identifiable from RE artifacts or request context)
- Whether it has a stable API boundary or requires interface negotiation

Signals to look for in the request and RE context:
- Data model changes (schema migrations, new entities, relationship changes)
- API changes (new endpoints, contract modifications, versioning implications)
- Cross-service communication (event publishing, service calls, shared state)
- Infrastructure changes (new cloud resources, deployment topology changes)
- Security or identity surface changes (auth flows, permission models, data classification)
- Observability or operational changes (new dashboards, alert thresholds, SLO impact)

---

### Step 4: Engineering Complexity Indicators

Assess the following complexity dimensions:

| Dimension | Low | Medium | High |
|-----------|-----|--------|------|
| **Component span** | 1 component | 2–3 components | 4+ components |
| **Integration surface** | None | 1–2 integration points | 3+ integration points |
| **Data model impact** | None or additive | Modifications to existing entities | Schema migrations or breaking changes |
| **ADR implications** | None | May extend existing ADRs | Likely requires new ADRs |
| **NFR surface** | Minimal | Performance or security considerations | Compliance, resilience, or scalability requirements |
| **Team dependency** | Single team | 2 teams | 3+ teams or cross-domain |
| **Delivery risk** | Low (reversible) | Medium (phased rollout helpful) | High (requires independent validation gates) |
| **Unknowns** | None | A few clarifiable unknowns | Significant research required before design |

Summarise each dimension in the report. Flag any dimension rated **High** as a risk signal.

---

### Step 5: Decomposition Recommendation

Based on the classification and complexity indicators, determine whether the request should proceed as a **single initiative** or be **decomposed into sub-initiatives**.

#### 5.1 Proceed as Single Initiative When

- Size is Story or Feature
- Complexity dimensions are predominantly Low or Medium
- No cross-team dependencies
- No significant unknowns
- A single Comprehensive Path or Fast-Track cycle is sufficient to deliver the whole request

#### 5.2 Recommend Decomposition When

- Size is Initiative, or the request exceeds Initiative scope
- Three or more High-rated complexity dimensions
- Multiple teams or domains involved
- Delivery risk is High
- The request contains logically separable capabilities that could be delivered independently

#### 5.3 Workflow Assignment Per Sub-Initiative

When decomposing, assign each sub-initiative to a workflow using the following criteria:

**Recommend Fast-Track when the sub-initiative:**
- Is well-defined with clear inputs and outputs
- Is bounded to one or two components
- Requires no new infrastructure, no ADRs, and no NFR analysis
- Is low risk and easily reversible
- Has a natural, single implementation path

**Recommend Comprehensive Path when the sub-initiative:**
- Involves new or changed infrastructure
- Has cross-service or cross-domain impact
- Requires architectural decisions that need ADRs
- Requires NFR analysis (performance, security, compliance, resilience)
- Involves multiple teams or has significant unknowns
- Has high delivery risk requiring formal design gates

#### 5.4 Sequencing Recommendation

If decomposition is recommended, propose a delivery sequence:
- Identify blocking dependencies (which sub-initiatives must land first to unblock others)
- Recommend whether sub-initiatives can run in parallel or must be sequential
- Note any shared infrastructure or data model work that should be extracted as its own sub-initiative and delivered first

---

### Step 6: Generate Technical Scoping Report

Create `specs/{BRANCH_NAME}/inception/technical-scoping/technical-scoping-report.md`:

```markdown
# Technical Scoping & Engineering Discovery Report

**Branch**: {BRANCH_NAME}
**JIRA Ticket**: {JIRA_TICKET | null}
**Generated**: [ISO timestamp]

---

## Request Classification

- **Initiative Size**: [Story / Feature / Initiative / Exceeds Initiative scope (flag for pre-scoping)]
- **Engineering Clarity**: [High / Medium / Low]
- **Recommendation**: [Proceed as single initiative / Decompose into sub-initiatives]

---

## Technical Scope Signals

| System / Service / Domain | Change Type | Owner (if known) | Notes |
|---------------------------|-------------|------------------|-------|
| ...                       | ...         | ...              | ...   |

---

## Engineering Complexity Assessment

| Dimension | Rating | Notes |
|-----------|--------|-------|
| Component span | [Low / Medium / High] | ... |
| Integration surface | [Low / Medium / High] | ... |
| Data model impact | [Low / Medium / High] | ... |
| ADR implications | [Low / Medium / High] | ... |
| NFR surface | [Low / Medium / High] | ... |
| Team dependency | [Low / Medium / High] | ... |
| Delivery risk | [Low / Medium / High] | ... |
| Unknowns | [Low / Medium / High] | ... |

**Risk Signals** (High-rated dimensions):
- [List any High-rated dimensions and brief rationale]

---

## Decomposition Recommendation

[If proceeding as single initiative:]

The request is within the scope of a single [Fast-Track / Comprehensive Path] cycle. No decomposition is recommended.

**Recommended workflow**: [Fast-Track / Comprehensive Path]

---

[If decomposing:]

The request is too broad for a single workflow cycle. The following decomposition is proposed:

### Proposed Sub-Initiatives

| # | Sub-Initiative Name | Scope Summary | Recommended Workflow | Sequence / Dependencies |
|---|---------------------|---------------|----------------------|-------------------------|
| 1 | ...                 | ...           | Fast-Track / Comprehensive Path | First — unblocks #2, #3 |
| 2 | ...                 | ...           | Fast-Track / Comprehensive Path | Depends on #1 |
| ... | ...               | ...           | ...                  | ... |

### Delivery Sequence

[Prose description of the recommended delivery order and rationale]

### Branch Naming Suggestions

[Proposed branch names for each sub-initiative, following the `###-jira-ticket-short-description` pattern]

---

## What Was Not Addressed

- [List any areas explicitly out of scope for this scoping analysis]
- [List any areas where the AI lacked sufficient context to assess]

---

## Key Assumptions

- [List assumptions made during analysis]

---

## AI Self-Review

- **Known risks**: [List]
- **Significant unknowns**: [List]
- **Confidence level**: [High / Medium / Low] — [brief rationale]

> This report is a proposal. Final scope and decomposition decisions rest with the team.
```

---

### Step 7: Update State Tracking

Update `specs/{BRANCH_NAME}/state.md`:

```markdown
## Stage Progress
### 🔵 INCEPTION PHASE
- [x] Technical Scoping & Engineering Discovery
```

Include the classification outcome and recommendation summary in the state entry.

---

### Step 8: Log and Present for Approval

1. Log the completion and report path in `specs/{BRANCH_NAME}/audit.md`
2. Present the completion message:

```markdown
# 🔭 Technical Scoping & Engineering Discovery Complete
```

Provide a brief structured summary:
- Classification outcome (size and clarity)
- Number of risk signals identified
- Recommendation (single initiative or decomposition with sub-initiative count)

Then end with:

```markdown
> **📋 <u>**REVIEW REQUIRED:**</u>**  
> Please examine the scoping report at: `specs/{BRANCH_NAME}/inception/technical-scoping/technical-scoping-report.md`



> **🚀 <u>**WHAT'S NEXT?**</u>**
>
> **You may:**
>
> 🔧 **Request Changes** — Ask for modifications to the scoping report or decomposition recommendation
> ✅ **Approve & Continue** — Approve the scoping report and proceed to **Requirements Analysis**

---
```

3. **Wait for explicit user approval** before proceeding
4. Record approval response with timestamp in `audit.md`
5. Update Technical Scoping & Engineering Discovery stage as complete in `state.md`

---

## Skipped Stage Handling

If the user opted out:

1. Log in `audit.md`:
   ```markdown
   ## Technical Scoping & Engineering Discovery
   **Timestamp**: [ISO timestamp]
   **User Input**: "NO" (or equivalent)
   **AI Response**: "Technical Scoping & Engineering Discovery skipped at user request"
   **Context**: Inception Phase — Stage skipped, proceeding to Requirements Analysis
   ```
2. Update `state.md`: `- [~] Technical Scoping & Engineering Discovery (skipped)`
3. Proceed directly to Requirements Analysis
