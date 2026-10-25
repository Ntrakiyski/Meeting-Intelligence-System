# Local Open-source Video Intelligence Resources

Separated from `resources.md` (VideoDB-only references) as requested.

## Selected local MVP engine

- **video-context-mcp** — https://github.com/smallthinkingmachines/video-context-mcp
  - NPM package: https://www.npmjs.com/package/@smallthinkingmachines/video-context-mcp
  - MIT license; Node 22+; Windows x64 documented as managed-runtime supported.
  - MCP operations: ingest, status, timeline, transcript, semantic/full-text search, inspect keyframe, crop image.
  - Local OCR and speech fallback; first run downloads/cache models/tools.
  - Securely runs on local stdio; do not expose an unauthenticated server.
  - Image interpretation by a cloud-based coding agent can still transfer selected frames out of local processing.

## Evaluated alternatives (not installed by default)

- **VideoHighlighter** — https://github.com/Aseiel/VideoHighlighter — capable local Windows video analysis/highlights and CLIP search, but desktop-centric and AGPL-3.0; better for manual visual inspection than Codex MCP orchestration.
- **TranscreveAI** — https://github.com/DeHor-Labs/transcreve-ai — Python CLI, MCP, local transcription/embeddings and OCR. Its documented local provider does **not** provide a local vision model, so not the primary screen-reasoning option.
- **Multimodal Video RAG** — https://github.com/iisc-kc/Multimodal-Video-RAG — vision model + Whisper + OCR + retrieval; significantly heavier GPU/deployment footprint and limited production verification.
- **MomentSearch** — https://github.com/traversaal-ai/momentsearch — visual-first RAG; defaults can require external Prefect/OpenAI services, even if local components exist.
- **Cerul** — https://github.com/cerul-ai/cerul — capable CLI but current bundled binary supports Linux/macOS and documentation defaults to Gemini models.

Pick a second local engine only after the MCP baseline shows an actual gap. Record why and ask before adding dependencies.
