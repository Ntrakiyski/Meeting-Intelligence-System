# Local and Optional External Embedding Resources

VideoDB-owned references stay in [resources.md](resources.md). This file lists the non-VideoDB components.

## Selected local visual engine (MVP)

- [SentrySearch](https://github.com/ssrajadh/sentrysearch) — Apache-2.0, Python, video chunk embeddings via local Qwen3-VL, CLI search and returned time-indexed clips, ChromaDB index; Windows supported. **It does not automatically ingest transcript.txt, transcribe speech, or OCR terminal text.** GPU practical; inspect hardware before indexing.
- [Qwen3-VL Embedding models](https://github.com/QwenLM/Qwen3-VL-Embedding) — official multimodal video/image/text model and usage. Start with 2B if hardware permits.
- [faster-whisper](https://github.com/SYSTRAN/faster-whisper) — **optional** timestamp generation/repair, CPU int8 base/tiny. Existing transcripts remain primary.
- [Sentence Transformers](https://github.com/huggingface/sentence-transformers) — optional local embedding of text transcript chunks when keyword search is insufficient. [Multilingual MiniLM](https://huggingface.co/sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2) is a reasonable lightweight first trial.
- [Tesseract OCR](https://github.com/tesseract-ocr/tesseract) — optional exact text extraction from *selected* clear frames/terminal screenshots. Do not OCR all 40 videos automatically.
- [FFmpeg](https://ffmpeg.org/) — extract video frames and inspect/trim clips when needed.

## Azure optional (CLOUD, not a local backend)

- [Microsoft Foundry Embedding Model Catalog](https://ai.azure.com/catalog/models?task=embeddings)
- [Voyage Multimodal 3.5](https://ai.azure.com/catalog/models/voyage-multimodal-3.5?task=embeddings) — Azure endpoint with documented native **video** embedding API.
- [Qwen3-VL-Embedding-2B Foundry listing](https://ai.azure.com/catalog/models/Qwen-Qwen3-VL-Embedding-2B?task=embeddings) — actual subscription access / deployment / SentrySearch compatibility requires test.
- [Cohere Embed 4](https://ai.azure.com/catalog/models/embed-v-4-0?task=embeddings) — text+image screenshot embeddings, not a proven whole-video endpoint.
- [Azure/OpenAI text embedding models](https://ai.azure.com/catalog/models?task=embeddings) — suitable for transcript text only.

## Not chosen

- [video-context-mcp](https://github.com/smallthinkingmachines/video-context-mcp) — previous smaller local MCP proposal, now superseded as **primary local visual engine** by SentrySearch.
- Other tiny-repo proof-of-concepts are not required for this MVP.
