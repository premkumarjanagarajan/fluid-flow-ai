# Needs Analysis

Understand what the user wants, check if existing capabilities cover it, and recommend the right approach. The user should never have to classify their need into a building block type.

---

## Step 5: Understand What the User Needs

**Do not ask the user to classify their need into a building block type.** Users typically don't know whether they need a skill, workflow, command, or knowledge file — and they shouldn't have to. Instead, gather what they want in their own words and figure out the right approach for them.

Ask a single open question:

**"Tell me in your own words — what do you want to achieve or change about how Fluid Flow works for your team?"**

Let the user describe their need freely. Then ask follow-up questions **one at a time** until you have a clear picture. Good follow-ups:

- "Can you give me an example of when you'd need this?"
- "Is this something you'd want to happen automatically during workflows, or something you'd trigger yourself?"
- "Does this involve connecting to an external system or API?"
- "Is this about teaching the AI something it doesn't know, or about changing how it behaves?"
- "How often would this be used — every workflow, or only in specific situations?"

**Stop gathering when you can confidently answer**: what the user needs, when it should happen, and what the expected outcome is.

---

## Step 6: Check Existing Capabilities

Before suggesting anything new, check whether what already exists can solve the user's need. Use the discovery scan results from Step 1.

### Check in this order:

1. **Can an existing core workflow handle this?** — Read the relevant `wf-*.md` to check if the user's need is already covered by a step in fast-track or comprehensive-path. If yes, explain which step does it and how.

2. **Can an existing core skill handle this?** — Check if any skill in `{FF_CORE_PATH}/skills/` already does what the user described. Read the skill's markdown to confirm. If yes, explain it and how to use it.

3. **Can an existing command/prompt trigger what they need?** — Check if there's already an entry point for it.

4. **Can the local knowledge base solve this?** — Many needs boil down to "I want the AI to know X when it works on my code." If the user's need is about domain rules, team conventions, architectural decisions, coding standards, or compliance — the local KB is almost certainly the answer. This is the **most common and simplest** solution.

5. **Can an existing MCP tool cover this?** — If the need involves an external service that's already configured.

### Present your finding

If something existing covers it:

```
Good news — this is already covered by {name}.

{Brief explanation of how it works and where it lives.}

{If it's a skill or command, explain how to invoke it.}
{If it's a workflow step, explain which workflow and phase.}
```

Ask: "Does this solve what you need, or is there a gap?"

If the user confirms it works → return to the caller (Completion).
If there's a gap → continue to Step 7.

If nothing existing covers it → continue to Step 7.

---

## Step 7: Recommend and Build

Now that you understand the need and have confirmed nothing existing covers it, **you** decide which building block is the right fit. The user does not need to know the taxonomy — explain your recommendation in plain terms.

### Decision logic

Apply these rules in order:

1. **If the need is about knowledge** (the AI should know something, follow a convention, apply a rule, understand a domain):
   → **Local knowledge base**. This is the simplest customisation. Explain: "The easiest way to handle this is to add it to your department's local knowledge base. The AI will load it during every workflow run."

2. **If the need is about connecting to an external service** (read from an API, post to a tool, query a database):
   → **MCP tool**. Explain: "This needs a tool connection. I'll add it to your department's MCP config."

3. **If the need is a reusable procedure** (a series of steps the AI should follow, with inputs and outputs, that can be invoked on demand or during a workflow):
   → **Skill**. Explain: "This is a good fit for a skill — a step-by-step procedure the AI follows. I'll create one in your department repo."

4. **If the need is a fundamentally different development process** (the existing fast-track and comprehensive-path don't fit the team's way of working, and the difference is structural — not just missing knowledge):
   → **Workflow**. Explain: "The core workflows don't cover this process. I'll help you design a custom workflow for your department."

5. **If the need is a shortcut to trigger something** (user wants a quick command to invoke an existing or new capability):
   → **Prompt / Command**. This usually comes as a follow-up after creating a skill. Explain: "I'll create a command so you can invoke this by typing `/{name}`."

**Always explain why** you're recommending a specific approach. Use plain language, not framework jargon.

### Present the recommendation

```
Based on what you described, here's what I recommend:

  {Plain-language explanation of the recommendation.}

  This means I'll create: {what will be created, in simple terms}
  It will live at: {path}
  You'll use it by: {how they interact with it}
```

Ask: "Does this sound right, or would you like to adjust anything?"

If the user agrees → load the matching scaffolding file from `scaffolding/` in this skill's directory.
If the user wants changes → adjust the recommendation based on their feedback.
