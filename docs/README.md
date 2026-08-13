# FalconExam documentation

Start here. `development-kit/specs/` is authoritative for requirements; everything below describes
how this repository implements them.

## Current state

- [STATUS.md](STATUS.md) — what exists, what was verified, and what was not
- [KNOWN_LIMITATIONS.md](KNOWN_LIMITATIONS.md) — what the product cannot do, honestly
- [ROADMAP.md](ROADMAP.md) — milestones 0–7 with acceptance criteria

## Architecture

- [architecture/overview.md](architecture/overview.md) — context, containers, key flows, tenancy
- [architecture/domain-boundaries.md](architecture/domain-boundaries.md) — modules, entities, allowed dependencies
- [architecture/assumptions-and-conflicts.md](architecture/assumptions-and-conflicts.md) — resolved conflicts, working assumptions, open specification gaps

## Decisions

- [DECISIONS.md](DECISIONS.md) — decision log and ADR index
- [adr/](adr/) — the ADRs themselves, plus the template for new ones

## Security and privacy

- [security/threat-model.md](security/threat-model.md) — trust boundaries and the attack-surface register
- [privacy/data-flow-inventory.md](privacy/data-flow-inventory.md) — data categories, purposes, processors, retention ownership

## Audience guides

- [guides/](guides/) — LTI setup, administrator, proctor, reviewer and student guides. Not written
  yet; each lands with the milestone that builds what it describes.

## Working in this repository

[../CLAUDE.md](../CLAUDE.md) is the working agreement: authority order, non-negotiable product and
engineering rules, and the per-milestone workflow.
