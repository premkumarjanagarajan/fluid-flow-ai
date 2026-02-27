# Changelog

All notable changes to Fluid Flow AI will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

---

## [0.1] - 2026-02-26 -- Alpha Release

### Added

- **Project Foundation** -- Initial project scaffold with AIDLC workflow, C4 architecture diagrams, and test coverage analysis *(2026-02-08)*
- **Unified Entry Point** -- Single entry point for all development work with branch creation, workspace detection, reverse engineering, and workflow routing *(2026-02-09)*
- **Spec-Kit Workflow** -- Lightweight specification-driven workflow with six commands: `/speckit.specify`, `/speckit.clarify`, `/speckit.plan`, `/speckit.tasks`, `/speckit.checklist`, `/speckit.implement` *(2026-02-09)*
- **AWS AI-DLC Workflow** -- Full Architecture Decision Lifecycle with Inception, Construction, and Operations phases *(2026-02-09)*
- **Shared Governance** -- AI Operating Contract, ISO 27001 security, ISO 9001 quality, ISO 50001 energy management compliance *(2026-02-09, [#1](../../pull/1))*
- **Documentation Suite** -- Getting Started, Architecture, Workflows, Commands, Governance, and Directory Structure docs *(2026-02-09, [#1](../../pull/1))*
- **Reverse Engineering** -- Automatic brownfield codebase analysis with C4 architecture modelling, component inventory, and artifact samples *(2026-02-11, [#4](../../pull/4))*
- **JIRA Integration** -- JIRA ticket prompt during branch creation and feature analytics initialisation *(2026-02-12, [#4](../../pull/4))*
- **Analytics Tracking** -- Per-feature analytics folder structure and initiative tracking *(2026-02-12, [#1](../../pull/1), [#2](../../pull/2))*
- **Per-Phase Analytics** -- Workflow analytics updated after every phase with finalised totals *(2026-02-16, [#3](../../pull/3))*
- **Per-Step Analytics** -- Granular per-step analytics updates for all Spec-Kit commands and AWS AI-DLC stages *(2026-02-16, [#4](../../pull/4))*
- **Continuous Improvement** -- Retrospective analysis with improvement backlog and `/fluid-flow.apply-improvements` command *(2026-02-16, [#4](../../pull/4))*
- **Conversation Persistence** -- Save full conversation history per feature with `/fluid-flow.save-conversation` *(2026-02-16, [#5](../../pull/5))*
- **Cross-Platform Scripts** -- PowerShell scripts alongside Bash for branch creation, prerequisites, agent context, and shell detection *(2026-02-17, [#6](../../pull/6))*
- **Slidev Guidelines** -- Presentation guidelines and loader for Slidev-based decks *(2026-02-24, [#10](../../pull/10))*
- **Coralogix Observability** -- Technology-specific instructions for Coralogix logging and observability *(2026-02-26, [#11](../../pull/11))*
- **Workflow Flow Documentation** -- Comprehensive workflow flow reference with Mermaid diagrams covering all stages end-to-end *(2026-02-26, [#12](../../pull/12))*
- **Versioning** -- `VERSION` file, `CHANGELOG.md` (Keep a Changelog format), and release process in README *(2026-02-26)*

### Changed

- **Branding** -- Renamed from Fluid Flow Pro to Fluid Flow AI across all references *(2026-02-12, [#4](../../pull/4))*
- **Mermaid Diagrams** -- Updated styles for dark and light theme compatibility *(2026-02-12, [#2](../../pull/2))*
- **Branch Naming** -- Standardised to `###-jira-ticket-short-description` format *(2026-02-16, [#4](../../pull/4))*
- **IDE-Agnostic Documentation** -- Rewrote README and docs to be IDE-agnostic instead of Cursor-specific *(2026-02-23, [#8](../../pull/8))*

### Fixed

- **Frontmatter Cleanup** -- Removed non-functional YAML frontmatter from non-agent files and fixed AWS inception file permissions *(2026-02-09, [#2](../../pull/2))*
- **Spec-Kit Routing** -- Fixed routing gap by adding explicit load-and-execute chain after workflow selection *(2026-02-19, [#7](../../pull/7))*
- **Workflow Entry Path** -- Fixed `workflow.mdc` to use workspace-root-relative path instead of rule-relative *(2026-02-19, [#7](../../pull/7))*
- **Orphaned Submodule** -- Removed orphaned submodule reference *(2026-02-23, [#9](../../pull/9))*
