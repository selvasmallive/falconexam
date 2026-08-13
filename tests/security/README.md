# tests/security — security tests

**Not implemented yet.** Cross-tenant isolation tests are required by Milestone 1; the rest follow
the threat model as each attack surface is built.

Every surface listed in [docs/security/threat-model.md](../../docs/security/threat-model.md) must
have a corresponding test before its milestone is accepted: tenant isolation, IDOR, JWT tampering,
LTI replay and nonce reuse, WebSocket/WebRTC authorization, signed-URL expiry, malicious upload,
media URL leakage, proctor abuse, support impersonation, model-input abuse, compromised LMS
registrations, SSRF and supply chain.

A threat-model entry with no test is an open finding, not a completed control.
