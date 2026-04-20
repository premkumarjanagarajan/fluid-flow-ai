# Branch Diff Summary

**Base:** `feature/kb-ff-merge`
**Target:** `feature/ARC-375-product-buddy-and-init`
**Date:** 20 April 2026
**Stats:** 7 commits, 85 files changed, +1,876 lines added

---

## 1. Directory Rename: `workflow/` → `workflows/`

All files under the old `workflow/` directory were renamed to `workflows/` (plural). This affects **57 files** across `comprehensive-path/` and `fast-track/` — content unchanged, purely a structural rename for naming consistency.

---

## 2. New Agents (5 files)

| File | Purpose | Status |
|------|---------|--------|
| `agents/product-buddy.agent.md` | Product-discovery agent with full 5-phase pipeline (~871 lines). | **Deleted** — all content incorporated into `workflows/product-buddy/wf-product-buddy.md`. |
| `agents/kb-librarian.agent.md` | KB navigation agent using overlay maps (~171 lines). | **Converted** to shared skill at `skills/kb-retrieval/kb-retrieval.skill.md`. The retrieval protocol is a repeatable procedure, not a persona. |
| `agents/updater.agent.md` | Agent for updating/maintaining fluid-flow-ai dependencies and configurations (~141 lines). | **Deleted** — MCP generation absorbed into `skills/mcp-check/mcp-check.md`. Dependency syncing no longer needed (mcp.json is gitignored and generated locally per user). |
| `agents/betssonAIte.agent.md` | Betsson-specific AI agent definition (~42 lines). | Kept |
| `.github/agents/technician.agent.md` | Technician agent for maintaining root-level tooling folders — validates file formats, naming conventions, and index files (~162 lines). | **Deleted** — replaced by `skills/ff-audit/ff-audit.skill.md`. The procedural audit logic is a skill, not a persona. Invoked via `/ff-audit` slash command. |

---

## 3. New MCP Configurations (6 files)

| File | Integration |
|------|-------------|
| `mcps/github.md` | GitHub MCP via `@modelcontextprotocol/server-github` (PAT-based auth) |
| `mcps/atlassian.md` | Atlassian MCP (Jira/Confluence access) |
| `mcps/figma.md` | Figma remote MCP endpoint (OAuth-based) |
| `mcps/aws-document-loader.md` | AWS Labs Document Loader MCP via `uvx` |
| `mcps/local/figma-dev-mode.md` | Figma desktop Dev Mode MCP (local `127.0.0.1:3845`) |
| `mcps/local/playwright.md` | Playwright browser automation MCP |

---

## 4. Prompt Files — DELETED

All 13 prompt files under `prompts/` have been **deleted**. Their functionality is now handled directly by the product-buddy workflow:

- **Artefact prompts** (8 files: big-bet, epic-brief, jira-epic, jpd-idea, jpd-need-opportunity, jpd-solution, user-story, test-case) — template loading is handled by workflow Step 2.7 (`7-load-template.md`)
- **Discovery prompts** (2 files: discover, questions) — discovery entry is via `/product-buddy` slash command → workflow Phase 1; question generation is available via workflow-local `skills/discovery-questions/`
- **Governance prompts** (3 files: decision-log, glossary, review) — decision log is handled by workflow Step 4.1; glossary and review are now workflow-local skills under `workflows/product-buddy/skills/`

**Rationale:** The prompts were standalone shortcut entry points that bypassed the workflow's discovery and gate requirements, contradicting Non-Negotiable Principle #2 ("Discovery before definition"). All template paths and trigger logic are now in the workflow steps.

---

## 5. Skills — Moved to Workflow

The 3 product-buddy-specific skills have been **moved** from `skills/` into the workflow folder at `workflows/product-buddy/skills/`, scoping them to this workflow only:

| Original Location | New Location | Purpose |
|-------------------|-------------|---------|
| `skills/discovery/discovery-questions/` | `workflows/product-buddy/skills/discovery-questions/` | Generates topic-tailored discovery questions before/during Phase 1 |
| `skills/governance/glossary/` | `workflows/product-buddy/skills/glossary/` | On-demand KB term resolution (any phase) |
| `skills/governance/review-document/` | `workflows/product-buddy/skills/review-document/` | Section-by-section artefact review before PR (Step 3.1) |

**Rationale:** These skills are specific to the product-buddy flow and should not be shared globally across all workflows. The `skills/discovery/` and `skills/governance/` folders have been deleted.

---

## 6. Skills — Deleted (duplicates of betsson-kb-docs prompts)

| Deleted Skill | Duplicate of (betsson-kb-docs) |
|---------------|-------------------------------|
| `skills/extract-rules-from-code/` | `.github/prompts/extract_rules_from_code_pattern.md` |
| `skills/compliance-summary/` | `.github/prompts/create_compliance_summary_doc.md` |

**Rationale:** Both were standalone prompt templates for authoring betsson-kb-docs content. They already exist as prompts in the KB repo and were not invoked by any fluid-flow workflow or agent.

---

## Summary of Themes

1. **Product Buddy workflow** — The flagship addition: a complete self-contained workflow (`workflows/product-buddy/`) with 5 phases, 16 steps, full persona, operating rules, anti-patterns, and template trigger maps. No separate agent file — everything is in the workflow.
2. **MCP expansion** — 6 new MCP configs (GitHub, Atlassian, Figma, AWS Docs, Playwright, Figma Dev Mode) adding integrations for the agents to use.
3. **Tooling agents** — BetssonAIte agent for maintenance. Technician deleted (replaced by ff-audit skill). Updater deleted (MCP generation moved to mcp-check skill).
4. **Skills** — `kb-retrieval` (shared, converted from kb-librarian agent), `ff-audit` (shared, replaced technician agent) + 3 workflow-local skills (discovery-questions, glossary, review-document). 2 duplicate skills deleted (extract-rules-from-code, compliance-summary — already in betsson-kb-docs prompts).
5. **Structural cleanup** — `workflow/` → `workflows/` rename.
6. **Prompt deletion** — All 13 product-buddy prompts removed; functionality absorbed into workflow steps.
7. **Skill frontmatter** — YAML frontmatter added to all skill files (name, description, execution, scope, version, last-updated).
8. **Orchestrator filter** — `orchestrator-listed: false` excludes product-buddy from the `/fluid-flow` workflow menu.
9. **MCP generation** — `.github/mcp.json` is now gitignored (local-only). Generated by `mcp-check` skill via a user-driven MCP selection flow instead of reading agent dependency declarations.

---
