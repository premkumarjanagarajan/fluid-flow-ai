---
step: build
subagent: false
---

## Inputs

- Implemented source files (from 2-implement)

## Guidance

### 1. Run Build

Execute the build command for the target project (e.g. `stencil build`, `pnpm build`).

### 2. Fix Errors

If the build fails:
- Read the error output
- Fix the source files causing the failure
- Re-run the build
- Repeat until build succeeds

### 3. Verify

Confirm zero build errors before proceeding.

## Outputs

- Successful build (zero errors)

## Gate

STOP until build succeeds. Do not proceed to tests with a broken build.
