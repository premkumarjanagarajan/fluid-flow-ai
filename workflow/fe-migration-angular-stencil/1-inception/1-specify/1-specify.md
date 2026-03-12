---
step: specify
subagent: false
---

## Inputs

- User prompt (migration request)

## Guidance

Collect four required inputs using the IDE question tool (Cursor: `AskQuestion` / VS Code: `vscode_askQuestions`). Do not proceed until all are provided.

**1. JIRA epic key**
Ask: "Provide the JIRA epic key (e.g. SBEUJE-1234) for this migration."
Store as `JIRA_KEY`.

**2. Angular widget entry point**
Ask: "Provide the relative path to the Angular widget's main component in the source repository."
Store as `ENTRY_POINT`.

**3. New widget name**
Ask: "What should the migrated widget be named? (kebab-case, e.g. popular-bets)"
Store as `WIDGET_NAME`.

**4. Target type**
Present multi-choice:
- **A**: app-mfe (user-facing widget with UI)
- **B**: service-mfe (headless service)
- **C**: design-system (reusable UI component)
- **D**: typescript library (pure utilities/types)
Store as `TARGET_TYPE`.

## Outputs

- `JIRA_KEY`, `ENTRY_POINT`, `WIDGET_NAME`, `TARGET_TYPE` stored for the session

## Gate

STOP until all 4 inputs are provided.
