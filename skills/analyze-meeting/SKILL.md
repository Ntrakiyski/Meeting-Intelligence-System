---
name: analyze-meeting
description: Analyze an authorized meeting recording using VideoDB speech, scene and OCR understanding, returning evidence-backed summaries and timestamped findings.
---

# Analyze Meeting

## Input
Authorized MP4 path or existing VideoDB video ID; goal/questions, optional project label.

## Workflow
1. Follow `AGENTS.md` safety and consent requirements.
2. Invoke the upstream VideoDB skill/MCP; fall back to its Python SDK only where required.
3. Verify analyses of spoken words, visual scenes and OCR. Do not silently downgrade to transcript only.
4. Use VideoDB indexing and retrieval; preserve video ID, timestamps and clip URLs where supported.
5. Deliver: concise summary, what appeared on screen, explicit decisions, open questions and action candidates.
6. Distinguish observation, speech and inference; mark uncertain findings.

## Output
Markdown with timestamp links or time ranges for each material claim; include methods and missing analyzers. No external writes without approval.
