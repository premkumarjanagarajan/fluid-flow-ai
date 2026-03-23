# Naming Conventions

## Component Tags

Format: `{prefix}-{domain}-{name}_{type}`

| Part | Description | Examples |
|------|-------------|---------|
| prefix | Organisation prefix | `sb-xp`, `fds` |
| domain | Feature domain | `betting`, `account`, `gaming` |
| name | Component name | `popular-bets`, `carousel` |
| type | Component classification | `component`, `control` |

Examples:
- `sb-xp-betting-popular-bets_component`
- `fds-button_control`

## File Naming

| Type | Pattern | Example |
|------|---------|---------|
| Component | `{tag-name}.tsx` | `sb-xp-popular-bets.tsx` |
| Styles | `{tag-name}.scss` | `sb-xp-popular-bets.scss` |
| Tests | `{tag-name}.spec.tsx` | `sb-xp-popular-bets.spec.tsx` |
| Stories | `{tag-name}.stories.ts` | `sb-xp-popular-bets.stories.ts` |
| Docs | `readme-notes.md` | (not auto-generated `readme.md`) |

## Folder Structure

```
src/components/{widget-name}/
  {root-component}.tsx
  {root-component}.scss
  {child-component}.tsx
  {child-component}.scss
  tests/
    {component}.spec.tsx
    {component}.mock.ts
```

## CSS Custom Properties

| Scope | Prefix | Example |
|-------|--------|---------|
| FDS design system | `--fds-` | `--fds-spacing-200` |
| FDS component override | `--libfds-` | `--libfds-button-padding` |
| Domain MFE | `--{domain}-` | `--betting-card-bg` |
