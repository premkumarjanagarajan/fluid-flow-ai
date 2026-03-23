# Project Workflows

Conventions for scaffolding, branching, and code quality.

## Using Templates

Based on target type, scaffold from the appropriate template:

```bash
# New app-mfe
cp -r templates/apps/app-mfe apps/my-new-widget

# New service-mfe
cp -r templates/services/service-mfe services/my-new-service

# New TypeScript library
cp -r libs/contracts libs/my-new-lib
```

After copying: update `package.json`, `stencil.config.ts`, component files, then `pnpm install`.

## When to Create What

| app-mfe | service-mfe | design-system | typescript library |
|---------|-------------|---------------|-------------------|
| User-facing feature | Shared business logic | Reusable UI element | Pure utilities |
| Standalone widget | API client | Presentation-only | Type definitions |
| Has unique route | Authentication | Framework-agnostic UI | Data transformers |

## Branch Naming

Format: `<type>/<JIRA-KEY>-<short-kebab-summary>`

Examples:
- `feature/SBEUJE-1234-migrate-carousel-widget`
- `bugfix/SBXP-2211-fix-event-payload-shape`

Types: `feature/`, `bugfix/`, `hotfix/`, `refactor/`, `docs/`, `chore/`, `spike/`

If the correct type is unclear, **ask the developer** rather than guessing.

## Code Quality Checklist (before committing)

- [ ] Tests pass (`pnpm test`)
- [ ] Lint passes (`pnpm lint`)
- [ ] Code is formatted (`pnpm format`)
- [ ] Types are correct (avoid `any` unless truly necessary)
- [ ] Documentation updated if needed
- [ ] Storybook story created/updated (if the change affects UI/components)

## `.gitkeep` Hygiene

If you add real files to a previously-empty template folder that contains a `.gitkeep`, **remove the `.gitkeep`** so it doesn't linger in non-empty folders.

## Storybook Event Bus Mocking Hygiene

When creating or updating stories with Event Bus interactions:

1. **Check for existing mocks first** — do not duplicate
2. **Add missing mocks** if a required event mock is not present
3. **Remove duplicates** — single source of truth per event
4. **Validate correctness** — mocked payloads must match the actual event contract
5. **If unsure what to mock** — ask the user and wait

### Central Mock File Structure

```
.storybook/mocks/
├── index.js          ← imports all mock files, exports registerAll()
├── context.js        ← sb-xp:context:get:v1 mock (always present)
└── <widget>.js       ← widget-specific mocks (one per widget/domain)
```

`preview.js` calls `registerAll` in its `beforeEach`, so all registered mocks are active before every story and cleaned up afterwards.
