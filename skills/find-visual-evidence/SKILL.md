---
name: find-visual-evidence
description: Find verified screen evidence via VideoDB or SentrySearch/LiteLLM/Azure hybrid, with exact MP4 timestamps.
---

# Find Visual Evidence

Read `config/provider.json`, `AGENTS.md`, `docs/litellm-integration.md`.

- `videodb`: use provider-managed scene/VLM/OCR retrieval; inspect clip and confirm observed text.
- `hybrid`: only use SentrySearch `--backend litellm` with **tested** video-capable embedding alias, retrieve candidate timecoded clips, then inspect selected full-resolution frames with the `meeting-vision` alias through LiteLLM. If video embeddings fail, optionally sample frames for **limited** inspection and label native search unavailable.
- Existing transcript text is supplementary; never use it as proof of what appeared visually.
- Protect secrets on screen; disclose remote inference, source timestamps, confidence and uncertain readings.
