# Event Bus Patterns

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

Mock Event Bus in stories to isolate components. Use `createComponent()` utility with Event Bus spy.
