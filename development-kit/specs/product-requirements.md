# Persistent Product Requirements

## Branding

- Product and company-facing name: FalconExam
- Canonical domain: falconexam.com
- Suggested applications: app.falconexam.com, api.falconexam.com, admin.falconexam.com, docs.falconexam.com and status.falconexam.com

## Competitive position

FalconExam is a privacy-first, accommodation-aware assessment integrity platform with explainable AI and optional human review. Its intended advantages are fewer unnecessary instructor-visible alerts, configurable data collection and retention, institution-controlled storage, transparent evidence, LMS simplicity and institution-wide annual licensing.

## Target customers

Universities, colleges, public school systems, private schools, certification providers and enterprise training organizations in Canada, the United States and later other regions.

## Initial LMS targets

Moodle, Canvas and D2L Brightspace through LTI 1.3/LTI Advantage.

## Proctoring modes (authoritative)

FalconExam supports these modes, each optional at platform, tenant, course, exam and accommodation levels:

1. No proctoring
2. Browser-event monitoring only
3. Automated TensorFlow proctoring
4. Record-and-review
5. Institution-operated live manual proctoring
6. Hybrid automated and human proctoring

## Pricing design

Unlimited named users under annual institutional agreements. Contract limits are based on capacity and variable-cost resources rather than user count: simultaneous sessions, storage, retention, AI analyses, support and FalconExam-supplied human proctoring.

Commercial plans (authoritative):

- Campus Essential
- Campus Professional
- Campus Enterprise
- Optional FalconExam Live human-proctoring add-on

Institution-employed proctors are included under the annual platform license. FalconExam-employed human proctors, third-party identity checks, excess storage, dedicated deployments and premium support are separately chargeable.

## Platform requirements (authoritative)

- **Internationalization and localization.** The UI, student-facing notices, consent text and emails must be localizable. English and Canadian French are required at launch given the Canadian market; the framework must not hard-code strings and must support per-tenant default and per-user language selection.
- **Supported browsers and devices.** Publish and enforce an explicit support matrix (current Chrome, Edge, Firefox, Safari on desktop, with a defined minimum version). Document mobile/tablet support status honestly. The student system check validates the environment against this matrix. FalconExam is not a lockdown browser and must not claim device-level control it does not have.
- **Notifications.** A single notifications module delivers pre-deletion notices, proctor/reviewer alerts and administrative messages over pluggable channels (in-app plus transactional email at minimum; SMS optional per tenant). Notifications are tenant-scoped, localized, auditable and respect per-user and per-tenant preferences. Backed by the `Notification` entity.
- **Session timing and clock authority.** Exam timing and grading are owned by the LMS (see ADR-001). FalconExam records proctoring-session start/stop and event timestamps against a server-authoritative clock, tolerates client clock skew, and never relies on browser-supplied time for evidence ordering or retention scheduling.

## Resolved scope decisions (authoritative)

These decisions are made and recorded as ADRs under `decisions/`. Treat them as authoritative requirements.

1. **Assessment scope — proctoring overlay only (ADR-001).** FalconExam does not administer exam content or compute grades; the LMS owns delivery, timing and grading. The `Exam` entity is FalconExam's proctoring configuration bound to an LMS assessment, not a question bank. LTI Assignment and Grade Services (AGS) is optional and disabled by default; when enabled it writes back only a non-grade proctoring/integrity status or review link, never a computed score or misconduct determination.
2. **Non-LMS user authentication — dedicated OIDC IdP (ADR-002).** Students and instructors authenticate via LTI only. All other roles (platform admin, tenant admin, LMS admin, proctor, reviewer, privacy officer, auditor, support) authenticate through a dedicated OIDC provider with optional per-tenant SSO federation (OIDC/SAML), mandatory MFA for every privileged role, short privileged sessions, step-up auth for sensitive actions, and audited, time-boxed, consented support impersonation.
3. **Unified entitlement model (ADR-003).** Marketplace and direct sales converge on a single `Entitlement` binding tenant → `SubscriptionPlan` → `CapacityQuota`. Marketplace uses the trusted server-side integration; direct contracts are provisioned by platform admins through an audited workflow. Capacity is enforced from the unified model regardless of channel; access is never granted from an unverified browser claim.
