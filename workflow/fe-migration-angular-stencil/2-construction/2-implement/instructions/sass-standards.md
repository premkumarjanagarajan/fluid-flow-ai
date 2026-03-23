# SASS/SCSS Standards

SASS/SCSS-specific conventions. For general CSS rules (specificity, shadow DOM scoping, responsive layout), see `css-conventions.md` and `knowledge-core/shadow-dom-css-rules.md`.

## Syntax & Formatting

- One selector per line, one rule per line
- Zero values: use `0` (no unit) for zero lengths; use leading zeros (`0.5rem`, not `.5rem`)
- Strings: use double quotes
- No hand-written vendor prefixes — rely on tooling

## Colours

- Prefer lowercase shortened hex (`#fff`) or `rgb/rgba` or `hsl/hsla`
- Avoid colour keywords (`white`, `red`) unless compelling reason

## Ordering Within a Rule Block

1. `@extend` (prefer `%placeholders`)
2. `@include`
3. Properties
4. Pseudo-classes / pseudo-elements (`&:hover`, `&::after`)
5. Attribute selectors (`&[aria-disabled="true"]`, `&[data-state="loading"]`)
6. Nested selectors / nested classes

## Ampersand (`&`) Usage

Use `&` for pseudo-classes/elements. **Do NOT use `&-suffix` for BEM nesting** — see `knowledge-core/shadow-dom-css-rules.md` Rule 2.

```scss
// ✅ Pseudo-classes and modifiers — these are safe
.login {
  &:hover { text-decoration: underline; }
  &::after { content: ""; }
}

// ❌ &-suffix BEM nesting — breaks in shadow DOM
.my-widget { &-panel { display: flex; } }

// ✅ Flat BEM — always works
.my-widget-panel { display: flex; }
```

## Mixins, Placeholders, Functions

- Prefer `@extend` on `%placeholders`, not real selectors
- Use mixins when they take arguments (generate different output)
- Prefer functions for calculations (return values, don't emit CSS)
- Prefer maps for evolving option sets

## Modules: `@use` / `@forward`

Prefer `@use` / `@forward` over deprecated `@import`. Import only what you need.

```scss
@use "sass:map";
@use "../tokens/spacing" as spacing;
@use "../mixins/typography" as type;

.card {
  @include type.body-regular;
  padding: spacing.$m;
}
```

## General

- Keep nesting to 1–2 levels, maximum 3
- Prefer readability (KISS) over excessive DRY abstraction
