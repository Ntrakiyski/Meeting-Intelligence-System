---
name: analyze-meeting
description: Analyze an existing MP4/transcript pair via VideoDB primary or LiteLLM/Azure hybrid, with verifiable seen-versus-said evidence.
---

# Analyze Meeting

Read `AGENTS.md`, provider selection, gateway configuration and provider-specific guide. Reuse `transcript.txt`; optional Whisper only if timestamps genuinely needed and absent.

- `videodb`: use official VideoDB skill/MCP/SDK for managed `vlm` scene understanding and OCR; user approves cloud upload. For **our** supplemental summarization/decisions/image analysis, use validated LiteLLM model aliases. VideoDB native analyzers do not become LiteLLM calls.
- `hybrid`: local SentrySearch and existing transcript search. **Before indexing MP4**, prove gateway `meeting-video-embedding` alias accepts MP4 base64 via SentrySearch's LiteLLM endpoint and text queries; if unsupported, clearly report blocked. Reasoning/image inspection only via validated LiteLLM aliases. Do not run local Qwen by default, call Azure directly, or present frame-based exploratory inspection as a full video index.
- Return screen-only finding, speech-only decision, timestamp/media clip, separated observed facts/interpretation/uncertainties, and usage. Save private reports only under gitignored `data/`. No external writes without user approval.
