# ADR: Fluid Flow Workspace — Extending Fluid Flow for Multi-Repo Development

## Status

Proposed

## Date

2026-03-15

## Context

Fluid Flow Core v0.9 is a mature, well-structured framework for AI-assisted software development. It provides a staged orchestrator lifecycle, pluggable workflows, a tiered knowledge base with compliance subagents, human gates after every step, and initiative tracking with audit trails.

v0.9 operates within a single repository. This document evaluates the limitations of that scope and proposes an extension — the Fluid Flow Workspace — to support multi-repo bounded contexts.

---

## The Problem

Enterprise development at Betsson spans ~3,200 repositories across 11 product domains. A typical feature in the sportsbook domain touches 3-8 repositories: the core API, event consumers, settlement services, and shared contracts. Teams currently manage 20-30 repos in a single VS Code workspace.

With v0.9, each of these repos has its own copy of Fluid Flow. This creates five concrete problems.

### Problem 1: No cross-repo codebase awareness

v0.9's reverse engineering produces 11 artifacts per repo using parallel subagents. But each repo's RE only knows about itself. When the agent works on sportsbook-api, it doesn't know that sportsbook-events consumes the events it publishes, or that shared-contracts defines the schemas both use. The agent discovers cross-repo dependencies at implementation time — or doesn't discover them at all.

**Impact**: Agents propose changes that break downstream consumers. Schema mismatches are caught in PR review, not during planning. Developers manually explain cross-repo relationships to the agent on every session.

### Problem 2: No cross-repo specifications

v0.9 initiatives live inside the repo being modified. If a feature spans sportsbook-api and sportsbook-events, there is no single spec that describes the full scope. The developer either writes two separate initiatives in two repos, or specs the work in one repo and handles the other informally.

**Impact**: Cross-repo features have incomplete specifications. The second and third repos get less rigour than the first. Governance, audit trails, and human gates only cover part of the work.

### Problem 3: No conflict detection

When two teams independently modify the same shared contract or the same event schema, neither knows until both PRs exist. v0.9 has no mechanism to compare active initiatives across repos.

**Impact**: Merge conflicts are the best case. Semantic conflicts — two teams making incompatible assumptions about the same schema — are the worst case. These are discovered in integration testing or production, not at planning time.

### Problem 4: Version drift

Each repo has its own copy of `fluid-flow-ai/`. When a new version ships, each team must manually copy the update. Some repos fall behind. Some get locally modified. There is no single source of truth for which version of Fluid Flow a team is running.

**Impact**: Governance rules, workflow definitions, and knowledge base content are inconsistent across repos. A security rule added to one repo's knowledge-base-core may not reach other repos for weeks.

### Problem 5: Context window waste in large workspaces

When a developer opens 20-30 repos in one workspace, v0.9's RE and workflow stages load context for every repo indiscriminately. The agent's context window fills with irrelevant information from repos unrelated to the current task.

**Impact**: Agent quality degrades as workspace size increases. Developers report that AI suggestions become less accurate in large multi-repo workspaces compared to single-repo usage.

---

## What v0.9 Already Solves Well

Before proposing changes, it's important to acknowledge what v0.9 gets right — and why v1.0 builds on it rather than replacing it.

| Capability | v0.9 Implementation | Assessment |
|------------|---------------------|------------|
| Staged lifecycle | Orchestrator with Stages 0-6, triage, shell detection, workspace detection, RE, workflow selection, initiative creation, routing, completion | Solid. No changes needed. |
| Knowledge base | Tiered loading manifest (always-load vs conditional), KB compliance subagent at phase boundaries with PASS/FAIL verdicts | Excellent design. Solves context pollution from governance rules. Superior to loading everything upfront. |
| Human gates | Mandatory A/B/C after every step. No auto-advancement. | Core principle. Unchanged. |
| Pluggable workflows | `workflow/{name}/wf-*.md` with frontmatter, phase/step chains, per-workflow knowledge-core | Clean extension point. New workflows drop in without orchestrator changes. |
| Primitives | human-gate, state-manager, analytics, kb-compliance — run in defined order after steps and phases | Well-separated concerns. Reusable across any workflow. |
| RE with subagents | Per-repo subagents running in parallel, each with own context window, returning only short status summaries | Best practice for multi-repo analysis. Already handles workspace-level scanning. |
| Initiative tracking | Typed folders, state.md, audit.md, analytics.md | Complete lifecycle tracking with resume capability. |
| No-assumption policy | Agent always asks instead of guessing | Critical for enterprise governance. |

v0.9's architecture is designed for extension. The pluggable workflow system, skill loading, and subagent patterns are exactly the infrastructure needed for multi-repo support. The proposal adds scope, not architecture.

---

## The Proposal: Fluid Flow Workspace

### Overview

