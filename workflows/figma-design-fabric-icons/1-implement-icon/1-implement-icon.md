---
phase: implement-icon
steps: 2
---

# Phase 1: Implement Icon

Goal: collect prerequisites, verify no duplicate exists, then create the TSX component, update the models enum, and update the Storybook stories entry.

## Step Chain

1. Load `1-setup/1-setup.md` — collect Jira ID, create branch, analyse SVG source, check for duplicates
2. Load `2-create-component/2-create-component.md` — create the icon TSX, update the models enum, update stories

## Phase Gate

After Step 2, summarise all files created/modified and ask:

> **"✅ All changes are in place. 🚀 Would you like me to commit, push, and open a Pull Request? (yes / no)"**

- **Yes** (or clear affirmative) → proceed to Phase 2
- **No** (or clear negative) → stop; inform user they can trigger Phase 2 later
- **Ambiguous** → ask again before proceeding
