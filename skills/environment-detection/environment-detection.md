---
name: environment-detection
description: Detects OS, shell, IDE, package managers, tech stack, and classifies source repos in a single script call.
execution: inline
scope: shared
version: 1.0
last-updated: 2026-04-20
---

# Environment Detection

Detect the user's OS, shell, IDE, available package managers, project tech stack, and classify source repos — all in a single script call.

## How to Run

Before executing the detection script, you **MUST** print a visible one-liner explanation **as a chat message** to the user so they can understand and approve the terminal command with confidence. This message must appear in the conversation **before** the terminal tool call — setting the tool's `explanation` parameter alone is NOT sufficient.

Example briefing (print this as chat text before the tool call):

> _"I'll detect your OS, shell, package managers, and tech stack by scanning source repo directories (read-only, no files are modified)."_

1. Try `skills/environment-detection/scripts/environment-detection.bash` first, passing all **source repo** paths as arguments:

```bash
bash skills/environment-detection/scripts/environment-detection.bash /path/to/repo1 /path/to/repo2 ...
```

2. If it fails (not found, permission denied, or error), try `skills/environment-detection/scripts/environment-detection.ps1` with the same arguments
3. Parse the JSON output and store all session variables

## Output Format

Both scripts output a **single JSON object** to stdout:

```json
{
  "os": "darwin",
  "shellType": "bash",
  "packageManagers": "npm,pnpm",
  "techStack": "python,sql,dotnet",
  "sourceRepos": [
    { "name": "my-repo", "type": "brownfield", "reTimestamp": "2026-04-02T00:00:00Z" },
    { "name": "new-repo", "type": "greenfield", "reTimestamp": null }
  ]
}
```

The script performs **tech stack detection and source repo classification in a single pass** — no need for a separate classification step.

The AI must also determine:

- `IDE`: infer from the runtime context (Cursor if `AskQuestion` tool is available; VS Code if `vscode_askQuestions` is available)

## Session Variables

| Variable | Source | Example | Purpose |
|----------|--------|---------|---------|
| `OS` | JSON `.os` | `darwin` | Platform-specific behaviour |
| `SHELL_TYPE` | JSON `.shellType` | `bash` | Script routing (.bash vs .ps1) |
| `IDE` | AI inference | `cursor` | MCP config path, IDE-specific tools |
| `PACKAGE_MANAGERS` | JSON `.packageManagers` | `npm,docker,terraform` | Available toolchain |
| `TECH_STACK` | JSON `.techStack` | `typescript,dotnet,terraform` | Workflow suggestion, KB loading |
| `SOURCE_REPOS[]` | JSON `.sourceRepos` | array of objects | Repo type + RE status |

## Script Routing

After detection, all subsequent scripts in the workflow use:
- `SHELL_TYPE=bash` --> run `.bash` / `.sh` scripts
- `SHELL_TYPE=powershell` --> run `.ps1` scripts

## Tech Stack Detection Rules

The scripts scan each provided directory (up to depth 3) for these markers:

| Marker files | Tech detected |
|-------------|---------------|
| `*.csproj`, `*.sln`, `*.fsproj` | `dotnet` |
| `package.json` | `typescript` (if has TS deps) or `javascript` |
| `*.tf`, `terraform/` | `terraform` |
| `go.mod` | `go` |
| `Cargo.toml` | `rust` |
| `docker-compose.yml`, `Dockerfile` | `docker` |
| `azure-pipelines.yml` | `azure` |
| `*.py`, `requirements.txt`, `pyproject.toml` | `python` |
| `*.sql` | `sql` |

## Source Repo Classification

Each scanned directory is classified during the same pass:
- **brownfield**: any of the tech markers above were found
- **greenfield**: no code markers detected

The script also checks for `reverse-engineering/reverse-engineering-timestamp.md` in each repo and extracts the timestamp if present.

## Caching

The orchestrator (Stage 0A) caches the detection output to `{FF_CORE_PATH}/.local-environment.json` after the first run. On subsequent sessions the cached file is loaded directly and this skill is skipped. The cache file is gitignored so it persists across `git pull` and is never committed.

To force a fresh detection, delete `.local-environment.json` from the `fluid-flow-ai` root.

## Downstream Usage

- **Workflow selection**: `TECH_STACK` helps suggest the best-matching workflow
- **KB loading**: `TECH_STACK` auto-selects which engineering standards to load from `$KB_PATH/knowledge/shared/engineering-standards/`
- **MCP check**: `IDE` determines which MCP config file to read (`.cursor/mcp.json` vs `.vscode/mcp.json`)
