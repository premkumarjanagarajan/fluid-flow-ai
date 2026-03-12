# Workflow Knowledge Core

Shared reference material for the fe-migration-angular-stencil workflow. These files contain cross-cutting knowledge that applies across multiple phases and steps.

Step-specific knowledge lives in each step's `instructions/` folder.

## Contents

| File | What it covers | Referenced by |
|------|---------------|---------------|
| `shadow-dom-css-rules.md` | Two mandatory Shadow DOM CSS rules (class placement, flat selectors) | 2.2 Implement, 2.3 Build, 2.4 Test, 2.5 Review |
| `event-bus-access.md` | Mandatory `window.sbXpEventBus` rule (never import directly) | 1.5 Design, 2.2 Implement, 2.4 Test, 2.5 Review |
| `bff-data-fetching.md` | Three mandatory BFF data fetching rules (type alias, dual guard, full envelope) | 2.2 Implement, 2.4 Test, 2.5 Review |
| `typescript-standards.md` | TypeScript standards (explicit return types, enum guidance, null handling) | 2.2 Implement |
| `troubleshooting.md` | Documented root causes and fixes for common issues | 2.2 Implement, 2.3 Build, 2.4 Test, 2.5 Review |

## Usage

Knowledge-core files are loaded by steps that reference them. The step's `{N}-{step}.md` file specifies which knowledge-core files to pre-load in its Guidance section.

These files are also available to the kb-compliance primitive for post-phase validation.
