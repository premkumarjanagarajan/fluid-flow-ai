---
name: reverse-engineering
description: Analyses existing codebases and generates design artefacts per repository for brownfield workspaces.
execution: inline
scope: shared
version: 1.0
last-updated: 2026-04-20
---

# Reverse Engineering

Analyze existing codebase(s) in the workspace and generate design artifacts per repository.

## When to Run

- **Automatic (brownfield detection)**: Brownfield workspace detected (Stage 1) and no `reverse-engineering/reverse-engineering-timestamp.md` found — runs as a **first-time** analysis.
- **Explicit invocation**: User explicitly calls this skill (e.g. via prompt) — runs as an **update**, re-analyzing and overwriting all existing artifacts even if the timestamp file already exists.

**This skill is mandatory for every brownfield repo not excluded by discovery rules and that lacks the timestamp file.**

## Excluded Repositories

The following repositories are **always excluded** from discovery and never analyzed, regardless of mode:

- `fluid-flow-ai-core` and local fluid-flow repositories (orchestration tooling, not target codebases)
- `betsson-kb-docs` (knowledge base, not a codebase)
- Department fluid-flow repositories, e.g. `data-fluid-flow`, `mobile-fluid-flow` (workflow orchestration, not target codebases)

These are hard exclusions — they are filtered out before any skip logic is evaluated.

## Skip If (exhaustive list)

After discovery exclusions, a repository is skipped only when:

- Greenfield (no existing code)
- **Automatic mode only**: `reverse-engineering/reverse-engineering-timestamp.md` already exists in the repository root

When the skill is **explicitly invoked** by the user, the presence of the timestamp file does NOT justify skipping — treat it as an update run.

**DO NOT** skip because the feature is "targeted", the codebase is "well understood", JIRA context was loaded, or any other rationale. If the timestamp file is absent and the repo has code, this skill runs.

## Execution

### 1. Repository Discovery

Scan the workspace for all repositories, removing those listed under **Excluded Repositories** above. For each remaining repo, check if `reverse-engineering/reverse-engineering-timestamp.md` already exists:

- **Automatic mode**: If the timestamp file exists, skip that repo.
- **Explicit invocation**: Include the repo regardless — this is an update run that overwrites existing artifacts.

For the remaining repos, detect their domain:

| Indicator | Domain |
|-----------|--------|
| `angular.json`, `package.json` with `@angular/*`, `stencil.config.*`, `next.config.*`, `vite.config.*` | front-end |
| `Podfile`, `build.gradle` with android, `pubspec.yaml`, `.xcodeproj` | mobile |
| `dbt_project.yml`, `airflow`, `spark`, `*.ipynb`, pipeline configs | data |
| `Startup.cs`, `go.mod`, `pom.xml`, `requirements.txt` with flask/django/fastapi, `serverless.yml` | back-end |
| `.tf`, `cdk.json`, `docker-compose.yml`, `Dockerfile`, `k8s/` | infra |

A repository can match multiple domains.

### 2. Subagent Strategy

> **Critical**: Each repository MUST be analyzed by a **single dedicated subagent** using the
> **Claude Opus 4.6 high** model. Each subagent performs both analysis and artifact generation
> within its own context window. This prevents the parent agent's context from overflowing
> with large analysis payloads.

For each repository discovered in Step 1, launch **one subagent** (in parallel where possible) with a prompt that includes:

1. The repository path
2. The domain indicators detected
3. The full artifact template list (from Step 3)
4. The templates path: `skills/reverse-engineering/templates/`
5. The output path: `{repo}/reverse-engineering/`
6. The current ISO 8601 timestamp and workspace path (for the timestamp file)
7. The current branch name and HEAD commit short SHA of the target repository (run `git rev-parse --abbrev-ref HEAD` and `git rev-parse --short HEAD` in the repo)
8. The author name (run `git config user.name` in the repo)

The subagent prompt MUST instruct the agent to:
- Explore the repository (package.json files, config files, source code, directory structure)
- Perform all analysis internally (multi-package discovery, business context, architecture mapping, code analysis)
- Create the `reverse-engineering/` directory in the repository
- Write all 11 artifact files directly to disk
- Record the branch name, commit short SHA, and author in the timestamp file (both in the metadata header and the update history entry)
- **Return ONLY a short status summary** (max 5 lines): repo name, domain, package count, and confirmation of files written

**Do NOT** ask the subagent to return the full analysis. All detailed findings go into the artifact files, not the return payload.

### 3. Artifact Templates

Each subagent populates these templates from `skills/reverse-engineering/templates/` into `{repo}/reverse-engineering/`:

| Template | Purpose |
|----------|---------|
| `business-overview.md` | Business context, transactions, domain dictionary |
| `architecture.md` | System overview, component descriptions, data flow |
| `c4-architecture.md` | C4 model (Context, Container, Component, Code) |
| `code-structure.md` | Build system, file inventory, design patterns |
| `api-documentation.md` | REST/internal APIs, data models |
| `component-inventory.md` | Package inventory by type |
| `technology-stack.md` | Languages, frameworks, infra, tools |
| `dependencies.md` | Internal/external dependency graph |
| `code-quality-assessment.md` | Quality indicators, tech debt, patterns |
| `test-coverage-analysis.md` | Test pyramid, coverage gaps, business flow matrix |

Last, the subagent generates `reverse-engineering-timestamp.md` to mark completion.

### 4. Present Summary

Collect the short status lines from each subagent. Present a consolidated summary table:

```
┌─────────────────────────────────────────────────┐
│  REVERSE ENGINEERING COMPLETE                   │
├──────────────┬──────────┬───────┬───────────────┤
│ Repository   │ Domain   │ Pkgs  │ Artifacts     │
├──────────────┼──────────┼───────┼───────────────┤
│ {repo}       │ {domain} │ {n}   │ 11/11 ✓       │
│ ...          │ ...      │ ...   │ ...           │
└──────────────┴──────────┴───────┴───────────────┘
```

**Wait for user approval** before proceeding.

Use the IDE question tool (Cursor: `AskQuestion` / VS Code: `vscode_askQuestions`):
- **A**: Approve and continue
- **B**: Request changes