A **Fluid Flow Workspace** is a dedicated repository per bounded context that hosts a single instance of Fluid Flow and provides multi-repo orchestration through a VS Code multi-root workspace.

### What Changes

| Area | v0.9 | v1.0 Proposal | Effort |
|------|------|---------------|--------|
| **Framework location** | Copied into each repo | Single instance in Fluid Flow Workspace repo | Migration: move files, no code changes |
| **Workspace scope** | Single repo | Multi-repo via `.code-workspace` file | Config: create workspace file |
| **Codebase awareness** | Per-repo RE artifacts | Per-repo RE (unchanged) + combined architecture in workspace | New: one post-RE subagent for combined views |
| **Workspace composition** | None | `ff-workspace.yaml` generated by RE from discovered state | New: generation step in RE skill |
| **Shared repo discovery** | None | GitHub MCP queries during workspace setup | New: MCP integration in setup skill |
| **Initiative specs** | Per-repo | Centralized in workspace, can reference multiple target repos | No code change — artifact location moves |
| **Conflict detection** | None | New skill comparing active initiatives before construction | New: `skills/conflict-detection/` |
| **Branch strategy** | Immediate in working repo | Workspace branched at inception, target repos at construction | Orchestrator: add lazy branching logic |
| **Completion** | Single-repo commit + PR | Multi-repo commits + PRs in dependency order | Stage 6: extend for multiple repos |
| **Cross-workspace initiatives** | None | New pluggable workflow reading org-level domain catalog | New: `workflow/initiative/` |
| **Production feedback** | None | `incident-learnings.md` stored with combined RE artifacts | New: one file, manual or CI updates |
| **Triage** | 3 intents | 4 intents (add Workspace Setup) | Orchestrator: add one condition |
| **Orchestrator lifecycle** | Stages 0-6 | Stages 0-6 (unchanged) + 4 hook points | Minimal additions to existing stages |
| **Knowledge base** | Tiered loading + KB compliance subagent | Unchanged | Zero changes |
| **Primitives** | human-gate, state-manager, analytics, kb-compliance | Unchanged | Zero changes |
| **Existing workflows** | Pluggable phase/step chains | Unchanged — they gain multi-repo awareness automatically via workspace context | Zero changes |
| **Version management** | Manual copy per repo | Single source in workspace | Elimination of maintenance overhead |

### What Does NOT Change

- The orchestrator lifecycle (Stages 0-6)
- All primitives (human-gate, state-manager, analytics, kb-compliance)
- The knowledge-base-core (manifest.md, tiered loading, compliance subagent)
- Existing workflows (fe-migration-angular-stencil and any future workflows)
- The RE skill's per-repo subagent strategy and templates
- Initiative folder structure (type/name/metadata/)
- Entry points (.cursor/rules/, .github/copilot-instructions.md)
- The no-assumption policy
- Human gate after every step

---

## v0.9 vs v1.0: Detailed Comparison

| Aspect | v0.9 (Current) | v1.0 (Proposed) |
|--------|----------------|-----------------|
| **Where Fluid Flow lives** | Copied into each repo as `fluid-flow-ai/` | Single instance in a dedicated Fluid Flow Workspace repo |
| **Scope of agent awareness** | One repo | All repos in a bounded context (5-8 repos) via multi-root workspace |
| **RE output** | 11 artifacts per repo, written to `{repo}/reverse-engineering/` | Same 11 per-repo artifacts (unchanged) + combined architecture and C4 in workspace |
| **Workspace composition** | No workspace-level metadata | `ff-workspace.yaml` auto-generated by RE — repos, teams, governance, shared flags |
| **Shared repo awareness** | None | Discovered via GitHub MCP. Flagged in ff-workspace.yaml with `also_in` list |
| **Initiative location** | `initiatives/` inside each repo | `initiatives/` in the Fluid Flow Workspace — one place for all initiatives |
| **Cross-repo features** | Not supported — developer coordinates manually | First-class: spec in workspace, target-repos.md maps changes per repo, lazy branching |
| **Conflict detection** | None — discovered at PR merge or production | Pre-construction skill comparing active initiatives for schema, file, and data flow conflicts |
| **Branch strategy** | Branch created immediately in working repo | Workspace branched at inception; target repos branched after plan + conflict check |
| **Multi-repo completion** | Not supported | Commits + PRs across repos in dependency order, risk report covers all |
| **Cross-workspace initiatives** | Not supported | Initiative workflow reads org domain catalog, proposes affected domains, generates per-workspace spec stubs |
| **Production feedback** | None | incident-learnings.md in workspace, loaded by agents during planning/implementation |
| **Triage intents** | Question, Continue, New | + Workspace Setup (auto-detects multi-repo, prompts for workspace creation) |
| **Version management** | Manual copy per repo — version drift inevitable | Single source of truth — one update reaches all teams in the context |
| **Orchestrator changes** | N/A | 4 additions to existing stages. Lifecycle and primitives unchanged. |
| **Knowledge base changes** | N/A | Zero |
| **Existing workflow changes** | N/A | Zero — existing workflows gain multi-repo context automatically |
| **Infrastructure required** | None | None — still files in a git repo |

