---
name: select-provider
description: Select VideoDB Cloud primary or LiteLLM/Azure Foundry hybrid; model gateway is the user's existing self-hosted LiteLLM.
---

# Select Provider

Run `scripts/select-provider.ps1 -Provider videodb|hybrid`. Legacy `local` maps to `hybrid` with a warning.

- `videodb`: VideoDB's cloud analyzer and indexes; our app-controlled LLM and embedding tasks use LiteLLM.
- `hybrid`: Windows MP4/index + SentrySearch CLI; model embeddings and image/reasoning via LiteLLM -> Azure Foundry. **Not fully offline**; video embeddings require compatibility check.
- Use existing transcript.txt and optional/on-demand lightweight Whisper.
- Never silently fall back, reindex all 40 files, change embedding model on existing index, or upload unapproved client media.
