# Step 4 — Reverse Engineering

**Scope behavior**: **Skip this step entirely when `scope=workspace-only`** — no source repos to scan.

**Session variables produced**: RE status per repo (timestamp or `null`).

**Progressive cache**: Updates `sourceRepos[].reTimestamp` entries in `.local-environment.json`.

---

**When `scope=full`**: For each brownfield source repo, check whether `reverse-engineering/reverse-engineering-timestamp.md` exists **in that repo's root**.

- **If the timestamp file is missing** → RE is **mandatory**. Load `skills/reverse-engineering/reverse-engineering.md` and execute it. There are **no other valid reasons to skip** — scope, feature size, JIRA context, or "existing familiarity" are never grounds for bypass.
- **If the timestamp file exists** → skip that repo (already done). Store its timestamp.
- **If all source repos are greenfield** → skip this step entirely.

When some repos have the timestamp and others do not, run the skill — it will only process the repos that are missing it.

**Wait for user approval** before proceeding.

Store RE status per repo (timestamp or `null` if not yet done).

**Write progressive cache** after this step — update the `sourceRepos[].reTimestamp` entries in `{FF_CORE_PATH}/.local-environment.json`.
