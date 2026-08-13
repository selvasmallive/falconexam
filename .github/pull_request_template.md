## What changed

<!-- One paragraph. What does this do, and which milestone does it belong to? -->

## Global acceptance checklist

From `development-kit/specs/acceptance-checklist.md`. Tick what applies; write "n/a — reason" for
what does not. Do not tick something you have not verified.

- [ ] Code builds from a clean checkout
- [ ] Automated tests pass (paste the commands and results below)
- [ ] Database migrations apply, and the rollback strategy is documented
- [ ] Authorization and tenant isolation are tested
- [ ] No secrets or private media URLs are exposed
- [ ] Audit events are generated for sensitive actions
- [ ] Accessibility impact reviewed
- [ ] Privacy/data-flow impact documented (`docs/privacy/data-flow-inventory.md`)
- [ ] Threat model updated for new attack surfaces (`docs/security/threat-model.md`)
- [ ] User-facing limitations documented honestly (`docs/KNOWN_LIMITATIONS.md`)
- [ ] AI output remains advisory and human-reviewed
- [ ] `docs/STATUS.md`, `docs/DECISIONS.md`, `docs/KNOWN_LIMITATIONS.md` updated

## Product invariants

- [ ] No user-facing text implies a student cheated, or presents a score as a probability of cheating
- [ ] Any new collection is optional, independently configurable, and collects nothing when disabled
- [ ] Raw detections remain separate from, and unmodified by, interpretation
- [ ] Every new tenant-owned entity has an immutable `tenant_id` and a non-sequential public id
- [ ] No new user-facing string is hard-coded English

## Commands run

```
<!-- Exact commands and their results. "Tests pass" without output is not evidence. -->
```

## Known gaps

<!-- Anything mocked, untested, or deferred. If there is nothing, say "none" — do not delete this. -->
