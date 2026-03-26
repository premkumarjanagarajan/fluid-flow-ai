# Fluid Flow

AI-driven development workflow framework. Single entry point, staged lifecycle, pluggable workflows, and a shared knowledge base that governs every step.

For detailed documentation, see the [Wiki](https://github.com/BetssonGroup/fluid-flow-ai/wiki).

## Quick Start

### 1. Open a blank workspace

Open an empty workspace in VS Code / Cursor (no folders added yet).

### 2. Clone the Fluid Flow repo

```bash
git clone https://github.com/BetssonGroup/fluid-flow-ai.git
```

### 3. Create your local Fluid Flow repo

Create a new repository for your team / department — this is where initiative artifacts will live (e.g. `fluid-flow-ai-pam`).

You can start with an empty folder, or copy the skeleton shipped with Fluid Flow:

```bash
cp -R fluid-flow-ai/local-fluid-flow my-local-fluid-flow
```

The skeleton includes empty `initiatives/`, `knowledge-base-local/`, `skills/`, and `workflows/` folders.

### 4. Add your working repositories

Add the repos you work on. For example:

```bash
git clone <your-working-repo-url>
```

Your workspace should now look like this:

```
fluid-flow-ai/            # Core framework (this repo)
my-local-fluid-flow/      # Your local Fluid Flow repo (artifacts live here)
my-working-repo/           # The code you change and ship
```

Open all folders in the same multi-root workspace, then start a development request — Fluid Flow takes it from there.
