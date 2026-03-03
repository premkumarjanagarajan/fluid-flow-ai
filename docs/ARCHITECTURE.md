# Architecture

This document describes the internal architecture of Fluid Flow AI -- how its components relate to each other, how data flows through the system, and the design decisions behind the framework.

---

## System Overview

Fluid Flow AI is a layered workflow framework. At the top sits an IDE rule (e.g., a Cursor `.mdc` rule or a VS Code `copilot-instructions.md` file) that intercepts every development request. That rule loads a unified entry point which orchestrates shared stages, then routes to one of two workflow engines. Both engines share a common governance backbone.

```mermaid
C4Context
    title Fluid Flow AI - System Context

    Person(developer, "Developer", "Uses an AI-capable IDE to make development requests")

    System(fluidflow, "Fluid Flow AI", "Adaptive workflow framework for AI-assisted software development")

    System_Ext(ide, "AI-Capable IDE", "Code editor with AI rules engine (e.g., Cursor, VS Code with Copilot)")
    System_Ext(git, "Git", "Version control for branches and code")
    System_Ext(github, "GitHub", "Issue tracking and pull requests")

    Rel(developer, ide, "Makes development requests")
    Rel(ide, fluidflow, "Triggers workflow via IDE rule")
    Rel(fluidflow, git, "Creates branches, manages code")
    Rel(fluidflow, github, "Creates issues via /fasttrack.taskstoissues")
```

---

## Component Architecture

```mermaid
flowchart TB
    subgraph TRIGGER["Trigger Layer"]
        MDC["workflow.mdc<br/><i>IDE Rule Trigger</i>"]
    end

    subgraph ENTRY["Shared Entry Point"]
        FF["fluid-flow.md<br/><i>Unified Orchestrator</i>"]
        WD["workspace-detection.md"]
        RE["reverse-engineering.md"]
        WS["Workflow Selection<br/><i>User chooses</i>"]
    end

    subgraph MEMORY["Shared Memory"]
        AOC["ai-operating-contract.md"]
        CV["content-validation.md"]
        ASR["ai-self-review.md"]
        HG["human-gate.md"]
        SEC["security/*.md"]
        ISO["iso/*.md"]
        WM["welcome-message.md"]
    end

    subgraph FASTTRACK["Fast-Track Workflow"]
        direction TB
        subgraph FT_INC["Inception"]
            SS["/fasttrack.specify"]
            SC["/fasttrack.clarify"]
            SP["/fasttrack.plan"]
        end
        subgraph FT_CON["Construction"]
            ST["/fasttrack.tasks"]
            SCH["/fasttrack.checklist"]
            SI["/fasttrack.implement"]
        end
    end

    subgraph COMPREHENSIVE["Comprehensive Path Workflow"]
        direction TB
        INC["Inception Phase<br/><i>7 stages</i>"]
        CON["Construction Phase<br/><i>Per-unit loop + Build & Test</i>"]
    end

    subgraph COMPLETION["Shared Completion"]
        COMMIT["Commit"]
        PR["PR"]
        RR["Risk Report"]
    end

    subgraph SCRIPTS["Automation"]
        direction TB
        subgraph BASH["Bash (macOS/Linux)"]
            CNF["create-new-feature.sh"]
            CP["check-prerequisites.sh"]
            SPL["setup-plan.sh"]
            CMN["common.sh"]
        end
        subgraph PS["PowerShell (Windows)"]
            CNF_PS["create-new-feature.ps1"]
            CP_PS["check-prerequisites.ps1"]
            SPL_PS["setup-plan.ps1"]
            CMN_PS["common.ps1"]
        end
    end

    subgraph ARTIFACTS["Output Artifacts"]
        STATE["state.md"]
        AUDIT["audit.md"]
        WDART["workspace-detection.md"]
        REART["reverse-engineering/"]
        SPECS["spec.md, plan.md, tasks.md"]
    end

    MDC --> FF
    FF --> WD --> RE --> WS
    FF -.->|loads| MEMORY
    WS -->|"Fast-Track"| FASTTRACK
    WS -->|"Comprehensive Path"| COMPREHENSIVE
    FASTTRACK --> COMPLETION
    COMPREHENSIVE --> COMPLETION
    FASTTRACK -.->|uses| SCRIPTS
    FASTTRACK -.->|loads| MEMORY
    COMPREHENSIVE -.->|loads| MEMORY
    COMPLETION -->|writes| ARTIFACTS

    style TRIGGER fill:#CE93D8,stroke:#6A1B9A,stroke-width:2px
    style ENTRY fill:#90CAF9,stroke:#1565C0,stroke-width:2px
    style MEMORY fill:#FFF176,stroke:#F9A825,stroke-width:2px
    style FASTTRACK fill:#81C784,stroke:#2E7D32,stroke-width:2px
    style COMPREHENSIVE fill:#FFB74D,stroke:#E65100,stroke-width:2px
    style COMPLETION fill:#64B5F6,stroke:#1976D2,stroke-width:2px
    style SCRIPTS fill:#BCAAA4,stroke:#4E342E,stroke-width:2px
    style ARTIFACTS fill:#80CBC4,stroke:#00695C,stroke-width:2px
```

