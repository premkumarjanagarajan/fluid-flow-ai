# Typography and Genos Rules (mandatory)

Two non-negotiable architectural constraints for migrated components.

## Rule 1 — Use `fds-sb-typography` for all typography

Do **not** apply raw Genos typography classes (e.g. `genos-heading-h2`, `genos-body-regular`) directly to elements in TSX templates. All typography must go through the `<fds-sb-typography>` design component.

```tsx
// ❌ WRONG — raw Genos typography class
<h2 class="genos-heading-h2">{this.title}</h2>

// ✅ CORRECT — fds-sb-typography with matching variant and semantic tag
<fds-sb-typography variant="heading-h2" tag="h2">{this.title}</fds-sb-typography>
```

**`variant` values** map directly to Genos typography names (drop the `genos-` prefix):
`heading-h1` · `heading-h2` · `heading-h3` · `heading-h4` · `heading-h5` · `heading-h6` · `subtitle-lead` · `subtitle-regular` · `subtitle-small` · `subtitle-tiny` · `body-lead` · `body-regular` · `body-small` · `body-tiny` · `typo-extra-caption` · `typo-extra-body-lead-extra-bold` · `typo-extra-heading-h6-bold`

**`tag` values:** `h1` · `h2` · `h3` · `h4` · `h5` · `h6` · `p` · `span` · `div` — always choose the semantically correct element.

## Rule 2 — Genos CSS variables are forbidden in new components

Do **not** use Genos CSS custom properties (`var(--genos-color-*)`, `var(--genos-spacing-*)`, `var(--genos-typography-*)`, or any `var(--genos-*)`) in any new or migrated component. These are Angular/Genos design system concerns not supported in the Stencil MFE architecture.

```scss
// ❌ WRONG — Genos CSS variable
.my-widget-panel {
  border-color: var(--genos-color-neutral-3);
  gap: var(--genos-spacing-m);
}

// ✅ CORRECT — project SCSS variables or design tokens
.my-widget-panel {
  border-color: $color-neutral-3;
  gap: $spacing-m;
}
```

If no equivalent project variable exists, document the gap and agree with the team on the correct token before implementing.

## Impact

These rules affect:
- **1.2 Analyze** — Angular analysis must scan for Genos typography classes and CSS variables and flag them
- **1.5 Design** — Architecture must specify `fds-sb-typography` replacements
- **2.2 Implement** — Components must use `fds-sb-typography`, not raw classes
- **2.5 Review** — Code review must flag any Genos class or CSS variable as MUST-FIX
