# CSS Conventions

## Design Tokens (FDS)

Use FDS tokens only. No hardcoded values.

| Category | Pattern | Examples |
|----------|---------|---------|
| Colors | `--fds-{role}` | `--fds-primary`, `--fds-surface`, `--fds-on-surface-hi` |
| Spacing | `--fds-spacing-{scale}` | `--fds-spacing-050`, `--fds-spacing-200`, `--fds-spacing-600` |
| Typography | `--fds-{category}-{weight}` | `--fds-paragraphs-regular`, `--fds-headline-regular` |
| Radius | `--fds-radius-{scale}` | `--fds-radius-100`, `--fds-radius-200` |

## Container Queries Only

- No media queries. Use container queries for responsive layout.
- Set `container-type: inline-size` on the host or wrapper element.
- Query with `@container` rules.

```scss
:host {
  container-type: inline-size;
}

@container (min-width: 640px) {
  .card-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}
```

## SCSS

- Use `styleUrl: '{component}.scss'` in the component decorator
- Nest selectors per BEM-like structure
- No `!important` unless overriding third-party
- Use CSS custom properties for theming, not SCSS variables

## CSS Custom Property Overrides

| Level | Prefix | Use |
|-------|--------|-----|
| FDS system | `--fds-` | Read-only, consume from design system |
| FDS override | `--libfds-` | Override FDS component internals |
| Domain | `--{domain}-` | Widget-specific theming |
