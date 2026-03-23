# Performance Best Practices

Apply these during implementation. Performance budgets for the target repo live in `docs/architecture.md`.

## Rules

1. **Lazy loading**: defer non-critical images and components
2. **Bundle size**: keep MFEs lightweight and focused — avoid unnecessary dependencies
3. **GPU acceleration**: use `transform` / `translate3d()` for animations. Use `will-change` only as a **last resort** for existing performance problems — overuse increases memory and can worsen performance. Toggle `will-change` via script when a change is about to happen, then reset to `auto`
4. **Efficient observers**: use `ResizeObserver` on `this.el` instead of window resize events — it is cheap and scoped to the element
5. **Conditional loading**: load first few items eagerly, rest lazy
6. **Avoid forced recalculations**: do not read `getComputedStyle().gridTemplateColumns` — it forces a style recalculation and returns a string that must be parsed. Use `offsetWidth` comparisons instead
7. **Clean up**: disconnect `ResizeObserver`, Event Bus subscriptions, and any listeners in `disconnectedCallback`
