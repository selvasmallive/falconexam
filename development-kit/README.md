# FalconExam Claude Development Kit

Product: **FalconExam**  
Canonical domain: **falconexam.com**  
Purpose: Develop a production-grade, privacy-first online exam proctoring SaaS for Moodle, Canvas, and D2L Brightspace, distributed through Google Cloud Marketplace.

## How to use this kit with Claude Code

1. Create or open the FalconExam repository.
2. Copy this kit into the repository root under `/development-kit`.
3. Start Claude Code from the repository root.
4. Give Claude `prompts/00-master-architect.md` first.
5. Run the phase prompts in numerical order. Do not ask Claude to implement all phases in one context.
6. Require Claude to update `docs/STATUS.md`, `docs/DECISIONS.md`, and `docs/KNOWN_LIMITATIONS.md`, and to re-verify the global acceptance checklist (`specs/acceptance-checklist.md`), after every milestone.
7. Create a Git commit after each accepted milestone.

## Product differentiators that must remain intact

- Automated proctoring is optional.
- Manual live proctoring and record-and-review are supported.
- TensorFlow performs baseline detection.
- Biber AI is an optional, replaceable contextual reasoning layer.
- AI never determines that a student cheated.
- Institution-level annual licensing supports unlimited users with contracted capacity.
- Privacy is configurable by evidence type, jurisdiction, tenant, exam, and accommodation.
- Retention includes automatic deletion, legal holds, and auditable policy versions.
- The product must support institution-owned storage and regional data residency.
- FalconExam must be accommodation-aware and must not implement emotion or deception detection.

## Prompt order

1. `00-master-architect.md`
2. `01-foundation-and-domain.md`
3. `02-lti-and-lms-integrations.md`
4. `03-proctoring-and-media.md`
5. `04-ai-tensorflow-biber.md`
6. `05-privacy-security-retention.md`
7. `06-google-cloud-marketplace.md`
8. `07-testing-release-and-documentation.md`

The `specs` directory contains persistent requirements that Claude must treat as authoritative.
