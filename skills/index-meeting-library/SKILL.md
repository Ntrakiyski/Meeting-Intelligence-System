---
name: index-meeting-library
description: Inventory MP4 and existing transcript.txt pairs and selectively index via VideoDB or tested LiteLLM/Azure video embeddings.
---

# Index Meeting Library

Read `AGENTS.md`, `config/provider.json`, `config/pipeline.json` and `docs/litellm-integration.md`.

1. Inventory 40 MP4/transcript pairs, detect timestamps and ambiguous pairings; do not upload/reindex the entire library.
2. Start with ONE authorized recording. Reuse original text; optionally query existing transcript with keyword/text model through LiteLLM.
3. `videodb`: approved provider upload and managed video retrieval. Our downstream summarization and reporting route through LiteLLM.
4. `hybrid`: require tested SentrySearch-compatible video embeddings via LiteLLM proxy. Use `--backend litellm --model meeting-video-embedding` only after video+text synthetic smoke tests succeed; keep local Chroma index.
5. If route incompatible, report blocked and keep a separate limited screenshot/vision exploration, with explicit consent for Azure inference.
6. Record timecode/clip evidence, gateway model aliases, provider charges, risk/uncertainty, no leaked keys or private media to public GitHub.
