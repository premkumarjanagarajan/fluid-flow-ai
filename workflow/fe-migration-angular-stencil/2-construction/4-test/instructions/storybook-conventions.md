# Storybook Conventions

Also read: `$KB_PATH/knowledge/shared/engineering-standards/fabric/coding-standards/event-bus-access.md` (why `window.sbXpEventBus`), `$KB_PATH/knowledge/shared/engineering-standards/fabric/coding-standards/bff-data-fetching.md` (full envelope in mocks).

## Principles

- **Deterministic**: no real network calls; no reliance on time, randomness, or external state
- **One story, one behaviour**: each story demonstrates a single state clearly
- **Fast to understand**: clear names, minimal setup, predictable mocks

## File Pattern

`{component}.stories.ts` alongside the component.

## Component Creation

Use `createComponent()` utility for consistent setup. Do not use raw `document.createElement`.

## Required Stories

| Story | Purpose |
|-------|---------|
| Default | Component with typical props |
| Variants | Each visual variant (if applicable) |
| Empty State | No data scenario |
| Error State | Error response scenario |
| Loading State | Loading/skeleton scenario |
| Interactive | User interaction demonstration |

## Container-Query / Space-Driven Layout Stories (mandatory)

If a widget uses `@container` queries or `auto-fit` grids, **every distinct layout must have its own story**. Reviewers must see each layout without manually resizing the canvas.

**Narrow (default) story** — constrain with a `max-width` wrapper:

```javascript
export const Default = () => html`
  <div style="max-width: 500px;">
    <sb-xp-my-widget widget-guid="storybook-guid"></sb-xp-my-widget>
  </div>
`;
```

**Wide story** — use `layout: 'fullscreen'` + custom viewport (not a fixed-width wrapper div):

```javascript
export const TwoColumnLayout = () => html`
  <sb-xp-my-widget widget-guid="storybook-guid"></sb-xp-my-widget>
`;
TwoColumnLayout.parameters = {
  layout: 'fullscreen',
  viewport: {
    viewports: {
      myWidgetWide: {
        name: 'Wide — My Widget (900px)',
        styles: { width: '900px', height: '600px' },
        type: 'desktop',
      },
    },
    defaultViewport: 'myWidgetWide',
  },
};
```

Rules:
- Narrow wrapper value must be **clearly below** the breakpoint (e.g. 500px when breakpoint is 640px)
- Wide stories **must** use `layout: 'fullscreen'` + custom viewport — never a fixed-width wrapper div
- Story name should reflect layout: `TwoColumnLayout`, `NarrowLayout`, etc.

## Mocks

- Place global mocks in `.storybook/mocks/` (one file per widget)
- Place component-specific mocks in `tests/*.mock.ts`
- Include full BFF `Response<T>` envelope in mocks (see `$KB_PATH/knowledge/shared/engineering-standards/fabric/coding-standards/bff-data-fetching.md` Rule 3)
- Use `MOCK_{COMPONENT}_{VARIANT}` naming for mock constants
- Mock Event Bus to isolate stories
- Use `mockTranslations()` if i18n is involved

### Mock Callback Timing

For request/response mocks, **defer the callback with `setTimeout(..., 0)`** so Stencil's rendering cycle finishes before state updates trigger a re-render:

```javascript
export const mocks = [
  {
    eventName: 'sb-xp:data:fetch:v1',
    handler(request, callback) {
      if (!String(request?.endpoint ?? '').includes('my-endpoint')) return;
      setTimeout(() => callback({
        ok: true, status: 200,
        data: sampleData,
        responseContext: { correlationId: 'storybook-correlation-id' },
        responseCode: 'Success',
        responseResults: [],
      }), 0);
    },
  },
];
```

### GUID-Scoped Mocks for Loading State

Scope responses to specific GUIDs. GUIDs not in the set get no response — component stays in loading state:

```javascript
const DATA_GUIDS = new Set(['storybook-my-widget']);
handler(request, callback) {
  const guid = String(request?.endpoint ?? '').split('my-endpoint/').pop();
  if (!DATA_GUIDS.has(guid)) return;
  setTimeout(() => callback({ ok: true, status: 200, data: sampleData, ... }), 0);
}
```

### Central Mock Registration

After creating a widget mock file (`.storybook/mocks/<widget>.js`), register it in `.storybook/mocks/index.js`:

```javascript
import { mocks as myWidgetMocks } from './<widget>.js';
const allMocks = [ ...contextMocks, ...myWidgetMocks ];
export function registerAll(eventBus) {
  const cleanups = allMocks.map((m) => eventBus.on(m.eventName, m.handler));
  return () => cleanups.forEach((fn) => fn());
}
```

### Showing Event Bus Events in the Actions Tab

Use `action()` from `storybook/actions` to log events:

```javascript
import { action } from 'storybook/actions';

const dataFetch = action('sb-xp:data:fetch:v1');
const selectionClicked = action('sb-xp:selection:clicked:v1');

export const Default = () => html`<sb-xp-my-widget widget-guid="storybook-guid"></sb-xp-my-widget>`;

Default.beforeEach = () => {
  const bus = window.sbXpEventBus;
  if (!bus) return;
  const cleanups = [
    bus.on('sb-xp:data:fetch:v1', (request, _callback) => dataFetch(request)),
    bus.on('sb-xp:selection:clicked:v1', (payload) => selectionClicked(payload)),
  ];
  return () => cleanups.forEach((fn) => fn());
};
```

- Request/response events: log `request` only — do not call `callback` (the central mock does that)
- Broadcast events: log `payload`
- Always return cleanup function from `beforeEach`

## Design Links

If Figma URL is available, add `design` parameter:

```typescript
export default {
  parameters: {
    design: {
      type: 'figma',
      url: 'https://www.figma.com/file/...',
    },
  },
};
```

## Accessibility

- Interactive stories must be keyboard usable (Tab/Enter/Space)
- Ensure accessible names/labels on key interactive elements

## Documentation

- Include `readme-notes.md` as docs source (not auto-generated `readme.md`)
- Document props, events, and slots in the notes file

## Common Gotchas

### JSDoc `*/` breaks story files

Story files are plain JS. A block comment `/* ... */` ends at the first `*/` — even inside a string or glob pattern. Writing `apps/*/dist/` inside a JSDoc causes a parse error.

```javascript
// ❌ the */ inside apps/*/dist closes the comment early
/** Loads components from apps/*/dist/components/*.js */

// ✅ rephrase to avoid */
/** Loads components from apps/<name>/dist/components/*.js */
```
