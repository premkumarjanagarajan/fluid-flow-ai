# AI-DLC CLI - Quick Reference Card

## Installation

```bash
# Build and install globally
dotnet pack src/AIDLC-CLI/AIDLC-CLI.csproj -o ./packages
dotnet tool install --global --add-source ./packages BetssonGroup.AiDlc.Cli
```

## Basic Commands

| Command | Description |
|---------|-------------|
| `aidlc install` | Install workflow (all IDEs) |
| `aidlc update` | Update workflow |
| `aidlc validate` | Validate installation |
| `aidlc status` | Show status |
| `aidlc --help` | Show help |

## Multi-IDE Support

### Supported IDEs
- `cursor` - Cursor AI IDE
- `github-copilot` - VS Code with GitHub Copilot
- `vscode` - VS Code with other AI extensions

### Default Behavior
**Installs for ALL IDEs** if `--ide` not specified

```bash
aidlc install
# Creates: .cursor/rules/, .github/copilot/rules/, .vscode/rules/
```

### Specific IDE(s)

```bash
# Single IDE
aidlc install --ide cursor

# Multiple IDEs
aidlc install --ide cursor --ide github-copilot

# Short form
aidlc install -i cursor -i github-copilot
```

## Common Workflows

### Single Repository

```bash
# Install for all IDEs (recommended)
cd /path/to/repo
aidlc install
aidlc validate

# Install for specific IDE
cd /path/to/repo
aidlc install --ide cursor
aidlc validate
```

### Multiple Repositories

```bash
# Create repository list
cat > repos.txt << EOF
/path/to/repo1
/path/to/repo2
/path/to/repo3
EOF

# Install for all IDEs
aidlc batch-install --file repos.txt

# Install for specific IDE
aidlc batch-install --file repos.txt --ide cursor
```

### Update Workflow

```bash
# Update all previously installed IDEs
aidlc update

# Update specific IDE
aidlc update --ide cursor

# Add new IDE to existing installation
aidlc update --ide cursor --ide github-copilot
```

## Options Reference

### Install Command
```bash
aidlc install [options]

Options:
  -p, --path <path>   Repository path (default: current directory)
  -f, --force         Force reinstall
  -i, --ide <ide>     Target IDE(s) (default: all)
  -h, --help          Show help
```

### Update Command
```bash
aidlc update [options]

Options:
  -p, --path <path>   Repository path (default: current directory)
  -i, --ide <ide>     Target IDE(s) (default: previously installed)
  -h, --help          Show help
```

### Validate Command
```bash
aidlc validate [options]

Options:
  -p, --path <path>   Repository path (default: current directory)
  -h, --help          Show help
```

### Status Command
```bash
aidlc status [options]

Options:
  -p, --path <path>   Repository path (default: current directory)
  -h, --help          Show help
```

### Batch Install Command
```bash
aidlc batch-install [options]

Options:
  -f, --file <file>   Repository list file (required)
  --force             Force reinstall
  -i, --ide <ide>     Target IDE(s) (default: all)
  -h, --help          Show help
```

## Directory Structure

### After Installation (All IDEs)
```
your-repository/
├── .cursor/rules/              # Cursor
│   ├── aidlc-rules.md
│   ├── common/
│   ├── inception/
│   ├── construction/
│   └── security/
├── .github/copilot/rules/      # GitHub Copilot
│   └── (same structure)
├── .vscode/rules/              # VS Code
│   └── (same structure)
└── .aidlc-config.json
```

### Configuration File
```json
{
  "Version": "1.0.0",
  "InstalledDate": "2026-02-06T10:30:00Z",
  "InstalledIdes": ["cursor", "github-copilot", "vscode"],
  "RepositoryPath": "/path/to/repository"
}
```

## Use Case Examples

### Mixed Team (Recommended)
```bash
# Install for all IDEs - everyone can use their preferred IDE
aidlc install
```

### Cursor-Only Team
```bash
# Install only for Cursor
aidlc install --ide cursor
```

### Adding IDE Support Later
```bash
# Initially: Cursor only
aidlc install --ide cursor

# Later: Add Copilot support
aidlc update --ide cursor --ide github-copilot
```

### Organization-Wide Rollout
```bash
# Generate repository list
find /path/to/repos -name ".git" -type d | sed 's/\/.git$//' > all-repos.txt

# Install for all IDEs
aidlc batch-install --file all-repos.txt

# Or install for specific IDE
aidlc batch-install --file all-repos.txt --ide cursor
```

## Validation Output

```
✓ Git repository detected
✓ AI-DLC workflow installed
✓ Configuration valid (Version: 1.0.0)

Validating cursor installation:
  ✓ Main rule file found
  ✓ Directory found: common
  ✓ Directory found: inception
  ✓ Directory found: construction
  ✓ Directory found: security

Validating github-copilot installation:
  ✓ Main rule file found
  ✓ Directory found: common
  ...

✓ Valid IDEs: cursor, github-copilot, vscode
```

## Status Output

```
AI-DLC Workflow Status for: /path/to/repo
------------------------------------------------------------
Repository Root: /path/to/repo
Current Branch: main
Remote URL: https://github.com/org/repo.git

Status: Installed ✓
Version: 1.0.0
Installed: 2026-02-06 10:30:00 UTC
Installed IDEs: cursor, github-copilot, vscode
  - cursor: 45 rule files in .cursor/rules
  - github-copilot: 45 rule files in .github/copilot/rules
  - vscode: 45 rule files in .vscode/rules
```

## Troubleshooting

### Issue: Workflow not found by IDE
```bash
# Check status
aidlc status

# Validate installation
aidlc validate

# Reinstall if needed
aidlc install --force
```

### Issue: Wrong IDE installed
```bash
# Update to correct IDE
aidlc update --ide cursor

# Or reinstall
aidlc install --force --ide cursor
```

### Issue: Need to add IDE support
```bash
# Add new IDE to existing installation
aidlc update --ide cursor --ide github-copilot --ide vscode
```

## Best Practices

1. **Default to All IDEs**: Use default installation for maximum team flexibility
2. **Keep IDEs in Sync**: Update all IDEs together
3. **Validate After Install**: Always run `validate` after installation
4. **Document Your Choice**: If using specific IDEs only, document in README
5. **Test Before Rollout**: Try on a few repos before organization-wide deployment

## Documentation Links

- [Full README](README.md)
- [Quick Start Guide](QUICKSTART.md)
- [Multi-IDE Support Guide](MULTI-IDE-SUPPORT.md)
- [Deployment Guide](DEPLOYMENT-GUIDE.md)
- [Architecture](ARCHITECTURE.md)

## Support

For issues or questions:
- Check documentation
- Run `aidlc --help`
- Run `aidlc <command> --help`
- Contact AI-DLC team

---

**Quick Tip**: When in doubt, use the default installation (`aidlc install`) - it supports all IDEs and provides maximum flexibility for your team!
