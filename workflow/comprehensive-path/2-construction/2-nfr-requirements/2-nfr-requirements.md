---
step: nfr-requirements
subagent: false
---

# NFR Requirements

**Non-functional requirements analysis per unit**

## Inputs

- Functional Design must be complete for the unit
- Unit functional design artifacts must be available
- Execution plan must indicate NFR Requirements stage should execute

**Read from**:
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/{unit-name}/functional-design/`

## Guidance

### Purpose

Determine non-functional requirements for the unit and make tech stack choices.

### Step 1: Analyze Functional Design

- Read functional design artifacts from `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/{unit-name}/functional-design/`
- Understand business logic complexity and requirements

### Step 2: Create NFR Requirements Plan

- Generate plan with checkboxes [] for NFR assessment
- Focus on scalability, performance, availability, security
- Each step should have a checkbox []

### Step 3: Generate Context-Appropriate Questions

**DIRECTIVE**: Thoroughly analyze the functional design to identify ALL areas where NFR clarification would improve system quality and architecture decisions. Be proactive in asking questions to ensure comprehensive NFR coverage.

**CRITICAL**: Default to asking questions when there is ANY ambiguity or missing detail that could affect system quality. It's better to ask too many questions than to make incorrect NFR assumptions.

- EMBED questions using [Answer]: tag format
- Focus on ANY ambiguities, missing information, or areas needing clarification
- Generate questions wherever user input would improve NFR and tech stack decisions
- **When in doubt, ask the question** - overconfidence leads to poor system quality

**Question format**: See `../../../knowledge-core/question-format-guide.md`

**Question categories to evaluate** (consider ALL categories):
- **Scalability Requirements** - Ask about expected load, growth patterns, scaling triggers, and capacity planning
- **Performance Requirements** - Ask about response times, throughput, latency, and performance benchmarks
- **Availability Requirements** - Ask about uptime expectations, disaster recovery, failover, and business continuity
- **Security Requirements** - Ask about data protection, compliance, authentication, authorization, and threat models
- **Tech Stack Selection** - Ask about technology preferences, constraints, existing systems, and integration requirements
- **Reliability Requirements** - Ask about error handling, fault tolerance, monitoring, and alerting needs
- **Maintainability Requirements** - Ask about code quality, documentation, testing, and operational requirements
- **Usability Requirements** - Ask about user experience, accessibility, and interface requirements

### Step 4: Store Plan

- Save as `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/plans/{unit-name}-nfr-requirements-plan.md`
- Include all [Answer]: tags for user input

### Step 5: Collect and Analyze Answers

- **MANDATORY**: Wait for user to complete all [Answer]: tags (see `../../knowledge-core/question-format-guide.md`).
- Wait for the user to confirm completion before proceeding.
- **MANDATORY**: Carefully review ALL responses for vague or ambiguous answers
- **CRITICAL**: Add follow-up questions for ANY unclear responses - do not proceed with ambiguity
- Look for responses like "depends", "maybe", "not sure", "mix of", "somewhere between", "standard", "typical"
- Create clarification questions file if ANY ambiguities are detected
- **Do not proceed until ALL ambiguities are resolved**

### Step 6: Generate NFR Requirements Artifacts

- Create `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/{unit-name}/nfr-requirements/nfr-requirements.md`
- Create `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/{unit-name}/nfr-requirements/tech-stack-decisions.md`

## Outputs

- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/plans/{unit-name}-nfr-requirements-plan.md`
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/{unit-name}/nfr-requirements/nfr-requirements.md`
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/{unit-name}/nfr-requirements/tech-stack-decisions.md`

## Gate

1. **Completion Announcement** (mandatory):

```markdown
# 📊 NFR Requirements Complete - [unit-name]
```

2. **AI Summary** (optional): Provide structured bullet-point summary of NFR requirements
   - Format: "NFR requirements assessment has identified [description]:"
   - List key scalability, performance, availability requirements (bullet points)
   - List security and compliance requirements identified
   - Mention tech stack decisions and rationale
   - DO NOT include workflow instructions ("please review", "let me know", "proceed to next phase", "before we proceed")
   - Keep factual and content-focused

3. **Formatted Workflow Message** (mandatory):

```markdown
> **📋 <u>**REVIEW REQUIRED:**</u>**  
> Please examine the NFR requirements at: `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/[unit-name]/nfr-requirements/`

> **🚀 <u>**WHAT'S NEXT?**</u>**
>
> **You may:**
>
> 🔧 **Request Changes** - Ask for modifications to the NFR requirements based on your review  
> ✅ **Continue to Next Stage** - Approve NFR requirements and proceed to **NFR Design**

---
```

4. **Wait for explicit user approval** before proceeding. If user requests changes, update the requirements and repeat the approval process.
