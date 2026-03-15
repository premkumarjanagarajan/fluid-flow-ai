---
step: scope
subagent: false
---

## Context Loading

| Load | Do NOT Load |
|------|------------|
| `domain-catalog.yaml` | `reverse-engineering/combined-architecture.md` |
| `ff-workspace.yaml` (already loaded at Stage 1) | Per-repo RE artifacts |
| | `reverse-engineering/combined-c4.md` |
| | `reverse-engineering/incident-learnings.md` |

The scope step works from the domain catalog and workspace composition file. Per-repo detail is not needed to identify affected domains.

## Inputs

- User prompt (natural language initiative description)
- `domain-catalog.yaml` — org-level domain registry

## Guidance

Identify which domains and workspaces are affected by the initiative. The AI proposes; the human validates.

### 1. Read Domain Catalog

Read `domain-catalog.yaml` from the workspace or a provided path. This is an existing org-level registry of repositories across product domains. It is not owned by Fluid Flow.

If the domain catalog is not found, ask the user to provide the path or describe the domains manually.

### 2. Analyse Initiative Against Domains

For each domain in the catalog:
- Read the domain description and key repo descriptions
- Classify as:
  - **Confirmed** — directly required by the initiative
  - **Evaluate** — possibly required, needs human decision
  - **Not affected** — no relationship to the initiative

### 3. Identify Cross-Domain Integration Points

- Look for repos that appear in multiple domains
- Trace event flows and API dependencies between confirmed domains
- Check for shared libraries, contracts, or schemas that bridge domains

### 4. Check for Existing Fluid Flow Workspaces

For each confirmed domain:
- Check if a Fluid Flow Workspace exists (via filesystem or GitHub MCP)
- If found: note the workspace name and `ff-workspace.yaml` location
- If not found: note that the domain has no workspace (specs will need manual distribution)

### 5. Present Domain Impact Analysis

Present the analysis for human review.

## Outputs

- `artefacts/1.1-domain-impact.md`

### Output Template

```markdown
# Domain Impact Analysis

**Initiative**: {INITIATIVE_NAME}
**Date**: {ISO_TIMESTAMP}

## Confirmed Domains

### {Domain Name}
- **Reason**: {Why this domain is required}
- **Key repos**: {repo1}, {repo2}, {repo3}
- **FF Workspace**: {workspace-name} (exists) | not found

{Repeat for each confirmed domain.}

## Evaluate

### {Domain Name}
- **Reason**: {Why this domain might be required}
- **Decision needed**: {Specific question for the human}

{Repeat for each domain needing evaluation.}

## Cross-Domain Integration Points

| Integration | From | To | Type |
|-------------|------|-----|------|
| {integration-name} | {domain} | {domain} | {New event/API / Existing API / Shared schema} |

## Decision Required

[ ] Confirm {domain1}, {domain2}, {domain3} as in-scope
[ ] Include or exclude {evaluate-domain1}
[ ] Include or exclude {evaluate-domain2}
```

## Gate

STOP. Present via `primitives/human-gate.md`. The human must confirm which domains are in-scope before proceeding to decomposition.
