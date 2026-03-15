# Reverse Engineering

Analyze existing codebase(s) in the workspace and generate design artifacts per repository. In Fluid Flow Workspace mode, also produce combined workspace-level architecture views and generate/update `ff-workspace.yaml`.

## When to Run

- **Brownfield** workspace detected (Stage 1)
- No `reverse-engineering/reverse-engineering-timestamp.md` found in the target repository

## Skip If

- Greenfield (no existing code)
- `reverse-engineering/reverse-engineering-timestamp.md` already exists in the repository
- Run-once per repository. Post-implementation updates are separate.

## Execution

### 1. Repository Discovery

Scan the workspace for all repositories. For each, detect its domain:

| Indicator | Domain |
|-----------|--------|
| `angular.json`, `package.json` with `@angular/*`, `stencil.config.*`, `next.config.*`, `vite.config.*` | front-end |
| `Podfile`, `build.gradle` with android, `pubspec.yaml`, `.xcodeproj` | mobile |
| `dbt_project.yml`, `airflow`, `spark`, `*.ipynb`, pipeline configs | data |
| `Startup.cs`, `go.mod`, `pom.xml`, `requirements.txt` with flask/django/fastapi, `serverless.yml` | back-end |
| `.tf`, `cdk.json`, `docker-compose.yml`, `Dockerfile`, `k8s/` | infra |

A repository can match multiple domains.

### 2. Subagent Strategy

> **Critical**: Each repository MUST be analyzed by a **single dedicated subagent** that performs
> both analysis and artifact generation within its own context window. This prevents the parent
> agent's context from overflowing with large analysis payloads.

#### Context Isolation

Each subagent type has a strictly scoped context:

| Subagent | What it gets | What it does NOT get |
|----------|-------------|---------------------|
| RE per-repo subagent | One repo's codebase | Other repos, combined architecture, ff-workspace.yaml |
| RE combined-architecture subagent | All per-repo `architecture.md`, `dependencies.md`, `c4-architecture.md`, `api-documentation.md` | Full codebases, knowledge-base-core |

This follows the workspace loading strategy in `knowledge-base-core/manifest.md` § Workspace Artifacts.

For each repository discovered in Step 1, launch **one subagent** (in parallel where possible) with a prompt that includes:

1. The repository path
2. The domain indicators detected
3. The full artifact template list (from Step 3)
4. The templates path: `skills/reverse-engineering/templates/`
5. The output path: `{repo}/reverse-engineering/`
6. The current ISO 8601 timestamp and workspace path (for the timestamp file)

The subagent prompt MUST instruct the agent to:
- Explore the repository (package.json files, config files, source code, directory structure)
- Perform all analysis internally (multi-package discovery, business context, architecture mapping, code analysis)
- Create the `reverse-engineering/` directory in the repository
- Write all 11 artifact files directly to disk
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

### 4. Combined Workspace Artifacts (Workspace Mode Only)

**Skip if**: no `ff-workspace.yaml` exists (single-repo mode).

After all per-repo subagents complete, launch **one additional subagent** to produce combined workspace-level artifacts. This subagent receives:

1. The workspace repo path
2. The list of all repos and their `reverse-engineering/` paths
3. The combined artifact templates from `skills/reverse-engineering/templates/`
4. The output path: `reverse-engineering/` in the Fluid Flow Workspace repo

The subagent prompt MUST instruct the agent to:
- Read per-repo `architecture.md`, `dependencies.md`, `c4-architecture.md`, and `api-documentation.md` from each repo
- Synthesise cross-repo relationships: inter-repo data flows (Kafka topics, REST API calls, shared library dependencies)
- Produce `combined-architecture.md` using the template — system-level architecture with Mermaid diagrams showing all repos and their relationships
- Produce `combined-c4.md` using the template — C4 model where containers = repos
- Write `reverse-engineering-timestamp.md` in the workspace `reverse-engineering/` directory
- **Return ONLY a short status summary**: repo count, relationship count, artifacts written

**Do NOT** ask the subagent to return full analysis. All findings go into the artifact files.

### 5. ff-workspace.yaml Generation (Workspace Mode Only)

**Skip if**: no `.code-workspace` file exists or single-repo mode.

After combined artifacts are produced, generate or update `ff-workspace.yaml` from RE findings:

1. **Repos**: for each repo, extract name, path, type (application/shared/library), language(s), description (from `business-overview.md`)
2. **Teams**: from CODEOWNERS files or GitHub API if available
3. **Governance**: default flags based on knowledge-base-core presence (e.g. `iso27001: true` if `security/iso27001-compliance.md` exists)

**On incremental RE updates** (ff-workspace.yaml already exists):
- Compare discovered state against existing `ff-workspace.yaml`
- Propose updates for changed repos (new repos, removed repos, language/type changes)
- **Preserve human-edited fields**: `change_coordination`, team `slack` channels, `governance` flags
- Present proposed changes via human-gate before writing

### 6. Present Summary

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

If workspace mode, also report:

```
┌─────────────────────────────────────────────────┐
│  COMBINED ARTIFACTS                             │
├─────────────────────────┬───────────────────────┤
│ combined-architecture   │ ✓                     │
│ combined-c4             │ ✓                     │
│ ff-workspace.yaml       │ Generated / Updated   │
└─────────────────────────┴───────────────────────┘
```

**Wait for user approval** before proceeding.

Use the IDE question tool (Cursor: `AskQuestion` / VS Code: `vscode_askQuestions`):
- **A**: Approve and continue
- **B**: Request changes
