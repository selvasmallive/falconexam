# FalconExam milestone roadmap

One milestone per Claude Code session, in order. A milestone is complete only when its own criteria
**and** the global acceptance checklist (`development-kit/specs/acceptance-checklist.md`) pass, the
status documents are updated, and the work is committed.

The authoritative acceptance criteria live in each phase prompt under `development-kit/prompts/`.
The criteria below are a condensed working summary — where they differ, the prompt wins.

| # | Milestone | Prompt | Status |
| --- | --- | --- | --- |
| 0 | Scaffolding and architecture baseline | `00-master-architect.md` | **Complete** (2026-08-12) |
| 1 | Foundation, tenancy and domain | `01-foundation-and-domain.md` | Next |
| 2 | LTI 1.3 and LMS integrations | `02-lti-and-lms-integrations.md` | Not started |
| 3 | Proctoring, sessions and media | `03-proctoring-and-media.md` | Not started |
| 4 | TensorFlow and Biber AI | `04-ai-tensorflow-biber.md` | Not started |
| 5 | Privacy, security, retention, accessibility | `05-privacy-security-retention.md` | Not started |
| 6 | Google Cloud and Marketplace | `06-google-cloud-marketplace.md` | Not started |
| 7 | Testing, release and documentation | `07-testing-release-and-documentation.md` | Not started |

---

## Milestone 0 — Scaffolding and architecture baseline · Complete

Cross-cutting structure only. No domain code, by design (see conflict C-02).

Delivered: repository layout; architecture overview with context, container and sequence diagrams;
domain-boundary map; threat-model skeleton; data-flow inventory; local Docker Compose environment
and dev scripts; CI skeleton; this roadmap; the assumptions and conflicts register; ADR-004.

**Exit state:** the repository explains itself, CI is green on an empty scaffold, and the three open
specification gaps (G-01 to G-03) are recorded rather than discovered mid-implementation.

## Milestone 1 — Foundation, tenancy and domain · Next

The milestone everything else inherits from. Getting tenancy wrong here is unrecoverable later.

**Build:** the monorepo services themselves (`services/api` Spring Boot modular monolith,
`apps/web` React shell, `services/ai` health endpoint); the 18 modules and 35 entities; Flyway
baseline schema; tenant context resolution; structural tenant scoping in the repository layer; RBAC
for all ten roles; the two isolated authentication paths (LTI for students/instructors, dedicated
OIDC + MFA for staff, per ADR-002); append-only audit; OpenAPI generation; role-aware accessible
React shell with the i18n framework; Dockerfiles and Compose entries for all three services;
ArchUnit rules enforcing the module boundaries.

**Acceptance:** local environment starts with one command · PostgreSQL and Redis health checks pass ·
Flyway creates the initial schema · tenant context cannot be supplied by browser input ·
cross-tenant repository tests demonstrate isolation · RBAC covers platform admin, tenant admin, LMS
admin, instructor, proctor, reviewer, privacy officer, auditor, support, student · staff authenticate
via the dedicated OIDC provider with MFA enforced for privileged roles while LMS users authenticate
only via LTI, and the two paths are isolated · audit events are append-only from the application ·
OpenAPI is generated · React shell supports role-aware routing and accessible navigation · CI runs
backend, frontend and AI checks · no secret is committed.

**Also resolve here:** G-01 (appeal entity), G-02 (identity-verification entity), G-03 (chat entity) —
add them or record an ADR explaining the alternative. Deciding at Milestone 1 is cheap; discovering
it at Milestone 5 means a schema migration across live evidence.

## Milestone 2 — LTI 1.3 and LMS integrations

One standards-based LTI core, thin adapters for Moodle, Canvas and Brightspace.

**Build:** OIDC login initiation and JWT launch validation; JWKS publication and rotation; Resource
Link and Deep Linking; optional, off-by-default AGS limited to a non-grade status or review link
(ADR-001); NRPS where enabled; course/user/role mapping; idempotent launch and session creation;
replay protection; multi-deployment tenant resolution; mock platform fixtures; setup guides and a
conformance matrix.

**Acceptance:** conformance fixtures pass for all three platforms · every claim validated (`iss`,
`aud`, signature, nonce, state, `exp`, message type, version, deployment) and malformed or replayed
launches rejected · JWKS rotation without downtime · multi-deployment tenant resolution correct and
cross-tenant launches rejected · Deep Linking and Resource Link work end to end for instructor and
student · launch tokens never logged, nonce/state expire, redirect URIs and registrations validated,
SSRF defenses cover platform-key retrieval · setup guides and conformance matrix accurate.

**Threat model:** closes T-05 through T-09.

## Milestone 3 — Proctoring, sessions and media

Where student data starts existing. The privacy design either holds here or it never does.

**Build:** versioned exam-policy editor; accommodation overrides that alter policy *before* capture
(G-05); student system check against the published browser matrix (G-04); transparent notice and
consent; session state machine with breaks, connection loss and recovery; browser-event collection;
segmented resumable media upload direct to storage with short-lived authorization; signed playback;
live proctor console with assignment queues, chat and escalation; record-and-review timeline;
retention, legal-hold and deletion hooks.

