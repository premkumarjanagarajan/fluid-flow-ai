# StencilJS Conventions

Also read before implementing:
- `knowledge-core/shadow-dom-css-rules.md` — two mandatory Shadow DOM CSS rules
- `knowledge-core/event-bus-access.md` — mandatory `window.sbXpEventBus` rule
- `knowledge-core/bff-data-fetching.md` — three mandatory BFF data fetching rules
- `knowledge-core/typescript-standards.md` — TypeScript standards (return types, enums, null handling)
- `knowledge-core/typography-and-genos-rules.md` — fds-sb-typography mandatory, Genos CSS variables forbidden
- `tsx-structure-semantics.md` — semantic HTML5 in TSX
- `sass-standards.md` — SCSS formatting
- `performance-best-practices.md` — performance rules

## Member Order in Component Class

1. `@Element()` host element
2. `@State()` internal state
3. `@Prop()` public properties
4. `@Event()` custom events
5. `@Listen()` event listeners
6. `@Watch()` prop/state watchers
7. Lifecycle: `componentWillLoad`, `componentDidLoad`, `componentWillRender`, `componentDidRender`, `disconnectedCallback`
8. `@Method()` public methods
9. `render()`
10. Private helper methods

## Shadow DOM

- `shadow: true` by default
- `shadow: false` must be justified (e.g. global styling dependency)
- **Mandatory**: read `knowledge-core/shadow-dom-css-rules.md` — never put BEM root class on `<Host>`, never use `&-` BEM nesting in SCSS

## Rendering Rules

- Root component = orchestrator: owns state, lifecycle, Event Bus, data fetching. No direct UI rendering of sections.
- Child component = pure: driven entirely by `@Prop()`, no side effects, no Event Bus.
- If a `.tsx` file exceeds ~150 lines, split it.
- Use functional components for simple stateless renders.
- Use semantic HTML5 elements — see `tsx-structure-semantics.md`

## Event Bus Access (mandatory)

**NEVER** import `EventBus` from `@sb-xp/event-bus` directly. **ALWAYS** use `window.sbXpEventBus`. See `knowledge-core/event-bus-access.md` for the full rule and reasoning.

```typescript
// ❌ WRONG — creates isolated singleton, breaks Storybook and cross-MFE comms
import { EventBus } from '@sb-xp/event-bus';
private get eventBus() { return EventBus.getInstance(); }

// ✅ CORRECT
private get eventBus() { return window.sbXpEventBus; }
```

Guard against unavailability:

```typescript
connectedCallback(): void {
  if (typeof window === 'undefined' || !window.sbXpEventBus) return;
}
```

## Data Fetching

- Fetch in `componentWillLoad` (async)
- Use `@State()` for loading/error/data states
- **Mandatory**: follow all three rules in `knowledge-core/bff-data-fetching.md`:
  1. Export a named response type alias (`GetMyWidgetResponse = HttpResponse<MyWidgetData>`)
  2. Guard on `responseCode === ResponseCode.Failure` AND `!ok`
  3. Include full BFF response envelope in mocks and test stubs

## Performance

- Avoid unnecessary re-renders
- Clean up Event Bus subscriptions and ResizeObserver in `disconnectedCallback`
- Use `@Watch()` sparingly — prefer reactive rendering
- See `performance-best-practices.md` for full rules