---

## Industry Context

This proposal is not theoretical. The enterprise agentic orchestration landscape has converged on the same gap.

**GitHub Copilot's coding agent** (GA September 2025) operates on a single repository per task. Multi-repo support is an open feature request (microsoft/vscode#259829) with no ETA. Mission Control allows launching parallel tasks but each remains repo-scoped.

**Nx Polygraph** (Enterprise) creates "synthetic monorepos" that federate multiple repos into a connected meta-repo, exposing the project graph to agents via MCP. Nx reports 30%+ productivity gains from monorepo + agent versus polyrepo + agent workflows. Their 2026 roadmap explicitly targets orchestrating agents across connected repos.

**GitHub's own blog** listed spec-driven development and MCP as top trends of 2025. AWS launched Kiro, a purpose-built IDE for spec-driven development. McKinsey/QuantumBlack published a February 2026 pattern using folder-based SDLC conventions with state-machine metadata — structurally similar to Fluid Flow's approach.

**Gartner** predicts 40% of enterprise apps will include task-specific AI agents by end of 2026 but warns that over 40% of agentic AI projects will be cancelled by 2027 due to orchestration failures, unclear ROI, and governance gaps. Deloitte reports only 28% of enterprises believe they have mature agent capabilities.

**No production tool** handles real-time cross-repo conflict detection among concurrent AI agents, dependency-aware PR sequencing across repositories, or spec-driven multi-repo orchestration.

Fluid Flow v0.9 already has the governance backbone, spec-first approach, and subagent architecture that the industry is converging toward. v1.0 extends it to the multi-repo scope where no other tool operates.

---

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| VS Code multi-root workspace bugs prevent agent/instruction discovery | Active bugs (vscode#296972, #264837) | Explicit path mappings in workspace file — workaround is reliable |
| Combined architecture artifacts are too large for agent context | Medium for 8+ repo contexts | Summary-first loading — orchestrator reads combined-architecture.md, dives into per-repo only when relevant |
| Teams resist centralising Fluid Flow into a workspace repo | Medium — ownership concerns | Backward compatible. Per-repo v0.9 keeps working. Pilot with willing team first. |
| ff-workspace.yaml regeneration overwrites human edits | Low | Preserved fields clearly marked. RE update preserves change_coordination, team slack channels, governance flags. |
| GitHub MCP not available in all environments | Medium | MCP queries are optional. Shared repo flags fall back to human input. |
| Initiative workflow adds overhead for simple cross-workspace coordination | Low | It's a pluggable workflow — teams only select it when needed. Standard workflows remain default. |

---

## Decision

Pending review and pilot.

### Proposed Pilot

1. **Team**: Sportsbook core (already agreed to identify bounded contexts)
2. **Scope**: Create one Fluid Flow Workspace from 5-8 sportsbook repos (down from the current 20-30 repo workspace)
3. **Steps**:
   a. Create `sportsbook-ff-workspace` repo
   b. Copy Fluid Flow v0.9 into it
   c. Create `.code-workspace` file with the 5-8 repos
   d. Run workspace setup — RE generates per-repo + combined artifacts and ff-workspace.yaml
   e. Run one cross-repo initiative through the workflow
4. **Measure**:
   - Did RE produce useful combined architecture across repos?
   - Did ff-workspace.yaml accurately reflect the workspace composition?
   - Did conflict detection catch anything?
   - Did the developer experience improve vs per-repo Fluid Flow?
5. **Timeline**: 2-3 weeks from workspace creation to first initiative complete
6. **Success gate**: Team wants to continue using the workspace model for subsequent work

### What is NOT in the Pilot

- Initiative workflow (cross-workspace) — requires multiple workspaces to exist first
- Option B/A shared repo coordination — manual (Option C) is sufficient for pilot
- MCP server tools beyond GitHub MCP — keep it simple

---

## Consequences

### If Adopted

- Fluid Flow gains multi-repo orchestration that no competitor offers
- Teams get unified codebase awareness, cross-repo specs, and conflict detection
- Version management overhead eliminated (single source of truth per workspace)
- Foundation laid for initiative workflow when multiple workspaces exist
- Positions Fluid Flow as an enterprise development protocol, not just a per-repo tool

### If Not Adopted

- Each repo continues with its own Fluid Flow copy
- Cross-repo coordination remains manual
- Conflicts discovered at merge time or production
- Version drift continues
- Fluid Flow's scope ceiling remains single-repo while the industry moves toward multi-agent multi-repo orchestration