**Acceptance:** all six modes selectable and each collects only what it declares — disabling collects
nothing · session state machine survives start, breaks, connection loss/recovery and completion
without data loss · uploads go direct to storage via short-lived authorization, no public buckets,
short-expiry signed playback, no media bytes in the database · object paths isolated by tenant, exam
and session with cross-session access failing · notice and consent shown and recorded before any
capture · retention, legal-hold and deletion hooks wired into media lifecycle · WCAG 2.2 AA passes
for student and proctor consoles.

**Threat model:** closes T-10 through T-15.

## Milestone 4 — TensorFlow and Biber AI

**Build:** the AI service API and model provider interfaces; TensorFlow reference pipeline with
configurable detectors; full detection metadata; temporal smoothing, minimum duration, deduplication,
calibration and correlation; provider-neutral Biber AI adapter with a mock; explainable
review-priority engine; model registry and version history; evaluation tooling and dataset schema;
human feedback capture.

**Acceptance:** raw detection, correlation, scoring and human review are separable stages and raw
detections are preserved distinctly · every detection carries the full required metadata · no single
detection produces a determination · Biber AI is disabled until configured, feature-flagged,
schema-validated, timeout- and circuit-breaker-protected, non-blocking, and its mock passes contract
tests · model registry tracks versions and shadow-mode evaluation runs before activation · evaluation
reproducibly reports precision, recall, false-positive rate per exam-hour, calibration and reviewer
dismissal, including across lighting, camera quality, glasses, head coverings, diverse skin tones,
assistive devices and network degradation · no reduction percentage asserted without measured
results.

**Threat model:** closes T-19 through T-21.

## Milestone 5 — Privacy, security, retention and accessibility

**Build:** the retention engine (per-evidence-type schedules, holds, appeal extensions, deletion
approval, proof of deletion, storage lifecycle sync, policy snapshots, templates, pre-deletion
notices, regional and institution-owned storage); privacy controls and purpose inventory; data
subject export/delete; student incident view and appeal workflow (G-01); identity-proofing adapter
and mock (G-02); support impersonation controls; the full security control set; the completed threat
model; accommodation-aware detection and review policy.

**Acceptance:** per-evidence-type schedules with no hard-coded universal duration, deletion produces
proof and syncs storage lifecycle, holds and appeal extensions block deletion · embeddings deleted
after verification unless explicitly retained, biometric and recording workflows independently
optional · export/delete, student incident view and appeals work end to end and are audited · every
threat-model surface has a corresponding test · security controls implemented and tested ·
impersonation MFA-gated, time-boxed and audited.

**Threat model:** closes the remainder and records residual risk.

## Milestone 6 — Google Cloud and Marketplace

**Build:** Terraform for isolated dev/test/UAT/prod with workload identity and least-privilege
service accounts; backup/restore and disaster recovery; the Marketplace trusted server-side
integration; the audited direct-sales provisioning workflow; entitlement reconciliation jobs; tenant
onboarding; capacity enforcement from the unified model (ADR-003); usage/cost dashboards; the
Marketplace submission checklist and production-readiness evidence package.

**Acceptance:** Terraform provisions the four isolated environments and DR is tested · Marketplace
approval, linking, activation, suspension, cancellation and plan change reconcile idempotently and
survive duplicate events · direct-sales provisioning is audited and MFA-gated and feeds the same
`Entitlement` · capacity enforced from the unified model with no per-user billing · access never
granted from an unverified browser claim · dashboards reflect metered `UsageRecord` data.

**Threat model:** closes T-24.

## Milestone 7 — Testing, release and documentation

**Build:** the full test matrix (unit, integration, contract, e2e across all three LMS platforms,
security, performance, chaos/recovery, accessibility, AI evaluation); release gates; canary/staged
rollout with shadow mode and rollback for scoring and model versions; the complete documentation set
including model cards and known limitations; the production-readiness checklist and the
security-questionnaire evidence index.

**Acceptance:** all suites exist and pass in CI · release gates block production unless builds,
tests, migrations, rollback, backup/restore, SBOM, container and dependency scans and threat-model
updates pass · new scoring/model versions ship via canary or staged rollout with shadow mode and a
validated rollback path · documentation complete, accurate and versioned · production-readiness
checklist and evidence index complete.

**Threat model:** closes T-22 and makes the model a release gate.

---

## Cross-milestone obligations

These are not a milestone. They are due every time.

- Update `docs/STATUS.md`, `docs/DECISIONS.md`, `docs/KNOWN_LIMITATIONS.md`.
- Update the threat model for any new attack surface, and the data-flow inventory for any new data.
- Re-verify the global acceptance checklist.
- Refresh the assumptions and conflicts register at the start of each milestone.
- Record material decisions as ADRs. Never silently change an accepted requirement.
