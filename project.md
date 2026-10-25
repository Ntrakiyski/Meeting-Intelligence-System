# PROJECT — Meeting Intelligence System

## Problem

Teams meeting transcripts capture speech but miss demonstrations, terminals, UI states, diagrams and the sequence of visible on-screen events. Isolated summaries do not create lasting, searchable project memory.

## Vision

Turn an authorized meeting MP4 collection into multimodal, timestamp-grounded knowledge that people and AI agents can query and act upon. Users should be able to ask *what was shown*, not only *what was said*.

## Business goals

1. Preserve technical explanations, demonstrations and decisions with retrievable video evidence.
2. Reduce manual note taking and repeated client/developer explanations.
3. Generate draft requirements, issues, handover docs and audit-ready explanations from recordings.
4. Make these workflows available to agents via portable `SKILL.md` instructions; offer UI and organizational MCP later only if required.
5. Keep operating cost, source permissions and control of meeting content visible.

## MVP (Windows — no custom application development)

- **Environment:** user's Windows PC, Codex or GitHub Copilot agent, folder of authorized MP4 files.
- **Provider:** VideoDB API, official VideoDB skill/MCP, optionally VideoDB Python SDK as an existing tool.
- **Inputs:** one local recording first; then five test recordings with screen sharing.
- **Output:** searchable spoken/visual evidence with accurate timestamps and a source clip, a summary, visible error/UI/diagram findings, and documented costs or usage.
- **Interaction:** chat with an agent using the installed official skill. No standalone GUI required.
- **Integration:** the user already has a VideoDB account and API key. Store secrets locally only.
- **No need for initial custom infrastructure:** no Go or Python service, React app, bespoke MCP server, database, containers or local vision-model stack.

### Acceptance criteria

- A real on-screen finding not present in the transcript is identified correctly.
- The system returns an inspectable timestamp/clip for each major evidence-backed claim.
- It separates what appears on screen, what participants said, and an agent's interpretation.
- It reports uncertainty where frames, audio, OCR or speaker attribution are insufficient.
- It provides a reproducible procedure, a cost/usage snapshot and a short validation report.
- The source recording and secrets are not committed to GitHub.
- If VideoDB fails these tests, capture the precise failure and propose the smallest workaround.

## Subsequent phases (not MVP)

**Phase 2:** Multiple recordings, collections, project permissions, consistent artifact schemas, issue/document handover skills.

**Phase 3:** Live Teams meeting participation and agent-initiated workflows; distinguish on-device local screen/audio capture from a visible meeting participant bot and from a Teams chat agent. Require permission and clear consent.

**Phase 4:** Lightweight Vite/React UX or company-facing MCP only if the native tools and existing interfaces prove insufficient.

## Technical decisions

| Topic | Default |
|---|---|
| Primary VideoDB integration | Official skill and supported hosted MCP |
| Programmatic fallback | VideoDB's maintained Python SDK |
| Visual analysis | VideoDB `vlm` and `ocr` analyzers, plus spoken words |
| Retrieval | VideoDB understand → index → retrieve/search/ask |
| UI | Agent chat for MVP; Vite/React later |
| Custom MCP | None for MVP; re-evaluate Go mcp-go only if needed |
| AI reasoning | VideoDB built-ins first; approved Copilot or LiteLLM configuration only if a capability gap exists |
| Data storage | Original test files local; understand processing may upload to VideoDB Cloud |
| Business workflow definitions | Per-use-case `skills/<name>/SKILL.md` |
| Team production deployment | Separate architecture/security review |

## Important boundaries

- An existing GitHub Copilot seat is **not** an unrestricted OpenAI-compatible inference endpoint. A LiteLLM route that happens to connect to Copilot must be independently checked for supported authentication and licensing. It is not an MVP requirement.
- The VideoDB open-source repositories are not evidence that the commercial indexing backend can be self-hosted without a contract.
- Do not upload real client/customer recordings until confidentiality, consent, retention, access rights and provider processing location have been approved.
- The repository is public: never commit recordings, API keys, transcripts or screenshots from confidential meetings.

## Measure

Per-file processing success, relevant visual findings, retrieval precision, playable timestamp accuracy, supported languages, turnaround latency, provider usage/cost, and manual correction rate.

## Non-goals for MVP

No app development, bespoke bots, GUI, live meeting joining, company-wide permissions, local deployment of VideoDB core, mandatory LiteLLM, or generation of real tickets without review.
