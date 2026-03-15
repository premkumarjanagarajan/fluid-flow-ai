# Fluid Flow v1.0 — Flexible Scope, RE Output Choice, and Workspace Creation

## Spec Metadata

- **Depends on**: Fluid Flow v1.0 Workspace spec, Workflow Rename & Fast-Track spec
- **Status**: Implemented
- **Date**: 2026-03-15

---

## 1. Problems Addressed

Four issues identified during testing of the v1.0 implementation:

1. **Multi-workspace scope too narrow** — The scope step assumed "another workspace" as the only cross-boundary target. In practice, initiatives can span repos in the same workspace, domains from an org catalog, specific repos the user names, or a combination.

2. **Initiative artifact location unclear for cross-context work** — When an initiative spans repos or domains outside the current workspace, it wasn't explicit where artifacts live.

3. **RE output pollutes repos the user doesn't own** — Per-repo RE writes 11 artifact files into each target repo. Users without write access to those repos, or who prefer to keep them clean, had no alternative.

4. **No option to create a workspace repo** — When VS Code has multiple folders but no Fluid Flow Workspace, the only options were "set up this repo" or "skip." Users who wanted a dedicated workspace repo had to create it manually.

---

## 2. Flexible Scope Modes

### 2.1 Change

The multi-workspace workflow's scope step now presents a mode selection:

| Mode | What it does | Primary input |
|------|-------------|---------------|
| **A) Repos in this workspace** | User selects from `ff-workspace.yaml` repo list | `ff-workspace.yaml` |
| **B) Domains from catalog** | AI analyses initiative against org domain catalog | `domain-catalog.yaml` |
| **C) Named repos** | User provides a list of repos directly | User input |
| **D) AI-analysed** | AI parses the initiative description against all available context | User description + all available context |

### 2.2 Mode Details

**Mode A** — simplest path when the initiative is within the current workspace. Skips domain catalog entirely. Presents `ff-workspace.yaml` repos for selection.

**Mode B** — the original v1.0 behaviour. Reads `domain-catalog.yaml`, classifies domains as Confirmed/Evaluate/Not affected. Falls back to Mode C/D if the catalog isn't found.

**Mode C** — user lists repos explicitly. Each repo is classified as: in-workspace (found in `ff-workspace.yaml`), in-org (found in domain catalog), or external. This is the most direct mode — no AI guessing.

**Mode D** — AI analyses the user's natural language description against all available context (`ff-workspace.yaml`, `domain-catalog.yaml`, brownfield RE artifacts). Proposes targets with reasoning. Best for when the user isn't sure what's affected.

### 2.3 Output

The output artifact is now `artefacts/1.1-scope-analysis.md` (renamed from `domain-impact.md` to reflect the broader scope). Each target is classified with its location: in this workspace, in org, or external.

---

## 3. Initiative Artifact Location

### 3.1 Rule

**Initiative artifacts always live in the workspace/repo where the initiative was created.**

This is the "home" workspace. Even when the initiative spans external repos or domains, all artifacts (scope analysis, decomposition, contracts, sequence, spec stubs) are stored in `initiatives/{INITIATIVE_NAME}/` in the home workspace.

### 3.2 Cross-Context Distribution

The seed step (Phase 5) generates per-target spec stubs at `artefacts/5.1-workspace-stubs/{target-name}.md`. These are designed to be manually copied to target workspaces/repos by the teams responsible for those targets. Fluid Flow does not write to repos outside the workspace.

### 3.3 Explicit Documentation

The scope analysis output now includes an "Initiative Home" section that states where artifacts live and how stubs will be distributed.

---

## 4. RE Output Location Choice

### 4.1 Change

During workspace setup (Step 3 of the workspace-setup skill), the user is asked:

```
Where should reverse engineering artifacts be stored?

A) Both — per-repo artifacts in each repo + combined in workspace (default)
B) Workspace only — all RE artifacts centralised in the workspace repo
```

### 4.2 Output Modes

| Mode | Per-repo artifacts | Combined artifacts |
|------|-------------------|-------------------|
| `both` (default) | `{repo}/reverse-engineering/` (inside each repo) | `reverse-engineering/` in workspace |
| `workspace-only` | `reverse-engineering/{repo-name}/` (in workspace repo) | `reverse-engineering/` in workspace |

In `workspace-only` mode, **no files are written inside target repos**. All RE output is centralised.

### 4.3 Persistence

The choice is stored in `ff-workspace.yaml` as the `re_output` field (`both` or `workspace-only`). Future RE runs read this field and skip the prompt. The field is preserved across `ff-workspace.yaml` regeneration (human-edited field).

### 4.4 Impact on Context Loading

The context loading strategy in `knowledge-base-core/manifest.md` § Workspace Artifacts is unaffected — it references per-repo RE artifacts generically. The RE skill resolves the actual path based on `re_output` mode. Implementation subagents receive the correct path regardless of mode.

---

## 5. Create New Workspace Repo (Option C)

### 5.1 Change

The multi-repo detection prompt in the orchestrator gains a third option:

```
A) Set up as Fluid Flow Workspace (recommended)
   Use this repo as the workspace

B) Continue with single-repo mode

C) Create a new Fluid Flow Workspace repo
   Creates {context}-ff-workspace/ as a sibling directory
```

### 5.2 Option C Flow

1. Ask for workspace context name (e.g. `sportsbook`). Suggest based on common repo name prefixes.
2. Create `../{context}-ff-workspace/` as a sibling directory
3. Initialise as git repo (`git init`)
4. Copy Fluid Flow framework files (orchestrator, knowledge-base-core, primitives, skills, workflow, templates)
5. Copy IDE entry points (`.cursor/rules/instructions.mdc`, `.github/copilot-instructions.md`)
6. Update `.code-workspace` file: add the new workspace repo as the **first** folder entry
7. Load workspace-setup skill to complete setup (RE, ff-workspace.yaml, shared repo discovery)

### 5.3 Why First Folder

The Fluid Flow Workspace must be the first folder in the `.code-workspace` file so that IDE entry points in that folder take precedence. This ensures the orchestrator is always loaded, regardless of which repo the user is working in.

---

## 6. Files Modified

| File | Change |
|------|--------|
| `workflow/multi-workspace/wf-multi-workspace.md` | Updated description, added scope modes documentation |
| `workflow/multi-workspace/1-scope/1-scope/1-scope.md` | Rewrote with 4 scope modes (A/B/C/D), renamed output to scope-analysis.md |
| `skills/workspace-setup/workspace-setup.md` | Added Step 3 (RE output location choice), renumbered subsequent steps, added `re_output` to ff-workspace.yaml generation |
| `skills/reverse-engineering/reverse-engineering.md` | Added RE Output Mode section with `both`/`workspace-only` path resolution |
| `orchestrator.md` | Added option C to multi-repo detection prompt with workspace repo creation flow, updated Stage 2 with RE output mode |
