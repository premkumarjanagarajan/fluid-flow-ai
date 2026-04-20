---
name: kb-retrieval
description: Navigates overlay maps to retrieve targeted information from the centralised knowledge base.
execution: subagent
scope: shared
version: 1.0
last-updated: 2026-04-20
---

# KB Retrieval

Retrieves accurate, targeted information from the centralised knowledge base (`betsson-kb-docs`) by navigating overlay maps and department overlays. Does not read every file; routes through the map first.

---

## Subagent Execution

This skill **must** be executed as a **dedicated subagent**. The calling agent (orchestrator or workflow step) launches a subagent, passes the query, and receives only the structured answer back. This keeps all overlay navigation, file reads, and intermediate reasoning out of the caller's context window.

### How to invoke

The caller must use `runSubagent` (or equivalent) with:

1. **Skill path**: `skills/kb-retrieval/kb-retrieval.skill.md` — the subagent reads and executes this file
2. **Query**: the specific question or topic to look up
3. **KB path**: path to the `betsson-kb-docs` workspace root (typically available as `KB_PATH` session variable)

### What the subagent returns

The subagent returns **only** the structured response defined in the **Response Format** section below (Answer + Sources + Navigation Path), or a **Gap Report** if the information was not found. No intermediate file contents, overlay dumps, or navigation logs are returned.

> **Rule**: Never inline-execute this skill in the main conversation. Always delegate to a subagent.

---

## When to Run

- Any workflow or step needs to look up market rules, compliance requirements, governance definitions, or domain knowledge
- Cross-referencing artefacts against KB content (e.g. Phase 1.3 KB Validation)
- Resolving knowledge gaps flagged during discovery or definition
- Loading canonical templates or governance references

---

## Prerequisites

- Access to the `betsson-kb-docs` repository (via workspace or submodule)
- The query or topic to look up

---

## Objectives

1. **Locate** — Identify the minimal set of files that can answer the query by navigating the overlay map and overlays first.
2. **Extract** — Read only the targeted files (or targeted sections of files) needed to answer the question.
3. **Return** — Respond with a focused, accurate answer drawn directly from the retrieved content, with source paths cited.
4. **Acknowledge gaps** — If the information does not exist in the KB, say so clearly and state which paths were checked.

---

## Execution

### Step 1 — Consult the Overlay Map

**Always start here:** `knowledge/overlay.map.md`

Scan the Quick Lookup Table to determine:
- Is the query department-specific? → identify the department overlay path
- Is it capability-specific? → identify the capability overlay path
- Is it shared/global (compliance, design tokens, accessibility, markets)? → navigate directly to `knowledge/shared/`

> If the overlay map has no matching entry, check `knowledge/shared/` and `knowledge/departments/` index files before concluding the topic is not covered.

### Step 2 — Load the Relevant Overlay (department or capability)

Open the overlay identified in Step 1. Within it:

- Read the **Routing Triggers** table — confirm the query aligns with this overlay's scope
- Read the **Mandatory Knowledge Sources** — these are the canonical file paths for this domain
- Read the **Top-Level Sections** table (if present) — identify which section(s) within the overlay relate to the query

> Only load a second overlay if the query explicitly spans a second department or capability.

### Step 3 — Identify Target Files

From the knowledge source paths surfaced in Step 2, apply the query intent to narrow down:

| Query type | Files to target |
|------------|-----------------|
| System behaviour / lifecycle | `systems/<system>/lifecycle.md`, `systems/<system>/overview.md` |
| Compliance & jurisdiction rules | `shared/global/compliance/jurisdiction-<X>.md` |
| Market-specific variation | `shared/markets/<ISO_CODE>.md` |
| UX / design constraints | `departments/<dept>/design/<doc>.md` |
| Engineering rules / pitfalls | `departments/<dept>/engineering/known-pitfalls.md` |
| Testing requirements | `departments/<dept>/engineering/testing/` |
| Design tokens | `shared/global/design-standards/tokens/<token-file>.md` |
| Accessibility | `shared/global/accessibility/` |
| Feature decisions | `departments/<dept>/product/decision-log.md` |
| Capabilities (flags, identity, wallet) | `shared/capabilities/<capability>/` |

Do **not** open files outside these targeted paths unless Step 2 explicitly names additional sources.

### Step 4 — Read and Extract

Open only the identified files. If a file is long, scan section headings first and read only the relevant section(s). Extract the exact content that answers the query.

### Step 5 — Respond

Return a structured answer that:
- Directly addresses the query
- Cites the source path(s) for every piece of information returned
- Calls out any status flags (e.g., `PLACEHOLDER`, `MISSING`) encountered during navigation
- States clearly if the answer is partial due to missing or unregistered KB entries

---

## Operating Rules

| Signal | Rule |
|--------|------|
| ✅ Always | Start navigation at `knowledge/overlay.map.md` — never jump directly to content files |
| ✅ Always | Cite the source file path alongside every piece of information returned |
| ✅ Always | Check the overlay's Routing Triggers before loading it — confirm scope alignment |
| ✅ Always | Note `PLACEHOLDER` or `MISSING` status entries and report them to the user |
| ⚠️ Only if needed | Load a second department or capability overlay when the query explicitly spans multiple domains |
| 🚫 Never | Read an entire directory of files to find an answer — navigate to the specific file first |
| 🚫 Never | Return raw file dumps; always extract and summarise the relevant portion |
| 🚫 Never | Invent or infer information not present in the KB — state the gap instead |
| 🚫 Never | Modify, author, or restructure knowledge files |
| 🚫 Never | Perform PR review, structural validation, or index maintenance |

---

## Authoritative Entry Points

| File | Role |
|------|------|
| `knowledge/overlay.map.md` | **Always first** — navigation map to all overlays and their status |
| `knowledge/departments/<dept>/engineering/ai/overlay.md` | Department-level rules, mandatory sources, routing triggers |
| `knowledge/shared/capabilities/<cap>/` | Shared capability knowledge (feature flags, identity, wallet) |
| `knowledge/shared/global/compliance/` | Jurisdiction and compliance rules |
| `knowledge/shared/global/accessibility/` | Accessibility standards |
| `knowledge/shared/global/design-standards/` | Design tokens and component usage rules |
| `knowledge/shared/markets/<ISO_CODE>.md` | Market-specific UX and operational variations |
| `knowledge/departments/<dept>/INDEX.md` | Department content index — use when overlay does not specify exact file paths |
| `knowledge/departments/<dept>/OWNERSHIP.md` | Identify the owner when escalation or routing is needed |

---

## Response Format

Structure answers as follows:

```
## Answer

<Focused answer to the query, written in plain language>

## Sources

| File | Section / Relevant Content |
|------|-----------------------------|
| `path/to/file.md` | Brief description of what was retrieved |

## Navigation Path

Overlay Map → <overlay loaded> → <files opened>
```

For short factual queries, a brief inline answer with cited paths is sufficient — do not pad with unnecessary structure.

---

## Gap Reporting

When information is not found, always report:

1. Which overlay (if any) was loaded
2. Which paths were checked
3. Whether the gap is a `MISSING` or `PLACEHOLDER` entry in the overlay map
4. Whether the query may belong to a domain not yet registered in the KB

---

## Out of Scope

This skill does **not**:

- Author, edit, or restructure KB files
- Validate or review contributions
- Perform compliance interpretation (retrieves rules; does not reason about compliance fitness)
- Maintain indexes or overlay maps

---

## Outputs

| Output | Format | Description |
|--------|--------|-------------|
| Answer | Inline response | Focused answer with cited source paths |
| Gap report | Inline response | Paths checked, status flags, and escalation suggestion |
