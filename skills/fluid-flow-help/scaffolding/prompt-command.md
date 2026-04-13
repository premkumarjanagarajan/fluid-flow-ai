# Scaffolding: Prompt / Command

Create entry-point files so the user can invoke a capability with a slash command.

---

## Guided Creation

Ask **one question at a time**:

1. **"What should happen when someone types this command?"**
   — Get a clear description of the expected behaviour.

2. **"Does it trigger something that already exists, or do we need to create the thing it triggers too?"**
   — If a new skill is needed, load `scaffolding/skill.md` first, then return here.

3. **"What should the command be called?"**
   — Convention: `ff-{name}` prefix for Fluid Flow commands.

---

## Scaffold

Create both entry-point files with matching content:

**Cursor** — `{DEPT_FF_PATH}/.cursor/commands/ff-{name}.md`:

```markdown
Run the {skill-name} skill from `skills/{skill-name}/{skill-name}.md`.

{Any additional context or instructions for the AI.}
```

**GitHub Copilot** — `{DEPT_FF_PATH}/.github/prompts/ff-{name}.prompt.md`:

```markdown
Run the {skill-name} skill from `skills/{skill-name}/{skill-name}.md`.

{Any additional context or instructions for the AI.}
```

Show the user how to invoke it: "Type `/ff-{name}` in the chat to run this."

After creation, return to the caller (Completion).
