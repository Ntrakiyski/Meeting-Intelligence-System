---
name: select-provider
description: Switch Meeting Intelligence System between VideoDB Cloud and local SentrySearch visual retrieval; keep existing transcripts and optional Whisper policy.
---

# Select Provider

Use `scripts/select-provider.ps1 -Provider videodb|local` to set `config/provider.json`. Follow `config/pipeline.json` and `AGENTS.md`.

- `videodb` — **primary**: VideoDB native skill/MCP/SDK; approved MP4 uploaded/processed by VideoDB, billed against usage credit.
- `local` — **alternative**: SentrySearch CLI with native local Qwen3-VL embedding for video clips; no VideoDB charges. Needs hardware preflight (24 GB **RAM**, GPU VRAM unknown). Transcript.txt is searched separately.
- Lightweight `faster-whisper` is optional/on-demand only for missing transcript timecodes or transcription gaps.
- Azure Foundry multimodal embeddings (Voyage/Qwen) are optional **cloud** experiments outside strict local mode, require user approval and real deployment verification.
- Never automatically switch providers or claim both passed acceptance without processing and checking the same video locally.
