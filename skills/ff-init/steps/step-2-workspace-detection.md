# Step 2 — Workspace Detection

The workspace is a multi-root IDE workspace with separate repos cloned side by side. Three repos are mandatory; at least one source repo is required when `scope=full`.

**Scope behavior**: Sub-step 2c is skipped when `scope=workspace-only`. Sub-step 2a does not require source repos in `workspace-only`.

**Session variables produced**: `FF_CORE_PATH`, `KB_PATH`, `DEPT_FF_PATH`, `DEPARTMENT`, `LOCAL_KB_MANIFEST`, `folderList`

**Progressive cache**: Writes the `workspace` block to `.local-environment.json`.

---

## 2a — Identify repos

Scan all workspace root folders and classify each by name or marker:

| Rule | Repo type | Variable |
|------|-----------|----------|
| Folder name is `fluid-flow-ai` | FF Core | `FF_CORE_PATH` |
| Folder name is `betsson-kb-docs` | Enterprise KB | `KB_PATH` |
| Contains `.department-fluid-flow.json` | Department FF | `DEPT_FF_PATH` |
| None of the above | Source repo | `SOURCE_REPOS[]` |

If `DEPT_FF_PATH` is unset (no repo contained `.department-fluid-flow.json`), apply a **fallback heuristic** before halting:

1. Scan `SOURCE_REPOS[]` for any repo that contains an `initiatives/` directory at its root
2. If exactly one candidate is found, it is likely a department repo missing its config file. Offer to scaffold it:

```
  Department repo detected by structure: {candidate folder name}
  Missing: .department-fluid-flow.json

  Scaffolding from template...
```

3. Copy `{FF_CORE_PATH}/local-fluid-flow/.department-fluid-flow.json` into the candidate repo root
4. Prompt the user to configure the `department` and `name` fields (pre-fill `name` from the repo folder name)
5. Write the configured values, reclassify the repo as Department FF (`DEPT_FF_PATH`), remove it from `SOURCE_REPOS[]`, and continue
6. If zero or multiple candidates are found, do not attempt remediation — fall through to the halt below

If any of the three mandatory repos is still missing after the fallback, return `BLOCKED`:

```
  Workspace Validation: FAIL
  Missing: {list of missing repo types}

  Required workspace structure:
    fluid-flow-ai/                 (FF core — contains orchestrator.md)
    betsson-kb-docs/               (enterprise KB — contains knowledge/)
    {dept}-fluid-flow/             (department repo — contains .department-fluid-flow.json)
    {source-repo}/                 (at least 1 working repo — scope=full only)
```

## 2b — Auto-update immutable repos

FF Core and the Enterprise KB are immutable — development teams do not modify them. Pull latest `main` for both, using the appropriate shell from `SHELL_TYPE` (Step 1).

**Briefing**: Before each `git pull`, print a visible chat message: _"Pulling latest changes for {repo name} (read-only repo, safe to run)."_ — this must appear in the conversation before the terminal tool call.

**Bash / Zsh** (`SHELL_TYPE=bash`):

```bash
cd "$FF_CORE_PATH" && git pull origin main
cd "$KB_PATH" && git pull origin main
```

**PowerShell** (`SHELL_TYPE=powershell`):

```powershell
Push-Location $FF_CORE_PATH; git pull origin main; Pop-Location
Push-Location $KB_PATH; git pull origin main; Pop-Location
```

If either pull fails (e.g. network, auth), warn but do not halt — continue with the local version.

## 2c — Find source repos

**Skip this step entirely when `scope=workspace-only`** — source repos are not required.

**When `scope=full`**: Validate at least 1 source repo is present in `SOURCE_REPOS[]`. If none found, return `BLOCKED`:

```
  Workspace Validation: FAIL
  No source code repositories found. Add at least one working repo to the workspace.
```

## 2d — Read department config

Read `{DEPT_FF_PATH}/.department-fluid-flow.json`. Validate the file is valid JSON and that `department` is set (not `"CHANGE_ME"` or empty). If validation fails, prompt the user to provide the value before continuing.

Store:
- `DEPARTMENT` — department identifier (used for KB overlay routing)

If `knowledgeBaseLocal` is `true`, check if `{DEPT_FF_PATH}/knowledge-base-local/manifest.md` exists:
- If found: read the manifest and load all files under its "Always Load" section. Store `LOCAL_KB_MANIFEST` path. Report: `Local KB: loaded ({N} domain files)`
- If not found: `LOCAL_KB_MANIFEST` remains empty. No error — local KB is optional even when flagged.

## 2e — Source repo classification (already done)

Repo classification (brownfield / greenfield) and RE timestamp extraction are performed by the environment-detection script in Step 1. The `sourceRepos` array from its JSON output already contains each repo's name, type, and `reTimestamp`.

Build the sorted `folderList` array from all workspace root folder names (for future change detection).

**Write progressive cache** after this step — update `{FF_CORE_PATH}/.local-environment.json` with the `workspace` block.
