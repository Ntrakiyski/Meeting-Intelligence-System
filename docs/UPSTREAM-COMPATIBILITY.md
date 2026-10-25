# Upstream Tools and Compatibility Notes

Verified against upstream documentation/source on **2026-10-25**. Recheck current versions **after cloning**; do not rely on code samples from different major releases.

## VideoDB

- Official agent skill: https://github.com/video-db/skills/blob/main/python/SKILL.md
- Python SDK: https://github.com/video-db/videodb-python
- Hosted MCP: https://mcp.videodb.io/mcp (client OAuth/auth required)
- SDK `video.understand` analyzers include `spoken_words`, `vlm` and `ocr`; store artifacts, then `video.index` and retrieve.
- **Pitfall:** the current official skill says a `partial` analyzer run may make `wait_until_complete()` poll until timeout. Poll analyzers with a bounded deadline and index successful artifacts; report partial failures. Read current skill rather than copying outdated synchronous examples.
- Current search response API may expose `SearchResponse`/`shots` and not the old `SearchResult`. Check installed SDK shapes before coding.
- Existing transcript.txt is not automatically usable as a native VideoDB speech index; do not assert that uploading a companion text file bypasses VideoDB speech processing.

## SentrySearch

- README: https://github.com/ssrajadh/sentrysearch
- LiteLLM source: https://github.com/ssrajadh/sentrysearch/blob/master/sentrysearch/litellm_embedder.py
- `--backend litellm` proxy path sends `data:video/mp4;base64,...` to standard `/embeddings` with model alias and floating vector response; text queries use same route.
- Upstream notes **Gemini Embedding 2 tested**. Others are hypotheses until verified on synthetic inputs.
- `--rerank` currently **unsupported in LiteLLM mode**; do not enable or route directly to provider.
- Original MP4 clip offsets and local Chroma model identity must be preserved. `stats --json` and `dlq list` help diagnose.
- For Teams static screen shares, use `--no-skip-still` in pilot; otherwise scene chunks may be omitted. Chunking + low resolution can make terminal text unreadable.
- No built-in transcript.txt import, transcription or OCR. Those are separate concerns.
- There is no requirement to install local Qwen if using proxy-hosted model. `24 GB system RAM` is *not* GPU VRAM.

## LiteLLM / Azure Foundry

- LiteLLM docs: https://docs.litellm.ai/docs/
- Voyage Foundry model: https://ai.azure.com/catalog/models/voyage-multimodal-3.5
- Voyage accepts native text/image/video embedding input with an Azure-managed API path ending `/v1/multimodalembeddings`, output dimensions commonly 1024 (or 256,512,2048). It is not identical to standard text `/embeddings`.
- Model alias listing does not prove binary video input support; real sample tests required.
- Azure Qwen-VL catalog entries do not prove user's tenant access, endpoint type or proxy support.
- OpenAI/Azure `text-embedding-3-small`, `text-embedding-3-large`, `ada-002` are for transcript **text**, not raw video embeddings.
- Provider credentials stored on proxy/authorized secret store only.

## Optional transcript alignment

- faster-whisper: https://github.com/SYSTRAN/faster-whisper
- CPU int8 `base`/`tiny` word timestamps derive from recognized speech; no automatic forced alignment of arbitrary original transcription. Review manual beginning/end anchors.
- Do not run on all 40 unless specifically approved.

## Version pinning

After successfully testing a package, document the installed exact version or upstream commit in local `data/runs/<run-id>/manifest.json`. For a future reproducible repo setup, add pinned dependency lock only for code that is actually introduced. Do not add untested version pins in this docs-only stage.