---

## Layers

### 1. Trigger Layer

The IDE rule (e.g., `workflow.mdc` in Cursor, or `copilot-instructions.md` in VS Code) is the gateway. It evaluates on every user message and classifies the request:

- **Development request** (new feature, bug fix, infrastructure change, etc.) --> activates the workflow
- **Non-development request** (question, discussion) --> responds normally without the workflow

When activated, it displays a visible confirmation banner and immediately loads the unified entry point.

### 2. Shared Entry Point

`fluid-flow.md` is the orchestrator. It executes stages in sequence:

| Stage | Condition | Purpose |
|-------|-----------|---------|
| Shell Detection | Always | Detect Bash vs PowerShell environment for script invocations |
| Branch Creation | Always | Create `{JIRA-TICKET}-{description}` or `{description}` branch and `specs/{BRANCH_NAME}/` directory |
| Workspace Detection | Always | Scan for existing code, determine greenfield/brownfield |
| Reverse Engineering | Brownfield, run-once | Generate comprehensive architecture documentation |
| Workflow Selection | Always | Present both workflows and let the user choose directly |
| Workflow Routing | Always | Route to the chosen workflow engine |

### 3. Shared Memory

Memory files are loaded at workflow start and referenced throughout execution. They define the rules of engagement:

| Category | Files | Purpose |
|----------|-------|---------|
| **Operating Contract** | `ai-operating-contract.md` | Defines AI role, decision authority, overconfidence guardrail |
| **Overconfidence Prevention** | `overconfidence-prevention.md` | Prevents confidence without evidence, question generation philosophy |
| **Content Validation** | `content-validation.md` | Mermaid validation, character escaping, fallback rules |
| **Review Gates** | `ai-self-review.md`, `human-gate.md` | Self-review checklist, human approval requirements |
| **Architecture** | `architecture/adr-integrity-gate.md` | ADR identification, compliance checking, extension rules |
| **Continuous Learning** | `meta/continuous-learning.md` | Systemic issue detection, rule/ADR improvement proposals |
| **Security** | `security/*.md` | ISO 27001, threat modelling, secrets, network boundaries, data classification |
| **Quality** | `iso/iso9001-quality-management.md` | Process discipline, traceability, continuous improvement |
| **Energy** | `iso/iso50001-energy-management.md` | Energy management for infrastructure-related work |

### 4. Workflow Engines

Both workflow engines converge into a shared **Completion** stage (Commit, PR, Risk Report) before producing final artifacts.

#### Fast-Track

A linear, command-driven pipeline organised into **Inception** (specify, clarify, plan) and **Construction** (tasks, checklist, implement) sub-phases. Each command is a standalone `.md` file that loads shared memory, executes its logic, and produces artifacts in `specs/{BRANCH_NAME}/`.

#### Comprehensive Path

