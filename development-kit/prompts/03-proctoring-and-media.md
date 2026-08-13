# Phase 3 — Proctoring, Sessions and Media

Implement configurable exam policies and all initial proctoring modes.

## Student workflow

System check, transparent monitoring notice, consent/acknowledgement, identity workflow when enabled, camera/microphone/screen permissions, exam rules, session start, connection recovery, permitted breaks, technical support and completion confirmation.

## Manual proctoring

Provide secure assignment queues, live student tiles, session health, authorized stream access, chat, standard warnings, notes, incidents, escalation and complete action auditing. Institution-employed proctors are included in the platform; FalconExam-supplied proctors remain a separately billable service.

## Media architecture

- WebRTC where appropriate
- Segmented and resumable recording
- Temporary encrypted browser buffering
- Direct upload to Cloud Storage using short-lived authorization
- No public buckets
- Media metadata in PostgreSQL, media bytes outside the database
- Tenant, exam and session-isolated object paths
- Signed playback URLs with short expiry
- Lifecycle, retention, legal hold and deletion integration

## Browser monitoring limitations

Implement only defensible browser-visible events. Clearly document that normal browser JavaScript cannot reliably detect all external devices, applications, virtual machines or cheating methods. Do not describe the initial product as a lockdown browser.

## Milestone acceptance criteria

- All six proctoring modes are selectable and enforce their configured data collection; disabling a mode collects nothing beyond what it declares.
- The session state machine handles start, permitted breaks, connection loss/recovery and completion without data loss.
- Media uploads go directly to Cloud Storage via short-lived authorization; no public buckets; playback uses signed URLs with short expiry; media bytes never enter the database.
- Object paths are isolated by tenant, exam and session; cross-session access fails.
- Transparent monitoring notice and consent/acknowledgement are shown and recorded before any capture.
- Retention, legal-hold and deletion hooks are wired into media lifecycle.
- Accessibility review against WCAG 2.2 AA passes for student and proctor consoles.
- The global acceptance checklist passes.

## Deliverables

- Versioned exam-policy editor
- Accommodation overrides
- Student system check
- Session state machine
- Browser-event collection
- Media upload and playback
- Live-proctor console
- Record-and-review timeline
- Failure recovery tests
- Accessibility review against WCAG 2.2 AA targets
