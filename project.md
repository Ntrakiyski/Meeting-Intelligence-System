# PROJECT — Meeting Intelligence System

## Problem

Traditional Teams transcripts miss screen-shared terminal errors, configuration settings, architectural diagrams, visual demonstrations and the visual sequence of work. We need evidence-grounded video understanding, not just meeting notes.

## Vision

An agent-first, multi-provider meeting intelligence system. A person or AI agent selects an existing video-processing engine, analyzes an authorized local MP4, and receives timestamped answers about **what was said and shown**. The output should support skills for decisions, issues, documentation, handovers and demo comparisons.

## Business goals

1. Recover technical context and requirements with inspectable audio/visual evidence.
2. Make meeting knowledge searchable and reusable across projects and agents.
3. Minimize custom development by orchestrating maintained upstream systems.
4. Compare operational cost, privacy and fidelity of VideoDB Cloud versus local processing.
5. Preserve an eventual route to live Teams agents, external integrations, a shared UI and a project memory platform.

## Windows MVP: TWO required backend options

**Provider switch:** `config/provider.json`, changed with `scripts/select-provider.ps1 -Provider videodb|local`. Agent workflows must honor this value. Do not automatically fail over from local to cloud.

### Provider A: `videodb`

- Use official `video-db/skills` and VideoDB MCP or Python SDK.
- Upload an approved MP4, run `spoken_words`, `vlm`, `ocr`, index and retrieve timestamped evidence.
- Requires VideoDB account and usage credit. Record actual usage before/after the test.
- The commercial VideoDB backend is hosted; open-source client repositories do not eliminate backend costs.

### Provider B: `local`

- Use the existing `@smallthinkingmachines/video-context-mcp` package over MCP (Node 22+, Windows x64 managed runtime documented).
- Use `ingest_video`, `get_ingest_status`, `get_video_timeline`, `get_transcript`, `search_videos`, `peek_frame`, `crop_region`.
- Local processing of MP4 files, transcription, OCR, keyframe creation, indexing and searching. No VideoDB API required.
- For richer screen reasoning, the selected agent can examine retrieved frames using its image-capable model; if the agent is cloud-hosted, these selected images/text **may leave the machine**. True end-to-end offline analysis requires a local vision-capable reasoning model and compatible agent.
- Local index + keyframes are not equivalent to VideoDB's managed VLM scene understanding: record quality gaps explicitly.
- If local provider cannot meet screen-awareness acceptance criteria, report failure and assess VideoHighlighter / a local VLM path *after* the baseline, not silently substitute a transcript-only answer.

### Common scope

- Input: `recordings/test.mp4` (gitignored), then five screen-heavy recordings.
- Output: evidence-backed results with video ID/path, timestamps, transcript references, inspected frames/screenshots or clips where supported, decisions, open issues and confidence/limitations.
- Entry point: coding agent and use-case `SKILL.md` files. No custom UI/API/server required for MVP.
- Comparison: run the same authorized video through both providers and compare using `docs/compare-backends.md`.

## Acceptance criteria (each provider independently)

- Agent identifies at least one accurately visible technical detail absent from the transcript.
- Agent returns correct seekable timestamp/evidence for the claim.
- User can ask what was said AND what was shown; agent marks unsupported or low-confidence claims.
- Results cite the specific video and clearly distinguish visual observations, spoken assertions and agent interpretations.
- Installation, provider selection, required tools, constraints, time and cost are recorded locally.
- Provider choice is never ignored, and local runs are never silently uploaded to VideoDB.
- Source videos and credentials never enter Git.

**Status:** This repository documents two executable upstream workflows, but neither has been run against the user's Windows machine or MP4 yet. Passing the acceptance criteria requires real local testing.

## Technical decisions

| Area | MVP |
|---|---|
| Orchestration | Codex / GitHub Copilot + repo `SKILL.md` |
| Cloud route | VideoDB Skills, SDK, official MCP |
| Local route | video-context-mcp |
| Provider selector | Small PowerShell script writing JSON |
| Python | Only via upstream VideoDB SDK as needed |
| Custom Go MCP / FastMCP | No |
| Vite + React UI | Not in MVP |
| LiteLLM + Copilot subscription | Not required; review permitted integration separately |
| Storage | Local MP4 and reports; managed VideoDB copies only in cloud mode |
| Company integrations | Later phase |

## Later phases

1. Multi-video project collections and evidence-normalized artifacts.
2. Live Teams agents (distinguish desktop recording vs meeting participant bot; require permissions/consent).
3. Permission-controlled team workflows via MCP, UI and internal knowledge base where useful.
4. Production security, retention, auditing and provider cost management.

## Security and costs

- This GitHub repository is public. Never commit videos, screenshots, transcripts, secrets or sensitive local reports.
- Only upload consented, approved recordings to VideoDB or any external model.
- Cloud coding agents may receive retrieved local keyframes; clarify the data boundary before sending sensitive frames.
- An advertised VideoDB free-credit allocation is finite. Do not assume repeatedly registering new accounts is allowed under provider terms; plan sustainable usage.
- Track actual VideoDB credit consumption and local hardware/runtime resource costs.

## Non-goals

No bespoke video processing, duplicate indexing engine, provider lock-in, custom web frontend, new hosting infrastructure or live bot for this MVP.
