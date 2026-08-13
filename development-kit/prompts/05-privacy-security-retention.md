# Phase 5 — Privacy, Security, Retention and Accessibility

Build controls suitable for institutional due diligence in Canada and the United States without claiming automatic compliance.

## Retention policy engine

Retention must be configurable by tenant, jurisdiction, evidence type, exam and investigation state. Support separate schedules for webcam, screen, audio, identity images, embeddings, browser events, raw detections, interpreted incidents, reviewer decisions, chat and audit logs.

Support:

- automatic scheduled deletion
- legal/investigation holds
- appeal-period extensions
- deletion approval where configured
- proof-of-deletion records
- storage lifecycle synchronization
- policy version snapshots per session
- institution-defined retention templates
- notification before deletion
- regional storage and institution-owned storage

Do not hard-code a universal 30-, 60- or 365-day requirement.

## Privacy controls

- Data minimization and purpose inventory
- Optional recording and optional biometric workflows
- Delete transient face embeddings after verification unless the institution explicitly configures otherwise
- Student-facing data-use notice
- Data subject/export/delete workflows
- Subprocessor inventory
- Regional residency
- Customer-managed encryption key option
- Institution-owned GCP project/storage option

## Student rights and appeals

Because FalconExam never determines misconduct and the human/LMS side owns outcomes, students must have a due-process path:

- A student can view the incidents and evidence attributed to their own sessions (subject to tenant configuration and active investigations).
- A student can submit a dispute/appeal against an incident, which is recorded, routed to the reviewer/instructor and audited.
- Submitting an appeal triggers the retention appeal-period extension so evidence is not deleted while under dispute.
- Appeal status and outcome are visible to the student and captured in the audit trail.

## Privileged access and support impersonation

Support impersonation is a first-class, tightly controlled capability (ADR-002): explicit, consented, time-boxed, scoped to a single tenant/session, MFA- and step-up-gated, and fully audited with clear start/stop events. It is never a silent login and never grants standing access.

## Identity-proofing integration

Identity verification (matching a student to a government or institutional ID) is an optional, pluggable adapter with a provider-neutral interface and a mock implementation, mirroring the Biber AI adapter pattern. It is disabled by default, third-party checks are separately billable, and accommodations may substitute an alternative verification method. Delete transient identity images and embeddings after verification unless the institution explicitly configures retention.

## Security controls

Follow OWASP ASVS and secure SDLC principles. Implement least privilege, CSP, HSTS, CSRF/XSS/SQLi defenses, short-lived sessions, key rotation, rate limiting, WAF integration, tenant isolation tests, signed URL expiry, WebSocket/WebRTC authorization, dependency/container/SBOM scanning and tamper-evident audit export.

Perform a threat model covering LTI replay, cross-tenant access, IDOR, malicious uploads, media URL leakage, proctor abuse, support impersonation, model-input abuse, compromised LMS registrations, SSRF and supply-chain attacks.

## Accessibility and accommodations

Approved accommodations must alter detection and review policies, not merely add a note after flags are generated. Support disabling gaze/head-pose features, permitted speech, caregivers, assistive devices, movement breaks, alternative identity verification and extended absence thresholds.

## Milestone acceptance criteria

- Retention runs per-evidence-type schedules with no hard-coded universal duration; deletion produces proof-of-deletion records and syncs storage lifecycle; legal holds and appeal extensions block deletion.
- Face/identity embeddings are deleted after verification unless explicitly retained; biometric and recording workflows are independently optional.
- Data subject export/delete, student incident view and appeal workflows function end to end and are audited.
- The threat model is documented and its listed attack surfaces have corresponding tests (LTI replay, cross-tenant, IDOR, malicious upload, media URL leakage, proctor abuse, support impersonation, model-input abuse, compromised registrations, SSRF, supply chain).
- Security controls (CSP, HSTS, CSRF/XSS/SQLi defenses, rate limiting, WAF, signed-URL expiry, WS/WebRTC authorization, SBOM/container/dependency scans, tamper-evident audit export) are implemented and tested.
- Support impersonation is MFA-gated, time-boxed and audited.
- The global acceptance checklist passes.
