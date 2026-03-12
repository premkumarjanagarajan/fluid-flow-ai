# Unit Testing Conventions

## Framework

Jest with `@stencil/core/testing`.

## File Pattern

`{component}.spec.tsx` in `tests/` folder alongside the component.

## What to Test

- **Rendering**: component renders with default props
- **Props**: each `@Prop()` affects output correctly
- **Events**: `@Event()` emitters fire with correct payload
- **State changes**: loading, error, populated, empty states
- **Edge cases**: null data, empty arrays, missing props
- **Accessibility**: key elements have `data-test-id`

## Mocking

- Mock services with Jest `jest.fn()`
- Mock Event Bus: stub subscribe/publish, verify calls
- Mock BFF responses: include full `Response<T>` envelope with `responseCode`
- Use `*.mock.ts` files for shared mock data

## Test IDs

Add `data-test-id` on:
- Host element
- Key interactive elements (buttons, links, inputs)
- State containers (loading spinner, error message, empty state)

## Coverage

Aim for meaningful coverage, not line count. Every requirement in `1.4-requirements.md` should have at least one corresponding test.
