# AI-DLC CLI Tool

A .NET command-line tool for managing the AI Development Lifecycle (AI-DLC) workflow across multiple repositories in your organization.

## Overview

The AI-DLC CLI tool helps you install, update, validate, and manage the AI-DLC workflow across thousands of Git repositories. It automates the deployment of workflow rules, documentation, and configuration files to ensure consistent AI-assisted development practices across your organization.

## Features

- **Install**: Deploy AI-DLC workflow to any Git repository
- **Multi-IDE Support**: Supports Cursor, GitHub Copilot, and VS Code
- **Update**: Update existing workflow installations with new versions
- **Validate**: Verify workflow installation integrity
- **Status**: Check workflow installation status and configuration
- **Batch Install**: Install workflow across multiple repositories at once

## Installation

### Install as a Global Tool

```bash
# Install from local package
dotnet pack src/AIDLC-CLI/AIDLC-CLI.csproj -o ./packages
dotnet tool install --global --add-source ./packages BetssonGroup.AiDlc.Cli

# Or install from NuGet (when published)
dotnet tool install --global BetssonGroup.AiDlc.Cli
```

### Build from Source

```bash
# Clone the repository
git clone <repository-url>
cd betssongroup-aidlc-workflow

# Build the solution
dotnet build src/AIDLC-CLI.sln

# Run the tool
dotnet run --project src/AIDLC-CLI/AIDLC-CLI.csproj -- <command>
```

## Usage

### Install Workflow in a Repository

Install the AI-DLC workflow in the current directory (installs for all IDEs by default):

```bash
aidlc install
```

Install in a specific repository:

```bash
aidlc install --path /path/to/repository
```

Install for specific IDE(s):

```bash
# Install only for Cursor
aidlc install --ide cursor

# Install for Cursor and GitHub Copilot
aidlc install --ide cursor --ide github-copilot

# Install for all IDEs (default)
aidlc install --ide cursor --ide github-copilot --ide vscode
```

Force reinstall (overwrite existing installation):

```bash
aidlc install --force
```

**Supported IDEs**: `cursor`, `github-copilot`, `vscode`

### Update Workflow

Update the workflow in the current directory (updates all previously installed IDEs):

```bash
aidlc update
```

Update in a specific repository:

```bash
aidlc update --path /path/to/repository
```

Update specific IDE(s):

```bash
# Update only Cursor
aidlc update --ide cursor

# Update Cursor and GitHub Copilot
aidlc update --ide cursor --ide github-copilot
```

### Validate Workflow Installation

Validate the workflow in the current directory:

```bash
aidlc validate
```

Validate in a specific repository:

```bash
aidlc validate --path /path/to/repository
```

### Check Workflow Status

Check status in the current directory:

```bash
aidlc status
```

Check status in a specific repository:

```bash
aidlc status --path /path/to/repository
```

### Batch Install Across Multiple Repositories

Create a text file with repository paths (one per line):

```text
# repos.txt
/Users/username/projects/repo1
/Users/username/projects/repo2
/Users/username/projects/repo3
```

Run batch installation (installs for all IDEs by default):

```bash
aidlc batch-install --file repos.txt
```

Install for specific IDE(s):

```bash
# Install only for Cursor across all repos
aidlc batch-install --file repos.txt --ide cursor

# Install for Cursor and Copilot
aidlc batch-install --file repos.txt --ide cursor --ide github-copilot
```

Force reinstall for all repositories:

```bash
aidlc batch-install --file repos.txt --force
```

## What Gets Installed

When you install the AI-DLC workflow, the tool creates workflow files for all supported IDEs by default:

```
your-repository/
├── .cursor/rules/                   # For Cursor users
│   ├── aidlc-rules.md
│   ├── common/
│   ├── inception/
│   ├── construction/
│   ├── security/
│   └── ...
├── .github/copilot/rules/           # For GitHub Copilot users
│   ├── aidlc-rules.md
│   ├── common/
│   └── ...
├── .vscode/rules/                   # For VS Code users
│   ├── aidlc-rules.md
│   ├── common/
│   └── ...
└── .aidlc-config.json              # Workflow configuration
```

**Multi-IDE Support**: By default, the tool installs for all IDEs (Cursor, GitHub Copilot, VS Code), ensuring all team members can use the workflow regardless of their IDE preference. You can target specific IDEs using the `--ide` option.

## Configuration File

