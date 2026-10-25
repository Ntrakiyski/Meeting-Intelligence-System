---
name: analyze-meeting
description: Analyze existing MP4 and transcript.txt pairs with the selected VideoDB or local SentrySearch provider; preserve screen and speech evidence.
---

# Analyze Meeting — Dual-Provider

1. Read `AGENTS.md`, `config/provider.json` and `config/pipeline.json`.
2. Pair MP4 with its **existing transcript.txt**. Detect timecodes. Do not replace transcript text or transcribe unnecessarily.
3. If `videodb`: official skill/MCP/SDK, approve cloud upload first, run visual scene `vlm` and `ocr` analyses, index/query clips; reuse existing transcript for spoken knowledge. Document speech analyzer duplication if service requires it.
4. If `local`: SentrySearch CLI local Qwen3-VL backend for video search; search original transcript text separately. Check GPU/VRAM first. SentrySearch has no built-in transcript importer/transcription/OCR.
5. If transcript lacks timecodes, use optional `ensure-transcript-timestamps` skill **only when the question needs a precise spoken timestamp**.
6. Inspect retrieved frame/clip before claiming screen details. Report: spoken points, visible evidence, explicit decisions, actions proposed, uncertainties, timestamped source references, and processing cost/runtime.
7. Save sensitive reports under gitignored `data/`; no external actions without approval.
