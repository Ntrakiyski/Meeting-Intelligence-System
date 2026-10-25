# Windows MVP — Local Engine (video-context-mcp)

## Goal

Enable screen- and speech-aware search over `recordings/test.mp4` **without using VideoDB credits**. Use existing `video-context-mcp` rather than writing our own ingestion/indexing service.

## Requirements

- Windows x64, Node.js **22 or newer**, Git and a Codex/Copilot agent that supports MCP tools.
- Space for downloaded runtime binaries, local model weights, keyframes, OCR and indexes.
- Internet only for initial downloading/setup. The MCP media/OCR/ASR/search pipeline runs locally, but a cloud-based coding agent can transmit retrieved frames/text to its model.
- Approved video recording (do not submit confidential footage to cloud AI reasoning without permission).

## One-time setup (PowerShell)

```powershell
npm install -g @smallthinkingmachines/video-context-mcp
video-context-mcp setup --all
video-context-mcp doctor --json
```

Read official setup: https://github.com/smallthinkingmachines/video-context-mcp

Register the installed executable in your MCP client. Codex user config, usually `$HOME/.codex/config.toml`:

```toml
[mcp_servers.video-context]
command = "video-context-mcp"
```

If Codex cannot find the executable, inspect `where.exe video-context-mcp` and use its full installation path in `command`. Restart Codex after editing its MCP configuration. The MCP registration is external to this repo and must be checked on the actual Windows machine.

## Switch and run

```powershell
.\scripts\select-provider.ps1 -Provider local
```

Tell the agent:

> Read AGENTS.md and skills/analyze-meeting/SKILL.md. My current provider is local. Use video-context MCP on recordings/test.mp4. Invoke `ingest_video` with the local file, check `get_ingest_status`, then use `get_video_timeline`, `search_videos`, `get_transcript`, `peek_frame` and `crop_region` where needed. Find visible errors/settings/diagrams not spoken aloud, and return exact file timestamps. Never invoke VideoDB, external video ingestion, or pretend unsupported VLM analysis happened.

## Expectations

- Processing outputs: transcript, keyframes, on-screen text, timeline, local index with semantic and keyword search.
- An image-capable agent may review returned keyframes and describe them. The MCP tool itself does not guarantee autonomous whole-video VLM reasoning.
- A local video path remains local to MCP. If Codex is cloud-powered, *retrieved images and text used in its answer may be transmitted to the agent provider*.
- The MCP has local cache management tools; inspect `list_videos` and do not delete caches by default.

## Acceptance tests

- [ ] `video-context-mcp doctor --json` reports healthy runtime.
- [ ] MCP appears in the agent tools and `ingest_video` accepts a local MP4.
- [ ] Status shows transcript and keyframes/OCR availability; failures are reported.
- [ ] Search retrieves at least one technical screen event with inspectable frame/time.
- [ ] Agent can read/crop relevant screen details accurately; fails honestly for blurry evidence.
- [ ] No VideoDB credit was consumed; no cloud media upload occurred.
- [ ] Any images/text shown to the cloud coding agent are disclosed.
- [ ] Result and timings documented under gitignored `data/local-validation.md`.

## Troubleshooting

Run `video-context-mcp doctor --json`; consult the upstream README. If embeddings fail, full-text retrieval may still work; use `repair_embeddings` rather than re-ingesting. Document feature status rather than claiming full success.
