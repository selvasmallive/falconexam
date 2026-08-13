# Phase 4 — TensorFlow and Biber AI

Implement an AI provider architecture that separates raw detection, temporal correlation, scoring and human review.

## TensorFlow baseline

Support configurable detection modules for face presence/absence, additional person, phone-like object, prohibited material, camera obstruction, poor lighting, head pose, extended absence, frozen video and signal quality. Add audio-derived events only when enabled and legally approved.

Every detection must include event ID, tenant/session IDs, event type, start/end, confidence, signal quality, model provider/version, processing location, bounding boxes where applicable, supporting artifact references, policy relevance and correlation ID.

Use temporal smoothing, minimum duration, deduplication, calibration and repeated-event correlation. A single detection must not create a misconduct determination.

## Biber AI

Create a provider-neutral adapter with mock and real implementations. Biber AI is optional, disabled until configured, controlled by feature flags, schema-validated, auditable, timeout-protected, circuit-breaker protected and non-blocking.

Biber AI may classify event windows, identify mitigating evidence, reduce duplicate/weak alerts, prioritize human review and summarize evidence. Its structured result must include classification, confidence, severity, supporting events, mitigating events, reason codes, model version and explanation.

## Evaluation

Create reproducible evaluation tooling for precision, recall, false-positive rate per exam-hour, false-negative rate, calibration, reviewer dismissal rate, model disagreement and performance across lighting, camera quality, glasses, head coverings, diverse skin tones, assistive devices and network degradation.

Do not market a reduction percentage until independently measured. Support shadow-mode evaluation before activating new model or scoring versions.

## Milestone acceptance criteria

- Raw detection, temporal correlation, scoring and human review are separable stages; raw detections are preserved distinctly from interpreted incidents.
- Every detection carries the full required metadata (event/tenant/session IDs, type, start/end, confidence, signal quality, model provider/version, processing location, artifacts, policy relevance, correlation ID).
- No single detection produces a misconduct determination; temporal smoothing, minimum duration, deduplication and calibration are applied.
- Biber AI is disabled until configured, feature-flagged, schema-validated, timeout- and circuit-breaker-protected, and non-blocking; the mock adapter passes contract tests.
- Model registry tracks versions; shadow-mode evaluation runs before any activation.
- Evaluation tooling reproducibly reports precision, recall, false-positive rate per exam-hour, calibration and reviewer dismissal, including across lighting, camera quality, glasses, head coverings, diverse skin tones, assistive devices and network degradation.
- No reduction percentage is asserted without measured results.
- The global acceptance checklist passes.

## Deliverables

- AI service API
- Model provider interfaces
- TensorFlow reference pipeline
- Biber AI adapter and mock
- Event correlation engine
- Explainable review-priority engine
- Model registry and version history
- Evaluation dataset schema and reports
- Human feedback capture
