---
name: analyze-meeting
description: Analyze an authorized meeting MP4 with the provider chosen in config/provider.json. Retrieve spoken and visual evidence with timestamps, using VideoDB or local video-context MCP.
---

# Analyze Meeting — Provider Aware

## Inputs
Authorized MP4 file in `recordings/`, user question, optional project label.

## Select backend
1. Read `config/provider.json` first. Allowed values: `videodb` or `local`.
2. Do not switch provider without explicit user instruction. Do not upload files in local mode.
3. Confirm privacy/consent and disclose if a cloud coding agent may receive a local frame.

## VideoDB route
Use official VideoDB skill/MCP or maintained Python SDK. Upload approved MP4, execute `spoken_words`, `vlm`, `ocr` understanding; index artifacts; query for grounded moments and clips. Confirm each analyzer status; record provider usage.

## Local route
Use installed `video-context-mcp` through the agent's MCP client. Invoke `ingest_video`, `get_ingest_status`, `get_video_timeline`, `get_transcript`, `search_videos`, `peek_frame` and optionally `crop_region`. Inspect retrieved frames for visually grounded findings (if image interpretation permitted); no VideoDB upload. Recognize that native local retrieval is not equivalent to automatically running a whole-video VLM analyzer.

## Common deliverable
Concise meeting summary; observed screen events; dialogue-specific points; explicit decisions vs proposals; open questions; action candidates. Every key claim includes video path/ID + timestamp and an inspectable frame/clip if available. Label **screen observation**, **speech**, **inference**, and **uncertain** separately. Save private report under `data/`; no external writes without approval.
