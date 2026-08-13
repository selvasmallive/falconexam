# Phase 2 — LTI 1.3 and LMS Integrations

Implement one standards-based LTI core and thin adapters for Moodle, Canvas and D2L Brightspace.

## Required LTI capabilities

- OIDC login initiation
- JWT launch validation
- Issuer, audience, signature, nonce, state, expiration, message type, version and deployment validation
- JWKS publication and key rotation
- Resource Link launches
- Deep Linking
- Assignment and Grade Services (AGS) — optional and disabled by default. FalconExam is a proctoring overlay (ADR-001); it does not administer exam content or compute grades. When AGS is enabled it may write back only a non-grade proctoring/integrity status or a review link, never a computed score or misconduct determination. The LMS remains authoritative for delivery, timing and grading.
- Names and Role Provisioning where enabled
- Course, user and role mapping
- Idempotent launch/session creation
- Replay protection
- Multi-deployment tenant resolution

## Adapter requirements

### Moodle

Prefer standard LTI configuration. Add a Moodle plugin only when it provides a documented feature unavailable through standard LTI.

### Canvas

Support Developer Key configuration, account/course deployments, appropriate placements, Deep Linking and Canvas-specific role normalization. Do not rely on beta APIs for core functionality without a fallback.

### Brightspace

Support registration, deployment, links, Deep Linking, AGS and NRPS. Respect vendor rate limits and implement retry/backoff for service calls.

## Security

Do not log launch tokens. Store nonce/state with strict expiration. Validate redirect URIs and platform registrations. Use outbound HTTP allowlists and defend against SSRF while retrieving platform keys.

## Milestone acceptance criteria

- OIDC login and JWT launch validation pass conformance fixtures for all three platforms.
- Issuer, audience, signature, nonce, state, expiration, message type, version and deployment are all validated; malformed or replayed launches are rejected.
- JWKS is published and key rotation works without downtime.
- Multi-deployment tenant resolution maps launches to the correct tenant; cross-tenant launch attempts fail.
- Deep Linking and Resource Link launches succeed end to end for instructor and student flows.
- Launch tokens are never logged; nonce/state expire; redirect URIs and registrations are validated; SSRF defenses cover platform-key retrieval.
- Setup guides and the vendor conformance matrix are produced and accurate.
- The global acceptance checklist passes.

## Deliverables

- Integration code and tests
- Mock LTI platform fixtures
- Setup guides for all three LMS products
- Vendor conformance matrix
- Failure and troubleshooting guide
- End-to-end launch tests
- Instructor Deep Linking workflow
- Student launch workflow
