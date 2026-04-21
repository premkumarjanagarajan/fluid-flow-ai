---
name: ff-help
description: Interactive skill that teaches Fluid Flow concepts and guides users through customising their department repository.
execution: inline
scope: shared
version: 1.0
last-updated: 2026-04-20
---

# Fluid Flow Help

Interactive skill that teaches Fluid Flow concepts and guides users through customising their department repository. Delivers information progressively — never overwhelm the user with everything at once.

---

## When to Run

- User wants to understand what Fluid Flow is and how it works
- User wants to know what they can customise in their department repo
- User wants to create a new skill, workflow, prompt, or other building block
- User is new to the framework and needs orientation

---

## Pacing Rule

**Never present more than one concept block at a time.** After each block, pause and ask the user what they want to do next. Let the conversation guide what to show — do not dump all building blocks, lifecycle stages, or customisation options in a single message.

---

## Execution

### Step 1: Welcome & Discovery

Display:

```
═══════════════════════════════════════════════════
  FLUID FLOW HELP
  Learn the framework. Customise your workflow.
═══════════════════════════════════════════════════
```

Then give a brief, conversational intro:

```
Fluid Flow is an AI-driven development workflow framework.

Three repositories work together:

  fluid-flow-ai        HOW the AI works (orchestrator, workflows,
                        skills, primitives, behavioural rules)

  betsson-kb-docs      WHAT the organisation knows (standards,
                        compliance, technology, domain knowledge)

  {dept}-fluid-flow    WHERE your team works (initiatives, local
                        knowledge, custom skills, custom workflows)

The first two are shared and immutable — they already contain
workflows, skills, and rules that cover most development scenarios.

Your department repo is where customisation happens.
```

**Then scan the workspace and present what's available.** Load `discovery.md` from this skill's directory and follow its instructions. This gives the user a map of what already exists before they think about customising anything.

**Pause.** Use the IDE question tool (Cursor: `AskQuestion` / VS Code: `vscode_askQuestions`):

- **A**: What can I customise?
- **B**: Explain a specific building block
- **C**: Walk me through the lifecycle stages
- **D**: I have something specific I want to do

If A → go to Step 2. If B → go to Step 3. If C → go to Step 4. If D → go to Step 5.

### Step 2: What You Can Customise

Present the recommended approach — start simple, escalate only if needed:

```
Most teams only need to customise their local knowledge base.

The core already ships with workflows (fast-track, comprehensive-path),
skills (reverse engineering, MCP check, retrospective, etc.), and
behavioural rules. Before building something custom, check whether
adding knowledge to your department repo is enough.
```

Then explain the escalation path:

```
Recommended approach:

  1. Start with your local knowledge base
     Add domain rules, team conventions, or architectural decisions
     to {dept}-fluid-flow/knowledge-base-local/
     The AI loads these during every workflow — this alone covers
     most customisation needs.

  2. If that's not enough, consider adding an MCP tool
     Connect a team-specific service (internal API, monitoring, etc.)
     to {dept}-fluid-flow/.cursor/mcp.json

  3. Only then think about custom skills or workflows
     When the core workflows don't fit your process, or you need
     a reusable procedure that doesn't exist yet.
```

**Pause.** Ask:

- **A**: Help me set up my local knowledge base
- **B**: I have something specific I want to do — help me figure out the best way
- **C**: Tell me more about the building blocks first
- **D**: I'm good — thanks!

If A → load `scaffolding/local-knowledge-base.md` from this skill's directory. If B → go to Step 5. If C → go to Step 3. If D → end.

### Step 3: Explain Building Blocks

Load `concepts.md` from this skill's directory and follow its building blocks section.

After the user finishes exploring concepts, ask:

- **A**: Move on to customisation
- **B**: I'm done

If A → go to Step 2. If B → end.

### Step 4: Lifecycle Walkthrough

Load `concepts.md` from this skill's directory and follow its lifecycle section.

After the user finishes exploring stages, ask:

- **A**: Move on to customisation
- **B**: I'm done

If A → go to Step 2. If B → end.

### Steps 5–7: Needs Analysis

Load `needs-analysis.md` from this skill's directory and follow it. This covers:

- Step 5: Understand what the user needs (open-ended conversation)
- Step 6: Check existing capabilities before creating anything new
- Step 7: Recommend the right approach and route to scaffolding

When needs-analysis routes to a scaffolding type, load the matching file from `scaffolding/` in this skill's directory:

| Recommendation | Load |
|----------------|------|
| Local knowledge base | `scaffolding/local-knowledge-base.md` |
| MCP tool | `scaffolding/mcp-tool.md` |
| Skill | `scaffolding/skill.md` |
| Workflow | `scaffolding/workflow.md` |
| Prompt / Command | `scaffolding/prompt-command.md` |

---

## Completion

After any path completes:

- **A**: I have another need — help me with something else
- **B**: Explain a concept I'm curious about
- **C**: I'm done — thanks!

If A → go to Step 5. If B → go to Step 3. If C → end.
