---
name: memory-leak-detection
description: Analyses UI component code for memory leak patterns — event listener accumulation, subscription cleanup, timer mismanagement, and DOM reference retention — and provides specific remediation steps.
execution: inline
scope: shared
version: v0.1
last-updated: 24/04/2026
---

# Memory Leak Detection

Analyses UI component code for memory leak risks and provides concrete remediation steps. Framework-specific patterns (lifecycle hooks, cleanup APIs) are determined by local repository instruction files.

---

## When to Use

- As part of code review for any UI component
- On-demand for components that use subscriptions, event listeners, timers, or hold DOM references
- After changes to component lifecycle or event handling logic

---

## Inputs

- Component file paths (implementation, any service/helper files)
- Local repository instruction files (`.github/instructions/` or equivalent)

---

## Instructions

### 1. Load Local Instruction Files

Read local instructions to understand:
- Component lifecycle hooks for setup and teardown (e.g. `connectedCallback`/`disconnectedCallback`, `useEffect` cleanup, `ngOnDestroy`, `onMounted`/`onUnmounted`)
- Approved patterns for subscriptions (e.g. event-bus, RxJS, custom events)
- Framework-specific memory management patterns

### 2. Event Listener Audit

- Find every `addEventListener` call
- Verify a corresponding `removeEventListener` exists in the teardown lifecycle hook
- Check that the same function reference is used for both add and remove
- Flag any anonymous function listeners (they cannot be removed)

### 3. Subscription Audit

- Find every subscription to observables, event buses, or pub/sub systems
- Verify each subscription is unsubscribed / unregistered in the teardown lifecycle hook
- Check for subscription accumulation in lifecycle hooks that run multiple times (e.g. re-renders without cleanup)

### 4. Timer Audit

- Find every `setTimeout`, `setInterval`, `requestAnimationFrame`
- Verify each is cleared (`clearTimeout`, `clearInterval`, `cancelAnimationFrame`) in the teardown lifecycle hook or on condition change

### 5. DOM Reference Audit

- Find component-level properties or refs holding DOM node references
- Verify references are nulled in teardown or when no longer needed
- Check for closures that inadvertently retain large DOM subtrees

### 6. Render Loop Audit (where applicable)

- Check for state updates that trigger infinite render cycles
- Verify list rendering uses stable keys (prevents unnecessary DOM churn)
- Check that derived values are memoised where appropriate

---

## Findings Format

For each issue found:
- **Location**: file path + line number or code block
- **Pattern**: what type of leak (listener, subscription, timer, DOM reference)
- **Risk**: what will happen if not fixed (listener accumulation, heap growth, etc.)
- **Fix**: exact code change required, including the teardown lifecycle hook where cleanup should go

---

## What NOT to Do

- ❌ Assume teardown is handled without verifying the code
- ❌ Accept anonymous function listeners without flagging them
- ❌ Skip subscription audits for components that use event-bus or pub/sub

---

## Output

- List of memory leak risks with location, pattern, risk, and fix
- Verdict: Clean ✅ / Issues Found ❌
- Priority order for fixes (blocking regressions first)
