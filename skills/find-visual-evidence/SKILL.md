---
name: find-visual-evidence
description: Find specific screen events across a meeting recording, including errors, terminals, dashboards, settings and diagrams, using VideoDB visual retrieval and OCR.
---

# Find Visual Evidence

## Input
Video ID or authorized local MP4 plus the sought error, UI behavior, architecture diagram, setting or code output.

## Workflow
1. Use VideoDB scene/VLM and OCR artifacts, not transcript retrieval alone.
2. Retrieve candidate timestamp windows, open relevant clips and validate the visible claim.
3. If too small, blurred or obscured to read, report low confidence; never invent command/error strings.
4. Cross-reference speech in the same windows without treating spoken statements as direct visual evidence.

## Output
Event, timestamp range, observed image detail, relevant speech, confidence/limitations and playable clip link where available.
