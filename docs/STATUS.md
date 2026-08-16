# Status

Last updated: 2026-08-14 · Milestone 0 (scaffolding) complete · Milestone 1 is next.

Published privately at [github.com/selvasmallive/falconexam](https://github.com/selvasmallive/falconexam).

## Where the product is

**There is no product code.** No entity, endpoint, screen, migration or model exists. Milestone 0
delivered the structure, the architecture baseline and the guardrails that Milestone 1 builds inside.

Nothing in this repository is deployable, and nothing should be shown to a customer as working
software.

## What exists

| Area | State |
| --- | --- |
| Repository layout | Created: `apps/web`, `services/api`, `services/ai`, `infra/terraform`, `tests/e2e`, `tests/security`, `docs`, `scripts`, `development-kit` — each with a README stating what lands there and when |
| Specification kit | Vendored at `development-kit/` (specs, prompts, ADRs, templates). Authoritative |
| Architecture | `docs/architecture/overview.md` — context, container and two sequence diagrams; modular-monolith rationale; sync/async boundaries; tenancy model; environments |
| Module design | `docs/architecture/domain-boundaries.md` — 18 modules, 35 entities, dependency direction, enforcement plan |
| Assumptions/conflicts | `docs/architecture/assumptions-and-conflicts.md` — 3 conflicts resolved, 6 assumptions, 5 open gaps |
| Threat model | `docs/security/threat-model.md` — skeleton with 26 registered surfaces, all `Planned` |
| Privacy | `docs/privacy/data-flow-inventory.md` — 22 data categories, purposes, processors, residency |
| Local environment | `docker-compose.yml` (PostgreSQL 16, Redis 7, Cloud Storage emulator, Mailpit) + `scripts/dev-up`/`dev-down` for both shells |
| CI | `.github/workflows/ci.yml` — hygiene, backend, frontend, AI and docs jobs; language jobs skip until their service exists |
| Decisions | ADR-001/002/003 carried over; ADR-004 records layout and toolchain |
| Roadmap | `docs/ROADMAP.md` — milestones 0–7 with condensed acceptance criteria |

## Verification performed

Report what was actually run, not what was intended.

| Check | Result |
| --- | --- |
| `docker compose config --quiet` | **Passed** — the Compose file parses and interpolates correctly |
| `docker compose up` | **Not run.** The Docker daemon was not running on this machine. The environment is therefore *unverified*: it has never been started, and no health check has ever reported healthy |
| CI workflow | **Passed.** Latest run [31926973432](https://github.com/selvasmallive/falconexam/actions/runs/31926973432): all six jobs green, no deprecation warnings, and the backend, frontend and AI jobs emitted their skip notices as designed. Three runs so far — the first surfaced deprecated action versions, the bump broke the AI job on an unresolvable tag, and this one is clean |
| Secret scan | **Passed** in CI, and manually over the tracked file list |
| Mermaid diagrams | Reviewed as source; not rendered by a Mermaid renderer |

The first task of Milestone 1 should be to start the environment and confirm the health checks —
that is a Milestone 1 acceptance criterion regardless, and it validates this scaffolding.

## Global acceptance checklist — Milestone 0

| Item | State |
| --- | --- |
| Code builds from a clean checkout | n/a — no code |
| Automated tests pass | n/a — no tests |
| Migrations apply, rollback documented | n/a — no migrations |
| Authorization and tenant isolation tested | n/a — not implemented (Milestone 1) |
| No secrets or private media URLs exposed | Met — no secrets tracked; `.gitignore` blocks env files and keys, with `.env.example` explicitly re-included |
| Audit events for sensitive actions | n/a — not implemented |
| Accessibility impact reviewed | n/a — no UI. WCAG 2.2 AA recorded as a gate for Milestones 3 and 7 |
| Privacy/data-flow impact documented | Met — inventory created |
| Threat model updated | Met — skeleton created, all entries `Planned` |
| User-facing limitations documented honestly | Met — `KNOWN_LIMITATIONS.md` |
| AI output advisory and human-reviewed | Met at design level — enforced architecturally in Milestone 4 |
| Status docs updated | Met |

## Next

Start a new Claude Code session for Milestone 1 with
`development-kit/prompts/01-foundation-and-domain.md` and
`development-kit/templates/CLAUDE-MILESTONE-INSTRUCTION.md`.

Before writing code, Milestone 1 should decide the three open gaps — G-01 appeal entity, G-02
identity-verification entity, G-03 chat entity — since all three change the schema.
