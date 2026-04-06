# Department Fluid Flow Repository (reference skeleton)

This folder is a **starter kit** for creating a new department fluid-flow repository. Copy it, configure it, and use it as your team's workspace anchor.

## What is a department fluid-flow repo?

The department repo is where your team's initiative artifacts, local knowledge, and custom workflows live. It sits alongside `fluid-flow-ai` and `betsson-kb-docs` in a multi-root workspace.

It contains:

- **`initiatives/`** — all initiative artifacts (specs, plans, tasks, code, metadata)
- **`knowledge-base-local/`** — optional domain/team-specific knowledge loaded during workflows
- **`skills/`** — optional local skills your team wants to add
- **`workflows/`** — optional custom workflows for your department

## Required workspace structure

A Fluid Flow workspace is a multi-root IDE workspace with four types of repos cloned side by side:

```
fluid-flow-ai/                     # FF core (cloned, auto-updated to latest main)
betsson-kb-docs/                   # Enterprise KB (cloned, auto-updated to latest main)
{dept}-fluid-flow/                 # This repo — department FF (workspace root)
  .department-fluid-flow.json      # department config (committed)
  initiatives/                     # initiative artifacts
  knowledge-base-local/            # optional local KB
  workflows/                       # optional custom workflows

{source-repo}/                     # Source code repo (workspace root, at least 1)
{source-repo-2}/                   # Additional source repos (optional)
```

## Quick start

### 1. Create your department repo

```bash
mkdir bx-fluid-flow && cd bx-fluid-flow
git init
```

### 2. Copy the skeleton files

```bash
# From the fluid-flow-ai core repo:
cp -R local-fluid-flow/.department-fluid-flow.json .
cp -R local-fluid-flow/.cursor .
cp -R local-fluid-flow/.vscode .
cp -R local-fluid-flow/initiatives .
cp -R local-fluid-flow/knowledge-base-local .
cp -R local-fluid-flow/skills .
cp -R local-fluid-flow/workflows .
```

### 3. Configure your department

Edit `.department-fluid-flow.json`:

```json
{
  "department": "brand-experience",
  "name": "bx-fluid-flow",
  "knowledgeBaseLocal": false,
  "workflows": []
}
```

### 4. Initial commit

```bash
git add .
git commit -m "chore: initialise department fluid-flow repo"
```

### 5. Clone the core repos

Clone `fluid-flow-ai` and `betsson-kb-docs` alongside your department repo:

```bash
cd ..
git clone https://github.com/BetssonGroup/fluid-flow-ai.git
git clone https://github.com/BetssonGroup/betsson-kb-docs.git
```

### 6. Set up the workspace

In your IDE, create a multi-root workspace with:
1. `fluid-flow-ai/`
2. `betsson-kb-docs/`
3. Your department repo (e.g., `bx-fluid-flow/`)
4. Your source code repo(s) (e.g., `sb-b2b-fe-app/`)

The orchestrator detects the workspace structure automatically on first run and auto-updates the core repos to latest `main`.
