# Meeting embeddings — via self-hosted LiteLLM

## A single gateway for our model calls

- All **custom application** embeddings and reasoning use the user's LiteLLM proxy, which they will connect to Azure AI Foundry.
- **VideoDB remains separate** for its managed indexing/understanding; its internal analysis cannot be assumed to use LiteLLM.
- Our four proposed (not yet active) aliases are `meeting-reasoning`, `meeting-vision`, `meeting-text-embedding`, `meeting-video-embedding`.

## Important modality difference

1. Existing `transcript.txt`: full-text/keyword search first (zero embeddings needed). Optionally use Azure OpenAI text embeddings through LiteLLM for semantic matching.
2. MP4 or actual video chunks: **multimodal video embeddings** required for SentrySearch native video search; text-only OpenAI embeddings do not work.
3. Screen-readable small text: selected full-resolution frames and an image-capable model via LiteLLM, optional OCR. Video embeddings may locate a scene but do not guarantee accurate on-screen lettering.
4. Optional `faster-whisper` (local, CPU int8) aligns missing transcript timestamps; not itself an embedding model.

## Candidate Azure models

- `text-embedding-3-small`: transcript chunks (text only).
- `voyage-multimodal-3.5`: documented native video embeddings via Foundry, but endpoint uses `/v1/multimodalembeddings`, **not proven compatible** with SentrySearch LiteLLM's `/embeddings` video body.
- `Qwen3-VL-Embedding-2B`: multimodal model family, Foundry catalog option; deployment access and endpoint require verification.
- Reasoning and vision: user's available Azure-chat deployments behind LiteLLM, selected based on actual image capability.

## Isolation and testing

Video clips and text queries must use same video embedding model/vector space. Do not silently route embedding models through a fallback. First check `docs/litellm-integration.md` with synthetic video and text; only index MP4s after successful retrieval and approval. For failed video embedding, manually inspected frames + LiteLLM vision are a limited pilot, *not* complete semantic video search.
