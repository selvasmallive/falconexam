# apps/web — FalconExam front end

React 19 + TypeScript + Vite + Material UI + TanStack Query.

Serves all ten roles from one application shell with role-aware routing: student, instructor,
LMS admin, proctor, reviewer, privacy officer, auditor, support, tenant admin, platform admin.

**Not implemented yet.** Created in Milestone 1 (`development-kit/prompts/01-foundation-and-domain.md`),
which delivers the shell, role-aware routing, accessible navigation and the i18n framework
(English + Canadian French, no hard-coded user-facing strings).

Later milestones add: the student system check and consent flow and the live proctor console
(Milestone 3), the record-and-review timeline and explainable review queue (Milestones 3-4), the
privacy/retention consoles and student appeal flow (Milestone 5), and the tenant onboarding and
usage/cost dashboards (Milestone 6).

WCAG 2.2 AA is a release gate for the student, proctor and reviewer surfaces.
