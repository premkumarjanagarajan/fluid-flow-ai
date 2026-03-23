# Shell Detection

Detect the user's OS and shell to route script execution for the session.

## How to Run

1. Try `skills/shell-detection/scripts/shell-detection.bash` first
2. If it fails (not found, permission denied, or error), try `skills/shell-detection/scripts/shell-detection.ps1`
3. Parse the output and store `SHELL_TYPE` and `OS` for the session

## Output Format

Both scripts output a single line:

```
SHELL_TYPE={bash|powershell} OS={darwin|linux|windows}
```

## Interpretation

| SHELL_TYPE | OS | Meaning |
|------------|------|---------|
| `bash` | `darwin` | macOS -- bash/zsh available |
| `bash` | `linux` | Linux -- bash available |
| `bash` | `windows` | Windows with Git Bash / MSYS2 / Cygwin |
| `powershell` | `windows` | Native Windows -- use .ps1 scripts |

## Script Routing

After detection, all subsequent scripts in the workflow use:
- `SHELL_TYPE=bash` --> run `.bash` / `.sh` scripts
- `SHELL_TYPE=powershell` --> run `.ps1` scripts
