---
phase: discover
steps: 5
---

# Phase 1: Discover

> **CRITICAL: Questions come FIRST. Knowledge Base comes SECOND.**
> Do NOT search for documentation, market rules, or compliance sources until the user has answered the structured discovery questions. The purpose of Phase 1 is to understand the problem from the user's perspective before validating against any knowledge base.

Goal: understand the problem through structured conversation, challenge assumptions, validate against KB, draft a confirmed problem statement, and detect existing context.

## Step Chain

1. Load `1-structured-discovery/1-structured-discovery.md` — engage the user in a structured discovery conversation
2. Load `2-challenge-deepen/2-challenge-deepen.md` — act as a critical friend, probe and sharpen the framing
3. Load `3-kb-validation/3-kb-validation.md` — validate against the knowledge base, resolve gaps
4. Load `4-problem-statement/4-problem-statement.md` — draft and confirm the problem statement
5. Load `5-existing-context/5-existing-context.md` — detect existing artefacts via MCP (conditional)

## Phase Gate

ALL must be met before advancing to Phase 2 (Artefact Selection):

- [ ] Structured discovery questions answered by the user (Step 1.1 complete)
- [ ] Challenge and follow-up questions asked (Step 1.2 complete)
- [ ] Knowledge base validation completed and gaps addressed (Step 1.3 complete)
- [ ] A clear problem statement has been drafted and confirmed by the user (Step 1.4 complete)
- [ ] Gate outcome is recorded in the decision log

Present:
- **A**: Approve and proceed to Artefact Selection
- **B**: Request changes
