# Event Bus Patterns

**Critical prerequisite**: read `knowledge-core/event-bus-access.md` — the mandatory `window.sbXpEventBus` rule. Components must NEVER import `EventBus` from `@sb-xp/event-bus` directly.

## Topic Naming

Format: `sb-xp:{domain}:{action}:{version}`

Examples:
- `sb-xp:betting:odds-format:get:v1`
- `sb-xp:context:locale:get:v1`
- `sb-xp:navigation:route:changed:v1`

## Message Types

| Type | Direction | Use Case |
|------|-----------|----------|
| **Command** | Send | Request an action from another MFE |
| **Value** | Request/Response | Get a value from shared context |
| **Event** | Broadcast | Notify others of state change |

## Access Pattern (mandatory)

```typescript
// ✅ CORRECT — shared singleton from shell / Storybook preview.js
private get eventBus() { return window.sbXpEventBus; }

// Guard against unavailability (SSR, mis-ordered init)
connectedCallback(): void {
  if (typeof window === 'undefined' || !window.sbXpEventBus) return;
}
```

The type for `window.sbXpEventBus` is declared globally in `@sb-xp/contracts`. Import as side effect:

```typescript
import '@sb-xp/contracts'; // activates the window.sbXpEventBus global type
```

## Rules

- Root component owns Event Bus subscriptions
- Child components are pure (no Event Bus calls)
- Unsubscribe in `disconnectedCallback` to prevent memory leaks
- Type all payloads in `libs/contracts/`
- Use `@Listen()` for DOM events, Event Bus API for cross-MFE

## Contract Definition

```typescript
interface EventBusMessage<T> {
  topic: string;
  payload: T;
  timestamp: number;
}
```

## Storybook Mocking

Mock Event Bus in stories to isolate components. Use `createComponent()` utility with Event Bus spy. `preview.js` creates the shared instance; components access it via `window.sbXpEventBus`. See `storybook-conventions.md` for detailed mock patterns.
