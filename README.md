# FalconExam

Privacy-first, accommodation-aware **exam proctoring overlay** for Moodle, Canvas and D2L Brightspace.
Canonical domain: **falconexam.com**.

FalconExam does not host exam content and does not compute grades. The LMS owns delivery, timing and
grading; FalconExam monitors, records and supports human review of the session (see
[ADR-001](docs/adr/ADR-001-assessment-scope.md)).

## Repository layout

| Path | Contents |
| --- | --- |
| `apps/web` | React + TypeScript + Vite front end for all ten roles |
| `services/api` | Spring Boot 3 / Java 21 modular monolith (the system of record) |
| `services/ai` | Python 3.12 / FastAPI inference service (TensorFlow baseline, Biber AI adapter) |
| `infra/terraform` | Google Cloud infrastructure as code |
| `tests/e2e` | Cross-service end-to-end tests, including LMS launch flows |
| `tests/security` | Tenant isolation, IDOR, replay and authorization tests |
| `docs` | Architecture, ADRs, threat model, privacy data map, roadmap, status |
| `scripts` | Developer tooling (local environment up/down, bootstrap) |
| `development-kit` | Authoritative specifications, phase prompts and templates |

`development-kit/specs` is authoritative. Nothing in this repository may silently contradict it.

## Current state

**Milestone 0 (scaffolding) complete. No product code yet.** Milestone 1 (foundation, tenancy and
domain) is next. See [docs/STATUS.md](docs/STATUS.md) for what exists and
[docs/ROADMAP.md](docs/ROADMAP.md) for what is planned.

## Local development

Requires Docker Desktop. Everything else arrives with each milestone.

```powershell
Copy-Item .env.example .env
.\scripts\dev-up.ps1
```

```bash
cp .env.example .env
./scripts/dev-up.sh
```

That starts PostgreSQL, Redis, a Cloud Storage emulator and a mail catcher. Ports and credentials are
in `.env.example`. Stop with `scripts/dev-down.ps1` / `scripts/dev-down.sh`.

## How this repository is built

One milestone per Claude Code session, in order, using the prompts in `development-kit/prompts`. The
reusable per-milestone instruction is `development-kit/templates/CLAUDE-MILESTONE-INSTRUCTION.md`.
After each accepted milestone: update `docs/STATUS.md`, `docs/DECISIONS.md` and
`docs/KNOWN_LIMITATIONS.md`, re-verify `development-kit/specs/acceptance-checklist.md`, and commit.

## Principles that do not change

- FalconExam never labels a student a cheater, and AI never makes a final misconduct decision.
- Automated monitoring is optional at platform, tenant, course, exam and accommodation levels.
- Raw detections are preserved separately from interpreted incidents.
- No emotion recognition, deception detection, personality inference or sensitive-trait inference.
- No claims of legal compliance — FalconExam provides controls that help institutions meet their own
  obligations.
- No claimed false-positive improvement without measured evaluation results.

See [CLAUDE.md](CLAUDE.md) for the full working agreement.
