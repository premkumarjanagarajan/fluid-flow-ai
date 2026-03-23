---
step: specify
subagent: false
---

## Inputs

- User prompt (migration request)

## Guidance

Collect four required inputs. Do not proceed until all are provided.

**Tool preference for fixed-option questions**: If the `AskQuestion` tool is available (Cursor), use it for structured questions. Otherwise, ask as free text and wait for a reply.

**1. JIRA epic key**
Ask: "Provide the JIRA epic key (e.g. SBEUJE-1234) for this migration."
Store as `JIRA_KEY`.

**2. Angular widget entry point**
Ask: "Provide the relative path to the Angular widget's main component in the source repository."
Store as `ENTRY_POINT`.

**Saved analysis shortcut**: If `docs/{WIDGET_NAME}/angular-analysis-report.md` exists in the target repository (produced by a prior JIRA Epic workflow), the entry point can be read from that file. In that case, inform the user the entry point was loaded from the saved report and skip this question.

**3. New widget name**
Ask: "What should the migrated widget be named? (kebab-case, e.g. popular-bets)"
Store as `WIDGET_NAME`. Also derive and store the PascalCase form as `PASCAL_CASE_WIDGET_NAME`.

**4. Target type**
Present multi-choice (via `AskQuestion` if available, otherwise as free text):
- **A**: app-mfe (user-facing widget with UI)
- **B**: service-mfe (headless service)
- **C**: design-system (reusable UI component)
- **D**: typescript library (pure utilities/types)
Store as `TARGET_TYPE`.

**5. Input confirmation**
Before proceeding, confirm all inputs with the user:

| Item | Value |
|---|---|
| JIRA epic key | {JIRA_KEY} |
| Angular entry point | {ENTRY_POINT} |
| New widget name | {WIDGET_NAME} |
| Target type | {TARGET_TYPE} |

## Outputs

- `JIRA_KEY`, `ENTRY_POINT`, `WIDGET_NAME`, `PASCAL_CASE_WIDGET_NAME`, `TARGET_TYPE` stored for the session

## Gate

STOP until all 4 inputs are provided and confirmed.
