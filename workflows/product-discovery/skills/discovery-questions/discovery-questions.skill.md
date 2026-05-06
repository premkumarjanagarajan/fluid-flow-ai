---
name: discovery-questions
description: Generates topic-tailored discovery questions by category before or during a discovery session.
execution: inline
scope: workflow-local
version: 1.0
last-updated: 2026-04-20
---

# Discovery Questions

Generates a structured, topic-specific set of discovery questions to help a Product Manager or Product Owner think through a problem space before or during a discovery session.

---

## When to Run

- Before starting a full Product Buddy discovery session
- When brainstorming the right questions to ask about a new idea or problem area
- When preparing for a stakeholder conversation or interview

---

## Prerequisites

- A topic, idea, or problem area provided by the user

---

## Execution

### Conversation Rule (non-negotiable)

Questions are asked ONE AT A TIME. Never present a list of questions to the user.

Each question must be shaped by the previous answer:
- Listen to the response
- Identify what it reveals and what it leaves unclear
- Ask the next most important question based on what was just said

The question order from the five categories is a guide, not a script. Skip questions that the user's previous answers have already addressed. Add questions that their answers make newly relevant.

The user should feel they are having a conversation, not filling in a form.

---

### Step 1: Generate Questions by Category

Generate questions tailored to the specific topic across these five categories:

**Problem & User**
- What is the user problem? Who is affected?
- What happens today without this? What is the cost of inaction?

**Evidence & Validation**
- What data, research, or feedback supports this?
- Have competitors solved this? How?

**Scope & Constraints**
- Which markets and platforms are in scope?
- Are there regulatory or compliance considerations?
- What are the known dependencies and deadlines?

**Strategic Fit**
- Does this connect to an existing Big Bet or initiative?
- How does this align with product themes (Revenue, CX, Technical Excellence, Operational Excellence, etc.)?

**Risks & Alternatives**
- What could go wrong?
- Have alternative approaches been considered?
- What are you choosing NOT to do?

### Step 2: Tailor to the Topic

Make every question specific to the topic provided. Replace generic placeholders with the actual domain, user group, market, or constraint context relevant to the topic. Generic questions that apply to anything are not acceptable.

### Step 3: Present as a Numbered Checklist

Present all questions as a single numbered checklist the user can work through in sequence.

### Step 4: Prioritise

Identify the 3–5 questions most critical to answer first. Mark them clearly (e.g. ⭐) and briefly explain why each is highest priority for this specific topic.

---

## Outputs

| Output | Format | Description |
|--------|--------|-------------|
| Discovery question checklist | Inline chat response | Numbered, prioritised, topic-specific questions |
