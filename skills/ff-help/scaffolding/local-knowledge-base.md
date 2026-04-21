# Scaffolding: Local Knowledge Base

This is the **most common customisation**. The local KB is department-specific knowledge that the AI loads alongside the enterprise KB during every workflow run.

---

## What is the local KB?

```
The local knowledge base is department-specific knowledge that the
AI loads alongside the enterprise KB during every workflow run.

It lives at {dept}-fluid-flow/knowledge-base-local/
A manifest.md file controls what gets loaded and when.
```

---

## Guided Setup

Ask **one question at a time**:

1. **"What specific knowledge should the AI have? Give me as much detail as you can — rules, conventions, decisions, standards."**
   — Domain rules, team conventions, architectural decisions, compliance requirements, coding standards, etc.

2. **"Should the AI always use this knowledge, or only when working on certain types of changes?"**
   — Always-load (like team coding standards) vs conditional (like specific compliance rules).

Then:

1. Set `knowledgeBaseLocal` to `true` in `{DEPT_FF_PATH}/.department-fluid-flow.json`
2. Create `{DEPT_FF_PATH}/knowledge-base-local/manifest.md`:

```markdown
# Local Knowledge Base Manifest

## Always Load

- Load `{file}.md` -- {description}

## Conditional: {Domain}

- Load `{file}.md` -- {description}
```

3. Create the referenced knowledge files based on what the user described
4. Briefly explain: "The orchestrator reads this manifest and loads these files into the AI's context during workflows. Always-load files are loaded for every step. Conditional files load when the step matches the domain."

After setup, return to the caller (Completion).
