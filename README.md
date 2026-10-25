# Meeting Intelligence System

An **agent-first** video intelligence workflow for Microsoft Teams MP4 recordings. **Two interchangeable MVP modes**: VideoDB Cloud and local-first open-source video analysis. No custom video backend, GUI, or database needs to be developed.

## Choose the provider (Windows PowerShell)

After cloning this repository, create `recordings/` and place one **authorized, non-confidential** MP4 there. The public GitHub repository must never contain private recordings, transcripts, screenshots, or credentials.

```powershell
# VideoDB Cloud: costs VideoDB usage credit
.\scripts\select-provider.ps1 -Provider videodb

# OR: local extraction, transcription, OCR and search using video-context-mcp
.\scripts\select-provider.ps1 -Provider local
```

The selection is stored in [config/provider.json](config/provider.json). This only chooses the engine: **you must install and configure the selected upstream skill/MCP once**.

| Mode | Existing tool | Requirement | Cloud boundary |
|---|---|---|---|
| `videodb` | [video-db/skills](https://github.com/video-db/skills) + VideoDB SDK/MCP | VideoDB API account/key | Video uploaded/processed by VideoDB |
| `local` | [video-context-mcp](https://github.com/smallthinkingmachines/video-context-mcp) | Node 22+, local MCP registered | Extraction, OCR, ASR and text search local; **cloud-based coding agents may still receive extracted frames/text** |

### Setup: VideoDB (one time)

```powershell
npx skills add video-db/skills
```

Follow the upstream skill's setup/authentication steps, avoiding storing the API key in Git. The MVP should use `spoken_words`, `vlm`, `ocr`, VideoDB indexing and grounded retrieval. [Windows guide](docs/windows-mvp.md).

### Setup: Local MCP (one time)

```powershell
npm install -g @smallthinkingmachines/video-context-mcp
video-context-mcp setup --all
video-context-mcp doctor --json
```

Register the executable as a **stdio MCP server** in Codex (`~/.codex/config.toml`, ensuring it is discoverable on your PATH):

```toml
[mcp_servers.video-context]
command = "video-context-mcp"
```

Restart the agent, verify it can see the tools, and follow [local MVP instructions](docs/local-mvp.md). Initial installation may download media tools and AI models; network access is required for first setup. This provider is MIT-licensed but relatively new; treat Windows runtime support as **documented, not independently verified here**.

### Run the SAME skills in either mode

Open the repo in your coding agent and say:

> Read AGENTS.md, config/provider.json and skills/analyze-meeting/SKILL.md. Using only the selected backend, analyze recordings/test.mp4 including **what is visible on screen** as well as speech. Find one screen-only technical detail and give the exact timestamp and inspectable evidence. Save a local report under data/ and disclose missing capabilities and external data transfers.

The local provider returns frames to the agent; those can be visually inspected if the coding agent supports image inputs. Neither the presence of OCR nor an image-capable agent guarantees accurate visual understanding.

## Project docs

- [project.md](project.md) — vision, dual-provider MVP and decisions
- [resources.md](resources.md) — VideoDB resources **only**
- [resources-local.md](resources-local.md) — local open-source alternatives
- [AGENTS.md](AGENTS.md) — orchestration/safety contract
- [docs/windows-mvp.md](docs/windows-mvp.md) — VideoDB mode
- [docs/local-mvp.md](docs/local-mvp.md) — local mode and MCP setup
- [docs/compare-backends.md](docs/compare-backends.md) — side-by-side scorecard
- [skills/](skills/) — business-facing agent workflows

**Guiding rule:** Orchestrate first. Add custom implementation only after demonstrating a capability gap.
