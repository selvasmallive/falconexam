# Decision log

Chronological index of decisions affecting this repository. Architecture decisions get a full ADR in
[`docs/adr/`](adr/); smaller decisions are recorded here with enough reasoning to be re-examined
later. Never silently change an accepted requirement — supersede it.

## Architecture decision records

| ADR | Title | Status | Date |
| --- | --- | --- | --- |
| [ADR-001](adr/ADR-001-assessment-scope.md) | FalconExam is a proctoring overlay, not an assessment engine | Accepted | 2026-08-03 |
| [ADR-002](adr/ADR-002-non-lms-authentication.md) | Dedicated OIDC identity provider for non-LMS users, with per-tenant SSO federation and mandatory MFA | Accepted | 2026-08-03 |
| [ADR-003](adr/ADR-003-entitlement-model.md) | Unified entitlement model for Marketplace and direct sales | Accepted | 2026-08-03 |
| [ADR-004](adr/ADR-004-monorepo-layout-and-toolchain.md) | Monorepo layout, modular-monolith baseline and toolchain | Accepted | 2026-08-12 |

ADR-001 to ADR-003 were accepted during the specification review and are mirrored here from
`development-kit/decisions/`. The kit remains their origin; this copy is the product-repository
record.

---

## Milestone 0 — 2026-08-12

Decisions that shaped the scaffolding but did not warrant their own ADR. Fuller reasoning for the
first three is in [`docs/architecture/assumptions-and-conflicts.md`](architecture/assumptions-and-conflicts.md).

### D-001 · The product repository is separate from the kit repository

The kit stays independently versioned at `falconexam-development-kit`; this repository vendors a copy
at `development-kit/`, which makes the `development-kit/…` paths in the prompts and the milestone
template resolve. Resolves conflict C-01. The trade-off is possible drift between the two copies —
the kit is authoritative for specification changes, and any sync is noted here.

### D-002 · Milestone 0 implements no domain code

The master-architect prompt's closing line reads as though Phase 0 should also build Milestone 1;
`CONTINUE-IN-CLAUDE-CODE.md` states the opposite and more recent position. Milestone 0 is scaffolding
only. Resolves conflict C-02. One phase per session exists so each milestone gets a full context
window and a genuine review gate.

### D-003 · Review-priority scoring is kept, and is not an integrity score

`ScoringPolicyVersion` and `RiskAssessment` coexist with "FalconExam determines nothing" because they
prioritize and explain human review rather than judge a student. The constraint that makes this safe
is enforced downstream: nothing derived from scoring may be written back through AGS, and no
user-facing surface may present a score as a probability of cheating. Resolves conflict C-03.

### D-004 · Three specification gaps are recorded, not resolved here

The specs require a student appeal workflow, an identity-proofing result and proctor–student chat
with its own retention schedule, but name no entity for any of them (G-01, G-02, G-03). Milestone 0
does not invent entities — that is Milestone 1's mandate. They are recorded so the schema decision
happens before there is live evidence to migrate.

### D-005 · Local Compose uses named volumes only

This repository may sit on a synced drive; bind-mounting a database directory there corrupts it. All
stateful services use Docker named volumes. Only read-only configuration (the database init scripts)
is bind-mounted.

### D-006 · CI jobs detect their service and skip cleanly

Rather than commenting out jobs until each service exists, every language job checks for its build
file and emits a notice when absent. CI is green on an empty scaffold, starts working automatically
at Milestone 1, and there is no disabled job to forget to re-enable.

### D-007 · CI enforces two product invariants from day one

The hygiene job fails on tracked secret-bearing files or secret material in content, and the docs job
fails on legal-compliance claims — the "is &lt;regime&gt; compliant/certified" phrasing, in any file. Both
rules come straight from the specs and are cheapest to enforce before there is anything to fix.

### D-008 · Published as a private GitHub repository

`selvasmallive/falconexam`, private, `main` as the default branch. Scaffolding was committed locally
first and published only on the owner's explicit instruction — publishing is the owner's decision,
not an implementation detail.

### D-009 · GitHub Actions pinned to current major versions

The first CI run flagged `actions/checkout@v4` as running on a deprecated Node runtime; checking the
rest showed every pinned action was several majors behind. All were bumped to their current majors
(checkout v7, setup-java v5, setup-node v7, upload-artifact v7, pnpm/action-setup v6, and setup-uv
pinned exactly at v10.0.1 because it stopped publishing floating major tags after v7).

Pinning to a major tag rather than a commit SHA is a deliberate trade for now: it keeps the skeleton
readable and picks up security fixes automatically. Milestone 7 hardens this — SHA-pinning third-party
actions is part of the supply-chain work under threat-model entry T-22, where a compromised action tag
is the specific risk.

Worth remembering when editing CI: GitHub resolves **every** action referenced in a job at setup
time, including steps whose `if` condition is false. An unresolvable action therefore fails a job
that would otherwise have done nothing — which is exactly how the bad `setup-uv@v10` reference took
down the AI job while the service does not yet exist.
