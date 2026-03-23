---
step: infrastructure-design
subagent: false
---

# Infrastructure Design

**Infrastructure and deployment design per unit**

## Inputs

- Functional Design must be complete for the unit
- NFR Design recommended (provides logical components to map)
- Execution plan must indicate Infrastructure Design stage should execute

**Read from**:
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/{unit-name}/functional-design/`
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/{unit-name}/nfr-design/` (if exists)

## Guidance

### Purpose

Map logical software components to actual infrastructure choices for deployment environments.

### Step 1: Analyze Design Artifacts

- Read functional design from `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/{unit-name}/functional-design/`
- Read NFR design from `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/{unit-name}/nfr-design/` (if exists)
- Identify logical components needing infrastructure

### Step 2: Create Infrastructure Design Plan

- Generate plan with checkboxes [] for infrastructure design
- Focus on mapping to actual services (AWS, Azure, GCP, on-premise)
- Each step should have a checkbox []

### Step 3: Generate Context-Appropriate Questions

**DIRECTIVE**: Analyze the functional and NFR design to generate ONLY questions relevant to THIS specific unit's infrastructure needs. Use the categories below as inspiration, NOT as a mandatory checklist. Skip entire categories if not applicable.

- EMBED questions using [Answer]: tag format
- Focus on ambiguities and missing information specific to this unit
- Generate questions only where user input is needed for infrastructure decisions

**Question format**: See `../../../knowledge-core/question-format-guide.md`

**Example question categories** (adapt as needed):
- **Deployment Environment** - Only if cloud provider or environment setup is unclear
- **Compute Infrastructure** - Only if compute service choice needs clarification
- **Storage Infrastructure** - Only if database or storage selection is ambiguous
- **Messaging Infrastructure** - Only if messaging/queuing services need specification
- **Networking Infrastructure** - Only if load balancing or API gateway approach is unclear
- **Monitoring Infrastructure** - Only if observability tooling needs clarification
- **Shared Infrastructure** - Only if infrastructure sharing strategy is ambiguous

### Step 4: Store Plan

- Save as `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/plans/{unit-name}-infrastructure-design-plan.md`
- Include all [Answer]: tags for user input

### Step 5: Collect and Analyze Answers

- **MANDATORY**: Offer the user the choice between **Answer Manually** or **AI Best Judgement** mode (see `../../../knowledge-core/question-format-guide.md` for full details):
  - **Answer Manually**: Wait for user to complete all [Answer]: tags
  - **AI Best Judgement**: AI fills all [Answer]: tags with best judgement, adds [Reasoning]: for each, flags low-confidence answers; user reviews and overrides as needed; wait for user to confirm review is complete
- Review for vague or ambiguous responses
- Add follow-up questions if needed

### Step 6: Generate Infrastructure Design Artifacts

- Create `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/{unit-name}/infrastructure-design/infrastructure-design.md`
- Create `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/{unit-name}/infrastructure-design/deployment-architecture.md`
- If shared infrastructure: Create `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/shared-infrastructure.md`

## Outputs

- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/plans/{unit-name}-infrastructure-design-plan.md`
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/{unit-name}/infrastructure-design/infrastructure-design.md`
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/{unit-name}/infrastructure-design/deployment-architecture.md`
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/shared-infrastructure.md` (if shared infrastructure)

## Gate

1. **Completion Announcement** (mandatory):

```markdown
# 🏢 Infrastructure Design Complete - [unit-name]
```

2. **AI Summary** (optional): Provide structured bullet-point summary of infrastructure design
   - Format: "Infrastructure design has mapped [description]:"
   - List key infrastructure services and components (bullet points)
   - List deployment architecture decisions and rationale
   - Mention cloud provider choices and service mappings
   - DO NOT include workflow instructions ("please review", "let me know", "proceed to next phase", "before we proceed")
   - Keep factual and content-focused

3. **Formatted Workflow Message** (mandatory):

```markdown
> **📋 <u>**REVIEW REQUIRED:**</u>**  
> Please examine the infrastructure design at: `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/[unit-name]/infrastructure-design/`

> **🚀 <u>**WHAT'S NEXT?**</u>**
>
> **You may:**
>
> 🔧 **Request Changes** - Ask for modifications to the infrastructure design based on your review  
> ✅ **Continue to Next Stage** - Approve infrastructure design and proceed to **Code Generation**

---
```

4. **Wait for explicit user approval** before proceeding. If user requests changes, update the design and repeat the approval process.
