# Multi-IDE Support Guide

The AI-DLC CLI tool supports multiple AI coding assistants, allowing teams to use their preferred IDE while maintaining a consistent workflow.

## Supported IDEs

The tool supports three AI coding environments:

| IDE | Identifier | Directory | Description |
|-----|------------|-----------|-------------|
| **Cursor** | `cursor` | `.cursor/rules/` | Cursor AI IDE |
| **GitHub Copilot** | `github-copilot` | `.github/copilot/rules/` | VS Code with GitHub Copilot |
| **VS Code** | `vscode` | `.vscode/rules/` | VS Code with other AI extensions |

## Default Behavior

**By default, the tool installs the workflow for ALL IDEs**, ensuring that every developer on your team can use the AI-DLC workflow regardless of their IDE choice.

```bash
# Installs for cursor, github-copilot, and vscode
aidlc install
```

This creates:
```
your-repository/
├── .cursor/rules/           # For Cursor users
├── .github/copilot/rules/   # For GitHub Copilot users
└── .vscode/rules/           # For VS Code users
```

## Targeting Specific IDEs

You can install for specific IDEs only using the `--ide` option:

### Single IDE

```bash
# Install only for Cursor
aidlc install --ide cursor

# Install only for GitHub Copilot
aidlc install --ide github-copilot

# Install only for VS Code
aidlc install --ide vscode
```

### Multiple IDEs

```bash
# Install for Cursor and GitHub Copilot
aidlc install --ide cursor --ide github-copilot

# Or using short form
aidlc install -i cursor -i github-copilot
```

## Use Cases

### Scenario 1: Mixed Team (Recommended)

**Situation**: Your team has developers using both Cursor and VS Code with Copilot.

**Solution**: Install for all IDEs (default behavior)

```bash
# Install for all IDEs
aidlc install

# Result: Everyone can use the workflow
```

### Scenario 2: Cursor-Only Team

**Situation**: Your entire team uses Cursor.

**Solution**: Install only for Cursor to keep the repository clean

```bash
# Install only for Cursor
aidlc install --ide cursor

# Result: Only .cursor/ directory is created
```

### Scenario 3: Gradual Migration

**Situation**: You're migrating from VS Code to Cursor, but some developers haven't switched yet.

**Solution**: Install for both IDEs during the transition

```bash
# Support both during migration
aidlc install --ide cursor --ide vscode

# Later, when everyone has migrated, you can remove VS Code support
```

### Scenario 4: Adding IDE Support Later

**Situation**: You initially installed for Cursor only, but now some developers want to use Copilot.

**Solution**: Update to add GitHub Copilot support

```bash
# Add GitHub Copilot support
aidlc update --ide github-copilot

# Or add both Cursor and Copilot
aidlc update --ide cursor --ide github-copilot
```

## Batch Installation with IDE Selection

When installing across multiple repositories, you can specify which IDEs to target:

```bash
# Install for all IDEs (default)
aidlc batch-install --file repos.txt

# Install only for Cursor across all repos
aidlc batch-install --file repos.txt --ide cursor

# Install for Cursor and Copilot
aidlc batch-install --file repos.txt --ide cursor --ide github-copilot
```

## Validation

The validation command checks all installed IDEs:

```bash
aidlc validate

# Output shows validation for each IDE:
# Validating cursor installation:
#   ✓ Main rule file found
#   ✓ Directory found: common
#   ...
# Validating github-copilot installation:
#   ✓ Main rule file found
#   ✓ Directory found: common
#   ...
```

## Status Check

The status command shows which IDEs are configured:

```bash
aidlc status

# Output includes:
# Status: Installed ✓
# Version: 1.0.0
# Installed IDEs: cursor, github-copilot, vscode
#   - cursor: 45 rule files in .cursor/rules
#   - github-copilot: 45 rule files in .github/copilot/rules
#   - vscode: 45 rule files in .vscode/rules
```

## Update Behavior

The update command respects previously installed IDEs:

```bash
# Updates all previously installed IDEs
aidlc update

# Updates only specific IDEs
aidlc update --ide cursor

# Adds a new IDE to existing installation
aidlc update --ide cursor --ide github-copilot --ide vscode
```

## Configuration File

The `.aidlc-config.json` file tracks which IDEs are installed:

```json
{
  "Version": "1.0.0",
  "InstalledDate": "2026-02-06T10:30:00Z",
  "LastUpdatedDate": null,
  "RepositoryPath": "/path/to/repository",
  "InstalledIdes": ["cursor", "github-copilot", "vscode"],
  "CustomOptions": {}
}
```

## Best Practices

### 1. Default to All IDEs

Unless you have a specific reason not to, install for all IDEs:

