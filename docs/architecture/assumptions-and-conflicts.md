# Assumptions and conflicts register

Required by step 2 of the master-architect workflow: before implementation, list assumptions and
conflicts. This register is updated at the start of every milestone.

- **Milestone 0 (scaffolding)** — recorded 2026-08-12.
- Status values: `Resolved` (settled here or by an ADR), `Assumed` (taken as a working assumption,
  reversible), `Open` (a real gap that a later milestone must close before it can be accepted).

---

## Conflicts found and how they were resolved

### C-01 — Where the product repository lives · Resolved

`development-kit/README.md` says to copy the kit into the product repository under
`/development-kit`, and both `prompts/00-master-architect.md` and
`templates/CLAUDE-MILESTONE-INSTRUCTION.md` reference paths under `development-kit/`. But
`CONTINUE-IN-CLAUDE-CODE.md` in the kit repository says to start the session from the kit folder
itself.

**Resolution.** The kit repository (`falconexam-development-kit`, published at
github.com/selvasmallive) stays a separate, independently versioned repository. This product
repository vendors a copy of the kit at `development-kit/`, which makes every `development-kit/…`
path in the prompts and templates resolve correctly.

**Consequence.** The vendored copy can drift from the kit repository. The kit is authoritative for
specification changes; sync deliberately and note the sync in `docs/DECISIONS.md`. Do not edit
`development-kit/specs/` here to work around an implementation inconvenience — that is the silent
requirement change the master-architect prompt forbids.

### C-02 — What Milestone 0 is allowed to implement · Resolved

The "First task" section of `prompts/00-master-architect.md` ends with "hand off to Milestone 1 in
`01-foundation-and-domain.md` and implement only that milestone," which reads as though the
architect phase should also build Milestone 1. `CONTINUE-IN-CLAUDE-CODE.md` states the opposite and
more recent position: Phase 0 "hands off to Phase 1 (it does not implement domain modules itself),"
and each phase runs in its own session.

**Resolution.** Milestone 0 delivers cross-cutting scaffolding only — layout, architecture overview
and diagrams, domain-boundary map, threat-model skeleton, data-flow inventory, local Compose
environment, CI skeleton, roadmap and status docs. No entities, no tenancy code, no RBAC. Milestone 1
is a separate session. The one-phase-per-session rule exists so each milestone gets a full context
window and a real review gate; collapsing two phases would defeat it.

### C-03 — "ScoringPolicyVersion" versus "FalconExam computes no score" · Resolved

ADR-001 says FalconExam never writes a computed score or misconduct determination, and the
non-negotiable principles say AI never makes a final decision. Yet the entity list includes
`ScoringPolicyVersion` and `RiskAssessment`, and Phase 4 requires a "review-priority engine."

**Resolution.** These are not in conflict, and the distinction must be preserved in naming and in the
UI. Scoring exists **only** to prioritize human review and to explain why a window was surfaced. It
is internal, advisory and never leaves the platform as a grade or a determination:

- `RiskAssessment` is a *review-priority* assessment with reason codes, supporting **and mitigating**
  evidence, and an explanation. It is not an integrity score and not a verdict.
- Nothing derived from `ScoringPolicyVersion` may be written back through AGS (ADR-001 permits only a
  non-grade status or a review link).
- No user-facing surface may present a score as a probability of cheating.

Enforce this in Milestone 4 review, and in copy review for any student- or instructor-visible text.

---

## Working assumptions

### A-01 — Toolchain versions and build tools · Assumed

The specs fix the stack (Java 21, Spring Boot 3, React/TypeScript/Vite, Python 3.12/FastAPI) but name
no build tool, package manager or exact versions. Baseline recorded in
[ADR-004](../adr/ADR-004-monorepo-layout-and-toolchain.md): Gradle (Kotlin DSL) multi-project for
`services/api`, pnpm + Node 22 LTS for `apps/web`, `uv` + `pyproject.toml` for `services/ai`,
PostgreSQL 16 and Redis 7 locally to match Cloud SQL and Memorystore.

### A-02 — No shared `packages/` workspace yet · Assumed

