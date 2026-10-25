# Microsoft Foundry — Optional Embedding Experiments

**Scope:** research/optional cloud-hosted embedding models. Does not replace primary VideoDB. Does not run in strict local/offline provider mode without explicit user approval.

## Verified public catalog

| Model | Modality | Intended meeting use | Compatibility status |
|---|---|---|---|
| `text-embedding-3-small` | Text | Existing transcript semantics | General Azure OpenAI deployment; not SentrySearch video-compatible |
| `text-embedding-3-large` | Text | Higher-recall transcript search | Same |
| `text-embedding-ada-002` | Text | Reuse existing deployment if present | Older, text only |
| `Cohere Embed 4` / `embed-v-4-0` | Text + images | Slide and frame screenshot search | Not native video ingestion |
| `Qwen-Qwen3-VL-Embedding-2B` | Model family accepts text/image/video | Hosted analog to local Qwen video search | Listed in Foundry; tenant deployment and endpoint support unverified |
| `voyage-multimodal-3.5` | Text + images + **video** | Video clip and transcript multimodal vectors | Foundry page explicitly documents a `/v1/multimodalembeddings` endpoint; deployment status unverified |

## How to verify in user's Azure account

1. Sign in to [Microsoft Foundry](https://ai.azure.com).
2. Open the project -> **Models / Model catalog** and filter **Embeddings**.
3. Inspect `Qwen-Qwen3-VL-Embedding-2B` and `voyage-multimodal-3.5` model details.
4. For each: check whether **Deploy** is enabled in subscription/region, and whether it is pay-per-token or managed-compute (potentially requiring a provisioned GPU endpoint).
5. Check deployment health, permissions, quotas, actual endpoint API and pricing before any footage transfer.
6. Test synthetic screenshot/video chunk + short text query; check shape and retrieval output.
7. Use the deployment only after explicit privacy approval. Avoid touching the real 40 recordings in discovery.

**No account-specific Azure portal access is available to this documentation update; catalog presence != entitlement/deployment.**

## LiteLLM nuance

SentrySearch supports a `litellm` backend for **video-capable embedding** models served through a compatible gateway. Its README reports Gemini Embedding 2 tested; alternative models need verification and might require adapters. Standard Azure OpenAI text embedding routes through LiteLLM are not substitutes for video embedding. Do not mix vectors or use embedding fallback to a different model.

## References

- Catalog: https://ai.azure.com/catalog/models?task=embeddings
- Voyage native video API: https://ai.azure.com/catalog/models/voyage-multimodal-3.5?task=embeddings
- Qwen2B listing: https://ai.azure.com/catalog/models/Qwen-Qwen3-VL-Embedding-2B?task=embeddings
- Cohere Embed 4: https://ai.azure.com/catalog/models/embed-v-4-0?task=embeddings
- Microsoft managed compute overview: https://learn.microsoft.com/en-us/azure/foundry/concepts/managed-compute-overview
- SentrySearch LiteLLM support: https://github.com/ssrajadh/sentrysearch
