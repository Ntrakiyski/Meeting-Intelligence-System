# Azure Foundry deployments for Meeting Intelligence via LiteLLM

**Architectural decision:** The user will connect Azure Foundry into an existing self-hosted LiteLLM proxy. All **application-controlled** model calls route through LiteLLM; no direct Azure SDK/model calls from app workflows. Deployment availability/region/quota and specific endpoint compatibility are not yet verified.

## Model mapping (proposed)

| Function | Foundry model candidate | LiteLLM alias (proposed) | Verified? |
|---|---|---|---|
| Decisions/summaries | Azure-hosted chat/reasoning model chosen by user | `meeting-reasoning` | No |
| Screenshots/diagrams | Azure-hosted vision-capable chat model | `meeting-vision` | No |
| Transcript embeddings | `text-embedding-3-small` or existing `text-embedding-ada-002` | `meeting-text-embedding` | No |
| Full video embeddings | `voyage-multimodal-3.5` or deployable `Qwen3-VL-Embedding-2B` | `meeting-video-embedding` | **Compatibility blocked pending test** |

## Protocol issues

Voyage's Foundry model page documents `/v1/multimodalembeddings`, not standard OpenAI `/embeddings`. SentrySearch's LiteLLM backend sends video as `data:video/mp4;base64` via `/embeddings`. LiteLLM's standard embeddings endpoint supports text-oriented OpenAI-compatible formats; do **not** assume that gateway routing handles Voyage's video contract. Check explicit LiteLLM/provider support and validate synthetic video retrieval.

Qwen catalog presence does not prove access to a deployment, video endpoint, or LiteLLM route. The gateway or provider may need an adapter; this must be documented and separately approved instead of invented.

Text embeddings are not video embeddings. Models must produce compatible vectors for query and index on a stable alias. Do not configure alternate-model fallback for any embedding alias.

## Admin checklist

- User connects available Foundry deployments to LiteLLM (secure gateway-only provider keys).
- Inspect proxy `/models`, deployment region, access and model pricing.
- Verify tiny **synthetic** text embedding, image-chat, and video-embedding calls as described in `docs/litellm-integration.md`.
- Record supported modality, dimensions, endpoint, input limits and cost before processing confidential media.
- Disclose Azure as the remote inference destination even when SentrySearch indexes remain local.

Sources:
- https://ai.azure.com/catalog/models/voyage-multimodal-3.5
- https://ai.azure.com/catalog/models?task=embeddings
- https://github.com/ssrajadh/sentrysearch
- https://docs.litellm.ai/api-reference
