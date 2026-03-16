---
step: scope
subagent: false
---

## Context Loading

| Load | Do NOT Load |
|------|------------|
| `domain-catalog.yaml` (if scope mode uses it) | `reverse-engineering/combined-architecture.md` |
| `*-domain-catalog.yaml` (domain-specific catalogs, if they exist) | |
| `ff-workspace.yaml` (already loaded at Stage 1) | Per-repo RE artifacts |
| | `reverse-engineering/combined-c4.md` |
| | `reverse-engineering/incident-learnings.md` |

The scope step works from the domain catalog, workspace composition, or user-provided repo list. Per-repo detail is not needed to identify what's in scope.

## Inputs

- User prompt (natural language initiative description)
- `domain-catalog.yaml` — org-level domain registry (optional, depends on scope mode)

## Guidance

Identify what this initiative spans. The AI proposes; the human validates.

### 1. Determine Scope Mode

Present the scope mode prompt and wait for user choice:

```
───────────────────────────────────────────────────
  MULTI-WORKSPACE — Scope Mode
───────────────────────────────────────────────────

  What does this initiative span?

  A) Multiple repos in this workspace
     → I'll use ff-workspace.yaml to identify targets

  B) Multiple domains across the organisation
     → I'll use the domain catalog to identify targets

  C) Specific repos I'll name
     → Tell me which repos are involved

  D) Let me describe the scope and you figure it out
     → I'll analyse your description against all
       available context

───────────────────────────────────────────────────
```

**Mode A — Repos in this workspace**:
- Read `ff-workspace.yaml` for the repo list
- Present the repos for the user to select which are in scope
- Skip domain catalog entirely

**Mode B — Domain catalog**:
- Read `domain-catalog.yaml` from the workspace or a provided path
- Also scan for `*-domain-catalog.yaml` files (domain-specific deep-dive catalogs, e.g. `sportsbook-domain-catalog.yaml`). These have a `parent_domain:` field linking back to the top-level catalog. Load any that match a confirmed or evaluated domain.
- If not found: ask the user to provide the path or fall back to Mode C/D
- Run domain impact analysis (step 2 below)

**Mode C — User-named repos**:
- Ask the user to list the repos involved
- For each repo: check if it's in `ff-workspace.yaml`, in the domain catalog, or external
- Classify repos as: in-workspace, in-org (known from catalog), or external

**Mode D — AI-analysed description**:
- Parse the user's initiative description
- Check against `ff-workspace.yaml` repos, `domain-catalog.yaml` domains, `*-domain-catalog.yaml` sub-domain catalogs, and any other available context
- Propose affected repos/domains with reasoning

### 2. Domain Impact Analysis (Mode B only)

For each domain in the catalog:
- Read the domain description and key repo descriptions
- If a domain-specific catalog exists (e.g. `sportsbook-domain-catalog.yaml` with `parent_domain: sportsbook`), load it for sub-domain detail — this gives granular repo-level insight beyond the top-level catalog
- Classify as:
  - **Confirmed** — directly required by the initiative
  - **Evaluate** — possibly required, needs human decision
  - **Not affected** — no relationship to the initiative

### 3. Out-of-Workspace Repos

After identifying confirmed targets, check which repos are NOT in `ff-workspace.yaml`. Any confirmed repo outside the workspace is automatically classified as **external reference**:

- Marked as `location: external` in the scope analysis
- The seed step will generate spec stubs for manual distribution to the owning team
- No cloning, no workspace modification — this is initiative planning, not workspace setup

### 4. Identify Integration Points

Regardless of scope mode:
- Look for repos/domains that connect (shared contracts, event flows, API dependencies)
- Check for shared libraries or schemas that bridge the selected targets
- If `ff-workspace.yaml` exists: check `shared: true` repos and their `also_in` lists

### 5. Check for Existing Fluid Flow Workspaces

For each confirmed domain or external repo:
- Check if a Fluid Flow Workspace exists (via filesystem or GitHub MCP)
- If found: note the workspace name and `ff-workspace.yaml` location
- If not found: note that specs will need manual distribution

### 6. Present Scope Analysis

Present the analysis for human review.

## Outputs

- `artefacts/1.1-scope-analysis.md`

### Output Template

```markdown
# Scope Analysis

**Initiative**: {INITIATIVE_NAME}
**Date**: {ISO_TIMESTAMP}
**Scope Mode**: {A: Workspace repos / B: Domain catalog / C: Named repos / D: AI-analysed}

## In-Scope Targets

### {Target Name} (repo / domain / workspace)
- **Reason**: {Why this target is in scope}
- **Key repos**: {repo1}, {repo2}, {repo3}
- **Location**: In workspace (in ff-workspace.yaml) / External reference
- **FF Workspace**: {workspace-name} (exists) | not found | this workspace

{Repeat for each confirmed target.}

## Evaluate

### {Target Name}
- **Reason**: {Why this target might be in scope}
- **Decision needed**: {Specific question for the human}

{Repeat for each target needing evaluation.}

## Integration Points

| Integration | From | To | Type |
|-------------|------|-----|------|
| {name} | {target} | {target} | {New event/API / Existing API / Shared schema} |

## Initiative Home

All initiative artifacts will be stored in:
`initiatives/{INITIATIVE_NAME}/` in **this** workspace/repo.

Spec stubs for targets outside this workspace will be generated
in the seed step for manual distribution.

## Decision Required

[ ] Confirm in-scope targets
[ ] Include or exclude evaluated targets
```

## Gate

STOP. Present via `primitives/human-gate.md`. The human must confirm what is in scope before proceeding to decomposition.
