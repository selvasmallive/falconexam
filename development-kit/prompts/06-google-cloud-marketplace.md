# Phase 6 — Google Cloud and Marketplace

Package FalconExam as a partner-managed multi-tenant SaaS product running on Google Cloud and purchasable through Google Cloud Marketplace.

## Cloud architecture

Prefer Cloud Run for stateless web/API services, Cloud SQL PostgreSQL, Memorystore Redis, Cloud Storage, Pub/Sub, Cloud Tasks, Secret Manager, KMS, Cloud Armor, Artifact Registry and Cloud Monitoring. Use GKE only for justified GPU or specialized media workloads.

Create isolated development, test, UAT and production environments. Use Terraform, workload identity, least-privilege service accounts, backup/restore testing, disaster recovery and observability.

## Marketplace integration

Implement trusted server-side integration for Marketplace account approval, account linking, entitlement activation, suspension, cancellation and plan changes. Reconcile state idempotently. If usage-based pricing is offered, implement official consumption reporting; otherwise support subscription plans and private offers.

Map Marketplace account -> FalconExam tenant -> entitlement -> subscription plan. Never grant access from an unverified browser claim.

## Unified entitlement model (ADR-003)

Marketplace and direct sales converge on one channel-neutral `Entitlement` binding tenant -> `SubscriptionPlan` -> `CapacityQuota`. The Marketplace integration above is one source that feeds `Entitlement` (via `MarketplaceEntitlement`). Direct (non-Marketplace) annual contracts are provisioned by a platform admin through an audited, MFA-gated workflow: contract/order reference -> tenant creation -> `Entitlement` activation -> `CapacityQuota`. Both channels share the same lifecycle states, idempotent reconciliation and capacity enforcement, and neither grants access from an unverified browser claim.

## Commercial plans

Support institution-wide annual agreements with unlimited students, instructors, courses and exam definitions. Protect variable costs through contracted concurrent-session capacity, pooled storage, included automated-analysis capacity, retention duration and support tier.

Plans:

- Campus Essential
- Campus Professional
- Campus Enterprise
- Optional FalconExam Live human-proctoring add-on

Institution-employed proctors can use the live console under the annual platform license. FalconExam-employed human proctors, third-party identity checks, excess storage, dedicated deployments and premium support are separately chargeable.

## Milestone acceptance criteria

- Terraform provisions isolated dev/test/UAT/prod with workload identity and least-privilege service accounts; backup/restore and disaster recovery are tested.
- Marketplace approval, linking, activation, suspension, cancellation and plan change reconcile idempotently and survive duplicate events.
- The direct-sales provisioning workflow creates tenant, entitlement and capacity through an audited, MFA-gated path and feeds the same unified `Entitlement`.
- Capacity (concurrent sessions, pooled storage, included analysis capacity, retention, support tier) is enforced from the unified model; no per-user billing.
- Access is never granted from an unverified browser claim from either channel.
- Usage/cost dashboards reflect metered `UsageRecord` data; the Marketplace submission checklist and production-readiness evidence package are complete.
- The global acceptance checklist passes.

## Deliverables

- Terraform and deployment pipelines
- Marketplace integration module
- Direct-sales provisioning workflow (audited, admin-driven) feeding the unified `Entitlement`
- Entitlement reconciliation jobs
- Tenant onboarding flow
- Plan/capacity enforcement without per-user billing
- Usage/cost dashboards
- Marketplace submission checklist
- Security and production-readiness evidence package
