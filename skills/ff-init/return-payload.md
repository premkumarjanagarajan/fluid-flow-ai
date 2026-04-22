# Return Payload

When called as a subagent by the orchestrator, return **ONLY** this structured payload. Do NOT return detection details, MCP diagnostics, RE analysis, or any verbose output. All detailed findings stay in the subagent context or in `.local-environment.json`.

```
FF-INIT: COMPLETE | BLOCKED

Session Variables:
  OS={value}
  SHELL_TYPE={value}
  IDE={value}
  PACKAGE_MANAGERS={value}
  TECH_STACK={value}
  FF_CORE_PATH={value}
  KB_PATH={value}
  DEPT_FF_PATH={value}
  DEPARTMENT={value}
  LOCAL_KB_MANIFEST={value or empty}
  SOURCE_REPOS={name:type:reStatus, name:type:reStatus, ...}
  MCP_SERVERS_OK={comma-separated list}

Summary:
  {2-3 line status: cached vs fresh run, repos found, MCP status}

Blockers (if BLOCKED):
  {what's missing and what the user needs to do}
```

The orchestrator parses the returned payload:
- **If `COMPLETE`**: stores all session variables, displays the summary, continues to Triage
- **If `BLOCKED`**: displays the blocker message, halts the workflow
