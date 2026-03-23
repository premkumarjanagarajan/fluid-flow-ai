# Troubleshooting

Read this before attempting to diagnose from first principles. Each section is a documented root cause with an exact fix derived from real problems.

## Build Issues

- Clear Nx cache: `pnpm reset`
- Reinstall dependencies (cross-platform): `pnpm -w dlx rimraf node_modules && pnpm install`
- Check TypeScript errors: `pnpm tsc --noEmit`

## Component Not Loading in Storybook

The repo uses `dist-custom-elements` with `customElementsExportBehavior: 'auto-define-custom-elements'` (no `defineCustomElements()` call). Components register when their dist module is imported. Storybook registers them via preview globs (`design-system/dist/components/*.js` and `apps/*/dist/components/*.js`).

**Fix**: ensure the project is built (`pnpm --filter '<package>' build`) before starting Storybook. Restart Storybook after building.

## Event Bus Singleton — Data Not Loading / Events Silently Buffered

**Symptom**: Component renders (loading state / title) but never receives data. No error in console. Mock handler is never called.

**Cause**: Component imports `EventBus` from `@sb-xp/event-bus` directly. Stencil bundles it inline, creating an isolated singleton invisible to Storybook mocks and the shell.

**Fix**: Use `window.sbXpEventBus`, not `EventBus.getInstance()`. See `knowledge-core/event-bus-access.md`.

## CSS Not Applying in Shadow DOM (Widget Renders Unstyled)

**Symptom**: Widget renders data correctly but appears completely unstyled. Changing SCSS has no effect after rebuild.

**Two root causes — check both:**

1. **BEM root class on `<Host>`** — class is in light DOM, shadow stylesheet can't match it. Move to a wrapper `<div>` inside `<Host>`. See `knowledge-core/shadow-dom-css-rules.md` Rule 1.

2. **SCSS `&-` BEM nesting** — Stencil's bundler emits CSS Nesting Level 1, which is unreliable in shadow DOM `adoptedStyleSheets`. Write flat selectors. See `knowledge-core/shadow-dom-css-rules.md` Rule 2.

**Diagnosis**: open `dist/components/index.js`, search for `static get style()`, inspect the CSS string for host-level classes or `&-` patterns.

## BFF 200 but Component Shows Loading/Error State

**Symptom**: Network tab shows 200 with correct data but component stays in loading or error state.

**Cause**: BFF returned `responseCode: 'Failure'` inside the 200 response, or the mock/stub omits `responseCode` so the guard logic behaves unexpectedly.

**Fix**: ensure the component guards on both `!response?.ok` and `response.responseCode === ResponseCode.Failure`. Ensure mocks include the full envelope with `responseCode: 'Success'`. See `knowledge-core/bff-data-fetching.md`.

## Unit Test TypeError — `Cannot read properties of undefined`

**Symptom**: Jest throws `TypeError: Cannot read properties of undefined (reading 'Failure')` or similar when accessing an enum value.

**Cause**: The component imports the enum from `@sb-xp/contracts`, mapped to `src/__mocks__/contracts.js` by `moduleNameMapper`. If the enum is not exported from that CJS mock file, the import resolves to `undefined`.

**Fix**: add the enum to `src/__mocks__/contracts.js`:

```javascript
const ResponseCode = { Unset: 'Unset', Success: 'Success', Failure: 'Failure', PartialSuccess: 'PartialSuccess' };
const OddsFormat = { Unset: 'Unset', Decimal: 'Decimal', American: 'American', Fractional: 'Fractional', ErrorUnknownEnum: 'ERROR_UNKNOWN_ENUM' };
module.exports = { OddsFormat, ResponseCode };
```

## New Type Not Found After Adding to `libs/contracts`

**Symptom**: Linter reports `Module '@sb-xp/contracts' has no exported member 'MyNewType'` despite the source being correct.

**Cause**: `@sb-xp/contracts` resolves to `dist/index.d.ts`, not the source. Until the library is rebuilt, the new type doesn't exist in `dist/`.

**Fix**: `pnpm --filter @sb-xp/contracts build`

## Build ENOENT for Workspace Lib

**Symptom**: Stencil/Rollup throws `ENOENT: no such file or directory` for a workspace lib dist file.

**Causes**:
1. **Library not built** — run `pnpm --filter <lib-name> build` before the app build
2. **`package.json` exports mismatch** — the `"import"` field points to `.mjs` when only `.js` is emitted. Align the exports field with what the build produces.
