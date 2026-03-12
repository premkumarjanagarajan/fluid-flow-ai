# StencilJS Conventions

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

## Rendering Rules

- Root component = orchestrator: owns state, lifecycle, Event Bus, data fetching. No direct UI rendering of sections.
- Child component = pure: driven entirely by `@Prop()`, no side effects, no Event Bus.
- If a `.tsx` file exceeds ~150 lines, split it.
- Use functional components for simple stateless renders.

## Data Fetching

- Fetch in `componentWillLoad` (async)
- Use `@State()` for loading/error/data states
- Guard on `responseCode === ResponseCode.Failure` AND `!ok`
- Include full BFF envelope in mocks and test stubs

## Performance

- Avoid unnecessary re-renders
- Clean up Event Bus subscriptions in `disconnectedCallback`
- Use `@Watch()` sparingly -- prefer reactive rendering