The `.aidlc-config.json` file tracks the workflow installation:

```json
{
  "Version": "1.0.0",
  "InstalledDate": "2026-02-06T10:30:00Z",
  "LastUpdatedDate": null,
  "RepositoryPath": "/path/to/repository",
  "CustomOptions": {}
}
```

## Workflow Structure

The AI-DLC workflow consists of three main phases:

1. **Inception Phase** (🔵): Planning, requirements gathering, and architectural decisions
   - Workspace Detection
   - Reverse Engineering (for existing codebases)
   - Requirements Analysis
   - User Stories
   - Workflow Planning
   - Application Design
   - Units Generation

2. **Construction Phase** (🟢): Detailed design and implementation
   - Functional Design
   - NFR Requirements
   - NFR Design
   - Infrastructure Design
   - Code Generation
   - Build and Test

3. **Operations Phase** (🟡): Deployment and monitoring (placeholder for future expansion)

## Examples

### Single Repository Installation

```bash
# Navigate to your repository
cd /path/to/your/repository

# Install the workflow
aidlc install

# Verify installation
aidlc validate

# Check status
aidlc status
```

### Organization-Wide Rollout

```bash
# Create a list of all repositories
cat > all-repos.txt << EOF
/repos/team-a/service-1
/repos/team-a/service-2
/repos/team-b/api-gateway
/repos/team-b/frontend
/repos/team-c/data-pipeline
EOF

# Install workflow in all repositories
aidlc batch-install --file all-repos.txt

# The tool will show progress for each repository
```

### Update Existing Installations

```bash
# Update a single repository
cd /path/to/repository
aidlc update

# Or update with explicit path
aidlc update --path /path/to/repository
```

## Validation

The validation command checks:

- ✓ Git repository detection
- ✓ Workflow installation status
- ✓ Configuration file validity
- ✓ Main rule file presence
- ✓ Required directory structure
- ✓ Key workflow components

Example output:

```
Validating AI-DLC workflow in /path/to/repository...
✓ Git repository detected
✓ AI-DLC workflow installed
✓ Configuration valid (Version: 1.0.0)
  - Installed: 2026-02-06 10:30:00 UTC
✓ Main rule file found
✓ Directory found: common
✓ Directory found: inception
✓ Directory found: construction
✓ Directory found: security
```

## Troubleshooting

### Workflow Not Found

If you see "Could not find workflow directory", ensure:
- You're running from the correct location
- The `workflow/` directory exists in the repository root
- The workflow files are properly structured

### Permission Issues

If you encounter permission errors:
- Ensure you have write access to the target repository
- Check that the repository is not locked by another process

### Git Repository Not Detected

The tool requires a valid Git repository:
- Initialize Git if needed: `git init`
- Ensure `.git` directory exists
- Check that you're in the correct directory

## Development

### Running Tests

```bash
# Run all tests
dotnet test src/AIDLC-CLI.Tests/AIDLC-CLI.Tests.csproj

# Run with verbose output
dotnet test src/AIDLC-CLI.Tests/AIDLC-CLI.Tests.csproj --verbosity detailed
```

### Building the Package

```bash
# Build the package
dotnet pack src/AIDLC-CLI/AIDLC-CLI.csproj -o ./packages

# Install locally for testing
dotnet tool install --global --add-source ./packages BetssonGroup.AiDlc.Cli
```

### Project Structure

```
src/
├── AIDLC-CLI/
│   ├── Models/
│   │   └── WorkflowConfig.cs       # Configuration model
│   ├── Services/
│   │   ├── GitService.cs           # Git operations
│   │   └── WorkflowService.cs      # Workflow management
│   ├── Program.cs                  # CLI entry point
│   └── AIDLC-CLI.csproj            # Project file
└── AIDLC-CLI.Tests/
    ├── Models/
    ├── Services/
    └── AIDLC-CLI.Tests.csproj      # Test project
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

Copyright © 2026 Betsson Group. All rights reserved.

## Support

For issues, questions, or contributions, please contact the AI-DLC team or create an issue in the repository.

## Roadmap

- [ ] Support for custom workflow templates
- [ ] Integration with CI/CD pipelines
- [ ] Workflow version migration tools
- [ ] Repository discovery and auto-detection
- [ ] Web dashboard for tracking installations
- [ ] Slack/Teams notifications for batch operations
- [ ] Rollback functionality
- [ ] Workflow customization per repository type
