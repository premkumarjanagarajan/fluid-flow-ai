# Fluid Flow v1.0 — Workspace Context Loading Strategy

## Spec Metadata

- **Depends on**: Fluid Flow v1.0 Workspace spec (already implemented)
- **Problem**: v1.0 introduces workspace-level artifacts that risk re-introducing the context bloat v0.9 solved with tiered KB loading
- **Status**: Draft
- **Date**: 2026-03-15

---

## 1. Problem

v0.9 solved governance context bloat with a two-layer strategy: tiered pre-step loading via `knowledge-base-core/manifest.md`, and a post-phase KB compliance subagent that carries the full KB in its own context window.

v1.0 introduces new workspace-level artifacts: `ff-workspace.yaml`, `combined-architecture.md`, `combined-c4.md`, `incident-learnings.md`, per-repo RE artifacts, and `target-repos.md`. If the orchestrator loads all of these early in the lifecycle, the main agent's context fills with cross-repo architecture data before any actual work begins — the same problem v0.9 solved for governance rules.

This spec defines when and how each workspace artifact is loaded, following v0.9's established tiered loading philosophy.

---

## 2. Principle

**Load the map, not the territory.**

`ff-workspace.yaml` is the map — small, always relevant, tells the agent what repos exist and how they relate. Everything else is territory — loaded only when the current stage or step needs it, and only the subset relevant to the repos being worked on.

This mirrors v0.9's approach: the KB manifest is always loaded (it's the map of governance rules), but the actual security rules only load when the step touches security.

---

## 3. Loading Strategy

### 3.1 Always Load

| Artifact | When | Why | Size |
|----------|------|-----|------|
| `ff-workspace.yaml` | Stage 1 (Workspace Detection) | The agent needs to know which repos are in the workspace, which teams own them, and which repos are shared. This is the equivalent of v0.9's KB manifest — it tells the agent what exists without loading the detail. | Small — repo list + metadata, typically < 100 lines |

### 3.2 Load on Demand

| Artifact | When to Load | Trigger | Who Loads It |
|----------|-------------|---------|--------------|
| `combined-architecture.md` | Planning phase of any workflow that may produce `target-repos.md` | Orchestrator detects workflow has a planning phase that references cross-repo scope | Planning step loads it |
| `combined-architecture.md` | Conflict detection | `target-repos.md` exists after planning | Conflict detection skill loads it |
| `combined-c4.md` | User asks architectural questions, or during RE update | Explicit user request or RE skill execution | Loaded by the responding step or RE skill |
| `incident-learnings.md` | Planning and implementation steps | Step targets repos that have entries in incident-learnings.md | Step loads it, filtered (see 3.3) |
| `target-repos.md` | Conflict detection, construction start, completion | Exists after planning phase | Orchestrator loads at Stage 5 checkpoints |
| Per-repo RE artifacts | Implementation steps targeting a specific repo | Construction phase, per-repo subagent | Implementation subagent loads only its target repo's RE |
| Per-repo `api-documentation.md` | Contract design steps in initiative workflow | Initiative contracts phase | Contracts step loads only relevant repos |
| Per-repo `dependencies.md` | Planning, when assessing cross-repo impact | Planning step for cross-repo initiatives | Planning step loads only target repos |

### 3.3 Filtered Loading for incident-learnings.md

`incident-learnings.md` may grow as incidents accumulate. Loading the entire file wastes tokens when only a subset of entries are relevant.

**Rule**: When a step loads incident-learnings.md, it MUST filter to entries where `Affected repos` includes at least one repo from the current initiative's `target-repos.md`. If `target-repos.md` does not yet exist (still in inception), filter to repos mentioned in the user's request or the draft spec.

If no entries match, do not load the file.

### 3.4 Never Load Proactively

| Artifact | Why Not |
|----------|---------|
| `combined-c4.md` | Large, detailed, rarely needed outside RE and explicit architecture questions |
| Per-repo RE artifacts for repos NOT in `target-repos.md` | Irrelevant to the current initiative — context waste |
| `conflict-report.md` from other initiatives | Only relevant during conflict detection, and only the current initiative's report matters |
| `ff-workspace.yaml` `also_in` details for non-shared repos | Only relevant when conflict detection hits a shared repo |

---

## 4. Orchestrator Integration

### 4.1 Stage 1 (Workspace Detection)

After detecting `ff-workspace.yaml`:

```markdown
1. Read ff-workspace.yaml
2. Store WORKSPACE_NAME, REPO_LIST, and SHARED_REPOS (repos with shared: true)
3. Do NOT load any RE artifacts, combined architecture, or incident learnings
4. Report workspace status including repo count and shared repo count
```

### 4.2 Stage 5 (Workflow Routing)

When entering a workflow's planning phase:

```markdown
1. If the workflow may produce target-repos.md (cross-repo scope):
   a. Load combined-architecture.md into the planning step's context
   b. Load incident-learnings.md filtered to repos mentioned in the spec/request
2. After planning produces target-repos.md:
   a. Load target-repos.md
   b. Load conflict-detection skill (which loads combined-architecture.md in its own context)
3. During construction, for each target repo:
   a. Subagent loads ONLY that repo's RE artifacts from {repo}/reverse-engineering/
   b. Subagent loads incident-learnings.md filtered to that repo
   c. Subagent does NOT load other repos' RE artifacts
```

