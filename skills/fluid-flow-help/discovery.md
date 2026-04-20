# Discovery Scan

Scan the workspace and present a summary of everything available — core and department. This gives the user a map before they think about customising anything.

---

## What to Scan

1. **Workflows** — Read frontmatter (`workflow-name`, `workflow-description`) from all `wf-*.md` files in:
   - `{FF_CORE_PATH}/workflow/*/wf-*.md` (core)
   - `{DEPT_FF_PATH}/workflows/*/wf-*.md` (department, if any)

2. **Skills** — List all skill folders (folder name = skill name) from:
   - `{FF_CORE_PATH}/skills/*/` (core)
   - `{DEPT_FF_PATH}/skills/*/` (department, if any)

3. **Prompts / Commands** — List all entry-point files from:
   - `{FF_CORE_PATH}/.cursor/commands/*.md` and `{FF_CORE_PATH}/.github/prompts/*.prompt.md` (core)
   - `{DEPT_FF_PATH}/.cursor/commands/*.md` and `{DEPT_FF_PATH}/.github/prompts/*.prompt.md` (department, if any)

4. **MCP Tools** — Read server names from:
   - `{FF_CORE_PATH}/.cursor/mcp.json` (core)
   - `{DEPT_FF_PATH}/.cursor/mcp.json` (department, if any)

5. **Local Knowledge Base** — Check if `{DEPT_FF_PATH}/.department-fluid-flow.json` has `knowledgeBaseLocal: true` and whether `{DEPT_FF_PATH}/knowledge-base-local/manifest.md` exists.

---

## How to Present

Display a compact inventory. Mark the source of each item (`[core]` vs `[dept]`):

```
Here's what's available in your workspace:

  Workflows:
    - fast-track — Streamlined spec-to-implementation pipeline  [core]
    - comprehensive-path — Full enterprise SDLC                 [core]
    - {name} — {description}                                    [dept]

  Skills:
    - reverse-engineering       [core]
    - mcp-check                 [core]
    - environment-detection     [core]
    - retrospective             [core]
    - jira-ff-assisted          [core]
    - shell-detection           [core]
    - fluid-flow-help           [core]
    - ff-audit                  [core]
    - {name}                    [dept]

  Commands:
    /fluid-flow                 [core]
    /ff-reverse-engineer        [core]
    /ff-audit                   [core]
    /ff-help                    [core]
    /{name}                     [dept]

  MCP Tools:
    - atlassian                 [core]
    - slack                     [core]
    - github                    [core]
    - aws-document-loader       [core]
    - {name}                    [dept]

  Local Knowledge Base:
    - {Configured / Not configured}
    - {N files in manifest / No manifest yet}
```

**Do not hardcode the list above** — always scan the actual workspace. The example shows what a typical result looks like. If a section has no department items, show `(none yet)` to hint that it's available for customisation.

If the local KB is configured, list the always-load files from the manifest.
