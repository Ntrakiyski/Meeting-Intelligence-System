# Architecture and Execution Boundaries

**Status:** Design specification, not a claim of installed or tested software. Last reviewed 2026-10-25.

## Goal
40 authorized Teams recordings (MP4 plus existing `transcript.txt`), analyzed for spoken AND screen evidence. One provider switch, one master skill, same evidence contract. Run from Windows via Codex/Copilot with no custom web server.

```text
User -> $meeting-intelligence (master skill)
       -> config/provider.json -> tasks/use-case SKILL.md
       -> local MP4/transcript inventory (read-only)
       -> [videodb] VideoDB skill/MCP or SDK ---> VideoDB cloud understand/index/retrieve
       -> [hybrid] SentrySearch CLI -----------> local Chroma index
             |                                   |
             +---------- video-embedding alias -> LiteLLM (existing VPS) -> Azure Foundry
             [if unsupported: sampled frames -> vision alias -> text embedding alias
                             -> small local timestamped frame-caption index]
       -> transcript search/time alignment (optional faster-whisper)
       -> evidence contract (source mp4, offsets, seen/said/inferred, confidence)
       -> agent skills -> answer/report/issue draft (private output)
```

**The LiteLLM proxy is remote from Windows**, though the user self-hosts it. In hybrid mode the MP4 itself remains in Windows storage, but **selected video chunks or images leave the PC** for model inference via the proxy. Do not describe hybrid mode as fully local, private/offline, or free.

## Responsibility split

| Component | Owns | Must NOT own |
|---|---|---|
| Master SKILL.md | Select task/provider, dispatch, enforce approvals, format evidence | Creating embeddings or an app |
| VideoDB native | Cloud media ingestion, analyzers, indexes, search/clip handles | Assuming use of LiteLLM for its internal inference |
| SentrySearch | Local video chunking, compatible video embeddings, local Chroma index and retrieval | Transcript ingestion, accurate OCR, meeting decision extraction |
| LiteLLM gateway | App-controlled model routing, auth, aliases, budgets, logs | Actual local video storage, VideoDB internal model choice |
| Azure Foundry deployment | Actual hosted embedding/vision/reasoning inference | Guaranteeing proxy input-format compatibility |
| Transcript path | Reuse original text and supplied timestamps | Silent re-transcription or fabricated timecodes |
| Optional faster-whisper | Speech time anchors when required | Proven forced alignment of arbitrary text |
| Skill outputs | Timestamped evidence, drafts and verification status | Unapproved external writes |

## MVP deployment boundaries

- Local Windows: approved MP4s, source transcripts, optional extracted frames, Chroma/other lightweight local index, ephemeral results, reports.
- Existing LiteLLM VPS: gateway and authenticated virtual keys, provider routing; no direct Azure access from scripts.
- External service #1 (VideoDB mode only): approved entire recording uploaded and indexed on VideoDB cloud.
- External service #2 (hybrid mode): media chunks/frames and model inputs routed through LiteLLM to Azure.
- GitHub PUBLIC repo: code/specification/skills only. NO media, transcripts, frames, embeddings, provider secrets, customer data, private reports.

## Provider invariants

- `videodb` is primary: managed VideoDB video understanding; LiteLLM only for **controlled downstream** reasoning/vision/text embeddings.
- `hybrid` is alternative: local SentrySearch data/index plus cloud model inference, not local Qwen.
- Never auto-switch provider, model, credentials or embedding vector space. Never send real video to a provider without consent.
- Hybrid native-video retrieval remains **gated** by the exact SentrySearch `/embeddings` request and Foundry response compatibility. If not supported, use an explicitly marked **frame-caption fallback** with measured limitations.
- No mandatory API server, Go, FastMCP, React, Docker, or database besides whichever local index the selected upstream tool requires.

## Source links

- VideoDB SDK: https://github.com/video-db/videodb-python
- Official VideoDB skill: https://github.com/video-db/skills/blob/main/python/SKILL.md
- SentrySearch README: https://github.com/ssrajadh/sentrysearch
- SentrySearch proxy source: https://github.com/ssrajadh/sentrysearch/blob/master/sentrysearch/litellm_embedder.py
- Foundry Voyage contract: https://ai.azure.com/catalog/models/voyage-multimodal-3.5
