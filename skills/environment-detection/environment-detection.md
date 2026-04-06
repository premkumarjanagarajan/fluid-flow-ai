# Environment Detection

Detect the user's OS, shell, IDE, available package managers, and project tech stack to configure the session.

## How to Run

1. Try `skills/environment-detection/scripts/environment-detection.bash` first
2. If it fails (not found, permission denied, or error), try `skills/environment-detection/scripts/environment-detection.ps1`
3. Parse the output and store all session variables

## Output Format

Both scripts output key-value pairs, one per line:

```
SHELL_TYPE={bash|powershell}
OS={darwin|linux|windows}
PACKAGE_MANAGERS={comma-separated list}
TECH_STACK={comma-separated list}
```

The AI must also determine:

- `IDE`: infer from the runtime context (Cursor if `AskQuestion` tool is available; VS Code if `vscode_askQuestions` is available)

## Session Variables

| Variable | Source | Example | Purpose |
|----------|--------|---------|---------|
| `OS` | Script output | `darwin` | Platform-specific behaviour |
| `SHELL_TYPE` | Script output | `bash` | Script routing (.bash vs .ps1) |
| `IDE` | AI inference | `cursor` | MCP config path, IDE-specific tools |
| `PACKAGE_MANAGERS` | Script output | `npm,docker,terraform` | Available toolchain |
| `TECH_STACK` | Script output | `typescript,dotnet,terraform` | Workflow suggestion, KB loading |

## Script Routing

After detection, all subsequent scripts in the workflow use:
- `SHELL_TYPE=bash` --> run `.bash` / `.sh` scripts
- `SHELL_TYPE=powershell` --> run `.ps1` scripts

## Tech Stack Detection Rules

The scripts scan workspace source repos for these markers:

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

## Downstream Usage

- **Workflow selection**: `TECH_STACK` helps suggest the best-matching workflow
- **KB loading**: `TECH_STACK` auto-selects which engineering standards to load from `$KB_PATH/knowledge/shared/engineering-standards/`
- **MCP check**: `IDE` determines which MCP config file to read (`.cursor/mcp.json` vs `.vscode/mcp.json`)
