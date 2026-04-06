# Fluid Flow

AI-driven development workflow framework. Single entry point, staged lifecycle, pluggable workflows, and a shared knowledge base that governs every step.

For detailed documentation, see the [Wiki](https://github.com/BetssonGroup/fluid-flow-ai/wiki).

## Quick Start

### 1. Open a blank workspace

Open an empty workspace in VS Code / Cursor (no folders added yet).

### 2. Clone the Fluid Flow and Knowledge Base repos

```bash
git clone https://github.com/BetssonGroup/fluid-flow-ai.git
git clone https://github.com/BetssonGroup/betsson-kb-docs.git
```

### 3. Add your department Fluid Flow repo

Each department has its own Fluid Flow repository where initiative artifacts, local knowledge base, and workflows live (e.g. `data-fluid-flow`, `payment-fluid-flow`).

If your department already has one, clone it:

```bash
git clone <your-department-fluid-flow-repo-url>
```

If your department doesn't have one yet, contact your Head of Engineering.

### 4. Add your source code/ working repositories

Add the repos you work on. For example:

```bash
git clone <your-working-repo-url>
```

Your workspace should now look like this:

```
fluid-flow-ai/                 # Core framework (this repo, auto-updated to latest main)
betsson-kb-docs/               # Enterprise knowledge base (auto-updated to latest main)
data-fluid-flow/                 # Your department Fluid Flow repo (artifacts live here)
  .department-fluid-flow.json
  initiatives/
my-working-repo/               # The source code you change and ship
```

Start a development request — the orchestrator handles the rest.

## Repository Boundary

- **`fluid-flow-ai`** = **HOW** the AI works during development (orchestrator, workflows, skills, instructions, prompts, primitives, behavioral rules)
- **`betsson-kb-docs`** = **WHAT** the organisation knows (standards, compliance, technology, domain knowledge)
