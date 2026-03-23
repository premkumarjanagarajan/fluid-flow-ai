---
step: validate
subagent: false
---

## Inputs

- `2.5-code-review.md` (from 5-review)
- User feedback from local review

## Guidance

### Fix Loop

If the user reports issues:

1. Apply the requested fixes
2. Re-run build (`3-build` logic)
3. Re-run tests (`4-test` logic)
4. Re-verify against requirements (`5-review` logic)
5. Present changes to user
6. Repeat until user says "looks good" / "approved"

### No Issues

If user approves on first pass, proceed directly to deliver.

## Outputs

- All issues resolved
- User confirmation

## Gate

STOP until user explicitly approves. Acceptable signals: "looks good", "approved", "ready to push".