### 4.3 Initiative Workflow Specifics

The initiative workflow (cross-workspace) has different loading needs:

| Phase | What to Load | What NOT to Load |
|-------|-------------|-----------------|
| Scope | `domain-catalog.yaml`, `ff-workspace.yaml` | Combined architecture, per-repo RE |
| Decompose | `ff-workspace.yaml` from each involved workspace (if accessible) | Per-repo RE from all repos |
| Contracts | Per-repo `api-documentation.md` ONLY for repos at integration points | Full RE artifacts, combined architecture |
| Sequence | `target-repos.md` equivalents from decomposition output | Per-repo RE |
| Seed | Decomposition + contracts outputs (already in initiative artefacts) | Everything else |

---

## 5. Subagent Context Isolation

v0.9 established that subagents get their own context windows. v1.0 must follow the same pattern for workspace artifacts:

| Subagent | What it gets | What it does NOT get |
|----------|-------------|---------------------|
| RE per-repo subagent | One repo's codebase | Other repos, combined architecture, ff-workspace.yaml |
| RE combined-architecture subagent | All per-repo architecture.md, dependencies.md, c4-architecture.md, api-documentation.md | Full codebases, knowledge-base-core |
| Conflict detection subagent | ff-workspace.yaml, combined-architecture.md, all active target-repos.md files | Per-repo RE, knowledge-base-core, codebases |
| Implementation subagent (per repo) | Target repo codebase, that repo's RE artifacts, filtered incident learnings, the initiative's spec and plan | Other repos' RE, combined architecture, ff-workspace.yaml |
| KB compliance subagent | Full knowledge-base-core, step output | Workspace artifacts, RE artifacts, ff-workspace.yaml |

The KB compliance subagent is unchanged from v0.9 — it reviews step output against governance rules. It does not need workspace composition context.

---

## 6. Loading Decision Flowchart

For any step in any workflow, the agent should follow this decision path:

```
Is this step aware of multiple repos?
├── No → Load nothing workspace-level. Standard v0.9 behaviour.
└── Yes → Load ff-workspace.yaml (if not already loaded at Stage 1)
          │
          Does this step need to understand cross-repo relationships?
          ├── No → Stop. ff-workspace.yaml is enough (repo list + teams).
          └── Yes → Load combined-architecture.md
                    │
                    Does this step need contract/API detail for specific repos?
                    ├── No → Stop. Combined architecture gives the overview.
                    └── Yes → Load per-repo api-documentation.md and/or
                              dependencies.md ONLY for the specific repos needed.
                              │
                              Are there incident learnings for these repos?
                              ├── No → Stop.
                              └── Yes → Load filtered incident-learnings.md entries.
```

---

## 7. Manifest Extension

To make workspace artifact loading discoverable and consistent, add a `## Workspace Artifacts` section to `knowledge-base-core/manifest.md`. This extends the existing KB loading manifest with workspace-level loading rules, keeping one source of truth for all context loading strategy.

```markdown
## Workspace Artifacts

These rules apply only when ff-workspace.yaml exists (Fluid Flow Workspace mode).

### Always Load
- Load `ff-workspace.yaml` at Stage 1 (Workspace Detection) — repo list, teams, shared flags

### On-Demand: Cross-Repo Planning
- Load `reverse-engineering/combined-architecture.md` during planning phases that may produce target-repos.md
- Load `reverse-engineering/incident-learnings.md` filtered to target repos during planning and implementation

### On-Demand: Conflict Detection
- Load `reverse-engineering/combined-architecture.md` in conflict detection subagent
- Load all active `initiatives/*/target-repos.md` in conflict detection subagent

### On-Demand: Per-Repo Implementation
- Load `{repo}/reverse-engineering/` artifacts ONLY for the repo being implemented
- Load `reverse-engineering/incident-learnings.md` filtered to that repo

### Never Load Proactively
- `reverse-engineering/combined-c4.md` — only on explicit architectural queries or during RE
- Per-repo RE for repos not in the current initiative's target-repos.md
- Per-repo RE for ALL repos simultaneously (use combined-architecture.md for the overview)
```

---

## 8. Validation

To confirm this loading strategy is working correctly:

| Signal | Problem | Fix |
|--------|---------|-----|
| Agent mentions repos not in target-repos.md during implementation | Loading too much workspace context | Check that implementation subagent only gets its target repo's RE |
| Agent doesn't know about cross-repo dependencies during planning | Not loading combined-architecture.md | Ensure planning step loads it when workflow has cross-repo scope |
| Agent gives generic answers about incident history | Not loading incident-learnings.md | Check filtering — entries should match target repos |
| Agent context window fills before implementation starts | Loading combined artifacts too early or unfiltered | Review Stage 1 — should only load ff-workspace.yaml, nothing else |
| KB compliance subagent fails on workspace-specific concerns | Subagent doesn't have workspace context | Expected — KB compliance checks governance, not workspace composition. These are separate concerns. |
