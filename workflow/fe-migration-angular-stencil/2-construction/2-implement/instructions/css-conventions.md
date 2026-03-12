# CSS Conventions

Also read: `knowledge-core/shadow-dom-css-rules.md` (two mandatory rules that cause invisible styling failures) and `sass-standards.md` (SCSS-specific formatting).

## Design Tokens (FDS)

Use FDS tokens only. No hardcoded values.

| Category | Pattern | Examples |
|----------|---------|---------|
| Colors | `--fds-{role}` | `--fds-primary`, `--fds-surface`, `--fds-on-surface-hi` |
| Spacing | `--fds-spacing-{scale}` | `--fds-spacing-050`, `--fds-spacing-200`, `--fds-spacing-600` |
| Typography | `--fds-{category}-{weight}` | `--fds-paragraphs-regular`, `--fds-headline-regular` |
| Radius | `--fds-radius-{scale}` | `--fds-radius-100`, `--fds-radius-200` |

## Shadow DOM CSS Scoping (mandatory)

See `knowledge-core/shadow-dom-css-rules.md` for full details. Summary:

1. **Never put the BEM root class on `<Host>`** — put it on a wrapper `<div>` inside `<Host>`
2. **Write flat SCSS selectors only** — no `&-` BEM nesting (Stencil's bundler emits CSS Nesting which silently fails in shadow DOM)

## Inline Styles (avoid by default)

Do not use inline `style=""` or TSX `style={...}`. Use CSS classes and component stylesheets. Exception: dynamic per-instance values where a class is not practical — use CSS custom properties as the bridge:

```tsx
<div class="card" style={{ '--card-gap': `${gapPx}px` }} />
```

```scss
.card { gap: var(--card-gap); }
```

## Responsive Layout — Hybrid Approach (mandatory)

App MFEs run inside shadow DOM at varying widths. A `@media` query reacts to the **viewport**, which the MFE cannot control. **Never use `@media` for component-level responsive layout.** Use the hybrid approach below.

### Step 1 — `display: block` on `:host`

Custom elements default to `display: inline`. An inline host measures content width, so responsive techniques fire at the wrong threshold.

```scss
:host {
  display: block;
}
```

### Step 2 — Grid column count with `auto-fit`

Use `repeat(auto-fit, minmax(min(MIN_COL_PX, 100%), 1fr))`. The grid self-organises — no `@container` rule needed for column count.

```scss
.my-widget-selections {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(min(200px, 100%), 1fr));
  gap: var(--genos-spacing-m) var(--genos-spacing-l);
}
```

### Step 3 — Structural layout changes with `@container`

Put `container-type: inline-size` on the **outermost element inside the shadow root** (not on `:host`). Placing it on `:host` requires queries to cross the shadow host boundary, which is unreliable in Stencil's compiled output.

```scss
.my-widget {
  display: block;
  container-type: inline-size;
  container-name: my-widget;
}
```

Write `@container` rules **outside** the BEM block. Only use them for structural changes (flex direction, borders, padding) — not column count.

```scss
@container my-widget (min-width: 632px) {
  .my-widget-container { flex-direction: row; }
  .my-widget-content { border-right: 1px solid var(--genos-color-neutral-3); }
}
```

### Step 4 — Constants as single source of truth

Define `MIN_COL_WIDTH_PX` and derive all thresholds. Keeps SCSS and TS in sync.

```typescript
export const MIN_COL_WIDTH_PX = 200;
const GRID_COL_GAP_PX = 16;
export const TWO_COLUMN_MIN_WIDTH_PX = MIN_COL_WIDTH_PX * 2 + GRID_COL_GAP_PX; // 416
export const THREE_COLUMN_MIN_WIDTH_PX = MIN_COL_WIDTH_PX * 3 + GRID_COL_GAP_PX * 2; // 632
```

### Step 5 — `ResizeObserver` for JS-driven item visibility

When the component shows different item counts per column count and has a "Show more" button, JS must know the column count. Use `ResizeObserver` on `this.el`:

```typescript
private observeResize(): void {
  if (typeof ResizeObserver === 'undefined') return;
  this.resizeObserver = new ResizeObserver(() => this.onHostResize());
  this.resizeObserver.observe(this.el);
}

private onHostResize(): void {
  const w = this.el.offsetWidth;
  if (w >= THREE_COLUMN_MIN_WIDTH_PX) this.columnsCount = 3;
  else if (w >= TWO_COLUMN_MIN_WIDTH_PX) this.columnsCount = 2;
  else this.columnsCount = 1;
}
```

Disconnect in `disconnectedCallback`. Do not read `getComputedStyle().gridTemplateColumns`.

### Why not `@container` for column count?

`auto-fit` with `minmax` requires only one constant change for new column counts. `@container` requires one rule per breakpoint and must be kept in sync with TS.

## Specificity

- Avoid `!important`
- Avoid ID selectors (`#id`)
- Avoid element-type + class selectors (`div.card`) unless compelling reason
- Prefer shallow selectors and predictable scopes
- Prefer composition (base + modifier classes, attribute selectors, CSS variables) over override-by-specificity

## Semantic Class Naming

Use names that describe the **thing** or **purpose**, not the visual style.

- ✅ `.info-box`, `.site-nav`, `.market-card`
- ❌ `.purple-info-box`, `.top-left-nav`, `.rounded-checkbox`

## SCSS

- Use `styleUrl: '{component}.scss'` in the component decorator
- **Flat selectors only** — no `&-` BEM nesting (see Shadow DOM rules above)
- No `!important` unless overriding third-party
- Use CSS custom properties for theming, not SCSS variables
- See `sass-standards.md` for SCSS-specific formatting rules

## CSS Custom Property Overrides

| Level | Prefix | Use |
|-------|--------|-----|
| FDS system | `--fds-` | Read-only, consume from design system |
| FDS override | `--libfds-` | Override FDS component internals |
| Domain | `--{domain}-` | Widget-specific theming |
