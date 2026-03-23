# KB Compliance

Validates the latest step output against the full knowledge base without bloating the main conversation context.

## When to Run

After the **last step of each phase** (i.e. on phase transitions and workflow end). This runs alongside state-manager and analytics at those boundaries, but NOT after every individual step within a phase.

## How It Works

Launch a **dedicated subagent** with its own context window. The subagent loads the entire knowledge base, reviews the step output, and returns a short verdict. The main conversation never loads the full KB -- only the subagent does.

## Subagent Prompt

The parent agent must launch a single subagent with the following inputs:

1. **KB path**: `knowledge-base-core/` -- instruct the subagent to read `manifest.md` and then load ALL files listed in it (both "Always Load" and all "Conditional" sections)
2. **Step context**: a 2-3 sentence summary of what was done in the step (e.g. "Generated BDD specifications for the login component migration from Angular to Stencil")
3. **Affected files**: list of file paths created or modified during the step
4. **Initiative path**: `initiatives/{INITIATIVE_NAME}/` for audit context
5. **Local KB path** (optional): if `LOCAL_KB_MANIFEST` is set, pass `{LOCAL_REPO_PATH}/knowledge-base-local/` -- instruct the subagent to read its `manifest.md` and load ALL files listed in it

The subagent prompt MUST instruct the agent to:
- Read every file in `knowledge-base-core/` (all concerns: ai-governance, review, quality, security)
- If a local KB path was provided, read every file in `knowledge-base-local/` (all domain standards)
- Read every affected file listed
- Check each KB rule (core and local) against the step output
- **Return ONLY a structured verdict** (see format below)

**Do NOT** ask the subagent to return the full analysis or quote the KB rules back. All reasoning stays inside the subagent's context.

## Verdict Format

The subagent must return exactly this structure:

```
KB-COMPLIANCE: PASS | FAIL

Violations (if any):
- [{concern}/{file}] {short description of violation}
- [local/{domain}/{file}] {short description of local KB violation}

Recommendations (if any):
- {actionable suggestion}
```

Example PASS:

```
KB-COMPLIANCE: PASS

No violations detected.
```

Example FAIL:

```
KB-COMPLIANCE: FAIL

Violations:
- [security/secrets-management] Hardcoded API key found in generated config file
- [review/human-gate] Architecture change proposed without flagging for human approval
- [local/snowflake/standards] Stored procedure uses FLOAT instead of required NUMBER(38,12)

Recommendations:
- Replace hardcoded key with ${API_KEY} placeholder
- Add "Requires Human Approval" section before proceeding
- Use NUMBER(38,12) per Snowflake layer standards
```

## On PASS

Proceed to the next step. No action required.

## On FAIL

1. The main agent MUST address every listed violation before proceeding
2. After remediation, re-run this primitive to confirm compliance
3. Do NOT proceed to the next step until the verdict is PASS

## Scope Rules

- The subagent checks the **output** of the step, not the process itself (process compliance is the orchestrator's job)
- The check covers all KB concerns: ai-governance, review, quality, and security
- Conditional KB files (security, ISO 50001) are always loaded by the subagent regardless of step type -- the subagent decides which rules are applicable based on the step context
- If `LOCAL_KB_MANIFEST` is set, the subagent also loads all local KB files and checks domain-specific rules
