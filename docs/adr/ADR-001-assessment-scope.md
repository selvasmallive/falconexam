# ADR-001: FalconExam is a proctoring overlay, not an assessment engine

- Status: Accepted
- Date: 2026-08-03
- Owners: FalconExam architecture

## Context

The kit defined `Exam` and `ExamPolicyVersion` entities, an exam/session workflow, and LTI Assignment and Grade Services (AGS), but never stated whether FalconExam administers exam content or only proctors assessments delivered by the LMS. This ambiguity blocks the exam/session model and the AGS design, and interacts with the non-negotiable principle that AI never determines misconduct and FalconExam produces no misconduct score of its own.

## Decision

FalconExam is a **proctoring overlay**. The LMS (Moodle, Canvas, Brightspace) owns exam content, delivery, timing and grading. FalconExam monitors, records and reviews the session; it does not host questions, administer the assessment, or compute a grade.

- The `Exam` entity represents FalconExam's **proctoring configuration** bound to an LMS assessment (mode, policy version, accommodations, retention), not a question bank.
- AGS is **optional and disabled by default**. When enabled, FalconExam may write back only a non-grade **proctoring/integrity result** — a session status and/or a link to the review record — so instructors see it as a reference alongside the LMS-owned grade. FalconExam never writes a computed score and never writes a misconduct determination.
- Exam timing and scoring remain authoritative in the LMS. FalconExam records its own session start/stop and connection events for evidence only.

## Alternatives considered

- **Full assessment engine (deliver questions + grade).** Rejected: contradicts the "LMS simplicity" positioning, massively expands scope and liability, and conflicts with the advisory-only AI principle.
- **AGS writes a computed integrity score into the gradebook.** Rejected: an integrity score in the gradebook reads as a misconduct determination and violates the core principle.
- **No AGS at all.** Rejected as the default but supported: some institutions want a visible "proctored / review-available" marker, so an optional non-grade status passback is retained.

## Security, privacy and accessibility impact

- Reduces data footprint: no exam content or answer data stored by FalconExam.
- Keeps human graders and the LMS as the sole authority for outcomes, preserving student due process.
- No accessibility regression; accommodations continue to alter detection/review policy, not delivery.

## Consequences

- Prompt 02 must state that AGS is optional, off by default, and limited to a non-grade status/link.
- The session model tracks proctoring lifecycle, not question navigation.
- Marketing and docs must not describe FalconExam as an assessment or grading system.

## Rollback or migration plan

Reversible at the spec level before implementation. If a future decision adds assessment delivery, it would be a new ADR superseding this one, with a new bounded module rather than changes to the proctoring core.
