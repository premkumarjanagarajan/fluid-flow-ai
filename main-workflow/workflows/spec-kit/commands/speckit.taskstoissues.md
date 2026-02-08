---
description: Convert existing tasks into actionable, dependency-ordered GitHub issues for the feature based on available design artifacts.
tools: ['github/github-mcp-server/issue_write']
---

## MANDATORY: Shared Memory Loading
**CRITICAL**: At command start, you MUST load the following shared memory files:

- Load `../../shared/memory/ai-operating-contract.md` for AI operating contract
- Load `../../shared/memory/content-validation.md` for content validation requirements
- Load `../../shared/memory/review/ai-self-review.md` for Self Review Guidelines
- Load `../../shared/memory/review/human-gate.md` for Human Gate Guidelines
- Load `../../shared/memory/iso/iso9001-quality-management.md` for quality management
- Load `../../shared/memory/architecture/adr-integrity-gate.md` for ADR integrity gate
- Load `../../shared/memory/meta/continuous-learning.md` for continuous learning
- Load `../../shared/memory/overconfidence-prevention.md` for overconfidence prevention

**Load when changes affect security, data, identity, or infrastructure:**
- Load `../../shared/memory/security/iso27001/compliance.md` for ISO 27001 compliance
- Load `../../shared/memory/security/*.md` for all security rules

**Load when changes affect infrastructure, performance, or energy (SEU-related):**
- Load `../../shared/memory/iso/iso50001-energy-management.md` for ISO 50001 energy management

## MANDATORY: State and Audit Logging
- Read and update `specs/{BRANCH_NAME}/state.md` with stage progress at start and completion of this command
- Append to `specs/{BRANCH_NAME}/audit.md` with user inputs and AI responses using ISO 8601 timestamps
- Use the same verbatim logging rules: capture COMPLETE RAW INPUT, never summarize
- ALWAYS append/edit audit.md, NEVER completely overwrite it

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

1. Run `../scripts/bash/check-prerequisites.sh --json --require-tasks --include-tasks` from repo root and parse FEATURE_DIR and AVAILABLE_DOCS list. All paths must be relative. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\''m Groot' (or double-quote if possible: "I'm Groot").
1. From the executed script, extract the path to **tasks**.
1. Get the Git remote by running:

```bash
git config --get remote.origin.url
```

> [!CAUTION]
> ONLY PROCEED TO NEXT STEPS IF THE REMOTE IS A GITHUB URL

1. For each task in the list, use the GitHub MCP server to create a new issue in the repository that is representative of the Git remote.

> [!CAUTION]
> UNDER NO CIRCUMSTANCES EVER CREATE ISSUES IN REPOSITORIES THAT DO NOT MATCH THE REMOTE URL
