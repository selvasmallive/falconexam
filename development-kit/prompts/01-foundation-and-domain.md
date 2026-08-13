# Phase 1 — Foundation, Tenancy and Domain

Implement a production-oriented monorepo with:

- `apps/web` for the full role set: student, instructor, LMS admin, proctor, reviewer, privacy officer, auditor, support, tenant admin and platform admin (must match the RBAC roles in the Milestone 1 acceptance criteria)
- `services/api` for the Spring Boot modular monolith
- `services/ai` for FastAPI inference
- `infra/terraform`
- `tests/e2e`, `tests/security`, `docs`, and `scripts`

## Core backend modules

Create explicit modules for tenancy, identity, authorization, institutions, LMS, exams, policies, accommodations, sessions, proctoring, evidence, incidents, review, retention, audit, marketplace, subscriptions and notifications.

## Core entities

Tenant, Institution, User, ExternalIdentity, TenantMembership, Role, Permission, IdentityProvider, LMSRegistration, LMSDeployment, CourseMapping, Exam, ExamPolicyVersion, ScoringPolicyVersion, Accommodation, ProctoringSession, ProctorAssignment, DetectionEvent, MediaArtifact, Incident, IncidentEvidence, RiskAssessment, ReviewDecision, ModelVersion, ConsentRecord, RetentionPolicyVersion, LegalHold, AuditEvent, MarketplaceAccount, Entitlement, MarketplaceEntitlement, SubscriptionPlan, CapacityQuota, Notification and UsageRecord.

The versioned entities (`ExamPolicyVersion`, `ScoringPolicyVersion`, `ModelVersion`, `RetentionPolicyVersion`) satisfy the master-architect requirement to version exam policies, scoring policies, model versions and retention policies. `CapacityQuota` and `UsageRecord` back the contracted-capacity enforcement and usage/cost dashboards required in the marketplace phase (concurrent sessions, storage, automated-analysis capacity). `Notification` backs the notifications module and pre-deletion notices. `Entitlement` is the channel-neutral binding of tenant → `SubscriptionPlan` → `CapacityQuota` (ADR-003); `MarketplaceEntitlement` is the Marketplace-specific source projection that feeds it. `IdentityProvider` holds per-tenant staff SSO federation configuration (ADR-002).

All tenant-owned entities must include immutable `tenant_id`. Public identifiers must be non-sequential UUIDs. Apply optimistic locking where concurrent changes are possible.

## Authentication (ADR-002)

Two distinct authentication paths:

- **LMS users (students, instructors):** LTI 1.3 launch only. They never receive staff credentials.
- **Staff/administrative users (platform admin, tenant admin, LMS admin, proctor, reviewer, privacy officer, auditor, support):** a dedicated OIDC identity provider behind a standards-based, replaceable boundary, with optional per-tenant SSO federation (OIDC/SAML) configured via the `IdentityProvider` entity.

Enforce mandatory MFA for every privileged role, short-lived privileged sessions, step-up (re-authentication) for sensitive actions (evidence export, retention override, entitlement changes, impersonation), no shared accounts, and tenant scoping on every request. Support impersonation must be explicit, consented, time-boxed and fully audited — never a silent login.

## Milestone 1 acceptance criteria

- Local environment starts with one command.
- PostgreSQL and Redis health checks succeed.
- Flyway creates the initial schema.
- Tenant context cannot be supplied solely by browser input.
- Cross-tenant repository tests demonstrate isolation.
- RBAC supports platform admin, tenant admin, LMS admin, instructor, proctor, reviewer, privacy officer, auditor, support and student.
- Staff users authenticate via the dedicated OIDC provider with MFA enforced for privileged roles; LMS users authenticate only via LTI. The two paths are isolated.
- Audit events are append-only from the application perspective.
- OpenAPI is generated.
- React shell supports role-aware routing and accessible navigation.
- CI runs backend, frontend and AI checks.
- No secret is committed.

Deliver complete code, tests, Dockerfiles, Compose, migration scripts, diagrams and setup documentation.
