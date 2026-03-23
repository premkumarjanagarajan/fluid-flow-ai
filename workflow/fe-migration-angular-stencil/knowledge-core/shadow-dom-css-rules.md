# Shadow DOM CSS — Two Mandatory Rules

These rules apply to every Stencil component using `shadow: true`. They are the most common source of invisible styling failures — the component renders its data correctly but appears completely unstyled.

## Rule 1 — Never put the BEM root class on `<Host>`

In Stencil's `render()`, the `<Host>` element IS the custom element (e.g. `<sb-xp-my-widget>`). It lives in the **light DOM**, not inside the shadow root. The shadow-root stylesheet's plain class selectors (`.my-widget`, `.my-widget-panel`) can only match elements **inside** the shadow root — they cannot match the host element itself.

If you write `<Host class="my-widget">`, every CSS rule inside `.my-widget { ... }` silently matches nothing.

```tsx
// ❌ WRONG — class is on the host (light DOM); CSS rules match nothing
<Host class="my-widget" data-test-id="my-widget">
  <div class="my-widget-panel">...</div>
</Host>

// ✅ CORRECT — wrapper div is inside the shadow root; CSS matches it
<Host data-test-id="my-widget">
  <div class="my-widget">
    <div class="my-widget-panel">...</div>
  </div>
</Host>
```

For the **error/hidden state**, keep the modifier on `<Host>` and use `:host(.class)` in SCSS:

```tsx
<Host class="my-widget--hidden" data-test-id="my-widget">
  <span style={{ display: 'none' }} />
</Host>
```

```scss
:host(.my-widget--hidden) {
  display: none;
}
```

## Rule 2 — Write flat SCSS selectors only (no `&-` BEM nesting)

Stencil's CSS bundler re-emits SCSS nesting (`.my-widget { &-panel { ... } }`) as **CSS Nesting Level 1** syntax. CSS Nesting `&-suffix` concatenation is unreliable in shadow DOM `adoptedStyleSheets` — the nested rules silently do not apply.

```scss
// ❌ WRONG — Stencil's bundler outputs CSS Nesting; unreliable in shadow DOM
.my-widget {
  display: block;
  &-panel { display: flex; }
  &-selections { display: grid; }
}

// ✅ CORRECT — flat selectors; always works
.my-widget        { display: block; }
.my-widget-panel  { display: flex; }
.my-widget-selections { display: grid; }
```

`@container`, `@keyframes`, pseudo-classes (`:host`, `:disabled`, `:hover`) and attribute selectors are fine — only `&-suffix` concatenation is problematic.

## Diagnosis

If a widget renders its data but appears completely unstyled:

1. Open `dist/components/index.js` and search for `static get style()`
2. **Cause A**: If the CSS string has `.my-widget{...}` but the host element has `class="my-widget"` — the class is on the host (Rule 1 violation)
3. **Cause B**: If the CSS string contains `&-panel` or other `&-` patterns — Stencil emitted CSS Nesting (Rule 2 violation)
