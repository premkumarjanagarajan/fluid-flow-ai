# `local-fluid-flow/` (reference kit)

This folder is a **starter kit you copy** into a separate “local fluid-flow repository”.

- It lives inside `fluid-flow-ai-core/` only so it’s easy to find and copy.
- It is **not meant to be used in-place**.
- Do **not** configure Fluid Flow to use this folder inside Core.

## What is a “local fluid-flow repository”?

A local fluid-flow repository is a **separate folder (often a separate git repo)** for a domain/area that Fluid Flow uses as the home for:

- **Workflows**: area-specific workflows / steps / conventions (now or later, depending on your setup)
- **Knowledge base**: prompts/instructions, architecture notes, gotchas, compliance constraints, team standards
- **Artifacts storage**: specs, plans, tasks, checklists, reports, metadata, and any other initiative outputs

Keeping this separate from Core is intentional:

- **Isolation**: knowledge/workflows don’t pollute work (and vice versa)
- **Customization**: each domain can evolve its own instructions and workflow variants safely
- **Durability**: artifacts have a stable home across many initiatives without cluttering `fluid-flow-ai-core/`

## What’s in this reference kit?

- `initiatives/` — the folder the orchestrator expects in a local repo (this kit keeps it empty for structure)
- `knowledge-base-local/` — optional domain/team knowledge you want loaded during workflows
- `skills/` — optional local skills your team wants to keep alongside the local repo
- `workflows/` — optional place for local workflows (future support / conventions)

## Quick start (copy into your own local repo)

1. Create a folder (outside `fluid-flow-ai-core/`) for your domain, and make sure it has `initiatives/`.
2. Copy the kit folders you want into that folder.
3. Run Fluid Flow and, when asked for the local repo path, point to **your** local repo folder.
4. On future runs, Fluid Flow will re-use the saved local-repo pointer automatically.

Example:

```bash
LOCAL_REPO="/path/to/your-local-fluid-flow-repo"
mkdir -p "$LOCAL_REPO/initiatives"

cp -R "local-fluid-flow/knowledge-base-local" "$LOCAL_REPO/"
cp -R "local-fluid-flow/skills" "$LOCAL_REPO/"
cp -R "local-fluid-flow/workflows" "$LOCAL_REPO/"
```

