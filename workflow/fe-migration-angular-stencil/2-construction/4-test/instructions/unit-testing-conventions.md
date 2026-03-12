# Unit Testing Conventions

Also read: `knowledge-core/event-bus-access.md` (why `window.sbXpEventBus`), `knowledge-core/bff-data-fetching.md` (full envelope rule), `knowledge-core/troubleshooting.md` (test TypeError fixes).

## Framework

Jest with `@stencil/core/testing`.

## File Pattern

`{component}.spec.tsx` in `tests/` folder alongside the component.

## What to Test

- **Pure logic first**: helpers in `utils/`, `services/`, mapping/formatting functions (fast, stable)
- **Rendering**: component renders with default props
- **Props**: each `@Prop()` affects output correctly
- **Events**: `@Event()` emitters fire with correct payload
- **State changes**: loading, error, populated, empty states
- **Edge cases**: null data, empty arrays, missing props
- **Accessibility**: key elements have `data-test-id`
- **Contracts/events**: event names and payload shapes stay consistent

## Keep Tests Deterministic

- No real network calls
- Avoid reliance on time and randomness; prefer fixed fixtures
- Mock Event Bus and external dependencies

## Mocking `window.sbXpEventBus`

Components access the Event Bus via `window.sbXpEventBus` (never a direct import). Set up in `beforeEach`, tear down in `afterEach`:

```typescript
const mockEmit = jest.fn();
const mockSbXpEventBus = {
  emit: mockEmit,
  on: jest.fn(() => jest.fn()),
  off: jest.fn(),
  onPattern: jest.fn(() => jest.fn()),
  getBufferStats: jest.fn(),
};

beforeEach(() => {
  mockEmit.mockReset();
  (window as unknown as { sbXpEventBus: unknown }).sbXpEventBus = mockSbXpEventBus;
});

afterEach(() => {
  delete (window as unknown as { sbXpEventBus?: unknown }).sbXpEventBus;
});
```

**Default behaviour**: `emit` never calls back — component stays in `isBusy=true` (loading state). Useful for loading-state tests.

**Simulating a success response**: override `mockEmit`. Always include the full BFF envelope — use string values for enum fields (enum imports not available in CJS mock):

```typescript
it('renders data after a successful fetch', async () => {
  mockEmit.mockImplementation((_event, _request, callback) => {
    callback({
      ok: true,
      status: 200,
      data: sampleData,
      responseContext: { correlationId: 'test-correlation-id' },
      responseCode: 'Success',
      responseResults: [],
    });
  });

  const page = await newSpecPage({ ... });
  await page.waitForChanges();
  expect(page.root?.shadowRoot?.querySelector('[data-test-id="my-widget"]')).toBeTruthy();
});
```

**Simulating a BFF-level failure** (HTTP 200 but `responseCode: 'Failure'`):

```typescript
it('shows error state when BFF reports Failure', async () => {
  mockEmit.mockImplementation((_event, _request, callback) => {
    callback({
      ok: true, status: 200, data: null,
      responseContext: { correlationId: 'test-correlation-id' },
      responseCode: 'Failure',
      responseResults: [{ type: 'Technical', code: 'SERVICE_UNAVAILABLE' }],
    });
  });

  const page = await newSpecPage({ ... });
  await page.waitForChanges();
  expect(page.root?.shadowRoot?.querySelector('[data-test-id="my-widget"]')).toBeFalsy();
});
```

## `moduleNameMapper` for `@sb-xp/*` packages

Stencil compiles tests with Jest, which cannot process ESM modules from `node_modules`. Map workspace packages to CJS mock files:

**`stencil.config.ts`**:
```typescript
export const config = createConfig({
  namespace: 'my-widget',
  testing: {
    browserHeadless: 'shell',
    moduleNameMapper: {
      '^@sb-xp/contracts$': '<rootDir>/src/__mocks__/contracts.js',
    },
  },
});
```

**`src/__mocks__/contracts.js`** (CJS, add only what the component uses):
```javascript
const OddsFormat = { Unset: 'Unset', Decimal: 'Decimal', American: 'American', Fractional: 'Fractional', ErrorUnknownEnum: 'ERROR_UNKNOWN_ENUM' };
const ResponseCode = { Unset: 'Unset', Success: 'Success', Failure: 'Failure', PartialSuccess: 'PartialSuccess' };
module.exports = { OddsFormat, ResponseCode };
```

Do **not** add a `moduleNameMapper` entry for `@sb-xp/event-bus` — components must use `window.sbXpEventBus`.

## Test IDs

Add `data-test-id` on:
- Host element
- Key interactive elements (buttons, links, inputs)
- State containers (loading spinner, error message, empty state)

## Test Structure

- One test file per component: `{component}.spec.tsx`
- Use **Arrange / Act / Assert**
- Group by behaviour/state with clear `describe` blocks
- Assert behaviour, not implementation details

## Coverage

Aim for meaningful coverage, not line count. Every requirement in `1.4-requirements.md` should have at least one corresponding test. Cover the happy path and at least one failure path for critical features.
