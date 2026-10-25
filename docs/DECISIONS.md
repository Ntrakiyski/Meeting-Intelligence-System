# Architecture Decision Register

**Authority:** This file records approved user direction vs open implementation questions. Do not treat an experiment as approved production capability. Modify with dates and evidence when choices change.

| ID | Status | Decision | Why / impact |
|---|---|---|---|
| ADR-001 | Accepted | One GitHub repo and an agent-first architecture; skill-driven operation. | No bespoke product just to run an MVP. |
| ADR-002 | Accepted | VideoDB Cloud is **primary**; use existing $20 signup credit for a measured pilot. | Fastest baseline for video scene/VLM/OCR retrieval; native VideoDB costs separate from LiteLLM. |
| ADR-003 | Accepted | Second mode is **hybrid** using Windows recording storage and SentrySearch. | Valid alternative to VideoDB, but not offline because Azure inference is remote. |
| ADR-004 | Accepted | **Existing self-hosted LiteLLM** is the only model gateway for application-controlled embeddings, vision and reasoning; Azure Foundry behind it. | Centralizes credentials/aliases/observability; not a supported override of VideoDB internals. |
| ADR-005 | Accepted | Original 40 `transcript.txt` files are primary text inputs. | Avoid repeat transcription/cost; align only when timecodes missing and necessary. |
| ADR-006 | Accepted | `faster-whisper` `base` CPU int8 is optional/on demand. | Speech anchors only, not claim of perfect transcript forced alignment. |
| ADR-007 | Accepted | No Go MCP, custom FastAPI, React/Vite, or server for MVP. | Agent uses official VideoDB tools, SentrySearch CLI and project skills. |
| ADR-008 | Accepted | Public repo must contain **zero** private recordings, screenshots, transcripts, indexes or keys. | Prevent client data leakage; all outputs to gitignored local folders. |
| ADR-009 | Accepted | Standard timestamped evidence contract across providers. | One agent interface; human-verifiable output. |
| ADR-010 | Accepted | Native hybrid video embedding MUST pass compatibility gate before being called functional. | SentrySearch uses `/embeddings` with MP4 base64; Voyage in Foundry uses `/v1/multimodalembeddings` with a different payload. |
| ADR-011 | Conditional MVP fallback | If native video embedding route is unsupported, allow a **small, isolated frame-caption/text-embedding script** after recording the failure and consent, without building a service. | Provides partial, verifiable visual search; NOT equivalent to native full video embeddings. Implement only minimum glue; flag reduced coverage. |
| ADR-012 | Accepted | Never configure embedding fallback to a different model/deployment. | Mixed vector spaces silently corrupt indexes. |
| ADR-013 | Accepted | Pilot one non-sensitive video, then five, then library only after gates. | Cost containment and reproducible testing. |
| ADR-014 | Deferred | Live Teams bot and optional UI/MCP frontend. | No impact on MVP validation. |

## Open decisions / blockers

| ID | Question | Decision gate |
|---|---|---|
| OQ-01 | Which Azure Foundry deployments are active for text embedding, video embedding, vision, reasoning? | Authenticated LiteLLM `/models` + successful smoke tests; no guessing aliases |
| OQ-02 | Does LiteLLM translate Voyage/Qwen video embeddings into SentrySearch-compatible payload/response? | Synthetic MP4 and matching text query through actual SentrySearch proxy backend |
| OQ-03 | If video embeddings cannot route, which existing vision/text model should support frame-caption fallback? | Test image input and standard text embedding through LiteLLM; agree quality/expense |
| OQ-04 | Are transcript.txt files already timestamped and aligned with MP4 audio? | Inspect 3 representative samples; check beginning/end offsets |
| OQ-05 | How much video/audio can legitimately be uploaded to each provider? | Per-recording permissions + organization policy/retention |
| OQ-06 | Actual provider fees and limits? | VideoDB console before/after; LiteLLM spend and Azure invoice/metering |
| OQ-07 | Does the master skill appear in the user's installed Codex/Copilot agent? | `$meeting-intelligence status` verified |
| OQ-08 | SentrySearch behavior on stationary text-heavy Teams screen shares? | Test `--no-skip-still`, readable original-resolution frame evidence |

## Change protocol

For a new ADR: mark Proposed / Accepted / Rejected / Superseded; include rationale, consequences, verification artifact and date. Never silently reinterpret `hybrid` as purely local/offline.
