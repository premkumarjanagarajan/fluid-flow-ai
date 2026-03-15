# Fluid Flow v1.0 — Observability & Status Indicators

## Spec Metadata

- **Depends on**: Fluid Flow v1.0 Workspace spec (implemented), Context Loading Strategy spec
- **Problem**: Developers cannot tell when Fluid Flow is driving a response, when subagents are active, or what Fluid Flow loaded into context
- **Status**: Draft
- **Date**: 2026-03-15

---

## 1. Problem

Three visibility gaps exist in the current Fluid Flow experience:

1. **Is Fluid Flow active?** — The v0.9 activation banner fires once at session start, then disappears into scroll history. During a long session, the developer cannot tell whether a response is orchestrated by Fluid Flow or a freeform agent response.

2. **What's happening with subagents?** — RE subagents, KB compliance subagents, conflict detection subagents, and combined-architecture subagents all launch and complete silently. The developer has no visibility into whether a subagent is running, what it's doing, or what it returned.

3. **What did Fluid Flow load?** — VS Code already shows total context window usage natively (token count as a fraction of total, e.g., 15K/128K, with breakdown by category on hover, and automatic compaction when full). Fluid Flow does NOT need to duplicate this. But VS Code's indicator doesn't attribute usage to Fluid Flow specifically — the developer can't tell how much of the 15K was governance rules vs combined-architecture.md vs conversation history. When the context indicator jumps after Fluid Flow loads workspace artifacts, the developer doesn't know why.

---

## 2. What VS Code Already Provides (Do Not Duplicate)

VS Code's built-in context management:

- **Context window indicator** in the chat UI showing token usage as a fraction (e.g., 15K/128K)
- **Breakdown on hover** by category
- **Model-aware** — denominator changes with model selection
- **Automatic compaction** — summarizes conversation history when context fills up

The Copilot CLI additionally tracks token usage internally and compacts at 95% capacity with checkpoint recovery.

Fluid Flow MUST NOT attempt to estimate or display total context usage. That is VS Code's job and it does it well. Fluid Flow's job is to make its own contribution to context usage transparent.

---

## 3. Status Prefix

### 3.1 Convention

Every response from the orchestrator or a workflow step includes a compact status prefix:

```
[FF · sportsbook · inception/specify]
```

