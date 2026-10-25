# Windows MVP — Hybrid SentrySearch + LiteLLM + Azure Foundry

**Historical filename**: `local-mvp.md`. This option is now `hybrid`, not offline inference.

## Processing boundary

Windows: the original 40 MP4/transcript.txt files, SentrySearch CLI, ChromaDB indexes, selected image/clip files. Existing **self-hosted LiteLLM**: all application-driven models. **Azure AI Foundry**: the provider behind the LiteLLM deployment for embeddings and optionally vision/reasoning.

No Qwen local GPU inference is required by this design; the 24 GB system RAM limitation is much less important than upload bandwidth, video model limits and provider costs.

## First-time setup

1. User configures Azure Foundry model deployments and proxies them through LiteLLM; confirm their existence.
2. Read `docs/litellm-integration.md`; perform synthetic chat, vision, text and video embedding probes **before real videos**.
3. Install SentrySearch from its upstream checkout using `uv` and Python 3.12. Its `litellm` **proxy mode** requires no in-process LiteLLM installation.
4. Connect environment variables securely to the proxy, not directly to Azure.
5. Select `hybrid`:

```powershell
.\scripts\select-provider.ps1 -Provider hybrid
```

Once `meeting-video-embedding` is proven compatible with SentrySearch:

```powershell
sentrysearch index "C:\path\to\one-authorized-meeting" --backend litellm --model meeting-video-embedding --no-skip-still
sentrysearch search "Kubernetes deployment error shown on screen" --results 5 --no-trim
```

The `--no-skip-still` option helps avoid accidentally excluding static slides/dashboards. Do not invoke these commands on real customer videos unless cloud model processing is approved.

## What if Azure video embedding cannot pass through LiteLLM?

- **Stop** and report the failed video-payload/endpoint test. Do not substitute text-only embeddings into SentrySearch video indexes.
- As a *limited pilot*, reuse existing transcripts and sample specific original-resolution frames (e.g. with FFmpeg) to submit to a verified `meeting-vision` model through LiteLLM. Compare visual facts against real clips. This supports some screen analysis but does **not** provide general native video semantic search.
- Keep the VideoDB path as primary, which remains functional independently of this blocker. An actual video adapter would be a separate, minimal, explicitly approved development scope.

## Optional transcription

Use supplied transcript.txt files. Optional `faster-whisper` CPU int8 base only for missing timestamps/gaps; never bulk-transcribe by default. See `docs/transcript-timestamps.md`.

## Verify

Record the exact proxy alias IDs (never keys), Foundry model deployments (non-secret names), embedding dimensions, retriever status, one correct screen-only clip, one speech-only citation, costs and whether MP4 chunks/frames left the machine. Save private report under ignored `data/`.

**Status:** Azure/SentrySearch video embedding integration not yet validated on the user's gateway. No real video has been processed.

## Latest implementation contract

Use [docs/GATEWAY-CONTRACT.md](GATEWAY-CONTRACT.md) and [docs/IMPLEMENTATION-PLAN.md](IMPLEMENTATION-PLAN.md) rather than treating this note as the sole implementation specification. Native SentrySearch video embeddings behind Azure/LiteLLM remain **unverified**; current source sends inline base64 MP4 to `/embeddings`, while Foundry Voyage uses `/v1/multimodalembeddings`. Upstream SentrySearch LiteLLM `--rerank` is unsupported; never enable it. If the native integration fails, the limited frame-caption fallback in implementation Phase 3B is allowed as a separately labeled, reduced-coverage trial after recording the blocker and securing model-data consent. It may require isolated minimal glue; no new app/server.
