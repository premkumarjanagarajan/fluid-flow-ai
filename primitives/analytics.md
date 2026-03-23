# Analytics

Manages `metadata/analytics.md` for the current initiative.

## When to Run

After every stage or step completion, alongside state-manager.

## On Initiative Creation

Copy `primitives/templates/analytics.template.md` --> `initiatives/{name}/metadata/analytics.md`

Replace all `{placeholders}` with actual values.

## On Stage/Step Completion

1. Update the matching row in `## Stage Timeline`: set Started, Completed, Duration, Status
2. Increment relevant counters in `## Metrics`
3. Update `## Effort Breakdown` phase row

## On Workflow End

1. Set `Completed` timestamp in Metadata
2. Calculate `Total Duration`
3. Calculate all durations in `## Cycle Summary`
4. Final count of all metrics