Three parts:
- `FF` — identifies this response as Fluid Flow-orchestrated
- Workspace name (from `ff-workspace.yaml`, or repo name if single-repo mode)
- Current phase/step (from the active workflow's phase chain)

### 3.2 Variants

| Situation | Prefix |
|-----------|--------|
| Workspace workflow step | `[FF · sportsbook · inception/specify]` |
| Orchestrator stage (not yet in a workflow) | `[FF · sportsbook · stage:workspace-detection]` |
| Initiative workflow | `[FF · sportsbook · initiative/scope]` |
| Workspace setup | `[FF · setup · workspace-setup]` |
| Single-repo mode (no ff-workspace.yaml) | `[FF · sportsbook-api · inception/specify]` |
| Not Fluid Flow (question answered directly) | No prefix |

### 3.3 Rules

- The prefix appears at the start of every orchestrator or workflow response
- When triage classifies a request as **Question** and answers directly, NO prefix — this is the signal that Fluid Flow is not active
- The prefix does NOT include context usage — VS Code handles that
- The prefix is a display convention in the orchestrator and workflow step instructions, not a tool or extension

---

## 4. Context Loading Announcements

### 4.1 Purpose

When Fluid Flow loads workspace artifacts into context, it announces what it loaded and the approximate size. This lets the developer correlate with VS Code's context indicator — "the indicator jumped from 8K to 14K because Fluid Flow loaded the combined architecture."

### 4.2 Format

```
  ┌ CONTEXT LOADED ────────────────────────
  │ combined-architecture.md       ~4.2K tokens
  │ incident-learnings.md (2 entries) ~0.3K tokens
  │ ff-workspace.yaml              ~0.2K tokens
  └────────────────────────────────────────
```

### 4.3 When to Announce

| Loading Event | Announce? |
|---------------|-----------|
| `ff-workspace.yaml` at Stage 1 | Yes — first load, establishes workspace context |
| KB files (always-load set) at step start | No — this is v0.9 behaviour, already expected |
| `combined-architecture.md` during planning | Yes — significant context addition |
| `incident-learnings.md` (filtered) | Yes — developer should know which learnings are influencing the plan |
| Per-repo RE loaded by implementation subagent | No — subagent context is separate (announced via subagent launch) |
| `target-repos.md` at conflict detection | Yes — establishes what's being checked |

### 4.4 Token Estimation

The agent estimates tokens from file size: `tokens ≈ file_bytes / 4` for English/markdown, `tokens ≈ file_bytes / 3` for code. This is approximate and explicitly labelled with `~`. The agent can use `wc -c` on loaded files for byte counts.

This estimation is ONLY for the loading announcement — it does not replace or duplicate VS Code's actual token counter.

---

## 5. Subagent Announcements

### 5.1 Launch

When the orchestrator or a workflow step launches a subagent:

```
───────────────────────────────────────
  SUBAGENT LAUNCHED
  Type: reverse-engineering
  Target: sportsbook-api
  Purpose: Per-repo codebase analysis
───────────────────────────────────────
```

### 5.2 Complete

When a subagent returns:

```
───────────────────────────────────────
  SUBAGENT COMPLETE
  Type: reverse-engineering
  Target: sportsbook-api
  Result: 11/11 artifacts written
───────────────────────────────────────
```

### 5.3 Parallel Subagents

When multiple subagents launch in parallel (e.g., RE across repos):

```
───────────────────────────────────────
  SUBAGENTS LAUNCHED (parallel)
  Type: reverse-engineering
  Targets: sportsbook-api, sportsbook-events,
           sportsbook-settlements, shared-contracts
  Purpose: Per-repo codebase analysis (4 repos)
───────────────────────────────────────
```

Completion can be announced individually as each returns, or as a batch when all complete — follow the v0.9 RE pattern of presenting a consolidated summary table.

### 5.4 Subagent Types

| Subagent Type | Launched by | What's in its context |
|---------------|-------------|----------------------|
| `reverse-engineering` | RE skill (Stage 2) | One repo's codebase |
| `combined-architecture` | RE skill (post-RE step) | All per-repo architecture.md, dependencies.md, c4.md, api-documentation.md |
| `kb-compliance` | kb-compliance primitive (phase boundaries) | Full knowledge-base-core + step output |
| `conflict-detection` | Conflict detection skill (Stage 5) | ff-workspace.yaml, combined-architecture.md, all active target-repos.md |
| `implementation` | Workflow construction phase (per repo) | Target repo codebase, repo's RE artifacts, filtered incident learnings |

### 5.5 KB Compliance Subagent

The KB compliance subagent already has a structured verdict format in v0.9 (`KB-COMPLIANCE: PASS | FAIL`). v1.0 wraps it with the subagent announcement:

```
───────────────────────────────────────
  SUBAGENT COMPLETE
  Type: kb-compliance
  Result: PASS
───────────────────────────────────────
```

Or on failure:

```
───────────────────────────────────────
  SUBAGENT COMPLETE
  Type: kb-compliance
  Result: FAIL — 2 violations found
───────────────────────────────────────
```

The detailed violations are then presented by the main agent as per v0.9's existing kb-compliance flow.

---

## 6. Context-Heavy Step Warning

### 6.1 Purpose

Some steps are known to be context-heavy — loading combined architecture, running conflict detection across many active initiatives, or implementing in a large repo. A heads-up lets the developer understand why VS Code's context indicator is about to jump.

### 6.2 Format

Before a step that will load significant context:

```
  ┌ NOTE ──────────────────────────────────
  │ This step loads cross-repo architecture
  │ context. Expect context usage to increase.
  └────────────────────────────────────────
```

### 6.3 When to Warn

| Step | Warn? | Why |
|------|-------|-----|
| Planning phase loading combined-architecture.md | Yes | Could be 5-15K tokens depending on bounded context size |
| Conflict detection with 5+ active initiatives | Yes | Each target-repos.md adds to context |
| Implementation in a repo with extensive RE artifacts | No — subagent handles it | Subagent context is separate |
| Initiative scope reading domain-catalog.yaml | Yes if catalog is large | 3,200 repos catalog could be significant |
| KB compliance subagent | No | Own context window |

---

## 7. Full Session Example

A complete Fluid Flow session showing all indicators:

```
═══════════════════════════════════════════════════
  FLUID-FLOW AI v1.0 WORKFLOW ACTIVATED
  All development follows the unified lifecycle.
  Reading workflow instructions now...
═══════════════════════════════════════════════════

  MCP Status:
    github: OK

  ┌ CONTEXT LOADED ────────────────────────
  │ ff-workspace.yaml              ~0.2K tokens
  └────────────────────────────────────────

[FF · sportsbook · stage:workspace-detection]
Workspace detected: 5 repositories, brownfield.
Reverse engineering artifacts found. Proceeding to workflow selection.

  -------------------------------------------
    AVAILABLE WORKFLOWS
  -------------------------------------------
    Core:
      1. fe-migration-angular-stencil -- Angular to StencilJS migration
      2. initiative -- Cross-workspace initiative planning

    Reply with number or name.
  -------------------------------------------

> User: 1

[FF · sportsbook · stage:initiative-creation]
...initiative created...

  ┌ CONTEXT LOADED ────────────────────────
  │ combined-architecture.md       ~4.2K tokens
  │ incident-learnings.md (1 entry) ~0.2K tokens
  └────────────────────────────────────────

[FF · sportsbook · inception/specify]
Based on the workspace architecture, this migration affects...

  ───────────────────────────────────────────────────
    HUMAN GATE — inception / specify
  ───────────────────────────────────────────────────

    Summary:
      Specification created for Angular widget migration.

    Artifacts:
      - initiatives/feature/DIT-179-widget-migration/artefacts/1.1-specification.md

    A) Approve and continue
    B) Clarify (provide feedback)
    C) Redo step
  ───────────────────────────────────────────────────

> User: A

  ───────────────────────────────────────
    SUBAGENT LAUNCHED
    Type: kb-compliance
    Purpose: Phase 1 boundary check
  ───────────────────────────────────────

  ───────────────────────────────────────
    SUBAGENT COMPLETE
    Type: kb-compliance
    Result: PASS
  ───────────────────────────────────────

  ┌ CONTEXT LOADED ────────────────────────
  │ target-repos.md                ~0.3K tokens
  └────────────────────────────────────────

  ───────────────────────────────────────
    SUBAGENT LAUNCHED
    Type: conflict-detection
    Purpose: Check active initiatives for conflicts
  ───────────────────────────────────────

  ───────────────────────────────────────
    SUBAGENT COMPLETE
    Type: conflict-detection
    Result: No conflicts found
  ───────────────────────────────────────

[FF · sportsbook · construction/scaffold]
Creating branches in target repositories...

  ───────────────────────────────────────
    SUBAGENT LAUNCHED
    Type: implementation
    Target: sportsbook-api
    Purpose: Scaffold migration in sportsbook-api
  ───────────────────────────────────────
```

---

## 8. Implementation

All indicators are display conventions defined in markdown files — no tooling, no extensions.

| Indicator | Where to Define |
|-----------|----------------|
| Status prefix | `orchestrator.md` rules section + each workflow step template |
| Context loaded announcement | Context loading strategy (manifest.md workspace artifacts section) |
| Subagent launch/complete | `skills/reverse-engineering/`, `primitives/kb-compliance.md`, `skills/conflict-detection/`, and orchestrator Stage 5/6 |
| Context-heavy warning | Steps that load combined-architecture.md or domain-catalog.yaml |
| Human gate display | `primitives/human-gate.md` (already exists in v0.9) |
| Activation banner | `orchestrator.md` (already exists in v0.9) |

No changes to VS Code settings, extensions, or MCP. Pure markdown conventions.