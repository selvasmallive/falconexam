# Known limitations

Last updated: 2026-08-14 (Milestone 0).

Honest limitations are a product requirement here, not a courtesy. Institutions make purchasing and
privacy decisions based on what this file says. Nothing may be removed from it because it is
inconvenient — only because it stopped being true.

## Current state of the software

**No product functionality exists.** Milestone 0 delivered scaffolding and architecture documents
only. Every capability described in `docs/architecture/overview.md`, `docs/ROADMAP.md` and the
specifications is *planned*. Treat any statement about how FalconExam behaves as a design intention
until the milestone that implements it is accepted.

Specifically, as of today: no LTI integration, no session handling, no capture of any kind, no
detection, no review workflow, no retention engine, no entitlements, no deployment.

## Verification gaps in this milestone

| Limitation | Impact | Resolution |
| --- | --- | --- |
| The local environment has never been started — the Docker daemon was not running when it was authored. `docker compose config` validates it; nothing has confirmed it runs | The Compose file may still fail on first use (image tags, health-check commands, port conflicts) | First task of Milestone 1 |
| Mermaid diagrams were reviewed as source, not rendered | A diagram may fail to render | Any Markdown preview |

The CI workflow has now executed and passed (all six jobs, with the language jobs skipping as
designed). It is no longer an unverified artefact.

## Product limitations that will not change

These follow from what the product is, and must appear in customer-facing documentation too.

- **FalconExam is not a lockdown browser.** It cannot reliably detect all external devices, secondary
  screens, virtual machines, phones outside the camera frame, a person off camera, or printed
  material out of view. Ordinary browser JavaScript cannot do this, and no claim to the contrary may
  be made.
- **FalconExam never determines misconduct.** It produces prioritized, explained evidence. A human
  decides, and the LMS owns the outcome. There is no integrity score, and no output may be presented
  as a probability of cheating.
- **FalconExam does not administer exams or compute grades** (ADR-001). It cannot be used as an
  assessment engine.
- **No compliance is claimed.** FalconExam provides controls that help institutions meet their own
  obligations under their own legal advice. It does not certify FERPA, GDPR, PIPEDA, SOC 2 or any
  other regime, and CI fails builds that claim otherwise.
- **No false-positive reduction is claimed.** Any such figure requires reproducible measured
  evaluation (Milestone 4) and may not be used in marketing before then.
- **No emotion recognition, deception detection, personality inference or sensitive-trait
  inference** — not implemented, not planned, not available on request.
- **Detection quality varies with conditions.** Lighting, camera quality, bandwidth, glasses, head
  coverings, skin tone and assistive devices all affect results. Milestone 4 measures this across
  those conditions and publishes the results in model cards rather than assuming parity.

## Known design risks being carried

| Risk | Why it is being carried | Watch item |
| --- | --- | --- |
| Three required behaviours have no entity yet (appeal, identity verification, chat) | The specs describe the behaviour but never named the entities; Milestone 0 does not invent schema | Must be settled in Milestone 1, before live evidence exists to migrate |
| The Cloud Storage emulator does not reproduce real signed-URL semantics | Local development needs *an* emulator | Signed-URL expiry must be tested against real GCS before Milestone 3 is accepted; the local test is not evidence |
| The vendored `development-kit/` copy can drift from the kit repository | Vendoring is what makes the prompt paths resolve | Sync deliberately; record it in `docs/DECISIONS.md` |
| The repository currently lives on a Google Drive-synced path | Where the owner works | Builds, `node_modules`, Gradle caches and Docker operations will be slow and can be disrupted by sync; consider cloning to a local disk before Milestone 1 |
| Accommodations must alter detection policy before capture, not annotate flags afterwards | Easy to implement the wrong way and hard to notice | Milestone 3 policy resolution (G-05) |
