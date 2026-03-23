# TSX Structure & Semantic HTML5

Use **semantic HTML5 elements first** in all Stencil TSX render output. Prefer correct elements and attributes over `div`/`span` + roles.

## Core Rules

- **Use the right element for the job**:
  - Navigation: `<a href="...">` (not a `<button>`)
  - Action: `<button type="button">` (not a clickable `<div>`)
  - Lists: `<ul>/<ol>/<li>` (not repeated `<div>`s)
  - Tabular data: `<table>/<thead>/<tbody>/<tr>/<th>/<td>`
- **Never make non-interactive elements interactive**:
  - ❌ `<div onClick=...>`, `<span onKeyDown=...>`, `role="button"` on a div
  - ✅ `<button>`, `<a>`, native form controls
- **Logical heading structure**: use `<h1>`–`<h6>`, don't skip levels arbitrarily
- **ARIA only when semantics can't express it**: prefer native semantics; ARIA is the exception
- **Avoid meaningless wrappers**: prefer simpler markup when a wrapper adds no semantics, layout, or behaviour

## Semantic Mapping

| Content | Element |
|---------|---------|
| Paragraphs | `<p>` |
| Inline styling | `<span>` |
| Emphasis | `<strong>`, `<em>` |
| Images | `<img alt="...">` (empty `alt=""` only for decorative) |
| Media with caption | `<figure>` + `<figcaption>` |
| Time / dates | `<time datetime="2026-02-19T18:30:00Z">18:30</time>` |
| Key/value facts | `<dl>`, `<dt>`, `<dd>` |

## Forms

- Always pair inputs with a `<label>` (or `aria-label` when visible label is not possible)
- Prefer native controls (`<button>`, `<input>`, `<select>`, `<textarea>`)

## ARIA / Role Notes

When ARIA/roles are truly needed:
- Ensure **keyboard accessibility** (Tab + Enter/Space)
- Add correct ARIA state/labels (`aria-label`, `aria-expanded`, `aria-disabled`)
- Prefer implementing a real `<button>` / `<a>` internally

## Stencil-Specific

- Use `class="..."` (not `className`) in Stencil TSX
- Use `<Host>` as the component root; use semantic elements inside it
- Custom elements use kebab-case with a hyphen (e.g. `<sb-xp-carousel>`)

## Examples

```tsx
// ✅ Action
<button type="button" class="sb-xp-market__cta" onClick={this.onAdd}>
  Add to betslip
</button>

// ✅ Navigation
<a class="sb-xp-link" href={this.href}>
  View all markets
</a>

// ✅ List
<ul class="sb-xp-list">
  {items.map(item => (
    <li class="sb-xp-list__item" key={item.id}>{item.label}</li>
  ))}
</ul>
```
