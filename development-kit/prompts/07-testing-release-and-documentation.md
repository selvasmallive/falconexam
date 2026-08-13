# Phase 7 — Testing, Release and Documentation

Establish release gates for a commercial education platform.

## Required testing

- Unit tests for domain and policy logic
- Integration tests with PostgreSQL, Redis, object storage abstractions and queues
- Contract tests for frontend/API, API/AI, Biber AI and Marketplace
- End-to-end tests for Moodle, Canvas and Brightspace launches
- Security tests for tenant isolation, IDOR, JWT tampering, replay, nonce reuse, WebSocket authorization, signed URL expiry and malicious uploads
- Performance tests for concurrent launches, event ingestion, media upload and review playback
- Chaos/recovery tests for AI outages, Redis loss, database failover, network interruption and duplicate Marketplace events
- Accessibility tests
- AI evaluation tests and model cards

## Release requirements

No production release unless builds, tests, migrations, rollback, backup/restore validation, SBOM, container scans, dependency scans and threat-model updates pass. Use canary or staged rollout for new scoring/model versions. Support rollback and shadow mode.

## Required documentation

Product requirements, architecture diagrams, ADRs, ERD, API docs, LTI setup guides, Google Cloud deployment, Marketplace onboarding, privacy data map, retention configuration, threat model, incident response, business continuity, backup/recovery, administrator guide, proctor guide, reviewer guide, student guide, model cards and known limitations.

Create a production-readiness checklist and a customer security-questionnaire evidence index.

## Milestone acceptance criteria

- All required test suites exist and pass in CI: unit, integration, contract, e2e for all three LMS launches, security, performance, chaos/recovery, accessibility and AI evaluation.
- Release gates block any production release unless builds, tests, migrations, rollback, backup/restore, SBOM, container/dependency scans and threat-model updates pass.
- New scoring/model versions ship via canary or staged rollout with shadow mode and a validated rollback path.
- The full documentation set (including model cards and known limitations) is present, accurate and versioned.
- The production-readiness checklist and security-questionnaire evidence index are complete.
- The global acceptance checklist passes.
