# Concepts

Building block definitions and lifecycle walkthrough for the Fluid Flow framework.

---

## Building Blocks

Present **one concept at a time**, not all at once. Start with the most important one and let the user navigate.

Begin with:

```
The framework is built from a few key building blocks.
Let me walk you through them one at a time.
```

Ask which one to start with:

- **A**: Orchestrator — the single entry point
- **B**: Workflows — phased pipelines (fast-track, comprehensive-path)
- **C**: Skills — reusable procedures the AI executes
- **D**: Primitives — gates that run between steps (human-gate, compliance, etc.)
- **E**: Agent Rules — behavioural rules for the AI
- **F**: Tools (MCP) — external services (Atlassian, Slack, GitHub)
- **G**: Prompts / Commands — entry points to invoke things
- **H**: Knowledge Base — enterprise + local standards

For whichever the user picks, give a **concise explanation** (3-5 sentences max), mention where it lives in the codebase, and give one concrete example. Then ask:

- **A**: Go deeper on this one
- **B**: Explain another building block
- **C**: I'm done exploring concepts

If A → expand with more detail on that specific concept only. If B → return to the list. If C → return to the caller.

---

## Concept Definitions

Present only the one the user asks about.

**Orchestrator**: The single entry point for all development. It runs a staged lifecycle: detects your environment, identifies your workspace, checks tools, triages your request, then routes you into a workflow. Lives at `orchestrator.md`. You invoke it with `/fluid-flow`.

**Workflow**: A phased pipeline of steps that produces artifacts. The core ships two: **fast-track** (spec → plan → build, for low-to-medium complexity) and **comprehensive-path** (full SDLC with operations planning, for high complexity). Lives at `workflow/{name}/wf-{name}.md`. Departments can add their own.

**Skill**: A reusable, self-contained procedure. The AI loads the markdown and follows it step by step. Examples: reverse engineering (analyses a codebase), MCP check (verifies tool connections), retrospective (post-workflow analysis). Lives at `skills/{name}/{name}.md`. Can be triggered by the orchestrator, a workflow step, or a command.

**Primitive**: A cross-cutting gate that runs automatically between steps or phases. You don't invoke these — the orchestrator does. Examples: human-gate (waits for user approval), state-manager (tracks progress), kb-compliance (checks output against standards), VAPT (security scan). Lives at `primitives/{name}.md`.

**Agent Rules**: Behavioural rules that shape how the AI thinks and acts. The manifest (`agent-rules/manifest.md`) defines which rules load when. Examples: no-assumption policy, self-review checklist, refusal patterns (when to say no). These are always-on governance — not something you typically customise.

**Tool (MCP)**: An external service the AI can call. Core ships with Atlassian, Slack, GitHub, and AWS document loader. Configured in `.cursor/mcp.json`. Department config merges with core — if your team needs a specific API, add it to your department's mcp.json.

**Prompt / Command**: A short entry-point file (1-5 lines) that tells the AI "load X and follow it." Cursor uses `.cursor/commands/{name}.md`, GitHub Copilot uses `.github/prompts/{name}.prompt.md`. Core ships `/fluid-flow` and `/ff-reverse-engineer`.

**Knowledge Base**: The enterprise KB (`betsson-kb-docs`) contains org-wide standards: ISO compliance, security rules, engineering standards per tech stack. The AI loads relevant files before every step and runs a compliance check at phase boundaries. Departments can add a **local KB** with team-specific knowledge.

---

## Lifecycle Walkthrough

Present the stages **progressively** — give a high-level summary first, then let the user drill down.

```
When you type /fluid-flow, the orchestrator runs through these stages:

  0. Setup       — Detects your environment and workspace
  1. Triage      — Decides if this is a question, continuation, or new work
  2. RE          — Analyses existing code (brownfield repos only)
  3. Selection   — You pick a workflow
  4. Initiative  — Creates folder structure for artifacts
  5. Execution   — Runs the workflow step by step
  6. Completion  — Security scan, risk report, commit, PR
```

**Pause.** Ask:

- **A**: Go deeper on a specific stage (which one?)
- **B**: I'm done exploring the lifecycle

If A → expand the requested stage with 3-5 sentences of detail only. Then ask again.
If B → return to the caller.

### Stage detail (for reference — present only what the user asks about)

**Setup (Stage 0)**: Two sub-stages. Environment Detection discovers your OS, shell type, IDE, and tech stack — then caches it so it only runs once. Workspace Detection identifies the four repo types (core, KB, department, source) by their markers, auto-updates core and KB to latest main, reads the department config, and classifies source repos as brownfield or greenfield.

**Triage**: The orchestrator reads the user's request and classifies it. A question gets answered directly without entering a workflow. A continuation resumes an existing initiative from its last completed stage. A new task starts the full workflow lifecycle.

**Reverse Engineering (Stage 1)**: For brownfield repos that haven't been analysed yet, the AI runs a dedicated skill that explores the codebase and generates architecture documentation (business overview, C4 diagrams, API docs, tech stack, dependencies, code quality, test coverage). This only runs once per repo — a timestamp file marks completion.

**Workflow Selection (Stage 2)**: The orchestrator reads all available workflows from core and department repos, presents them with descriptions, and suggests the best match based on your tech stack and department. You pick one.

**Initiative Creation (Stage 3)**: Creates a folder structure in the department repo for the initiative's artifacts and metadata (state tracking, audit log, analytics). All workflow outputs go here.

**Workflow Execution (Stage 4)**: Runs the chosen workflow phase by phase, step by step. After every step: human gate (waits for your approval), state tracking, and analytics. After the last step of each phase: a KB compliance check reviews the output against enterprise and local knowledge.

**Completion (Stage 5)**: Post-implementation: VAPT security scan, risk report generation, reverse engineering update (refreshes architecture docs with new changes), analytics finalisation, commit, PR creation, and an optional retrospective for continuous improvement.
