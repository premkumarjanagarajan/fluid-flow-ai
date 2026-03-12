# State Manager

Manages `metadata/state.md` and `metadata/audit.md` for the current initiative.

## When to Run

After every stage or step completion. The orchestrator and workflow steps must call this primitive.

## On Initiative Creation

Copy templates into `initiatives/{name}/metadata/`:
- `primitives/templates/stage.template.md` --> `state.md`
- `primitives/templates/audit.template.md` --> `audit.md`

Replace all `{placeholders}` with actual values.

## On Stage/Step Completion

### state.md

1. Mark completed stage/step: `[x]`
2. Update `Updated` timestamp
3. Update `Workflow` after selection
4. Append workflow phases/steps to `## Workflow Progress` after routing

### audit.md

1. Append a new entry at the end of the file
2. Always include: Timestamp, User Input (verbatim), AI Response, Context
3. **Append-only** -- never overwrite, never summarize user input
