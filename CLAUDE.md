# Working agreement for this repository

FalconExam is a commercial, privacy-first exam **proctoring overlay**. Read this before changing code.

## Authority order

1. `development-kit/specs/` — authoritative product requirements and the global acceptance checklist.
2. `docs/adr/` — accepted architecture decisions. Do not re-litigate an Accepted ADR; supersede it
   with a new one if it must change.
3. `development-kit/prompts/` — the phase prompt for the milestone being built.
4. This file and the rest of `docs/`.

If an instruction conflicts with `development-kit/specs/`, stop and surface the conflict. Record
material changes as an ADR (`development-kit/templates/ADR-TEMPLATE.md`). Never silently change an
accepted requirement.

## Non-negotiable product rules

- Never label a student a cheater. AI output is advisory; a human makes every determination.
- Automated monitoring is optional at platform, tenant, course, exam and accommodation levels.
- Recording, audio, identity verification and screen capture are **independently** configurable.
- Preserve raw detections separately from interpreted incidents.
- Version exam policies, scoring policies, model versions, retention policies and reviewer decisions.
- No emotion recognition, deception detection, personality inference or sensitive-trait inference.
- Do not claim legal compliance. Do not claim a false-positive reduction without measured results.
- Do not describe FalconExam as a lockdown browser or claim device-level control it does not have.
- The LMS owns exam content, timing and grading (ADR-001). AGS is off by default and may write back
  only a non-grade status or review link.

## Non-negotiable engineering rules

- **Tenancy.** Every tenant-owned entity carries an immutable `tenant_id`, enforced in application
  logic, repositories, object storage paths, cache keys, queues, logs and tests. Tenant context is
  never taken from browser input alone.
- **Identifiers.** Public identifiers are non-sequential UUIDs. Never expose sequential keys.
- **Media.** Media bytes never enter PostgreSQL. No public buckets. Playback uses short-expiry signed
  URLs. Object paths are isolated by tenant, exam and session.
- **Audit.** Sensitive actions emit audit events; audit is append-only from the application's view.
- **Secrets.** Never commit `.env`, service-account JSON, `*.key` or `*.pem`. Check `.gitignore`
  before adding a new file type that could carry credentials.
- **Logging.** Never log LTI launch tokens, JWTs, signed URLs, media bytes or student PII.
- **Architecture.** Modular monolith (`services/api`) plus independently scalable AI/media workers.
  Do not extract a service without a demonstrated scaling or security boundary and an ADR.
- **Completeness.** No unexplained ellipses, no placeholder implementations presented as done. If
  something is mocked or untested, say so in `docs/KNOWN_LIMITATIONS.md`.

## Per-milestone workflow

Implement only the next uncompleted milestone (`docs/ROADMAP.md`).

1. Inspect the repository first.
2. State assumptions, acceptance criteria and files to change.
3. Update architecture diagrams and ADRs.
4. Implement complete code with tests.
5. Run formatting, linting, type checking, unit and integration tests, dependency checks and builds.
6. Fix every failure before claiming completion; report exact commands and results.
7. Update `docs/STATUS.md`, `docs/DECISIONS.md`, `docs/KNOWN_LIMITATIONS.md`, the threat model and
   the data-flow inventory.
8. Re-verify `development-kit/specs/acceptance-checklist.md`, then commit.

## Stack

Java 21 / Spring Boot 3 / Spring Security / Spring Data JPA / Flyway; PostgreSQL; Redis.
React / TypeScript / Vite / Material UI / TanStack Query.
Python 3.12 / FastAPI / TensorFlow / OpenCV.
WebRTC for media, WebSocket/SSE for events.
Google Cloud Run (GKE only for GPU/media), Cloud SQL, Memorystore, Cloud Storage, Pub/Sub,
Cloud Tasks, Secret Manager, Cloud KMS, Artifact Registry, Cloud Armor.
Terraform and GitHub Actions.

Toolchain baseline and layout rationale: [ADR-004](docs/adr/ADR-004-monorepo-layout-and-toolchain.md).

## Accessibility and localization

WCAG 2.2 AA is a release gate for student, proctor and reviewer consoles. No hard-coded user-facing
strings — English and Canadian French are required at launch, with per-tenant default and per-user
language selection.
