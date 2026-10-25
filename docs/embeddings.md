# Embeddings for 40 Teams MP4 + transcript.txt files

## First principle: text embeddings != video embeddings

- **Transcript text** can be searched with plain keyword search. Embeddings are optional for semantic meaning and synonyms.
- **Screens/whole clips** require a multimodal image/video embedding model. An OpenAI `text-embedding-3-small`, `text-embedding-3-large` or `text-embedding-ada-002` model does *not* accept video or image input.
- SentrySearch's visual pipeline is built for compatible Gemini Embedding 2, local Qwen3-VL-Embedding, Qwen Cloud and selected LiteLLM-proxied **video-capable** models; arbitrary text-only embedding models are not drop-in replacements.
- A model used for document vectors and a model used for queries must be compatible. Never mix unrelated embedding vector spaces.

## Transcript search choices

**MVP stage 1:** search existing transcript.txt files with rg/grep, inspect timestamps if present. Zero new embedding service or indexing infrastructure.

**Optional local stage 2:** `sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2` (text-only, 384-dimensional, 50+ languages) for semantic search. On a 24 GB RAM PC, memory is normally much less demanding than Qwen video embeddings; benchmark CPU speed. `BAAI/bge-m3` is a stronger/larger local alternative if justified.

**Optional hosted Azure text embedding:** `text-embedding-3-small` economical; `text-embedding-3-large` stronger; existing `text-embedding-ada-002` deployment can be reused but is older. They index transcript chunks, not MP4/video frames. Azure Foundry model availability does not mean you have an active deployment or free use.

## Screen/video search choices

**Local main candidate:** SentrySearch with local `Qwen3-VL-Embedding-2B`. Native video clips are vectorized; text description queries can retrieve matching scenes. Qwen can also embed text/images/video in shared space.

**Hardware prerequisite:** system RAM = 24 GB; **GPU VRAM is not known**. Run `nvidia-smi --query-gpu=name,memory.total --format=csv` (if NVIDIA) before installing heavy models. NVIDIA CUDA with adequate VRAM is desirable. CPU fallback is documented but may be impractically slow. Do not promise 2B runs well solely from RAM.

**Azure candidate:** `voyage-multimodal-3.5` has a documented video embedding endpoint in Foundry. `Qwen-Qwen3-VL-Embedding-2B` appears in the catalog. Neither is a guaranteed drop-in replacement for SentrySearch's built-in backends. Test endpoint schema, batching, input constraints, billing, vector dimensions, query/document embedding consistency and index isolation **before** any adapter development.

**Screenshot-only Azure candidate:** Cohere Embed 4 text/image, useful for indexing sampled frames but not claimed to handle MP4 directly.

## Next-step decision gates

1. Do we need semantic transcript matching? If keyword search works, no text embedding.
2. Do we need screen-only discovery? Then video embeddings (local Qwen or managed VideoDB); avoid reliance on transcript keywords.
3. Is Windows GPU adequate? If not, keep VideoDB as working MVP provider and evaluate an explicitly approved Azure-hosted embedding experiment; do not label it local/offline.
4. Do we need exact screen strings? Inspect original-resolution frames; optional Tesseract OCR. Video embeddings alone do not faithfully recover small terminal text.

## External references

- OpenAI text embedding models: https://developers.openai.com/api/docs/models/text-embedding-3-small
- Microsoft Foundry catalog: https://ai.azure.com/catalog/models?task=embeddings
- Voyage video endpoint: https://ai.azure.com/catalog/models/voyage-multimodal-3.5?task=embeddings
- Qwen multimodal video embeddings: https://huggingface.co/Qwen/Qwen3-VL-Embedding-2B
- SentrySearch supported backends: https://github.com/ssrajadh/sentrysearch
