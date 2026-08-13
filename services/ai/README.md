# services/ai — FalconExam inference service

Python 3.12 + FastAPI + TensorFlow + OpenCV (optional MediaPipe). Independently scalable; the only
component that may require GPU nodes.

**Not implemented yet.** A health endpoint and CI wiring arrive in Milestone 1; the detection
pipeline, correlation engine, Biber AI adapter, model registry and evaluation tooling arrive in
Milestone 4 (`development-kit/prompts/04-ai-tensorflow-biber.md`).

Boundaries that hold from the first line of code:

- Raw detection, temporal correlation, scoring and human review are separable stages.
- Raw detections are preserved distinctly from interpreted incidents.
- A single detection never produces a misconduct determination.
- Biber AI is optional, disabled until configured, non-blocking, timeout- and circuit-breaker
  protected, and replaceable behind a provider-neutral adapter.
- No emotion recognition, deception detection, personality inference or sensitive-trait inference.
