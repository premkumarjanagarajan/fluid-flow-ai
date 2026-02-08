---
name: fluid-flow-rules
description: The Unified Workflow Entry Point
---

# PRIORITY: This workflow is the SINGLE ENTRY POINT for all development work
# When a user requests software development, ALWAYS follow this workflow FIRST

## Authority & Accountability

AI is a non-accountable participant in the delivery lifecycle.

AI may:
- Propose designs, implementations, and alternatives
- Analyse risks, trade-offs, and impacts
- Generate code and documentation

AI must never:
- Make final architectural decisions
- Make compliance or regulatory decisions
- Assume jurisdictional constraints
- Modify security or data-handling models without approval

Final accountability always rests with humans.

## MANDATORY: Shared Memory Loading
**CRITICAL**: At workflow start, you MUST load the following shared memory files:

**Always load:**
- Load `../../fluid-flow/workflows/shared/memory/ai-operating-contract.md` for AI operating contract
- Load `../../fluid-flow/workflows/shared/memory/content-validation.md` for content validation requirements
- Load `../../fluid-flow/workflows/shared/memory/review/ai-self-review.md` for Self Review Guidelines
- Load `../../fluid-flow/workflows/shared/memory/review/human-gate.md` for Human Gate Guidelines
- Load `../../fluid-flow/workflows/shared/memory/iso/iso9001-quality-management.md` for quality management

**Load when changes affect security, data, identity, or infrastructure:**
- Load `../../fluid-flow/workflows/shared/memory/security/iso27001/compliance.md` for ISO 27001 compliance
- Load `../../fluid-flow/workflows/shared/memory/security/*.md` for all security rules

## MANDATORY: Custom Welcome Message
**CRITICAL**: When starting ANY software development request, you MUST display the welcome message.
1. Load the welcome message from `../../fluid-flow/workflows/shared/memory/welcome-message.md`
2. Display the complete message to the user
3. This should only be done ONCE at the start of a new workflow
4. Do NOT load this file in subsequent interactions to save context space

---

# Unified Entry Flow

The shared entry point orchestrates three stages before routing to a workflow:

1. **Branch Creation** (ALWAYS)
2. **Workspace Detection** (ALWAYS)
3. **Reverse Engineering** (CONDITIONAL - Brownfield, run-once per project)
4. **Complexity Assessment** (ALWAYS)
5. **Workflow Routing** (ALWAYS - routes to Spec-Kit or AWS AI-DLC)

---

## Stage 1: Branch Creation (ALWAYS EXECUTE)

**Purpose**: Create a numbered feature branch and initialize the feature directory.

1. Parse the user's request to extract the feature description
2. **Generate a concise short name** (2-4 words) for the branch:
   - Analyze the feature description and extract meaningful keywords
   - Use action-noun format when possible (e.g., "add-user-auth", "fix-payment-bug")
   - Preserve technical terms and acronyms
3. **Create the feature branch** by running `../../spec-kit/scripts/bash/create-new-feature.sh`:
   - Pass `--json` for structured output
   - Pass `--short-name "<name>"` with the generated short name
   - Pass the feature description as positional argument
   - Parse the JSON output for BRANCH_NAME, SPEC_FILE, FEATURE_NUM
   - For single quotes in args, use escape syntax: e.g `"I'm Groot"` (double-quote)
4. **Initialize state tracking** in the feature directory (`specs/{BRANCH_NAME}/`):
   - Create `state.md` with initial state (see State File Format below)
   - Create `audit.md` with header (see Audit File Format below)
5. **Create project directory** if it does not exist: `specs/_project/`
6. **MANDATORY**: Log the initial user request in `audit.md` with complete raw input

### State File Format

Create `specs/{BRANCH_NAME}/state.md`:

```markdown
# Feature State Tracking

## Feature Information
- **Branch**: {BRANCH_NAME}
- **Created**: [ISO timestamp]
- **Current Stage**: Entry Point - Branch Creation
- **Workflow**: Pending (awaiting complexity assessment)

## Entry Point Progress
- [ ] Branch Creation
- [ ] Workspace Detection
- [ ] Reverse Engineering (if brownfield)
- [ ] Complexity Assessment
- [ ] Workflow Routing

## Workspace State
[Populated by Workspace Detection]

## Workflow Progress
[Populated by chosen workflow]
```

### Audit File Format

Create `specs/{BRANCH_NAME}/audit.md`:

```markdown
# Feature Audit Trail

**Branch**: {BRANCH_NAME}
**Created**: [ISO timestamp]

---

## Branch Creation
**Timestamp**: [ISO timestamp]
**User Input**: "[Complete raw user input - never summarized]"
**AI Response**: "Created feature branch {BRANCH_NAME}"
**Context**: Entry Point - Branch Creation

---
```

---

## Stage 2: Workspace Detection (ALWAYS EXECUTE)

1. **MANDATORY**: Log start of workspace detection in audit.md
2. Load all steps from `../stages/workspace-detection.md`
3. Execute workspace detection:
   - Check for existing `specs/{BRANCH_NAME}/state.md` (resume if found with populated state)
   - Scan workspace for existing code
   - Determine if brownfield or greenfield
   - Check for existing reverse engineering artifacts at `specs/_project/reverse-engineering/`
4. Update `specs/{BRANCH_NAME}/state.md` with workspace findings
5. Update `specs/{BRANCH_NAME}/workspace-detection.md` with detailed findings
6. Mark checkbox in state.md: `[x] Workspace Detection`
7. Present completion message to user (see workspace-detection.md for message formats)
8. Automatically proceed to next stage

---

## Stage 3: Reverse Engineering (CONDITIONAL - Brownfield, Run-Once)

