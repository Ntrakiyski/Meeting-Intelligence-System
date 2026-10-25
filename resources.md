# VideoDB Resources Only

This file intentionally lists **only VideoDB-owned documentation or repositories**, not the general technology stack.

## Essential (MVP)

| Resource | Link | Why |
|---|---|---|
| VideoDB Console | https://console.videodb.io | API key and usage |
| VideoDB Quickstart | https://docs.videodb.io/pages/getting-started/quickstart | First upload and SDK/skill |
| VideoDB Skills | https://github.com/video-db/skills | Primary agent instructions; supports Codex/Copilot/Windows |
| VideoDB MCP guide | https://docs.videodb.io/pages/mcp/connect | Official hosted MCP, authorization and client setup |
| VideoDB MCP endpoint | https://mcp.videodb.io/mcp | Connect an authorized MCP client; **not** a human webpage |
| VideoDB Python SDK | https://github.com/video-db/videodb-python | `understand`, `index`, `search`, `ask` and analyzers |
| VideoDB API Docs | https://docs.videodb.io | SDK reference and behavior |
| VideoDB Cookbook | https://github.com/video-db/videodb-cookbook | Reference workflow examples |

## Useful references, not required as MVP dependencies

| Resource | Link | Why |
|---|---|---|
| Director | https://github.com/video-db/Director | Existing agentic video-chat framework |
| StreamRAG | https://github.com/video-db/StreamRAG | Search across a media collection |
| Call.md | https://github.com/video-db/call.md | Local live meeting capture, audio intelligence and MCP |
| Bloom | https://github.com/video-db/bloom | Local-first screen recorder with VideoDB cloud intelligence |
| Pair Programmer | https://github.com/video-db/pair-programmer | Screen/audio-aware coding-agent skill |
| VideoDB Agent Toolkit | https://github.com/video-db/agent-toolkit | Documentation, agent context and legacy MCP launch option |
| Open Record Replay | https://github.com/video-db/open-record-replay | Reference for screen-to-repeatable-agent-workflow ideas |
| Robot Runs article | https://videodb.io/blog/robot-runs | Advanced video querying/deployment concepts |

## Capability notes verified from the SDK and skills

- Analyzer types include `spoken_words`, `vlm` and `ocr` — don't mistake speech-only indexing for a screen-aware pipeline.
- The SDK documents `understand → index → retrieve` and source-grounded `ask` queries.
- The official skill has a built-in setup workflow and supports Windows PowerShell.
- Official hosted MCP is available; prefer it to building another MCP server.
- Hosted VideoDB processing requires an account and can incur charges. Verify actual billing/credits in the user's console.
- SDK/README examples can change: agents must consult current upstream reference when implementing a particular API call.
