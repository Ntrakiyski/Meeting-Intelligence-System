# LiteLLM / Azure Foundry Integration Contract

**Current state:** Configuration intended, **not verified** in user's LiteLLM deployment. All model calls controlled by our own workflow MUST go through the existing LiteLLM proxy. VideoDB's native internal analyzers are outside this contract.

## 1. Four logical model roles

| Gateway alias (proposed) | Input | Output | Must pass |
|---|---|---|---|
| `meeting-reasoning` | Text/messages | Text | factual formatting + token usage |
| `meeting-vision` | Text + image | Text about screenshot | actually accepts image attachments |
| `meeting-text-embedding` | Text | Numeric vector | fixed dimensions and stable model |
| `meeting-video-embedding` | Video MP4 **and** separate text query | Vectors in same retrieval space | exact SentrySearch proxy call and image/video support |

These aliases are **placeholders**. Do not configure phantom Foundry deployments or claim a model listed in a catalog is active. Confirm authenticated `/models` plus live calls. Model versions/dimensions must be logged locally without keys.

## 2. Windows PowerShell proxy health (no credentials in repo)

Assume user already has working LiteLLM VPS. Set env vars **in the process** using a secure secret store; below values are placeholders, not real credentials.

```powershell
$env:LITELLM_PROXY_API_BASE = "https://YOUR-LITELLM-HOST/v1"
$env:LITELLM_PROXY_API_KEY = "<virtual-key-from-your-gateway>"
$base = $env:LITELLM_PROXY_API_BASE.TrimEnd('/')
$headers = @{ Authorization = "Bearer $env:LITELLM_PROXY_API_KEY" }
Invoke-RestMethod -Uri "$base/models" -Headers $headers -Method Get
```

Never paste real secrets into repository files, terminal transcripts, uploaded prompts or test output. Log model identifiers only, not tokens. Check the proxy's health/auth, and compare `/models` against the configured `config/pipeline.json` roles.

Tiny chat probe:

```powershell
$body = @{ model = "meeting-reasoning"; messages = @(@{ role = "user"; content = "Respond exactly: READY" }) } | ConvertTo-Json -Depth 10
Invoke-RestMethod -Uri "$base/chat/completions" -Headers $headers -Method Post -ContentType "application/json" -Body $body
```

Tiny text embedding probe:

```powershell
$body = @{ model = "meeting-text-embedding"; input = @("synthetic meeting about a test dashboard"); encoding_format = "float" } | ConvertTo-Json -Depth 10
$response = Invoke-RestMethod -Uri "$base/embeddings" -Headers $headers -Method Post -ContentType "application/json" -Body $body
$response.data[0].embedding.Count
```

Verify numeric, nonempty, fixed-dimension vectors on two requests, and log deployment/usage. A model that appears in `/models` but fails inference is NOT ready.

## 3. Vision smoke test

Use a **synthetic** PNG containing distinctive text such as `TEST ONLY - SCREEN 503`. Send via the proxy's chat-completions endpoint with an image-capable model using the provider-supported image-content schema. Verify the returned description reads the distinctive text. Do not use a private Teams screenshot for the first test. Failure to interpret legible test text disqualifies the alias for exact-screen reading; do not mask with a text-only prompt.

## 4. Native video embedding is the highest-risk contract

Actual SentrySearch LiteLLMEmbedder uses roughly:

```http
POST {LITELLM_PROXY_API_BASE}/embeddings
Authorization: Bearer <virtual-key>
Content-Type: application/json

{
  "model": "meeting-video-embedding",
  "input": ["data:video/mp4;base64,<BASE64_MP4>"],
  "encoding_format": "float"
}
```

It submits **text queries** to the same alias via `/embeddings` with `input: ["visual scene about a test panel"]`. If video and text are embedded by different actual models, the search is invalid. SentrySearch might keep separate indexes per name, but same alias with silently changed backing model also invalidates existing vectors.

Compare to published Microsoft Foundry Voyage 3.5 contract:

```http
POST {AZURE_FOUNDRY_ENDPOINT}/v1/multimodalembeddings
Authorization: Bearer <Azure-managed token or key>

{
  "model": "voyage-multimodal-3.5",
  "input_type": "document",
  "inputs": [{"content": [{"type": "video_base64", "video_base64": "<video-payload-as-required-by-provider>"}]}],
  "output_dimension": 1024
}
```

**Provider illustration only:** consult current Foundry documentation for exact `video_base64` field value, media metadata and limits. This is not a claimed working request or a valid LiteLLM drop-in.

**Compatibility checklist:**
- [ ] A compatible Azure Foundry deployment actually exists and is authorized.
- [ ] LiteLLM supports incoming SentrySearch `/embeddings` MP4 requests for that model alias and properly transforms/forwards to the Foundry video endpoint.
- [ ] 5–10 s **synthetic** MP4 returns a numeric vector; no 413/415/422/unsupported modality.
- [ ] A text query returns numeric vector from **same** deployment/dimension/space.
- [ ] Positive scene query ranks its matched synthetic clip ahead of unrelated control clip.
- [ ] Proper usage/cost, input limits and private logging behavior verified.
- [ ] Existing indexes isolated by actual provider model/version/dimensions.
- [ ] No fallback across different embedding models (including proxy model router).

If any item fails: status `blocked`, save redacted diagnostics. Do not configure the text-only OpenAI embedding as fake video embedding. Run reduced frame-caption path only when it has its own documented acceptance status.

## 5. SentrySearch CLI after pass

The LiteLLM mode uses environment values above; **do not run `sentrysearch init`**, which prompts for a Gemini key by default, when the organization uses a proxy.

```powershell
sentrysearch index "C:\approved-pilot-video-folder" --backend litellm --model meeting-video-embedding --no-skip-still --rpm 10
sentrysearch search "a test deployment error visible on screen" --results 5 --no-trim
sentrysearch stats --json
```

Check installed upstream version supports flags. `--no-skip-still` is crucial for static Teams presentation screens. The source SentrySearch README states `--rerank` is **not supported** with its LiteLLM backend and may otherwise bypass the proxy; keep reranking off. Do not rely on its default Gemini embedding alias.

## 6. Notes for proxy administrator

- Register only aliases actually backed by working Azure deployment endpoints. Keep Foundry keys/server secret material on LiteLLM VPS.
- Enforce virtual-key scope, auth, usage budgets and logs with media/prompt redaction.
- Never log raw base64 video/image request bodies in debug traces.
- Disable fallback from video embedding alias to other models—even same-dimensional different families.
- Separate test and future production credentials/limits.
- Do not deploy a custom compatibility adapter as a prerequisite; only propose one if the synthetic probe conclusively demonstrates an actual mismatch.

Primary docs:
- https://github.com/ssrajadh/sentrysearch/blob/master/sentrysearch/litellm_embedder.py
- https://ai.azure.com/catalog/models/voyage-multimodal-3.5
- https://docs.litellm.ai/docs/
