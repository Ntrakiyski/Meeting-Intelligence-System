# Non-VideoDB Resources for the Hybrid Option

VideoDB-owned resources remain in [resources.md](resources.md).

- [SentrySearch](https://github.com/ssrajadh/sentrysearch) — Windows Python CLI, local ChromaDB index, native video search and LiteLLM proxy backend. Its LiteLLM endpoint sends inline base64 MP4 to `/embeddings`; only Gemini Embedding 2 was upstream-tested, so Azure video providers require validation.
- [LiteLLM](https://github.com/BerriAI/litellm) — user's existing self-hosted gateway for **all controlled embeddings and reasoning**.
- [Microsoft Azure AI Foundry model catalog](https://ai.azure.com/catalog/models?task=embeddings) — external managed model deployments for LiteLLM.
- [Voyage multimodal 3.5](https://ai.azure.com/catalog/models/voyage-multimodal-3.5) — video/text/images, but provider uses distinct multimodal API.
- [Qwen3-VL Embedding](https://huggingface.co/Qwen/Qwen3-VL-Embedding-2B) — model family; Azure Foundry deployment and LiteLLM path unverified.
- [faster-whisper](https://github.com/SYSTRAN/faster-whisper) — optional local timestamp repair, not routine transcription.
- [Tesseract](https://github.com/tesseract-ocr/tesseract) and [FFmpeg](https://ffmpeg.org) — selected screenshot text extraction and clip/frame processing.

**Provider contract:** local files/indexes + Azure inference through LiteLLM is called `hybrid`; it is not offline or zero-cost model processing. No 24 GB GPU-memory assumption.
