---
step: build
subagent: false
---

## Inputs

- Implemented source files (from 2-implement)

## Guidance

Pre-load `knowledge-core/troubleshooting.md` — contains documented root causes for common build failures (ENOENT for workspace libs, Nx cache issues, dependency reinstall).

### 1. Run Build

Execute the build command for the target project (e.g. `stencil build`, `pnpm build`).

### 2. Fix Errors

If the build fails:
- Read the error output
- Check `knowledge-core/troubleshooting.md` for known root causes before diagnosing from first principles
- Fix the source files causing the failure
- Re-run the build
- Repeat until build succeeds

Common build issues:
- **ENOENT for workspace lib**: run `pnpm --filter <lib-name> build` before the app build
- **`package.json` exports mismatch**: align the `"import"` field with actual build output
- **Nx cache stale**: run `pnpm reset`
- **Dependency issues**: `pnpm -w dlx rimraf node_modules && pnpm install`

### 3. Verify

Confirm zero build errors before proceeding.

## Outputs

- Successful build (zero errors)

## Gate

STOP until build succeeds. Do not proceed to tests with a broken build.
