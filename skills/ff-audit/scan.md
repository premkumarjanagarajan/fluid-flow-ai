# Scan

Scan building blocks and collect issues. The **scope** parameter controls what to scan, and the **target** parameter controls which repo(s).

---

## Target Resolution

| Target | Repos to scan |
|--------|---------------|
| `core` | `{FF_CORE_PATH}` (fluid-flow-ai) |
| `department` | `{DEPT_FF_PATH}` (department fluid-flow repo) |
| `both` | Both repos, reported separately |

When auditing `department`, use the core repo as a **read-only reference** for expected patterns — never modify core files.

---

## Scope Resolution

### Core building blocks (`{FF_CORE_PATH}`)

| Scope | What to scan |
|-------|-------------|
| `all` | Everything below |
| `workflows` | `workflows/` |
| `skills` | `skills/` (shared) + `workflows/*/skills/` (workflow-local) |
| `agents` | `agents/` |
| `mcps` | `mcps/` |
| `primitives` | `primitives/` |
| `commands` | `.github/prompts/` + `.cursor/commands/` |

### Department building blocks (`{DEPT_FF_PATH}`)

| Scope | What to scan |
|-------|-------------|
| `all` | Everything below |
| `workflows` | `workflows/` (custom department workflows) |
| `skills` | `skills/` (custom department skills) |
| `commands` | `.github/prompts/` + `.cursor/commands/` |
| `initiatives` | `initiatives/*/` (folder structure + metadata integrity) |
| `local-kb` | `knowledge-base-local/` (manifest + referenced files) |
| `config` | `.department-fluid-flow.json` (valid JSON, required fields populated) |

**Out of scope (always):** `.git/`, `.vscode/`, `node_modules/`, `.env`, script files (`*.sh`, `*.ps1`, `*.bash`), template files inside skill subfolders (e.g. `reverse-engineering/templates/`).

---

## Expected Patterns

Do **not** hardcode required fields. Instead, derive the expected format from the scaffolding templates in `skills/fluid-flow-help/scaffolding/`:

| Building block | Reference file | Expected naming | Frontmatter source of truth |
|----------------|---------------|-----------------|----------------------------|
| Workflow | `scaffolding/workflow.md` | `wf-*.md` overview file per workflow folder | `workflow-name`, `workflow-description`, `domain`, `version`, `release`, `last-update` |
| Skill (shared) | `scaffolding/skill.md` | One main `.skill.md` or `.md` per skill subfolder | `name`, `description`, `execution`, `scope`, `version`, `last-updated` |
| Skill (workflow-local) | Same as shared | Same but `scope: workflow-local` | Same fields |
| Agent | (no scaffolding — use existing agents as reference) | `*.agent.md` | `name`, `description`, `tools`, `version`, `last-updated` |
| MCP | `scaffolding/mcp-tool.md` | `*.md` with `## Config` code block containing valid JSON | No YAML frontmatter — validate the Config block |
| Primitive | (no scaffolding) | `*.md` in `primitives/` | No frontmatter — validate file exists and is non-empty |
| Command | `scaffolding/prompt-command.md` | `.github/prompts/*.prompt.md` + `.cursor/commands/*.md` | No frontmatter — validate file exists and is non-empty |

When validating frontmatter fields, read the scaffolding template to confirm the current expected structure. If the scaffolding template has been updated with new fields, use the updated version — the scaffolding is the source of truth.

---

## Department-Specific Checks

When target is `department` or `both`, also validate:

### Config file

Read `{DEPT_FF_PATH}/.department-fluid-flow.json`:
- Must be valid JSON
- `department` must not be `"CHANGE_ME"` or empty
- `name` must not be `"CHANGE_ME"` or empty
- `knowledgeBaseLocal` must be boolean

### Initiatives

For each folder in `{DEPT_FF_PATH}/initiatives/*/`:
- Must contain `metadata/state.md` — the initiative's progress tracker
- Must contain `metadata/audit.md`
- Must contain `metadata/analytics.md`
- Must contain `artefacts/` directory
- `state.md` must have valid content (not empty, not a bare template with no progress)

### Local Knowledge Base

If `knowledgeBaseLocal` is `true` in the config:
- `knowledge-base-local/manifest.md` must exist
- Every file listed in the manifest's "Always Load" section must exist on disk
- Files in the directory that aren't listed in the manifest should be flagged as unreferenced

If `knowledgeBaseLocal` is `false`:
- Skip this check, but note if `knowledge-base-local/` contains files other than `.gitkeep` (possible misconfiguration)

### Department custom building blocks

Department skills and workflows follow the **same format rules** as core. Use the Expected Patterns table above to validate them. The only difference is that department workflows appear under `{DEPT_FF_PATH}/workflows/` and department skills under `{DEPT_FF_PATH}/skills/`.

---

## Scan Procedure

For each building block in scope:

### 1. List files

List all files in the building block's folder(s). For skills and workflows, scan subdirectories recursively to find the main file.

### 2. Validate format

For each main file (not templates, not scripts):

- **Frontmatter present?** — attempt to parse YAML between `---` delimiters
- **Required fields present?** — check against the Expected Patterns table above
- **Required fields non-empty?** — no blank values

### 3. Validate naming

- Does the file match the expected naming pattern for its building block?
- Are folder names consistent with file names? (e.g. `skills/mcp-check/mcp-check.md`)

### 4. Detect drift

- **Unreferenced files** — files that exist but aren't referenced by any workflow dependency, orchestrator, or other building block
- **Broken references** — dependency paths (in frontmatter `dependencies` blocks or in markdown body links) that point to files that don't exist on disk
- **Stale references** — mentions of files that have been deleted or moved

### 5. Collect

Record every finding as:

```
{file_path} | {issue_type} | {detail} | {suggested_fix}
```

Issue types: `Format`, `Naming`, `Broken Ref`, `Unreferenced`, `Stale Ref`

Pass all findings to `report.md` for presentation.
