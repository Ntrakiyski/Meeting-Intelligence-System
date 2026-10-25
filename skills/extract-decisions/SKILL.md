---
name: extract-decisions
description: Extract approved decisions, proposed solutions, owners, and unresolved items from a meeting with timestamped visual and spoken evidence.
---

# Extract Decisions

Read `AGENTS.md` and `config/provider.json`; use the selected existing backend via `analyze-meeting`. Distinguish explicit approvals, suggestions, rejections and unresolved items. Avoid asserting speaker identities without evidence. Provide a timestamp for each decision and separate spoken approvals from things merely displayed on screen. Return a draft decision log; no external writes without approval.
