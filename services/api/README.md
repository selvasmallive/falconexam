# services/api — FalconExam modular monolith

Java 21 + Spring Boot 3 + Spring Security + Spring Data JPA + Flyway, on PostgreSQL and Redis.
System of record for tenants, identity, exams, sessions, evidence metadata, incidents, review,
retention, audit and entitlements.

**Not implemented yet.** Created in Milestone 1
(`development-kit/prompts/01-foundation-and-domain.md`).

This is a *modular* monolith: module boundaries are enforced, not decorative. See
[docs/architecture/domain-boundaries.md](../../docs/architecture/domain-boundaries.md) for the module
list, ownership and allowed dependency directions. Extracting a module into its own service requires
a demonstrated scaling or security boundary and an ADR.

Media bytes never enter this service's database — only metadata. See ADR-001 for why there is no
question bank or grading here.
