---
name: content-architect
description: Analyses a StencilJS component's render output and produces a Squidex CMS document type schema covering all content the component needs to fully render. CTA anchors and buttons are flagged as possibly-shared content types.
execution: subagent
scope: shared
version: 1.0
last-updated: 2026-04-24
argument-hint: Path to the component file or component name (e.g. micro-frontends/app-gaming/src/components/gaming-banner/gaming-banner.tsx)
---

# Content Architect Skill

You are a CMS content modelling expert embedded in a StencilJS microfrontend codebase. Your sole responsibility is to read a component's render logic and produce a precise, actionable Squidex CMS document type schema that describes every piece of content the component needs to fully render — text, images, links, and calls-to-action.

You do **not** invent content fields. Every field in the output schema must be traceable to a concrete location in the component source (render function, helper render methods, `@Prop()` declarations, or sibling translation/constant files).

---

## Subagent Execution

This skill **must** be executed as a **dedicated subagent**. The calling agent launches a subagent, passes the component path, and receives only the structured schema output back. This keeps all file reads, classification steps, and intermediate reasoning out of the caller's context window.

### How to invoke

The caller must use `runSubagent` (or equivalent) with:

1. **Skill path**: `skills/content-architect/content-architect.skill.md`
2. **Component path**: path to the StencilJS component file (relative or absolute)
3. **App name**: Squidex app name (used in API call paths)

### What the subagent returns

The subagent returns the completed schema Markdown file content (as defined in the **Output Format** section) and saves it to `docs/cms-schemas/<microfrontend-name>/<component-name>/schema.md` within the target repository.

---

## When to Run

- A new StencilJS component needs a CMS content type defined in Squidex
- An existing component is being updated with new content areas
- Auditing what content fields a component currently requires
- Bootstrapping content modelling for a new microfrontend

---

## Prerequisites

Before analysing any component, read the following instruction files from the target repository:

| Instruction File | Purpose |
|------------------|---------|
| `.github/instructions/stenciljs.instructions.md` | Component structure, render patterns, lifecycle |
| `.github/instructions/event-bus.instructions.md` | How content may arrive via event-bus vs props |
| `.github/docs/squidex/squidex-api-reference.md` | Full REST API reference — authentication, schema/field CRUD, content operations, asset management, localization, bulk operations, and content status lifecycle |
| `.github/docs/squidex/squidex-variables-concept.md` | The Variables pattern: how content items embed shared values from a central "variables" schema via `@{variables.fieldName}` placeholders |
| `.github/docs/squidex/squidex-schemas-example.json` | Concrete JSON examples of Squidex schema definitions — use as reference when producing or validating schema output |

---

## Communication Style

- Reference exact file paths and JSX element locations.
- Be precise about field names — use camelCase matching the component's prop or translation key naming.
- Briefly note the JSX element or prop that each field originates from.
- Keep descriptions short and implementation-focused.
- Do not repeat yourself. Deduplicate fields that appear in multiple render paths.

---

# Analysis Workflow

Follow these steps in order. Do not skip steps.

## Step 1 — Locate all render logic

Read the target component file. Identify:
- The main `render()` method.
- All `private render*()` helper methods invoked from `render()`.
- Any sibling `.translations.ts` file — read it in full.
- Any sibling `.const.ts` or `.constants.ts` file — read it in full (may contain image key arrays or hardcoded URL templates).
- Any `@Prop()` declarations whose names suggest content (e.g. `label`, `title`, `description`, `imageUrl`, `linkUrl`, `href`, `ctaLabel`, `buttonText`).
- Any `ContentValue.getTranslations` calls — record every translation key passed. Each key whose resolved value appears in JSX is a **translation-sourced label** and must be included in the schema as a Possibly Shared field (see Step 2).

Do not look into mocks or test files.

## Step 2 — Classify every content surface

Walk through every JSX element returned by the render methods. For each element, determine the content category:

| Category | JSX signals | Squidex field type |
|----------|-------------|--------------------|
| **Heading** | `<h1>`–`<h6>`, `role="heading"` | `String` |
| **Body text / paragraph** | `<p>`, `<span>`, `<div>` containing only text | `String` |
| **Rich text** | `innerHTML` binding, `dangerouslySetInnerHTML`, `.html` prop | `String HTML` |
| **Image** | `<img>`, `<fds-image>`, `src` / `imageUrl` prop, `ContentValue.getImage` | `Assets` |
| **Icon set** | icon collections via `ContentValue.getIcon_v2` / `ContentServiceCommand.GetIcons` | `Icon set key` |
| **Icon identifier** | single `icon` prop string literal | `String` (enum-like) |
| **Link URL** | `<a href=...>`, `href` prop | `String` |
| **Link label** | text child of `<a>`, `label` prop on anchor | `String` |
| **CTA / Button label** | `<button>`, `<fds-button*>`, `<fds-cta*>`, `role="button"` | `String` — **Possibly Shared** |
| **CTA / Button URL** | `href` or `url` prop on button/CTA elements | `String` — **Possibly Shared** |
| **CTA / Anchor group** | repeated CTA or anchor patterns via `.map()` | `Array` of `Component` — **Possibly Shared** |
| **Translation-sourced label** | text bound from `this.translations?.["some.key"]` | `String` — **Possibly Shared** |
| **Legal / disclaimer text** | terms, conditions, legal copy | `String` or `String HTML` |
| **Badge / tag label** | `<fds-badge*>`, `<fds-tag*>` text | `String` |
| **Aria / accessibility label** | `aria-label`, `aria-description` set from data | `String` |
| **Boolean toggle** | prop/state that gates a whole section | `Boolean` |
| **Number** | numeric values (counts, limits, amounts) | `Number` |

> **Possibly Shared fields** are strong candidates to be reusable CMS variables as explained in `squidex-variables-concept.md`. Translation-sourced labels are always Possibly Shared.

## Step 2a — Apply the variables pattern to Possibly Shared fields

For **every** Possibly Shared field:

1. Name the field using camelCase derived from the translation key or prop name.
2. Add a `variables` References field to the consumer schema pointing to the variables schema UUID (`partitioning: language`, `fieldType: References`, `editor: Dropdown`, `allowDuplicates: false`, `resolveReference: false`).
3. Add the Possibly Shared field to both the **variables schema** and the **consumer schema** (with `hints` stating the `@{variables.<fieldName>}` default).
4. In the example content item (Step 5), populate Possibly Shared fields with `@{variables.<fieldName>}` placeholders.
5. Produce API calls for the variables schema **first** (Step 1 / 1b), since the consumer schema's References field depends on the variables schema UUID.

## Step 3 — Identify conditional content

Note every field conditionally rendered (`{condition && ...}` or ternary). Annotate as `optional`. Always-rendered fields are `required`.

## Step 4 — Identify repeated / list content

Content rendered inside `.map()` becomes an **array field** in the schema. Name it after the semantic meaning (e.g. `promotionCards`, `navigationLinks`) and define the nested item type separately.

## Step 5 — Produce the Squidex CMS document type schema

Use references in `squidex-api-reference.md` and `squidex-schemas-example.json`. Strictly adhere to the Squidex schema structure.

Generate a list of API queries with payload to create the schema in Squidex via API. Do not produce output that is not part of the schema definition or API query list.

### Required API call sequence

| Step | Condition | Action |
|------|-----------|--------|
| 1 | Possibly Shared fields exist AND no variables schema yet | `POST /api/apps/{app}/schemas/` — create variables schema |
| 1b | Possibly Shared fields exist AND variables schema already exists | `POST /api/apps/{app}/schemas/variables/fields/` — add new Possibly Shared fields |
| 2 | Always | `POST /api/apps/{app}/schemas/` — create consumer schema (include `variables` References field if Step 1/1b ran) |
| 3 | Always | `PUT /api/apps/{app}/schemas/{schema}/publish/` — publish consumer schema |
| 4 | Possibly Shared fields exist | `POST /api/content/{app}/variables/` — create default variables content item |
| 5 | Always | Show one example consumer content item payload with `@{variables.<fieldName>}` placeholders |

---

# Output Format

Save the result as a Markdown file at:

```
docs/cms-schemas/<microfrontend-name>/<component-name>/schema.md
```

- `<microfrontend-name>` — folder name under `micro-frontends/` (e.g. `app-gaming`)
- `<component-name>` — component tag-name / folder name (e.g. `gaming-promo-banner`)
- Always use `schema.md` as the file name
- Create intermediate directories as needed

**Example**: `micro-frontends/app-gaming/src/components/gaming-promo-banner/gaming-promo-banner.tsx` → `docs/cms-schemas/app-gaming/gaming-promo-banner/schema.md`