```bash
# ✅ Good: Everyone can use the workflow
aidlc install

# ❌ Avoid: Limits team flexibility
aidlc install --ide cursor
```

**Why?** It ensures maximum flexibility and doesn't require developers to change their IDE preferences.

### 2. Keep IDEs in Sync

When updating, update all installed IDEs:

```bash
# ✅ Good: All IDEs get the latest workflow
aidlc update

# ❌ Avoid: Creates inconsistency
aidlc update --ide cursor  # Only updates Cursor, others are outdated
```

### 3. Document Your Choice

If you choose to support specific IDEs only, document it in your repository:

```markdown
# README.md

## AI Development Workflow

This repository uses the AI-DLC workflow with:
- ✅ Cursor (`.cursor/rules/`)
- ✅ GitHub Copilot (`.github/copilot/rules/`)

To use the workflow, configure your IDE to use the appropriate rules directory.
```

### 4. Consider .gitignore

You might want to add IDE-specific files to `.gitignore` while keeping the rules:

```gitignore
# .gitignore

# IDE workspace files (but keep rules)
.cursor/*
!.cursor/rules/

.github/*
!.github/copilot/

.vscode/*
!.vscode/rules/
```

## Migration Strategies

### From Single IDE to Multi-IDE

If you currently support only one IDE and want to add others:

```bash
# Check current status
aidlc status

# Add support for additional IDEs
aidlc update --ide cursor --ide github-copilot --ide vscode

# Validate
aidlc validate
```

### From Multi-IDE to Single IDE

If you want to standardize on one IDE:

1. **Communicate the change** to your team
2. **Update to single IDE**:
   ```bash
   aidlc update --ide cursor
   ```
3. **Manually remove old IDE directories** (optional):
   ```bash
   rm -rf .github/copilot
   rm -rf .vscode
   ```

## Troubleshooting

### Issue: IDE Not Recognized

**Error**: `Warning: Unknown IDE 'my-ide', skipping...`

**Solution**: Use one of the supported identifiers: `cursor`, `github-copilot`, or `vscode`

```bash
# ✅ Correct
aidlc install --ide cursor

# ❌ Incorrect
aidlc install --ide my-ide
```

### Issue: Workflow Not Found by IDE

**Problem**: IDE doesn't see the workflow rules

**Solution**: Verify the correct directory was created

```bash
# Check status
aidlc status

# Validate installation
aidlc validate

# Check directory structure
ls -la .cursor/rules/
ls -la .github/copilot/rules/
ls -la .vscode/rules/
```

### Issue: Mixed Versions

**Problem**: Different IDEs have different workflow versions

**Solution**: Update all IDEs to sync versions

```bash
# Update all IDEs
aidlc update

# Or force reinstall
aidlc install --force
```

## Examples

### Example 1: Organization-Wide Rollout

```bash
# Create repository list
cat > repos.txt << EOF
/repos/team-a/service-1
/repos/team-a/service-2
/repos/team-b/api-gateway
EOF

# Install for all IDEs (default)
aidlc batch-install --file repos.txt

# Result: All repos support all IDEs
```

### Example 2: Cursor-Only Rollout

```bash
# Install only for Cursor across all repos
aidlc batch-install --file repos.txt --ide cursor

# Result: Only .cursor/ directories created
```

### Example 3: Adding Copilot Support Later

```bash
# Initially installed for Cursor only
aidlc install --ide cursor

# Later, add Copilot support
aidlc update --ide cursor --ide github-copilot

# Result: Both .cursor/ and .github/copilot/ exist
```

### Example 4: Check What's Installed

```bash
# Check a single repository
cd /path/to/repo
aidlc status

# Check multiple repositories
for repo in $(cat repos.txt); do
    echo "=== $repo ==="
    aidlc status --path "$repo"
done
```

## IDE-Specific Considerations

### Cursor

- **Directory**: `.cursor/rules/`
- **Format**: Markdown files (`.md`)
- **Note**: Cursor natively supports rules in this directory

### GitHub Copilot

- **Directory**: `.github/copilot/rules/`
- **Format**: Markdown files (`.md`)
- **Note**: GitHub Copilot uses custom instructions from this directory

### VS Code

- **Directory**: `.vscode/rules/`
- **Format**: Markdown files (`.md`)
- **Note**: Compatible with various VS Code AI extensions

## Summary

- **Default**: Installs for all IDEs (recommended for maximum flexibility)
- **Specific**: Use `--ide` option to target specific IDEs
- **Update**: Respects previously installed IDEs unless specified
- **Validate**: Checks all installed IDEs
- **Status**: Shows which IDEs are configured

The multi-IDE support ensures that your AI-DLC workflow can be used by all developers regardless of their IDE preference, while still allowing teams to standardize on specific tools if desired.