**Execute IF**:
- Existing codebase detected (brownfield)
- No previous reverse engineering artifacts found at `specs/_project/reverse-engineering/reverse-engineering-timestamp.md`

**Skip IF**:
- Greenfield project (no existing code)
- Previous reverse engineering artifacts exist at `specs/_project/reverse-engineering/`
  - Log: "Using existing reverse engineering artifacts from [timestamp]"
  - Load artifacts as context for complexity assessment

**Execution**:
1. **MANDATORY**: Log start of reverse engineering in audit.md
2. Load all steps from `../stages/reverse-engineering.md`
3. Execute reverse engineering:
   - Analyze all packages and components
   - Generate business overview, architecture documentation, C4 architecture model, code structure, API docs, component inventory, technology stack, dependencies, code quality assessment
   - Write ALL artifacts to `specs/_project/reverse-engineering/`
4. **Wait for Explicit Approval**: Present detailed completion message - DO NOT PROCEED until user confirms
5. **MANDATORY**: Log user's response in audit.md with complete raw input
6. Mark checkbox in state.md: `[x] Reverse Engineering`

---

## Stage 4: Complexity Assessment (ALWAYS EXECUTE)

**Purpose**: Evaluate the complexity of the request and recommend the appropriate workflow.

1. **MANDATORY**: Log start of complexity assessment in audit.md
2. Load all steps from `../stages/complexity-assessment.md`
3. Load context:
   - User's original request (from audit.md)
   - Workspace detection findings (from `specs/{BRANCH_NAME}/workspace-detection.md`)
   - Reverse engineering artifacts (from `specs/_project/reverse-engineering/` if they exist)
4. Execute complexity assessment per `../stages/complexity-assessment.md`
5. Present recommendation with reasoning to user
6. **Wait for Human Confirmation**: User may accept or override the recommendation
7. **MANDATORY**: Log the decision in audit.md and state.md
8. Mark checkbox in state.md: `[x] Complexity Assessment`

---

## Stage 5: Workflow Routing (ALWAYS EXECUTE)

Based on the confirmed workflow choice:

### If Spec-Kit was chosen:

1. Update `specs/{BRANCH_NAME}/state.md`: Set `**Workflow**: Spec-Kit`
2. Log routing decision in audit.md
3. Inform the user:
   ```markdown
   ## Workflow: Spec-Kit

   Your feature will follow the Spec-Kit workflow. The next steps are:

   1. `/speckit.specify` - Create the feature specification
   2. `/speckit.clarify` - (optional) Clarify ambiguities
   3. `/speckit.plan` - Create the implementation plan
   4. `/speckit.tasks` - Generate ordered tasks
   5. `/speckit.implement` - Execute the implementation

   The feature directory is ready at: `specs/{BRANCH_NAME}/`

   **Ready to proceed with specification?**
   ```

### If AWS AI-DLC was chosen:

1. Update `specs/{BRANCH_NAME}/state.md`: Set `**Workflow**: AWS AI-DLC`
2. Log routing decision in audit.md
3. The AWS workflow begins from **Requirements Analysis** (workspace detection and reverse engineering are already complete)
4. Load the AWS workflow rules from `../../aws/commands/aws-rules.md`
5. Execute the AWS workflow starting from Requirements Analysis

---

## Key Principles

- **Single Entry Point**: All development work starts here
- **Adaptive Routing**: Simple work goes to Spec-Kit, complex work goes to AWS AI-DLC
- **Human Control**: User can override the AI's workflow recommendation
- **Standardized Branching**: All features use `###-feature-name` numbered branches
- **Standardized Artifacts**: All features write to `specs/{branch}/`
- **Project-Level RE**: Reverse engineering runs once, stored at `specs/_project/`, updated after implementations
- **Full Audit Trail**: Every interaction logged in `specs/{branch}/audit.md`
- **Complete State Tracking**: Progress tracked in `specs/{branch}/state.md`

## Prompts Logging Requirements
- **MANDATORY**: Log EVERY user input (prompts, questions, responses) with timestamp in audit.md
- **MANDATORY**: Capture user's COMPLETE RAW INPUT exactly as provided (never summarize)
- **MANDATORY**: Log every approval prompt with timestamp before asking the user
- **MANDATORY**: Record every user response with timestamp after receiving it
- **CRITICAL**: ALWAYS append changes to EDIT audit.md file, NEVER use tools and commands that completely overwrite its contents
- Use ISO 8601 format for timestamps (YYYY-MM-DDTHH:MM:SSZ)
- Include stage context for each entry

### Audit Log Format:
```markdown
## [Stage Name or Interaction Type]
**Timestamp**: [ISO timestamp]
**User Input**: "[Complete raw user input - never summarized]"
**AI Response**: "[AI's response or action taken]"
**Context**: [Stage, action, or decision made]

---
```

### Correct Tool Usage for audit.md

✅ CORRECT:

1. Read the audit.md file
2. Append/Edit the file to make changes

❌ WRONG:

1. Read the audit.md file
2. Completely overwrite the audit.md with the contents of what you read, plus the new changes you want to add to it

## MANDATORY: Content Validation
**CRITICAL**: Before creating ANY file, you MUST validate content according to `../memory/content-validation.md` rules:
- Validate Mermaid diagram syntax
- Escape special characters properly
- Provide text alternatives for complex visual content
- Test content parsing compatibility

## AI Self-Review Gate

Before finalising output, the AI must explicitly state:
- Key assumptions made
- Known risks and unknowns
- Operational and on-call impact
- Rollback or mitigation strategy
- What was intentionally not addressed

The AI must not self-approve its own output.
