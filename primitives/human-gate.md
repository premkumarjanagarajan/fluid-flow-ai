# Human Gate

Enforces a mandatory validation checkpoint after every workflow step. The agent MUST stop and present the step outcome to the user before moving on. No step may be skipped or auto-advanced.

## When to Run

After every step completion, before state-manager and analytics. This is the first primitive in the post-step sequence.

## Gate Protocol

1. Present a brief summary of what was done and what artifacts were produced
2. Ask the user to choose one of:
   - **A**: Approve — proceed to the next step
   - **B**: Clarify — the user provides additional context or corrections; the agent re-executes or adjusts the step, then presents the gate again
   - **C**: Redo — the agent re-executes the step from scratch, then presents the gate again
3. Do NOT proceed until the user explicitly selects **A**

## Display Format

```
───────────────────────────────────────────────────
  HUMAN GATE — {phase-name} / {step-name}
───────────────────────────────────────────────────

  Summary:
    {1-3 sentences describing what was done}

  Artifacts:
    - {list of files created or modified}

  A) Approve and continue
  B) Clarify (provide feedback)
  C) Redo step
───────────────────────────────────────────────────
```

## On Approve (A)

Proceed to run state-manager and analytics, then continue to the next step.

## On Clarify (B)

1. Read the user's feedback
2. Adjust or partially re-execute the step incorporating the feedback
3. Present the gate again with the updated summary

## On Redo (C)

1. Re-execute the step from scratch
2. Present the gate again with the new summary

## Scope Rules

- The gate applies to **workflow steps** (Stage 5) and **orchestrator stages** that produce artifacts
- The gate does NOT apply to internal primitives (state-manager, analytics, kb-compliance) — those run silently after the gate is approved
- If the user selects B or C, the gate loops until the user selects A
