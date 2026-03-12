# Event Bus Access — Mandatory Rule

**NEVER import `EventBus` from `@sb-xp/event-bus` directly in a component or service. ALWAYS use `window.sbXpEventBus`.**

## Why

When Stencil builds a component into `dist/`, all `import` statements from `node_modules` are bundled inline. If `@sb-xp/event-bus` is bundled, `EventBus.getInstance()` creates a singleton *inside that bundle* — completely isolated from the shell's (or Storybook's) singleton. Emits from the component find no registered listeners, get buffered indefinitely, and no response is ever received.

The `window.sbXpEventBus` instance is initialised once by the shell or Storybook's `preview.js` and shared across all MFEs regardless of how they are bundled.

## Correct Pattern

```typescript
// ❌ WRONG — bundles a private EventBus instance; breaks Storybook mocks and cross-MFE communication
import { EventBus } from '@sb-xp/event-bus';
private get eventBus() { return EventBus.getInstance(); }

// ✅ CORRECT — uses the shared singleton initialised by the shell / Storybook preview.js
private get eventBus() { return window.sbXpEventBus; }
```

## Type Declaration

The type for `window.sbXpEventBus` is declared globally in `@sb-xp/contracts` (`libs/contracts/src/types/window.types.ts`). Import it as a side effect:

```typescript
import '@sb-xp/contracts'; // activates the window.sbXpEventBus global type
```

## Guard Against Unavailability

Guard against the bus not being available (e.g. SSR or mis-ordered initialisation):

```typescript
connectedCallback(): void {
  if (typeof window === 'undefined' || !window.sbXpEventBus) return;
  // ... proceed
}
```

## Impact

This rule affects:
- **Components** (`@Component` classes) — must use `window.sbXpEventBus`
- **Unit tests** — must mock `window.sbXpEventBus` (not an import)
- **Storybook stories** — `preview.js` creates the shared instance; components access it via `window`
- **Jest config** — do NOT add a `moduleNameMapper` entry for `@sb-xp/event-bus`
