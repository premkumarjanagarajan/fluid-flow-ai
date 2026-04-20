---
step: existing-context
subagent: false
conditional: true
condition: Atlassian MCP is available
---

## Inputs

- Confirmed problem statement (Step 1.4)
- `MCP_SERVERS_OK[]` session variable

## Guidance

Skip if Atlassian MCP is unavailable — ask the user to provide context manually instead.

## Execution

Search via MCP for existing:
- Big Bets
- Needs & Opportunities
- Solutions
- Active or approved Epics

Identify overlaps in:
- Problem space
- User groups
- Intended outcomes
- Delivery scope

**Routing logic:**
- If relevant context exists → prefer attaching to or extending it instead of creating a new artefact. Present the overlap to the user and ask how to proceed.
- If no relevant context exists → continue to Phase 2.

## Outputs

- Overlap report (or confirmation that no existing context was found)

## Gate

User decides: attach to existing artefact or create new.
