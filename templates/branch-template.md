# Branch Template

Naming convention for initiative folders.

## Pattern

`{type}/{jira-ticket}-{short-description}`

| Part | Description |
|------|-------------|
| **type** | `feature/`, `fix/`, `bug/`, `chore/`, `refactor/`, `docs/` |
| **jira-ticket** | JIRA ticket ID (e.g. `DIT-179`). Omit if no ticket. |
| **short-description** | 2-4 word kebab-case summary |

## Examples

- `feature/DIT-179-budget-stage5`
- `fix/GXD-1732-header-alignment`
- `bug/PROJ-456-dropdown-overflow`
- `chore/update-dependencies`

## Folder Structure

```
initiatives/{name}/
  metadata/
    state.md
    audit.md
    analytics.md
```