A phase-based engine with adaptive depth. Stages are conditional -- the AI assesses what is needed based on complexity, scope, and risk. The **Inception** phase includes a BDD Specification stage that converts user story acceptance criteria into Gherkin feature files when business behaviour contracts are needed. The **Construction** phase uses a per-unit loop where each unit goes through design, NFR assessment, infrastructure design, step definition generation (if BDD was executed), and code generation before the next unit starts.

### 5. Automation Scripts

Shell scripts handle mechanical tasks. Both Bash and PowerShell versions are provided for cross-OS support. The workflow auto-detects the shell environment (see `shell-detection.md`) and invokes the correct variant.

| Script (Bash / PowerShell) | Purpose |
|----------------------------|---------|
| `create-new-feature.sh` / `.ps1` | Creates feature branches, initialises feature directories |
| `check-prerequisites.sh` / `.ps1` | Validates feature context exists before commands run |
| `setup-plan.sh` / `.ps1` | Prepares plan template and context for planning commands |
| `update-agent-context.sh` / `.ps1` | Updates AI agent context files from plan data |
| `common.sh` / `.ps1` | Shared utilities for the other scripts |

### 6. Output Artifacts

All artifacts are written to `specs/`:

- **Feature-level**: `specs/{BRANCH_NAME}/` -- state, audit, workspace detection, specifications, plans, tasks, design documents
- **Project-level**: `specs/_project/` -- reverse engineering artifacts shared across features

Application code is always written to the workspace root, never to `specs/`.

---

## Data Flow

```mermaid
sequenceDiagram
    participant Dev as Developer
    participant IDE as AI-Capable IDE
    participant Rule as workflow.mdc
    participant FF as Fluid Flow Entry
    participant WD as Workspace Detection
    participant RE as Reverse Engineering
    participant WF as Chosen Workflow

    Dev->>IDE: Development request
    IDE->>Rule: Evaluate request
    Rule->>Rule: Classify as development
    Rule->>FF: Load fluid-flow.md

    FF->>FF: Load shared memory files
    FF->>Dev: Display welcome message

    FF->>FF: Create feature branch
    FF->>WD: Execute workspace detection
    WD-->>FF: Greenfield/Brownfield result

    alt Brownfield & no RE artifacts
        FF->>RE: Execute reverse engineering
        RE-->>Dev: Present findings for approval
        Dev-->>RE: Approve
    end

    FF->>Dev: Present workflow choice (Fast-Track or Comprehensive Path)
    Dev-->>FF: Choose workflow

    FF->>WF: Route to chosen workflow
    WF->>Dev: Execute stages with approval gates
```

---

## State Management

### Feature State (`state.md`)

Each feature has a `state.md` file that tracks:
- Feature information (branch name, creation date, current stage, selected workflow)
- Entry point progress (checkboxes for each shared stage)
- Workspace state (project type, brownfield status, workspace root)
- Workflow progress (populated by the chosen workflow)

### Audit Trail (`audit.md`)

Each feature has an `audit.md` file that records:
- Every user input (complete raw text, never summarised)
- Every AI response and action taken
- Every approval prompt and user response
- ISO 8601 timestamps for all entries
- Stage context for each entry

The audit file is **append-only** -- it must never be overwritten, only appended to.

---

## Design Decisions

### Why Two Workflow Paths?

Not every feature needs a full enterprise SDLC. Simple bug fixes, CRUD operations, and well-scoped enhancements benefit from a lightweight pipeline. Complex infrastructure changes, multi-service integrations, and work requiring ADRs need comprehensive design phases. The dual-path approach keeps simple work efficient while ensuring complex work gets proper treatment.

### Why Run-Once Reverse Engineering?

Full codebase analysis is expensive in terms of context window usage. Running it once per project and updating incrementally after each implementation keeps the cost manageable while maintaining accurate architectural documentation.

### Why Shared Memory Files?

Centralising governance rules (security, quality, review gates) ensures both workflow paths enforce the same standards. Changes to governance rules propagate automatically to both paths.

### Why Mandatory Approval Gates?

The AI Operating Contract establishes that AI proposes and humans decide. Approval gates enforce this contract by requiring explicit human confirmation before proceeding at each critical stage.
