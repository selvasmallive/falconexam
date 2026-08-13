# ADR-004: Monorepo layout, modular-monolith baseline and toolchain

- Status: Accepted
- Date: 2026-08-12
- Owners: FalconExam architecture

## Context

The specifications fix the stack in broad terms — Java 21 / Spring Boot 3, React / TypeScript / Vite,
Python 3.12 / FastAPI, PostgreSQL, Redis, Google Cloud — and Phase 1 fixes the top-level directory
names. They deliberately do not name a build tool, package manager, dependency manager or version
policy, and they do not say how "modular monolith" is to be enforced rather than merely intended.

Those choices have to be made before the first line of code, they are expensive to change once three
services depend on them, and CI cannot be written without them. Milestone 0 owns cross-cutting
scaffolding, so it owns this decision.

Two further constraints shaped it. The repository currently lives on a Google Drive-synced path,
which is hostile to large dependency trees and to bind-mounted database directories. And the highest
severity risk in the threat model is cross-tenant data exposure, which argues for keeping the
transactional core in one process where isolation can be proven once.

## Decision

### Layout

A single repository containing `apps/web`, `services/api`, `services/ai`, `infra/terraform`,
`tests/e2e`, `tests/security`, `docs`, `scripts`, and a vendored copy of the specification kit at
`development-kit/`. Each service owns its own build; there is no repository-wide build orchestrator
until one is needed.

No shared `packages/` workspace initially. Front-end API types are generated from the OpenAPI
document that `services/api` produces, rather than hand-maintained in a shared package. A shared
package is introduced only when a second TypeScript consumer exists.

### Modular monolith, enforced

`services/api` is one deployable containing the eighteen modules in
[domain-boundaries.md](../architecture/domain-boundaries.md). Modularity is enforced mechanically,
not by convention: package structure separates each module's `api` from its `internal`; ArchUnit
tests in CI fail the build on module cycles, cross-module `internal` imports, cross-module entity
imports, JPA relationships crossing a boundary, unscoped repository methods, and writes to
`audit_event` from outside `audit`. Flyway migrations are organized per module with table prefixes,
so a foreign key crossing a boundary is visible in review.

Only inference (`services/ai`) and media/retention workers run separately — both have a demonstrated
scaling profile (bursty, CPU/GPU- or I/O-bound, asynchronous) and hold no durable tenant state. Any
further extraction requires a demonstrated scaling or security boundary and a superseding ADR.

### Toolchain

| Component | Choice | Reason |
| --- | --- | --- |
| `services/api` build | Gradle multi-project, Kotlin DSL, wrapper committed | Multi-project support suits eighteen modules; the wrapper pins the version for CI and every developer |
| Java | 21 (Temurin) | Specified; current LTS |
| `apps/web` package manager | pnpm, with Node 22 LTS | Content-addressed store keeps the dependency tree far smaller — this matters on a synced drive; strict resolution prevents phantom dependencies |
| `services/ai` dependencies | `uv` with `pyproject.toml` and a committed lockfile | Fast, reproducible resolution; a lockfile is a supply-chain control (T-22) |
| Python | 3.12 | Specified |
| Local PostgreSQL | 16 | Matches a Cloud SQL supported major version |
| Local Redis | 7 | Matches Memorystore |
| Local object storage | `fake-gcs-server` | Only practical local emulator; its differences from real GCS are recorded as a limitation, not hidden |
| CI | GitHub Actions | Specified |

Local backing services run under Docker Compose using **named volumes only**. Only read-only
configuration is bind-mounted.

## Alternatives considered

- **Maven for `services/api`.** Rejected, narrowly. Maven is more conventional in Spring shops and its
  rigidity is a genuine virtue. Gradle wins here specifically on multi-module ergonomics and
  incremental build time across eighteen modules; a team that prefers Maven could switch before
  Milestone 1 at low cost, and after it at high cost.
- **npm or yarn instead of pnpm.** Rejected on disk footprint and install time, which are materially
  worse on a synced drive, and on pnpm's stricter dependency resolution.
- **Poetry or plain pip/requirements.txt for the AI service.** Poetry is a reasonable alternative;
  `uv` was chosen for speed and lockfile handling. Plain pip was rejected — no lockfile means no
  reproducible build and a weaker supply-chain story.
- **Separate repositories per service.** Rejected: cross-cutting changes (a contract change touching
  API, web and tests) would need coordinated pull requests across repositories, and the specification
  kit could not sit alongside the code it governs.
- **Microservices from the start.** Rejected by the specifications, and independently by the threat
  model: distributing the transactional core multiplies the places tenant isolation can silently
  fail, for no scaling benefit the two extracted workers do not already provide.
- **Documented-only module boundaries.** Rejected. An unenforced boundary erodes within weeks, and
  the whole rationale for the monolith is that the boundaries survive to make later extraction
  possible.

## Security, privacy and accessibility impact

- **Security.** Keeping the transactional core in one process makes tenant isolation provable in one
  place, and the ArchUnit rule against unscoped repository methods turns the top threat-model risk
  into a build failure. Lockfiles across all three ecosystems support the supply-chain controls in
  T-22. Named volumes avoid database corruption from filesystem sync.
- **Privacy.** No direct impact. The layout keeps evidence-handling code (`evidence`, `retention`) in
  reviewable modules with explicit boundaries rather than spread across services.
- **Accessibility.** No direct impact. `apps/web` as a single application means one accessibility
  baseline and one i18n framework for all ten roles, instead of per-role apps drifting apart.

## Consequences

- Milestone 1 must create the Gradle multi-project build, the pnpm workspace and the `uv` project,
  and must land the ArchUnit rules with the modules — rules added later would be written to fit the
  code rather than the design.
- CI is already written against these choices; changing one means changing the workflow.
- Cross-module joins become two queries, by design. Developers will feel this; the trade is
  deliberate and documented in the boundary map.
- The vendored `development-kit/` copy can drift from the kit repository and must be synced
  deliberately.
- Working from a synced drive will be slow. Cloning to a local disk is recommended before Milestone 1
  and changes nothing in this ADR.

## Rollback or migration plan

- **Build tools** are the cheapest to reverse before Milestone 1 completes and progressively more
  expensive after. Gradle→Maven, pnpm→npm and uv→Poetry are all mechanical migrations affecting the
  build files and CI only, with no effect on the data model or the architecture.
- **Versions** (PostgreSQL 16, Node 22, Redis 7) are floating baselines, not commitments; bumping a
  major version is a normal maintenance change.
- **The layout and the modular monolith** are the expensive parts. Extracting a module into its own
  service is intended to remain possible precisely because the boundaries are enforced: the module
  already communicates through a published API and events, and owns its own tables. That path
  requires a superseding ADR with the measurement that justifies it.
