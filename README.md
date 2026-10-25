# Meeting Intelligence System

**Tomorrow / new agent:** Start at [docs/TOMORROW-CODEX-KICKOFF.md](docs/TOMORROW-CODEX-KICKOFF.md). The canonical execution order is in [docs/IMPLEMENTATION-PLAN.md](docs/IMPLEMENTATION-PLAN.md); do not begin by coding a backend.

### Build-ready technical specification

- [Architecture](docs/ARCHITECTURE.md) — ownership, data flow, two provider boundaries
- [Decisions / ADRs](docs/DECISIONS.md) — accepted decisions vs open questions
- [Shared evidence contracts](docs/DATA-CONTRACTS.md) — normalized video-relative citations and run manifests
- [LiteLLM gateway contract](docs/GATEWAY-CONTRACT.md) — exact video embedding compatibility gate
- [Implementation plan](docs/IMPLEMENTATION-PLAN.md) — phases 0–4 and stop/go gates
- [Test plan](docs/TEST-PLAN.md) — manual evidence, positive/negative and model tests
- [Security and cost controls](docs/SECURITY-AND-COSTS.md) — consent, costs, logs, budgeting
- [Upstream compatibility](docs/UPSTREAM-COMPATIBILITY.md) — latest known API pitfalls

**Status: documentation and skills committed; neither provider has yet passed the end-to-end Windows recording test.**


An agent-first system for 40 Microsoft Teams MP4 recordings with existing `transcript.txt` files. **No custom backend, UI, MCP server, or transcription service is required by default.**

## The two MVP choices

| Provider | Video understanding | Models used by our agents | Data boundary |
|---|---|---|---|
| **`videodb` (primary)** | VideoDB Cloud SDK/official skill: VLM, OCR, video retrieval | Our own reasoning and supplemental embeddings via **self-hosted LiteLLM** | Approved video uploaded to VideoDB; model calls we control route through LiteLLM |
| **`hybrid` (alternative)** | Windows-based SentrySearch/FFmpeg and local video/index storage | **All** text/video embeddings and vision/reasoning through LiteLLM → Azure Foundry or other approved model provider | Local storage/index, cloud model inference; not offline |

**Important:** VideoDB's internal visual analyzers/indexing are managed by VideoDB and cannot be assumed to route through LiteLLM. SentrySearch's LiteLLM mode is documented but has been tested upstream with Gemini Embedding 2; **Azure Foundry Voyage video embeddings are not confirmed plug-and-play** because their documented API is `/v1/multimodalembeddings`. See [docs/litellm-integration.md](docs/litellm-integration.md).

## Provider selection (PowerShell)

```powershell
.\scripts\select-provider.ps1 -Provider videodb
.\scripts\select-provider.ps1 -Provider hybrid
```

Legacy `-Provider local` maps to `hybrid` to avoid calling the new cloud-inference approach offline.

## Media and transcripts

- Pair MP4 and transcript.txt by folder or filename; preserve originals. Never commit them to this **public** repository.
- Existing timecodes are preferred. Optional CPU `faster-whisper` runs **only** when transcript alignment or missing speech requires it.
- Start with **one** authorized MP4, verify both provider paths, then five, then the complete library.

## Model aliases (through LiteLLM only)

Configure and test these aliases on your existing proxy (they are **proposed names**, not active deployments):

- `meeting-reasoning` — requirements, summaries, decisions, reports.
- `meeting-vision` — visually inspect retrieved screenshots/frames.
- `meeting-text-embedding` — optional semantic search of transcript chunks.
- `meeting-video-embedding` — true MP4/frame embedding route, only when provider/proxy/SentrySearch compatibility is verified.

Do not make up Azure Foundry deployment names, endpoints, keys or prices. For strict video-embedding compatibility tests, see [docs/azure-foundry.md](docs/azure-foundry.md).

## Guides

- [project.md](project.md) — charter, architecture and acceptance criteria
- [AGENTS.md](AGENTS.md) — operating and safety instructions
- [config/pipeline.json](config/pipeline.json) — model gateway and transcript preferences
- [docs/litellm-integration.md](docs/litellm-integration.md) — gateway requirements and smoke tests
- [docs/windows-mvp.md](docs/windows-mvp.md) — VideoDB path
- [docs/local-mvp.md](docs/local-mvp.md) — hybrid path (historical file name)
- [docs/embeddings.md](docs/embeddings.md) — modality compatibility
- [docs/azure-foundry.md](docs/azure-foundry.md) — Azure deployments and compatibility
- [docs/transcript-timestamps.md](docs/transcript-timestamps.md) — optional Whisper alignment
- [docs/compare-backends.md](docs/compare-backends.md) — side-by-side scorecard
- [resources.md](resources.md) — VideoDB resources only
- [resources-local.md](resources-local.md) — non-VideoDB tools

## First task for Codex

> Read AGENTS.md, project.md, docs/litellm-integration.md and config/*.json. Inspect the existing LiteLLM gateway's published model list with authorization. Verify real model deployments, and test (1) text embedding, (2) image-based reasoning and (3) video embedding with a **synthetic** clip. Do not assume the Azure Voyage endpoint works through standard /embeddings. Report results; do not build an adapter without showing a capability gap and requesting approval. Then take one approved MP4/transcript pair through VideoDB (primary) and through the hybrid route if it passed its compatibility gate.

## Use it from Codex or Copilot

A single, automatically discoverable repo skill is at [`.agents/skills/meeting-intelligence/SKILL.md`](.agents/skills/meeting-intelligence/SKILL.md). Open this repo in Codex and type `$meeting-intelligence status` to see whether your selected provider is ready. For tasks, use `$meeting-intelligence analyze Meeting-001` or `$meeting-intelligence find the deployment error`. The skill routes to the existing use-case instructions and honors `config/provider.json`.

See [docs/using-meeting-intelligence.md](docs/using-meeting-intelligence.md) for usage examples, privacy rules and the distinction between documented setup and a working provider.
