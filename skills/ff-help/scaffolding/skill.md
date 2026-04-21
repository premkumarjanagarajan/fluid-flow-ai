# Scaffolding: Skill

Create a reusable, self-contained procedure in the department repo.

---

## Guided Creation

Ask **one question at a time** — only ask the next question after the user answers:

1. **"Walk me through exactly what should happen, step by step, when this runs."**

2. **"What information does it need to start?"**
   — Files, user input, data from a tool?

3. **"What should the end result be?"**
   — Files created, a report, changes to code, a summary?

---

## Scaffold

Once the answers are gathered:

1. Create `{DEPT_FF_PATH}/skills/{skill-name}/{skill-name}.md` following this structure:

```markdown
# {Skill Name}

{One-line description.}

---

## When to Run

{Trigger conditions.}

---

## Prerequisites

{What must be true before this skill runs.}

---

## Execution

### Step 1: {Step Name}

{Instructions for the AI.}

### Step 2: {Step Name}

{Next step...}

---

## Outputs

| Output | Location | Description |
|--------|----------|-------------|
| {file} | {path}   | {what it contains} |
```

2. If templates are needed, create `{DEPT_FF_PATH}/skills/{skill-name}/templates/`

3. If scripts are needed, create `{DEPT_FF_PATH}/skills/{skill-name}/scripts/`

4. Ask: "Do you want a command so you can trigger this by typing a slash command?"
   If yes, load `scaffolding/prompt-command.md` from this skill's directory to create the entry points.

After scaffolding, return to the caller (Completion).
