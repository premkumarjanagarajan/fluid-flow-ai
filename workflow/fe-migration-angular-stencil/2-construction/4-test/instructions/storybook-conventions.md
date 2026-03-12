# Storybook Conventions

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

## Mocks

- Place mocks in `.storybook/mocks/` or `tests/*.mock.ts`
- Include full BFF `Response<T>` envelope in mocks
- Use `MOCK_{COMPONENT}_{VARIANT}` naming for mock constants
- Mock Event Bus to isolate stories
- Use `mockTranslations()` if i18n is involved

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

## Documentation

- Include `readme-notes.md` as docs source (not auto-generated `readme.md`)
- Document props, events, and slots in the notes file
