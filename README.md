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

### 3. Add your department Fluid Flow repo

Each department has its own Fluid Flow repository where initiative artifacts, local knowledge base, and workflows live (e.g. `data-fluid-flow`, `payment-fluid-flow`).

If your department already has one, clone it:

```bash
git clone <your-department-fluid-flow-repo-url>
```

If your department doesn't have one yet, reach out to your Head of Engineering to discuss the best approach for creating it.

### 4. Add your working repositories

Add the repos you work on. For example:

```bash
git clone <your-working-repo-url>
```

Your workspace should now look like this:

```
fluid-flow-ai/            # Core framework (this repo)
data-fluid-flow/          # Your department Fluid Flow repo (artifacts live here)
my-working-repo/           # The code you change and ship
```

Open all folders in the same multi-root workspace, then start a development request — Fluid Flow takes it from there.
