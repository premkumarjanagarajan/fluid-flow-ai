# Step 5 — Finalize Cache

**Scope behavior**: Runs in both `full` and `workspace-only` modes (no differences).

**Session variables produced**: None (finalizes existing data).

**Progressive cache**: Bumps `version` and `detectedAt` to confirm a complete run.

---

By this point, the cache file (`{FF_CORE_PATH}/.local-environment.json`) already has partial data from progressive writes in Steps 1–4. Finalize it with any remaining fields and bump the `version` and `detectedAt` timestamp to confirm a complete run.

**Timestamp capture**: Before writing the cache, run the following command to get the precise current UTC time and use the output as the value for `detectedAt` and `mcp.checkedAt`:

```bash
date -u +"%Y-%m-%dT%H:%M:%SZ"
```

Do **not** hardcode or approximate the timestamp — always capture it from the command above at write time.

The final cache must contain the complete state:

```json
{
  "version": 2,
  "detectedAt": "{ISO-8601 timestamp}",
  "environment": {
    "os": "{OS}",
    "shellType": "{SHELL_TYPE}",
    "ide": "{IDE}",
    "packageManagers": "{PACKAGE_MANAGERS}",
    "techStack": "{TECH_STACK}"
  },
  "workspace": {
    "ffCorePath": "{FF_CORE_PATH folder name}",
    "kbPath": "{KB_PATH folder name}",
    "deptFfPath": "{DEPT_FF_PATH folder name}",
    "department": "{DEPARTMENT}",
    "localKbLoaded": true|false,
    "localKbFiles": 0,
    "sourceRepos": [
      { "name": "{repo name}", "type": "{brownfield|greenfield}", "reTimestamp": "{ISO-8601|null}" }
    ],
    "folderList": ["{sorted list of all workspace root folder names}"]
  },
  "mcp": {
    "checkedAt": "{ISO-8601 timestamp}",
    "serversOk": ["{server names}"],
    "serversFailed": ["{server names}"]
  }
}
```
