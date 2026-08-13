# ADR-003: Unified entitlement model for Marketplace and direct sales

- Status: Accepted
- Date: 2026-08-03
- Owners: FalconExam architecture

## Context

FalconExam is sold both directly and through Google Cloud Marketplace, but only the Marketplace entitlement flow was specified. Direct annual institutional contracts — the primary pricing model — had no provisioning, entitlement or capacity-enforcement path.

## Decision

Both sales channels converge on a single internal **`Entitlement`** aggregate that binds a tenant to a `SubscriptionPlan` and a `CapacityQuota`. The channel is a source attribute, not a separate model.

- **Marketplace source:** the existing trusted server-side integration (account approval, linking, activation, suspension, cancellation, plan change) creates and reconciles `Entitlement` records idempotently. `MarketplaceAccount` and `MarketplaceEntitlement` remain the Marketplace-specific projection feeding the unified `Entitlement`.
- **Direct source:** a platform admin provisions a direct contract through an audited internal workflow (order/contract reference → tenant creation → `Entitlement` activation → `CapacityQuota`). The same reconciliation, capacity enforcement and lifecycle states apply.
- **Common invariants:** capacity (concurrent sessions, pooled storage, included automated-analysis capacity, retention duration, support tier) is enforced from `CapacityQuota` regardless of source; access is never granted from an unverified browser claim; all entitlement changes are audited and versioned.
- Usage is metered via `UsageRecord` and surfaced in the usage/cost dashboards for both channels.

## Alternatives considered

- **Separate Marketplace-only entitlement, direct sales handled manually.** Rejected: no capacity enforcement for the primary revenue channel and divergent logic.
- **Two parallel entitlement models.** Rejected: duplicated reconciliation and enforcement, higher risk of drift.

## Security, privacy and accessibility impact

- Direct provisioning is a privileged, audited, MFA-gated action (see ADR-002).
- Uniform enforcement prevents capacity/authorization gaps between channels.
- No student PII involved in entitlement provisioning.

## Consequences

- Prompt 01 adds a channel-neutral `Entitlement` entity; `MarketplaceEntitlement` becomes the Marketplace-specific source projection.
- Prompt 06 must specify the direct-sales provisioning workflow alongside Marketplace integration and enforce capacity from the unified model.

## Rollback or migration plan

Marketplace records already map cleanly into the unified `Entitlement`; the direct path is additive. Reverting would only remove the direct workflow, leaving Marketplace unaffected.
