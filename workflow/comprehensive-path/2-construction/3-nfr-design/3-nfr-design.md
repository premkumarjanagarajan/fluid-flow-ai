---
step: nfr-design
subagent: false
---

# NFR Design

**Non-functional requirements design per unit**

## Inputs

- NFR Requirements must be complete for the unit
- NFR requirements artifacts must be available
- Execution plan must indicate NFR Design stage should execute

**Read from**:
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/{unit-name}/nfr-requirements/`

## Guidance

### Purpose

Incorporate NFR requirements into unit design using patterns and logical components.

### Step 1: Analyze NFR Requirements

- Read NFR requirements from `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/{unit-name}/nfr-requirements/`
- Understand scalability, performance, availability, security needs

### Step 2: Create NFR Design Plan

- Generate plan with checkboxes [] for NFR design
- Focus on design patterns and logical components
- Each step should have a checkbox []

### Step 3: Generate Context-Appropriate Questions

**DIRECTIVE**: Analyze the NFR requirements to generate ONLY questions relevant to THIS specific unit's NFR design. Use the categories below as inspiration, NOT as a mandatory checklist. Skip entire categories if not applicable.

- EMBED questions using [Answer]: tag format
- Focus on ambiguities and missing information specific to this unit
- Generate questions only where user input is needed for pattern and component decisions

**Question format**: See `../../../knowledge-core/question-format-guide.md`

**Example question categories** (adapt as needed):
- **Resilience Patterns** - Only if fault tolerance approach needs clarification
- **Scalability Patterns** - Only if scaling mechanisms are unclear
- **Performance Patterns** - Only if performance optimization strategy is ambiguous
- **Security Patterns** - Only if security implementation approach needs input
- **Logical Components** - Only if infrastructure components (queues, caches, etc.) need clarification

### Step 4: Store Plan

- Save as `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/plans/{unit-name}-nfr-design-plan.md`
- Include all [Answer]: tags for user input

### Step 5: Collect and Analyze Answers

- **MANDATORY**: Offer the user the choice between **Answer Manually** or **AI Best Judgement** mode (see `../../../knowledge-core/question-format-guide.md` for full details):
  - **Answer Manually**: Wait for user to complete all [Answer]: tags
  - **AI Best Judgement**: AI fills all [Answer]: tags with best judgement, adds [Reasoning]: for each, flags low-confidence answers; user reviews and overrides as needed; wait for user to confirm review is complete
- Review for vague or ambiguous responses
- Add follow-up questions if needed

### Step 6: Generate NFR Design Artifacts

- Create `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/{unit-name}/nfr-design/nfr-design-patterns.md`
- Create `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/{unit-name}/nfr-design/logical-components.md`

## Outputs

- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/plans/{unit-name}-nfr-design-plan.md`
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/{unit-name}/nfr-design/nfr-design-patterns.md`
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/{unit-name}/nfr-design/logical-components.md`

## Gate

1. **Completion Announcement** (mandatory):

```markdown
# 🎨 NFR Design Complete - [unit-name]
```

2. **AI Summary** (optional): Provide structured bullet-point summary of NFR design
   - Format: "NFR design has incorporated [description]:"
   - List key design patterns implemented (bullet points)
   - List logical components and infrastructure elements
   - Mention resilience, scalability, and performance patterns applied
   - DO NOT include workflow instructions ("please review", "let me know", "proceed to next phase", "before we proceed")
   - Keep factual and content-focused

3. **Formatted Workflow Message** (mandatory):

```markdown
> **📋 <u>**REVIEW REQUIRED:**</u>**  
> Please examine the NFR design at: `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/[unit-name]/nfr-design/`

> **🚀 <u>**WHAT'S NEXT?**</u>**
>
> **You may:**
>
> 🔧 **Request Changes** - Ask for modifications to the NFR design based on your review  
> ✅ **Continue to Next Stage** - Approve NFR design and proceed to **Infrastructure Design**

---
```

4. **Wait for explicit user approval** before proceeding. If user requests changes, update the design and repeat the approval process.
