# Step 1 — Environment Detection

**Scope behavior**: Runs in both `full` and `workspace-only` modes. In `workspace-only`, runs without source repo paths (OS and shell only).

**Session variables produced**: `OS`, `SHELL_TYPE`, `IDE`, `PACKAGE_MANAGERS`, `TECH_STACK`, `SOURCE_REPOS[]`

**Progressive cache**: Writes the `environment` block to `.local-environment.json`.

---

Load `skills/environment-detection/environment-detection.md` and execute it.

**If `scope=full`** (default): Pass all **source repo paths** (identified in Step 2a) as arguments to the detection script so it can scan them for tech stack markers and classify them as brownfield/greenfield in a single pass:

```bash
bash skills/environment-detection/scripts/environment-detection.bash /path/to/repo1 /path/to/repo2 ...
```

**If `scope=workspace-only`**: Run the detection script **without** any source repo paths — it will detect OS and shell only:

```bash
bash skills/environment-detection/scripts/environment-detection.bash
```

The script outputs a **single JSON object** containing:
- `os`, `shellType`, `packageManagers`, `techStack`
- `sourceRepos` — array with each repo's name, type (brownfield/greenfield), and RE timestamp

Parse the JSON output and store session variables:
- `OS` (darwin / linux / windows)
- `SHELL_TYPE` (bash / powershell)
- `IDE` (cursor / vscode) — inferred by the AI from the runtime context
- `PACKAGE_MANAGERS` (comma-separated list) — **empty when `scope=workspace-only`**
- `TECH_STACK` (comma-separated list) — **empty when `scope=workspace-only`**
- `SOURCE_REPOS[]` — from the `sourceRepos` array in the JSON output — **empty when `scope=workspace-only`**

**Write progressive cache** after this step — update `{FF_CORE_PATH}/.local-environment.json` with the `environment` block so progress is preserved if later steps fail.
