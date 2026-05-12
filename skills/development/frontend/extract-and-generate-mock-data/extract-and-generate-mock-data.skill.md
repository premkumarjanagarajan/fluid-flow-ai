---
name: extract-and-generate-mock-data
description: Extracts text content and image assets from JIRA tickets and Figma designs and generates structured mock data covering all component variants and states.
execution: inline
scope: shared
version: v0.1
last-updated: 24/04/2026
dependencies:
  mcps:
  - mcps/atlassian.md
  - mcps/figma.md
---

# Extract and Generate Mock Data

Extracts all text content and images from JIRA requirements and Figma designs, then generates structured mock data for use in component tests and stories.

---

## When to Use

- After component discovery, before component code generation
- Whenever a component requires realistic test/story data
- When updating component stories to reflect new design content

---

## Inputs

- JIRA ticket key and content (from JIRA analysis output)
- Figma design URL with node-id
- Local repository path for image assets (e.g. `public/mocked-images/` or equivalent)

---

## Instructions

### 1. Extract Text Content

From JIRA:
- Ticket description, acceptance criteria, and comments
- User stories, use cases, example copy
- Error messages, edge case descriptions

From Figma design:
- All text layers across all frames and variants
- Button labels and CTAs
- Input placeholders and labels
- Error, validation, empty, loading, and success messages

### 2. Extract Image Assets from Figma

- Use Figma MCP `get_design_context` with the node ID
- Extract image URLs from the response
- Download images and save to the local repository's mocked-images folder
- Use descriptive filenames reflecting the image content

**MCP fallback:** If `get_design_context` returns an asset URL (`<img src="...">`):
1. Call `get_metadata` on the node to find the inner image node
2. Call `get_design_context` on the inner node
3. If still an asset URL, fetch it directly — the response is the image file
4. Save with a descriptive filename

### 3. Create Mock Data Variants

Generate variants covering all component states:

| Variant | Purpose |
|---------|---------|
| `default` | Standard content matching the primary design |
| `short` | Minimal text — tests truncation behaviour |
| `long` | Maximum text — tests wrapping and overflow |
| `error` | Error state messaging |
| `success` | Success/confirmation messaging |
| `empty` | Empty state messaging |
| `loading` | Loading state text |

Add additional variant-specific mocks as needed for the component.

### 4. Generate Output File

- Create mock data file following local repository conventions (TypeScript export objects, JSON, or equivalent)
- Use realistic content from the actual design — not "Lorem ipsum" or placeholder text
- Reference images by their saved local path
- Name exports consistently: `MOCK_{COMPONENT}_{VARIANT}` or equivalent local convention
- Include a header documenting JIRA ticket key, Figma URL, and generation timestamp

---

## What NOT to Do

- ❌ Use placeholder or Lorem ipsum content
- ❌ Skip any component state (error, loading, empty, etc.)
- ❌ Use external image placeholder services
- ❌ Forget to document JIRA and Figma sources in the file header

---

## Output

- Mock data file at the path defined by local repository conventions
- All variants populated with realistic content
- Images saved to the local mocked-images folder with references in the mock file
- Source documentation (JIRA ticket, Figma URL) in the file header
