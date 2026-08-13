# ADR-002: Dedicated OIDC identity provider for non-LMS users, with per-tenant SSO federation and mandatory MFA

- Status: Accepted
- Date: 2026-08-03
- Owners: FalconExam architecture

## Context

LTI 1.3 authenticates students and instructors through the LMS. The RBAC set also includes platform admin, tenant admin, LMS admin, proctor, reviewer, privacy officer, auditor and support — roles that do not necessarily arrive via an LMS launch. No authentication method was defined for them, despite the threat model naming "support impersonation" and "proctor abuse." This is a security-critical gap.

## Decision

Non-LMS users authenticate through a **dedicated OIDC-based identity provider** for FalconExam staff/administrative access, separate from the LTI launch path.

- **Federation:** each tenant may federate its own IdP via OIDC or SAML (e.g. Azure AD/Entra, Okta, Google Workspace). Where a tenant has no IdP, FalconExam-managed local accounts are supported.
- **MFA:** mandatory for all privileged roles (platform admin, tenant admin, LMS admin, proctor, reviewer, privacy officer, auditor, support). No privileged role may hold a password-only session.
- **Sessions:** short-lived privileged sessions, step-up (re-auth) for sensitive actions (evidence export, retention override, impersonation, entitlement changes), no shared accounts, per-tenant scoping enforced on every request.
- **Support impersonation** is an explicit, consented, time-boxed and fully audited capability — never a silent login.
- On the GCP stack this is realized with Identity Platform / OIDC; the boundary is standards-based so the provider is replaceable.
- Students and instructors continue to authenticate via LTI only; they never receive staff IdP credentials.

## Alternatives considered

- **Reuse LTI for everyone.** Rejected: LTI is LMS-scoped and cannot cover platform/tenant staff who have no LMS context.
- **Local passwords only.** Rejected: fails enterprise SSO expectations and weakens privileged-access security.
- **A single global admin realm without tenant federation.** Rejected: breaks tenant isolation and institutional IdP requirements.

## Security, privacy and accessibility impact

- Directly mitigates support impersonation and proctor abuse via MFA, step-up auth and full audit.
- Enforces tenant isolation at the identity layer.
- Accessible authentication flows (WCAG 2.2 AA) required for staff consoles.

## Consequences

- Prompt 01 identity/authorization modules must implement the staff IdP, federation, MFA and privileged-session policy.
- Prompt 05 threat model and audit requirements extend to the staff auth surface.
- Adds IdP configuration to tenant onboarding.

## Rollback or migration plan

Provider is behind a standards-based boundary; swapping IdP implementations requires no data-model change. Federation is opt-in per tenant, so rollout is incremental.
