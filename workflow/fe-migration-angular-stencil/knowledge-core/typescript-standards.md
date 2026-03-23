# TypeScript Standards

Standards that apply to all TypeScript written during the migration.

## Explicit Return Types (required)

All functions/methods must declare an explicit return type, **including `: void`**.

```typescript
// ✅
export function toChannel(value: string): Channel {
  return value as Channel;
}

private setupListeners(): void { /* ... */ }

const parseId = (raw: string): number => Number(raw);

// ❌ implicit return type
const parseId = (raw: string) => Number(raw);
```

## Naming

- **Interfaces**: no `I` prefix — use `Person`, not `IPerson`
- **Booleans**: prefix with `is`, `has`, or `should` (`isOpen`, `hasItems`, `shouldValidate`)
- **Prefer whole words** over unclear abbreviations (`seconds`, not `secs`)

## Enums: `const enum` vs `enum`

Prefer `const enum` when the enum is not iterated at runtime and does not use reverse mapping. Benefits: smaller bundles (no runtime object), values inlined at compile time.

```typescript
// ✅ const enum — values inlined
export const enum UserState {
  Unset = "Unset",
  Anonymous = "Anonymous",
  LoggedIn = "LoggedIn",
  LoggedOut = "LoggedOut",
  ErrorUnknownEnum = "ERROR_UNKNOWN_ENUM",
}

// Regular import (not type-only) — required for value inlining
import { UserState } from "@sb-xp/contracts";

// ❌ type-only import prevents value inlining
import type { UserState } from "@sb-xp/contracts";
```

Use regular `enum` only when you need runtime iteration, reverse mapping, or the enum as a runtime object.

## Null/Undefined

- Prefer **required** fields over optional when a value is always present
- Prefer `T | undefined` over `T | null` unless the domain explicitly uses `null`
- Use optional chaining (`?.`) for safe access
- Use nullish coalescing (`??`) for fallbacks (use `||` only for boolean logic)
- Avoid non-null assertions (`!`) unless the value's existence is proven in the same scope
- Avoid type assertions that force invalid shapes (`{} as Person`) — fix the types or handle the missing values

## Readability

- Avoid deep nested ternaries; split into `if` blocks or helper functions
- Use early returns to reduce nesting
- Prefer parameter objects when a function takes more than ~3 parameters
- Use `for...of` when you need `break`/`continue` or `await`; array methods (`map`, `filter`, `reduce`) for transformations
