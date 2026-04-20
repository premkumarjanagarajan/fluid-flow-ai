# Step 7 — Report

**Scope behavior**: Runs in both `full` and `workspace-only` modes (no differences).

**Session variables produced**: None (display only).

---

Display the full summary:

```
═══════════════════════════════════════════════════
  FF INIT — Complete
═══════════════════════════════════════════════════
  Environment:
    OS: {os} | Shell: {shellType} | IDE: {ide}
    Packages: {packageManagers}
    Tech: {techStack}

  Workspace:
    FF Core       : {ffCorePath} (updated)
    Enterprise KB : {kbPath} (updated)
    Department FF : {deptFfPath}
    Department    : {department}
    Local KB      : {loaded (N files) | not configured}
    Source repos  : {name} ({type}), ...

  MCP: {ok}/{total} servers OK
  Env: {loaded} loaded, {skipped} skipped, persisted: {yes|no}
  RE:  {N} repos scanned, {N} pending

  Cached to .local-environment.json
  (run /ff-init to force refresh)
═══════════════════════════════════════════════════
```

After displaying the report, build and return the payload defined in `return-payload.md`.
