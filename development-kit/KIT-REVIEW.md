# FalconExam Development Kit — Gap & Consistency Review

Scope: `README.md`, `specs/` (2 files), `prompts/00`–`07`, `templates/` (2 files). This reviews the kit as a specification/prompt set, not code. Findings are ordered by severity.

## Changes applied (2026-08-03)

- **L1** — Canonical six-mode proctoring list added to `specs/product-requirements.md`.
- **L2** — Commercial plan names + billing split moved into `specs/product-requirements.md`.
- **M1** — `apps/web` role modules in `prompts/01` reconciled to the full ten-role RBAC set.
- **M2** — `README.md` step 6 corrected to include `docs/KNOWN_LIMITATIONS.md` and the acceptance checklist.
- **H4 / M3** — Missing entities added to `prompts/01`: `ScoringPolicyVersion`, `ModelVersion`, `CapacityQuota`, `UsageRecord`, `Notification`.
- **H1 / H2 / H3** — Decided and recorded as ADRs in `decisions/`, marked authoritative in `specs/product-requirements.md`, and threaded into the affected prompts:
  - **H1 (ADR-001)** — FalconExam is a proctoring overlay, not an assessment engine. AGS optional/off by default, non-grade status only. Threaded into `prompts/02`.
  - **H2 (ADR-002)** — Dedicated OIDC IdP for staff, per-tenant SSO federation, mandatory MFA, audited impersonation. Threaded into `prompts/01` (new Authentication section, `IdentityProvider` entity, acceptance criterion).
  - **H3 (ADR-003)** — Unified `Entitlement` model for Marketplace + direct sales. Threaded into `prompts/01` (`Entitlement` entity) and `prompts/06` (direct-sales provisioning workflow).

- **M4** — Explicit "Milestone acceptance criteria" added to prompts 02–07 (previously only Phase 1 had them).
- **M5** — Identity-proofing specified in `prompts/05` as an optional provider-neutral adapter (mock + real), disabled by default.
- **M6** — Student rights & appeals workflow added to `prompts/05` (view own incidents, dispute, retention-hold on appeal, audited outcome).
- **L3** — Notifications + delivery channels specified in `specs/product-requirements.md`; `Notification` entity in `prompts/01`.
- **L4** — Internationalization/bilingual (English + Canadian French) requirement added to specs.
- **L5** — Session timing/server-authoritative clock clarified in specs (LMS owns exam timing per ADR-001).
- **L6** — Supported browser/device matrix requirement added to specs.
- **L7** — Support impersonation hardened as a first-class audited capability in `prompts/05` (per ADR-002).
- **L8** — Prompt 00 vs Phase 1 ownership boundary clarified in `prompts/00`.

All review findings are now resolved. Remaining work is implementation, not specification.

---

## High severity — scope-defining ambiguities and contradictions

### H1. Assessment scope is undefined: does FalconExam deliver exams or only proctor them?
Nothing in the kit states whether FalconExam administers exam content or is a proctoring overlay on exams the LMS delivers. This is the single most load-bearing unstated decision. It collides with two other requirements:

- Prompt 02 requires **Assignment and Grade Services (AGS)** — grade passback. But if FalconExam does not administer questions, what grade does it pass back? And the core principle "AI never determines that a student cheated" means FalconExam produces no score of its own.
- Prompt 01 defines `Exam` and `ExamPolicyVersion` entities and prompt 03 covers "exam rules," "session start," and "completion confirmation," which read like exam delivery.

Add an authoritative statement in `specs/product-requirements.md` clarifying that FalconExam proctors LMS-delivered assessments (and, if so, that AGS is used only to write a proctoring/integrity result or session status, not a computed grade), or the opposite. Every downstream phase depends on this.

### H2. Authentication for non-LMS users is entirely unspecified.
LTI 1.3 (prompt 02) authenticates students and instructors *through the LMS*. But the RBAC list (prompt 01) also includes platform admin, tenant admin, LMS admin, proctor, reviewer, privacy officer, auditor and support — none of whom necessarily arrive via an LMS launch. No prompt specifies how these users log in (SSO/SAML/OIDC, IdP, MFA, session policy for privileged roles). Given the threat model explicitly lists "support impersonation" and "proctor abuse," privileged-user auth and MFA are a security-critical gap. Add an identity/auth section (likely to prompt 01 or 05).

### H3. Direct-sales provisioning has no entitlement path.
The product is "sold directly and through Google Cloud Marketplace" (prompt 00, 06). Only the Marketplace entitlement flow is specified (`MarketplaceAccount → tenant → entitlement → SubscriptionPlan`). There is no described mechanism to provision, entitle, or enforce capacity for a **direct** annual institutional contract — which is the primary pricing model in the specs. Define how a non-Marketplace tenant is created, entitled, and capacity-bound.

### H4. Required versioning has no data model.
Prompt 00 mandates versioning of "exam policies, scoring policies, model versions, retention policies, and reviewer decisions." Prompt 01's entity list covers `ExamPolicyVersion`, `RetentionPolicyVersion`, and `ReviewDecision` — but there is **no `ModelVersion` or `ScoringPolicyVersion` entity**, even though prompt 04 separately requires a "model registry and version history" and shadow-mode/version rollout. The entity model contradicts a non-negotiable principle. Add the missing versioned entities.

