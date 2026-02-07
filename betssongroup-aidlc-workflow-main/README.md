# Betsson Group AI-DLC Workflow

**AI Development Lifecycle (AI-DLC) Workflow Management System**

A comprehensive workflow framework and CLI tool for managing AI-assisted software development across your organization.

---

## 📑 Table of Contents

- [Overview](#-overview)
- [Quick Start](#-quick-start)
- [Features](#-features)
- [Installation](#-installation)
- [Multi-IDE Support](#-multi-ide-support)
- [CLI Commands](#-cli-commands)
- [Use Cases & Examples](#-use-cases--examples)
- [Workflow Structure](#-workflow-structure)
- [Deployment Strategy](#-deployment-strategy)
- [What Gets Installed](#-what-gets-installed)
- [Configuration](#-configuration)
- [Testing](#-testing)
- [Troubleshooting](#-troubleshooting)
- [Architecture](#-architecture)
- [Contributing](#-contributing)
- [Support](#-support)

---

## 🎯 Overview

The AI-DLC (AI Development Lifecycle) workflow provides a structured, standardized approach to AI-assisted software development. This repository contains:

### 1. **Workflow Blueprint** (`workflow/`)
Comprehensive rules and guidelines covering:
- **Inception Phase**: Requirements, design, and planning
- **Construction Phase**: Implementation, testing, and validation
- **Operations Phase**: Deployment and monitoring (planned)
- **Security & Compliance**: ISO 27001, ISO 9001, ISO 50001
- **Technology-Specific Rules**: C#, .NET, Terraform

### 2. **CLI Tool** (`src/AIDLC-CLI/`)
A powerful .NET CLI tool for managing workflows:
- ✅ Install workflow in any Git repository
- ✅ **Multi-IDE support** (Cursor, GitHub Copilot, VS Code)
- ✅ Update existing installations
- ✅ Validate workflow integrity
- ✅ Check installation status
- ✅ Batch operations across multiple repositories

### 3. **Documentation & Examples**
- Complete CLI documentation
- Multi-IDE support guide
- Example scripts for batch operations
- Deployment strategies

---

## 🚀 Quick Start

Get started in 5 minutes:

```bash
# 1. Build and install the CLI tool
cd /path/to/betssongroup-aidlc-workflow
dotnet pack src/AIDLC-CLI/AIDLC-CLI.csproj -o ./packages
dotnet tool install --global --add-source ./packages BetssonGroup.AiDlc.Cli

# 2. Install workflow in your repository (installs for all IDEs by default)
cd /path/to/your/repository
aidlc install

# 3. Verify installation
aidlc validate

# 4. Check status
aidlc status
```

---

## ✨ Features

### Core Capabilities
- **Single Repository Management**: Install, update, validate workflows
- **Batch Operations**: Process multiple repositories at once
- **Multi-IDE Support**: Works with Cursor, GitHub Copilot, and VS Code
- **Git Integration**: Automatic repository detection
- **Version Tracking**: Track installation and update history
- **Validation**: Comprehensive integrity checks
- **Backup on Update**: Automatic backups before updates

### Enterprise Ready
- Comprehensive error handling
- Detailed logging and reporting
- Backward compatible
- Production tested

---

## 🔧 Installation

### Prerequisites

- .NET 8.0 SDK or later
- Git
- Access to target repositories

### Install CLI Tool

```bash
# Clone the repository
git clone <repository-url>
cd betssongroup-aidlc-workflow

# Build and pack
dotnet pack src/AIDLC-CLI/AIDLC-CLI.csproj -o ./packages

# Install globally
dotnet tool install --global --add-source ./packages BetssonGroup.AiDlc.Cli

# Verify installation
aidlc --help
```

### Uninstall

```bash
dotnet tool uninstall --global BetssonGroup.AiDlc.Cli
```

---

## 🎨 Multi-IDE Support

The CLI tool supports multiple AI coding assistants, allowing teams to use their preferred IDE.

### Supported IDEs

| IDE | Identifier | Directory | Description |
|-----|------------|-----------|-------------|
| **Cursor** | `cursor` | `.cursor/rules/` | Cursor AI IDE |
| **GitHub Copilot** | `github-copilot` | `.github/copilot/rules/` | VS Code with GitHub Copilot |
| **VS Code** | `vscode` | `.vscode/rules/` | VS Code with other AI extensions |

### Default Behavior

**By default, the tool installs for ALL IDEs**, ensuring maximum team flexibility:

```bash
# Installs for cursor, github-copilot, and vscode
aidlc install
```

### Target Specific IDEs

```bash
# Install only for Cursor
aidlc install --ide cursor

# Install for Cursor and GitHub Copilot
aidlc install --ide cursor --ide github-copilot

# Short form
aidlc install -i cursor -i github-copilot
```

### Multi-IDE Examples

```bash
# Mixed team (recommended) - install for all IDEs
aidlc install

# Cursor-only team
aidlc install --ide cursor

# Add IDE support later
aidlc update --ide cursor --ide github-copilot

# Batch install for specific IDE
aidlc batch-install --file repos.txt --ide cursor
```

---

## 📋 CLI Commands

### Install Command

Install AI-DLC workflow in a repository.

```bash
# Install in current directory (all IDEs)
aidlc install

# Install in specific repository
aidlc install --path /path/to/repository

# Install for specific IDE(s)
aidlc install --ide cursor
aidlc install --ide cursor --ide github-copilot

# Force reinstall
aidlc install --force
```

**Options:**
- `-p, --path <path>` - Repository path (default: current directory)
- `-f, --force` - Force reinstall even if already installed
- `-i, --ide <ide>` - Target IDE(s): cursor, github-copilot, vscode (default: all)

### Update Command

Update existing workflow installation.

```bash
# Update all previously installed IDEs
aidlc update

# Update specific repository
aidlc update --path /path/to/repository

# Update specific IDE(s)
aidlc update --ide cursor
aidlc update --ide cursor --ide github-copilot
```

**Options:**
- `-p, --path <path>` - Repository path (default: current directory)
- `-i, --ide <ide>` - Target IDE(s) (default: previously installed)

### Validate Command

Validate workflow installation integrity.

```bash
# Validate current directory
aidlc validate

# Validate specific repository
aidlc validate --path /path/to/repository
```

**Options:**
- `-p, --path <path>` - Repository path (default: current directory)

**Exit Codes:**
- `0` - Valid installation
- `1` - Invalid installation

### Status Command

Show workflow status and configuration.

```bash
# Show status for current directory
aidlc status

# Show status for specific repository
aidlc status --path /path/to/repository
```

**Options:**
- `-p, --path <path>` - Repository path (default: current directory)

### Batch Install Command

Install workflow in multiple repositories.

```bash
# Create repository list
cat > repos.txt << EOF
/path/to/repo1
/path/to/repo2
/path/to/repo3
EOF

# Batch install (all IDEs)
aidlc batch-install --file repos.txt

# Batch install for specific IDE
aidlc batch-install --file repos.txt --ide cursor

# Force reinstall all
aidlc batch-install --file repos.txt --force
```

**Options:**
- `-f, --file <file>` - Repository list file (required)
- `--force` - Force reinstall even if already installed
- `-i, --ide <ide>` - Target IDE(s) (default: all)

**Repository List Format:**
```text
# repos.txt
# Lines starting with # are comments

/path/to/repo1
/path/to/repo2
/path/to/repo3
```

---

## 🎯 Use Cases & Examples

### Use Case 1: Single Repository

Perfect for trying out the workflow or onboarding individual projects.

```bash
cd /path/to/repository
aidlc install
aidlc validate
aidlc status
```

### Use Case 2: Team Onboarding

Install workflow across all repositories for a new team.

```bash
# Create team repository list
cat > team-repos.txt << EOF
/repos/team-a/service-1
/repos/team-a/service-2
/repos/team-a/frontend
/repos/team-a/backend
EOF

# Install in all team repositories
aidlc batch-install --file team-repos.txt

# Validate all installations
for repo in $(cat team-repos.txt); do
    aidlc validate --path "$repo"
done
```

### Use Case 3: Organization-Wide Rollout

Deploy across all your repositories.

```bash
# Generate complete repository list
find /path/to/all/repos -name ".git" -type d | sed 's/\/.git$//' > all-repos.txt

# Review the list
wc -l all-repos.txt
head -20 all-repos.txt

# Start with pilot group (first 10)
head -10 all-repos.txt > pilot-repos.txt
aidlc batch-install --file pilot-repos.txt

# After pilot success, deploy to all
aidlc batch-install --file all-repos.txt
```

### Use Case 4: Mixed IDE Team

Team has developers using both Cursor and VS Code with Copilot.

```bash
# Install for all IDEs (recommended)
aidlc batch-install --file repos.txt

# Result: Everyone can use their preferred IDE
```

### Use Case 5: Cursor-Only Team

Entire team uses Cursor, keep repository clean.

```bash
# Install only for Cursor
aidlc batch-install --file repos.txt --ide cursor

# Result: Only .cursor/ directory created
```

### Use Case 6: Adding IDE Support

Initially installed for one IDE, need to add another.

```bash
# Check current status
aidlc status

# Add GitHub Copilot support
aidlc update --ide cursor --ide github-copilot

# Validate
aidlc validate
```

### Use Case 7: Validation Across Repositories

Check workflow status across multiple repositories.

```bash
# Create validation script
cat > check-all.sh << 'EOF'
#!/bin/bash
while IFS= read -r repo; do
    echo "=== $repo ==="
    aidlc status --path "$repo"
    aidlc validate --path "$repo"
    echo ""
done < "$1"
EOF

chmod +x check-all.sh
./check-all.sh repos.txt
```

---

## 📖 Workflow Structure

The AI-DLC workflow consists of three main phases:

### 🔵 Inception Phase
**Purpose**: Planning, requirements gathering, and architectural decisions  
**Focus**: Determine WHAT to build and WHY

**Stages**:
- **Workspace Detection** (Always) - Detect project type and existing code
- **Reverse Engineering** (Brownfield) - Analyze existing codebase
- **Requirements Analysis** (Always) - Gather and document requirements
- **User Stories** (Conditional) - Create user stories for features
- **Workflow Planning** (Always) - Plan execution strategy
- **Application Design** (Conditional) - Design components and services
- **Units Generation** (Conditional) - Break down into work units

### 🟢 Construction Phase
**Purpose**: Detailed design, NFR implementation, and code generation  
**Focus**: Determine HOW to build it

**Stages** (per unit):
- **Functional Design** (Conditional) - Design data models and business logic
- **NFR Requirements** (Conditional) - Assess non-functional requirements
- **NFR Design** (Conditional) - Design NFR implementation patterns
- **Infrastructure Design** (Conditional) - Design cloud resources
- **Code Generation** (Always) - Generate code and tests
- **Onboarding Update** (Conditional) - Update documentation
- **Build and Test** (Always) - Build and test instructions

### 🟡 Operations Phase
**Purpose**: Deployment and monitoring  
**Focus**: How to DEPLOY and RUN it

**Status**: Planned for future expansion

---

## 🚢 Deployment Strategy

### Recommended 10-Week Rollout Plan

#### Week 1: Preparation
- Build and test CLI tool
- Create complete repository inventory
- Categorize repositories by team/priority
- Prepare communication materials

```bash
# Build tool
dotnet pack src/AIDLC-CLI/AIDLC-CLI.csproj -o ./packages
dotnet tool install --global --add-source ./packages BetssonGroup.AiDlc.Cli

# Create inventory
find /path/to/repos -name ".git" -type d | sed 's/\/.git$//' > inventory/all-repos.txt
wc -l inventory/all-repos.txt
```

#### Week 2: Pilot Deployment
- Select 10-20 pilot repositories
- Install workflow
- Gather feedback
- Make adjustments

```bash
# Create pilot list
head -20 inventory/all-repos.txt > inventory/pilot-repos.txt

# Install
aidlc batch-install --file inventory/pilot-repos.txt

# Validate
./examples/validate-all.sh inventory/pilot-repos.txt
```

#### Weeks 3-6: Gradual Team Rollout
- Deploy team by team
- Monitor progress
- Address issues
- Collect feedback

```bash
# Week 3: Team A
aidlc batch-install --file inventory/team-a.txt

# Week 4: Team B
aidlc batch-install --file inventory/team-b.txt

# Continue for other teams...
```

#### Weeks 7-10: Full Organization Deployment
- Process remaining repositories in batches
- Handle failures and retries
- Complete validation
- Document lessons learned

```bash
# Process in batches of 200
split -l 200 inventory/remaining-repos.txt batch-

for batch in batch-*; do
    echo "Processing $batch..."
    aidlc batch-install --file "$batch"
    sleep 60
done
```

#### Ongoing: Maintenance
- Regular validation
- Update workflows
- Monitor adoption
- Continuous improvement

```bash
# Weekly validation
./examples/validate-all.sh inventory/all-repos.txt > reports/validation-$(date +%Y%m%d).txt
```

### Success Metrics

Track these metrics for successful deployment:

- **Installation Coverage**: 95%+ of repositories
- **Validation Success**: 90%+ valid installations
- **Support Tickets**: <5% of installations
- **Team Feedback**: Positive satisfaction scores
- **Workflow Consistency**: Measurable improvement

---

## 📊 What Gets Installed

When you install the workflow, the CLI tool creates workflow files for all supported IDEs by default:

```
your-repository/
├── .cursor/rules/                   # For Cursor users
│   ├── aidlc-rules.md              # Main workflow rules
│   ├── common/                      # Common components
│   │   ├── ai-operating-contract.md
│   │   ├── process-overview.md
│   │   ├── session-continuity.md
│   │   ├── architecture/
│   │   ├── review/
│   │   └── ...
│   ├── inception/                   # Inception phase rules
│   │   ├── workspace-detection.md
│   │   ├── requirements-analysis.md
│   │   ├── application-design.md
│   │   └── ...
│   ├── construction/                # Construction phase rules
│   │   ├── functional-design.md
│   │   ├── code-generation.md
│   │   ├── build-and-test.md
│   │   └── ...
│   ├── security/                    # Security guidelines
│   │   ├── threat-model.md
│   │   ├── authz-authn.md
│   │   ├── iso27001/
│   │   └── ...
│   ├── iso/                         # ISO compliance
│   │   ├── iso9001-quality-management.md
│   │   └── iso50001-energy-management.md
│   ├── operations/                  # Operations guidelines
│   ├── csharp/                      # C# specific rules
│   ├── dotnet/                      # .NET specific rules
│   └── terraform/                   # Terraform specific rules
│
├── .github/copilot/rules/           # For GitHub Copilot users
│   └── (same structure as above)
│
├── .vscode/rules/                   # For VS Code users
│   └── (same structure as above)
│
└── .aidlc-config.json              # Configuration file
```

### Configuration File (`.aidlc-config.json`)

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

---

## ⚙️ Configuration

### Repository List Format

Create a text file with repository paths (one per line):

```text
# repos.txt
# Lines starting with # are comments and will be ignored

# Team A repositories
/path/to/team-a/service-1
/path/to/team-a/service-2

# Team B repositories
/path/to/team-b/api-gateway
/path/to/team-b/frontend
```

### IDE Selection

Control which IDEs are configured:

```bash
# All IDEs (default - recommended)
aidlc install

# Specific IDE
aidlc install --ide cursor

# Multiple IDEs
aidlc install --ide cursor --ide github-copilot
```

### Validation Checks

The validation command checks:
- ✓ Git repository detection
- ✓ Workflow installation status
- ✓ Configuration file validity
- ✓ Main rule file presence
- ✓ Required directory structure
- ✓ IDE-specific installations

---

## 🧪 Testing

### Run Tests

```bash
# Run all tests
dotnet test src/AIDLC-CLI.Tests/AIDLC-CLI.Tests.csproj

# Run with detailed output
dotnet test src/AIDLC-CLI.Tests/AIDLC-CLI.Tests.csproj --verbosity detailed

# Run specific test
dotnet test --filter "FullyQualifiedName~GitServiceTests"
```

### Test Coverage

- ✅ 8/8 tests passing
- ✅ Model tests
- ✅ Git service tests
- ✅ Workflow service tests
- ✅ No warnings or errors

### Manual Testing

```bash
# Test on a sample repository
mkdir /tmp/test-repo
cd /tmp/test-repo
git init

# Install workflow
aidlc install

# Validate
aidlc validate

# Check status
aidlc status

# Cleanup
cd ..
rm -rf /tmp/test-repo
```

---

## 🔧 Troubleshooting

### Issue: Workflow Not Found

**Error**: `Could not find workflow directory`

**Solution**:
```bash
# Ensure you're in the correct location
pwd

# Rebuild and reinstall
dotnet pack src/AIDLC-CLI/AIDLC-CLI.csproj -o ./packages --force
dotnet tool uninstall --global BetssonGroup.AiDlc.Cli
dotnet tool install --global --add-source ./packages BetssonGroup.AiDlc.Cli
```

### Issue: Not a Git Repository

**Error**: `Not a Git repository`

**Solution**:
```bash
# Initialize Git if needed
cd /path/to/directory
git init

# Or verify you're in the correct directory
git status
```

### Issue: Permission Denied

**Error**: `Permission denied` when installing

**Solution**:
```bash
# Check permissions
ls -la /path/to/repository

# Fix permissions if needed
chmod -R u+w /path/to/repository
```

### Issue: IDE Not Recognized

**Error**: `Warning: Unknown IDE 'my-ide', skipping...`

**Solution**: Use supported IDE identifiers:
```bash
# ✅ Correct
aidlc install --ide cursor
aidlc install --ide github-copilot
aidlc install --ide vscode

# ❌ Incorrect
aidlc install --ide my-ide
```

### Issue: Workflow Not Found by IDE

**Problem**: IDE doesn't see the workflow rules

**Solution**:
```bash
# Check status
aidlc status

# Validate installation
aidlc validate

# Check directory structure
ls -la .cursor/rules/
ls -la .github/copilot/rules/
ls -la .vscode/rules/

# Reinstall if needed
aidlc install --force
```

### Issue: Mixed Versions

**Problem**: Different IDEs have different workflow versions

**Solution**:
```bash
# Update all IDEs to sync versions
aidlc update

# Or force reinstall
aidlc install --force
```

### Issue: Batch Installation Interrupted

**Problem**: Batch installation stopped midway

**Solution**:
```bash
# Find where it stopped
tail -50 installation-*.log

# Create list of remaining repos
tail -n +X repos.txt > remaining-repos.txt

# Resume installation
aidlc batch-install --file remaining-repos.txt
```

---

## 🏗️ Architecture

### Component Architecture

```
┌──────────────────────────────────────────────────────────────────┐
│                        CLI Application                           │
│                         (Program.cs)                             │
├──────────────────────────────────────────────────────────────────┤
│  Commands: install, update, validate, status, batch-install     │
├──────────────────────────────────────────────────────────────────┤
│  Services Layer:                                                 │
│  ┌──────────────────────────────────────────┐                   │
│  │ WorkflowService                          │                   │
│  │ - InstallWorkflow()                      │                   │
│  │ - UpdateWorkflow()                       │                   │
│  │ - ValidateWorkflow()                     │                   │
│  │ - ShowStatus()                           │                   │
│  └──────────────┬───────────────────────────┘                   │
│                 │ uses                                           │
│  ┌──────────────▼───────────────────────────┐                   │
│  │ GitService                               │                   │
│  │ - IsGitRepository()                      │                   │
│  │ - GetRepositoryRoot()                    │                   │
│  │ - GetCurrentBranch()                     │                   │
│  │ - GetRemoteUrl()                         │                   │
│  └──────────────────────────────────────────┘                   │
├──────────────────────────────────────────────────────────────────┤
│  Models: WorkflowConfig                                          │
└──────────────────────────────────────────────────────────────────┘
```

### Technology Stack

- **.NET 8.0**: Latest LTS version
- **System.CommandLine**: Modern CLI framework
- **System.Text.Json**: Configuration serialization
- **xUnit**: Testing framework
- **C# 12**: Latest language features

### Repository Structure

```
betssongroup-aidlc-workflow/
├── workflow/blueprint/          # Source of truth for workflow
│   ├── aidlc-rules.md
│   ├── common/
│   ├── inception/
│   ├── construction/
│   ├── security/
│   └── ...
│
├── src/                         # CLI tool source
│   ├── AIDLC-CLI/
│   │   ├── Program.cs
│   │   ├── Models/
│   │   │   └── WorkflowConfig.cs
│   │   └── Services/
│   │       ├── GitService.cs
│   │       └── WorkflowService.cs
│   ├── AIDLC-CLI.Tests/
│   │   ├── Models/
│   │   └── Services/
│   └── AIDLC-CLI.sln
│
├── examples/                    # Helper scripts
│   ├── batch-install.sh
│   ├── validate-all.sh
│   └── repos-example.txt
│
└── README.md                    # This file
```

---

## 🤝 Contributing

We welcome contributions to improve the AI-DLC workflow and CLI tool!

### How to Contribute

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make your changes**
   - Follow existing code style
   - Add tests for new functionality
   - Update documentation
4. **Run tests**
   ```bash
   dotnet test src/AIDLC-CLI.Tests/AIDLC-CLI.Tests.csproj
   ```
5. **Submit a pull request**
   - Describe your changes
   - Reference any related issues
   - Ensure all tests pass

### Development Setup

```bash
# Clone repository
git clone <repository-url>
cd betssongroup-aidlc-workflow

# Build solution
dotnet build src/AIDLC-CLI.sln

# Run tests
dotnet test src/AIDLC-CLI.Tests/AIDLC-CLI.Tests.csproj

# Run locally
dotnet run --project src/AIDLC-CLI/AIDLC-CLI.csproj -- --help
```

---

## 🆘 Support

### Documentation

- **This README**: Complete guide to the CLI tool
- **ARCHITECTURE.md**: Technical architecture details
- **MULTI-IDE-SUPPORT.md**: Detailed multi-IDE guide
- **QUICK-REFERENCE.md**: Quick command reference
- **src/README.md**: CLI tool documentation

### Getting Help

1. **Check Documentation**: Review this README and related docs
2. **Run Help Commands**:
   ```bash
   aidlc --help
   aidlc install --help
   aidlc update --help
   ```
3. **Create an Issue**: Report bugs or request features in this repository
4. **Contact Team**: Reach out to the AI-DLC team

### Common Questions

**Q: Which IDEs should I install for?**  
A: By default, install for all IDEs (`aidlc install`) to maximize team flexibility.

**Q: Can I add IDE support later?**  
A: Yes! Use `aidlc update --ide cursor --ide github-copilot --ide vscode`

**Q: How do I update the workflow?**  
A: Run `aidlc update` to update all previously installed IDEs.

**Q: Can I rollback an installation?**  
A: Updates create backups (`.cursor-backup-TIMESTAMP`). You can manually restore from backups.

**Q: How do I uninstall the workflow?**  
A: Manually delete `.cursor/`, `.github/copilot/`, `.vscode/` directories and `.aidlc-config.json`.

---

## 🗺️ Roadmap

### Completed ✅
- [x] Core CLI tool (install, update, validate, status)
- [x] Multi-IDE support (Cursor, GitHub Copilot, VS Code)
- [x] Batch installation support
- [x] Comprehensive workflow blueprint
- [x] Git repository integration
- [x] Configuration tracking
- [x] Validation and status reporting
- [x] Complete documentation

### Planned 🔮
- [ ] CI/CD pipeline integration
- [ ] Web dashboard for tracking installations
- [ ] Automated repository discovery
- [ ] Custom workflow templates
- [ ] Workflow customization per repository type
- [ ] Rollback functionality
- [ ] Slack/Teams notifications
- [ ] Auto-update mechanism
- [ ] Repository type detection
- [ ] Parallel batch processing

---

## 📝 License

Copyright © 2026 Betsson Group. All rights reserved.

---

## 🙏 Acknowledgments

Inspired by AWS AI Development Lifecycle practices and adapted for Betsson Group's needs.

Special thanks to all contributors and teams who provided feedback during development.

---

## 🎯 Quick Reference

### Essential Commands

```bash
# Install workflow (all IDEs)
aidlc install

# Install for specific IDE
aidlc install --ide cursor

# Update workflow
aidlc update

# Validate installation
aidlc validate

# Check status
aidlc status

# Batch install
aidlc batch-install --file repos.txt

# Get help
aidlc --help
aidlc install --help
```

### Example Scripts

```bash
# Batch installation with logging
./examples/batch-install.sh repos.txt

# Validate multiple repositories
./examples/validate-all.sh repos.txt
```

---

**Ready to get started?** Run `aidlc install` in your repository!

For questions or support, contact the AI-DLC team or create an issue in this repository.
