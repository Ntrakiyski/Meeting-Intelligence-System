# LiteLLM — Single model gateway for controlled inference

## Decision

The user's existing **self-hosted LiteLLM** proxy supplies all application-controlled **reasoning, vision and embeddings**, backed by Azure Foundry deployments. Do not call Azure model endpoints directly from agent workflows.

**Exception:** VideoDB's managed video analyzers and native indexes are not known to accept a LiteLLM override. VideoDB processing remains managed and is billed independently.

## Model aliases to configure on the proxy (not yet verified)

| Proxy alias (placeholder) | Required input | Use |
|---|---|---|
| `meeting-reasoning` | text chat | summaries, decisions, reports |
| `meeting-vision` | image + text | explain UI, screenshot and diagrams |
| `meeting-text-embedding` | text via `/embeddings` | optional transcript semantic retrieval |
| `meeting-video-embedding` | native video clips + compatible text query | SentrySearch full visual search |

Check user's proxy `/models` (authenticated) and deployed Foundry models before declaring any alias active. These aliases are **design conventions only**; add them on the LiteLLM side, not as secrets in the project Git repository.

## Critical protocol compatibility gap

Current [SentrySearch LiteLLM backend](https://github.com/ssrajadh/sentrysearch/blob/master/sentrysearch/litellm_embedder.py):

- Sends `POST {LITELLM_PROXY_API_BASE}/embeddings`.
- Body `{"model":"<alias>","input":["data:video/mp4;base64,..."],"encoding_format":"float"}` for video clips.
- Text queries use the *same* model and embedding vector space.
- Upstream README says **only Gemini Embedding 2 tested** behind LiteLLM.

Current [Azure Foundry Voyage Multimodal 3.5](https://ai.azure.com/catalog/models/voyage-multimodal-3.5) documents **`/v1/multimodalembeddings`** with provider-specific input format. This is *not* equivalent to standard OpenAI `/embeddings`. LiteLLM routing alone does not prove it translates payloads.

Foundry Qwen3-VL Embedding is a separate candidate; subscription availability and VideoDB/SentrySearch/ LiteLLM protocol compatibility are unverified.

**Do not fabricate LiteLLM `model_list` or assume `azure_ai/<deployment>` supports multimodal embedding.** Establish a supported adapter/backend route with tests; if absent, report a blocker, do not silently use a text-only embedding model.

## Connection setup (on Windows, after the user configures their proxy)

PowerShell environment variables in a user-secure session:

```powershell
$env:LITELLM_PROXY_API_BASE = "https://<your-lite-llm-host>/v1"
$env:LITELLM_PROXY_API_KEY = "<virtual-key-from-the-gateway>"
$env:LITELLM_EMBEDDING_MODEL = "meeting-video-embedding"
```

Values above are **placeholders**, not credentials or claims of an endpoint. Do not save them to GitHub or show keys in logs.

## Smoke-test order (synthetic inputs ONLY)

1. Proxy is reachable; authenticated `GET /models` returns actual alias names.
2. `meeting-reasoning`: one tiny text request to `/chat/completions`.
3. `meeting-vision`: one deliberately generated non-sensitive screenshot/image sent to `/chat/completions` using supported image payload, validate output.
4. `meeting-text-embedding`: a short synthetic sentence via `/embeddings`, inspect vector dimension, response and spend.
5. `meeting-video-embedding`: a **synthetic 5–10 second MP4** through the same proxy `/embeddings` request SentrySearch uses, plus a text query on that alias. Validate success, embedding dimensions, modality acceptance, query retrieval and billing.
6. After #5 passes, run SentrySearch against **one approved MP4**, not the entire folder.
7. Confirm privacy rules and cost/usage logs. Disable cross-model embedding fallbacks: swapping embedding spaces invalidates stored vectors.
8. If #5 fails, stop full video indexing and report exact HTTP/API incompatibility without exposing credentials. Optionally inspect manually selected frames using `meeting-vision` as a limited separate pilot; this is not native video retrieval.

## Provider-specific charges

VideoDB credits apply to its service calls even when LiteLLM is the application's reasoning gateway. Azure/model charges apply to LiteLLM-proxied requests; self-hosting the proxy does not make provider inference free. Track both separately.