---

## Medium severity — consistency and coverage

### M1. Role lists don't match.
Prompt 01's `apps/web` role modules name six roles (student, instructor, proctor, reviewer, tenant-admin, platform-admin), but the same file's RBAC acceptance criterion names ten (adds LMS admin, privacy officer, auditor, support). The frontend scaffold silently drops four roles, including privacy officer and auditor, which are central to the privacy-first positioning. Reconcile to a single canonical role list.

### M2. Progress-tracking docs are inconsistent across files.
`README.md` step 6 says to update `STATUS.md`, `DECISIONS.md`, and "the acceptance checklist" after each milestone. But `specs/acceptance-checklist.md`, prompt 00, and prompt 07 all require a third doc, **`docs/KNOWN_LIMITATIONS.md`**, which the README omits. Separately, `acceptance-checklist.md` is a *static global* checklist, not a per-milestone tracker — there is no defined per-milestone status/acceptance record. Align the README with the three-doc set and clarify what "update the checklist" means.

### M3. Capacity/usage enforcement has no data model.
Prompt 06 requires enforcing "contracted concurrent-session capacity, pooled storage, included automated-analysis capacity" and building usage/cost dashboards. Prompt 01 defines no usage-metering, quota, or counter entity to support this. Concurrent-session capping in particular needs a live counter model. Add usage/quota entities.

### M4. Per-phase acceptance criteria are uneven.
Only Phase 1 has explicit "Milestone acceptance criteria." Phases 2–7 list "Deliverables" but no definition-of-done. Prompt 00 asks Claude to "define the milestone acceptance criteria," so this may be intentional — but the asymmetry means Phases 2–7 have no objective completion bar in the kit itself. Consider adding acceptance criteria to each phase, or state clearly that they are Claude-generated.

### M5. Identity-verification integration is referenced but never specified.
Identity workflows, alternative identity verification (accommodations), and "third-party identity checks" as a billable add-on all appear (prompts 03, 05, 06), and face embeddings are covered (04/05) — but no phase specifies the **ID-document / identity-proofing** architecture or vendor adapter (matching a student to a government ID). This is a distinct capability from face-presence detection. Assign it to a phase or mark it out of scope.

### M6. No student appeal/dispute workflow for incidents.
The positioning is privacy-first and "AI never determines cheating," yet the only appeal mechanism in the kit is a retention "appeal-period extension" (prompt 05). There is no student-facing workflow to view or contest an `Incident`/`ReviewDecision`. For an integrity product this is both an expectation and a due-process risk. Consider adding it.

---

## Lower severity — polish and completeness

- **L1. Canonical proctoring modes live in the wrong file.** The authoritative six-mode list appears only in prompt 00; the README differentiators imply three. `specs/` is declared authoritative but doesn't contain the mode list. Move it into `specs/product-requirements.md`.
- **L2. Plan names are not in specs.** "Campus Essential/Professional/Enterprise" and "FalconExam Live" appear only in prompt 06, not in the authoritative pricing spec.
- **L3. Notifications are underspecified.** A notifications module exists (01) and "notification before deletion" is required (05), but there is no `Notification` entity and no delivery-channel/provider spec (email/SMS/in-app).
- **L4. Internationalization/localization is absent.** Target customers include Canada, where French-language support is often contractually or legally expected; no i18n/l10n requirement appears anywhere.
- **L5. Exam timing / server-authoritative clock not addressed.** No mention of time limits, timers, or clock-skew handling — relevant to integrity and to "connection recovery/permitted breaks" in prompt 03.
- **L6. No supported-browser/device matrix.** Prompt 03 has a student "system check" but the kit never states which browsers/OS/devices (or mobile) are supported; prompt 03 also says "do not describe the product as a lockdown browser," which sharpens the need for an explicit support matrix.
- **L7. Support impersonation tooling is a named threat but has no feature spec.** Prompt 05 lists "support impersonation" in the threat model and prompt 01 defines a support role, but no phase specifies secure, audited impersonation/assist tooling.
- **L8. Scope overlap between prompt 00's "first task" and Phase 1.** Both describe the monorepo/foundation, diagrams, and threat-model skeleton. Clarify which document owns the foundation to avoid duplicated or conflicting scaffolding.

---

## What's strong
The kit is unusually disciplined on the things that matter most: the non-negotiable principles (advisory-only AI, optional monitoring at five levels, separation of raw detections from interpreted incidents), tenant isolation across every layer, retention configurability with no hard-coded durations, the anti-overclaiming stance (no unmeasured false-positive marketing, no legal-compliance claims), and evaluation across demographic and hardware conditions. The ADR and milestone templates enforce good hygiene. The gaps above are mostly *unstated decisions and missing data-model/auth coverage*, not flaws in the principles.

## Suggested next actions
1. Resolve H1 (assessment scope) first — it unblocks AGS design and the whole exam/session model.
2. Add an auth/identity section for non-LMS users (H2) and a direct-sales entitlement path (H3).
3. Add the missing entities: `ModelVersion`, `ScoringPolicyVersion`, usage/quota, and (if in scope) identity-proofing (H4, M3, M5).
4. Reconcile the role list (M1) and the docs-tracking instructions (M2).
5. Move canonical mode list and plan names into `specs/` (L1, L2).