Phase 1 specifies the top-level directories and does not include a shared TypeScript package.
API types for the front end will be generated from the OpenAPI document produced by `services/api`
rather than hand-maintained in a shared package. Introduce `packages/` only when a second TypeScript
consumer exists.

### A-03 — Local object storage is emulated, and the emulation is not the contract · Assumed

The specs require direct-to-Cloud-Storage upload with short-lived authorization, no public buckets
and short-expiry signed playback URLs. Locally, Compose runs a Cloud Storage emulator behind the same
storage abstraction. Signed-URL generation and expiry semantics differ between the emulator and real
GCS, so **signed-URL expiry must also be verified against real GCS in a cloud environment** before
Milestone 3 is accepted; the local test alone is not evidence. Tracked in
`docs/KNOWN_LIMITATIONS.md`.

### A-04 — Compose uses named volumes, never bind mounts for data · Assumed

This repository currently lives on a Google Drive-synced path. Bind-mounting database or emulator
data directories from a synced folder causes corruption and lock contention. All stateful services
use Docker named volumes. Developers who want faster builds should clone to a local, unsynced disk.

### A-05 — Server-authoritative time · Assumed

Per the platform requirements, the API server's clock is authoritative for all evidence ordering,
session lifecycle and retention scheduling. Browser-supplied timestamps are recorded as *reported*
client time for skew diagnosis only, and are never used to order evidence or to schedule deletion.
This is an architectural invariant from Milestone 1, not a Milestone 3 detail.

### A-06 — Deployment target for the AI service · Assumed

`services/ai` runs on Cloud Run without GPU for the initial detection set, and moves to GKE with GPU
nodes only when measured latency or throughput requires it. Milestone 4 must report the measurement
rather than assume the answer.

---

## Open gaps for later milestones

These are genuine gaps between the phase prompts, not scaffolding decisions. Each must be closed by
the named milestone — with an ADR if it changes an accepted requirement.

### G-01 — No entity backs the student appeal workflow · Open · Milestone 1 or 5

Phase 5 requires students to view incidents attributed to their own sessions, submit a dispute or
appeal, have it routed and audited, have it extend the retention appeal period, and see its status
and outcome. The Milestone 1 entity list has no `Appeal` (or `Dispute`) entity, and no state for it
on `Incident`.

An appeal is durable, auditable, student-initiated state with its own lifecycle and a hard link into
retention scheduling — it cannot live as a flag on `ReviewDecision`, which represents the reviewer's
action, not the student's challenge to it. Milestone 1 should either add the entity or record an ADR
explaining the alternative. Milestone 5 cannot be accepted without it.

### G-02 — No entity backs identity-proofing results · Open · Milestone 1 or 5

Phase 5 defines identity verification as a pluggable, provider-neutral, off-by-default adapter whose
transient images and embeddings are deleted after verification unless explicitly retained. There is
no `IdentityVerification` entity to hold the outcome, provider, model/provider version, timestamp,
accommodation substitution and deletion proof. `ConsentRecord` and `MediaArtifact` do not cover it.

### G-03 — No entity backs proctor–student chat · Open · Milestone 1 or 3

Phase 3 requires chat in the live proctor console, and Phase 5 requires a **separate retention
schedule for chat**. A separate retention schedule implies a distinct, addressable evidence type.
There is no `ChatMessage` entity.

### G-04 — Browser and device support matrix is required but unwritten · Open · Milestone 3

The platform requirements say the matrix must be published and enforced, and that the student system
check validates the environment against it. Milestone 0 does not own it; Milestone 3 must publish
`docs/guides/browser-support-matrix.md` with explicit minimum versions and an honest statement of
mobile/tablet support, and the system check must read from it rather than duplicating the list.

### G-05 — "Accommodations alter detection policy" needs a mechanism, not a note · Open · Milestone 3

Phase 5 is explicit that approved accommodations must change detection and review policy rather than
annotate flags after the fact. That means `Accommodation` must resolve into the effective policy
*before* detection runs, and the resolved policy must be snapshotted onto the session alongside the
`ExamPolicyVersion`. Design this in Milestone 3 policy resolution; do not let it become a
post-processing filter.
