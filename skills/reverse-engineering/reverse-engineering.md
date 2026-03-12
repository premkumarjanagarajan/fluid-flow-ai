# Reverse Engineering

Analyze existing codebase(s) in the workspace and generate design artifacts per repository.

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
