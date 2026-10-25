# Meeting Intelligence System

**Two MVP providers, one agent-first workflow.** Primary = **VideoDB Cloud** (use the initial $20 credit). Alternative = **local SentrySearch visual retrieval** on Windows. Both consume existing MP4 + transcript.txt pairs; both must be tested on the same recording. We orchestrate upstream tools, not build a custom web application.

## Source library

Use an existing local folder. Preferred layout, but do not move or duplicate files just to conform:

```text
recordings/
  Meeting-001/
    recording.mp4
    transcript.txt
  Meeting-002/
    recording.mp4
    transcript.txt
```

A folder with `meeting-name.mp4` and `meeting-name.txt` is also acceptable. Agent must pair them by verified name/duration, report ambiguous matches and preserve originals. Never upload any private file to this **public** GitHub repo.

**Existing transcripts are authoritative working inputs.** Inspect timestamp format first. Do not regenerate speech by default; see [optional Whisper policy](docs/transcript-timestamps.md).

## Select MVP provider on Windows

```powershell
.\scripts\select-provider.ps1 -Provider videodb  # default / primary
.\scripts\select-provider.ps1 -Provider local    # alternative / SentrySearch
```

Selection is stored in `config/provider.json`; preferences in [config/pipeline.json](config/pipeline.json). These are agent instructions, not an already-installed processing system.

| | VideoDB Cloud | Local SentrySearch |
|---|---|---|
| Entry | Official VideoDB Skill + hosted MCP/Python SDK | SentrySearch CLI, orchestrated by Codex/Copilot |
| Input | MP4 + local transcript.txt | MP4 + local transcript.txt |
| Video search | VideoDB VLM/scene/OCR indexes | Qwen3-VL video embeddings (GPU practical) |
| Text search | Existing transcript first; VideoDB transcript optionally | Existing transcript via keyword search, optional text embeddings |
| Whisper | Optional only for timestamps/gaps | Optional only for timestamps/gaps |
| Cloud processing | Uploaded approved MP4 to VideoDB | No VideoDB upload; cloud coding agent may still receive selected screenshots |
| External model endpoint | VideoDB-owned | Optional Azure Foundry experiment **not enabled in strictly local mode** |
| UI | Agent chat | Agent chat |

## Setup and operating guides

- [docs/windows-mvp.md](docs/windows-mvp.md) — primary VideoDB experiment
- [docs/local-mvp.md](docs/local-mvp.md) — SentrySearch with Windows and hardware preflight
- [docs/transcript-timestamps.md](docs/transcript-timestamps.md) — reuse transcripts; optional faster-whisper
- [docs/embeddings.md](docs/embeddings.md) — text vs image/video embeddings, model selection
- [docs/azure-foundry.md](docs/azure-foundry.md) — Foundry catalog and deployment reality
- [docs/compare-backends.md](docs/compare-backends.md) — acceptance tests for both engines
- [project.md](project.md) — goals, phases and decisions
- [AGENTS.md](AGENTS.md) — operator/agent contract
- [resources.md](resources.md) — VideoDB-owned references only
- [resources-local.md](resources-local.md) — locally operated OSS references

## Agent kickoff

Open the cloned repo in Codex or Copilot:

> Read AGENTS.md, project.md, config/provider.json, config/pipeline.json and the selected provider guide. Inventory my authorized MP4 + transcript.txt pairs, choose ONE recording, reuse the existing transcript, use optional faster-whisper only if timestamps are absent and necessary, analyze its visible screen events, and return verifiable file timestamps and source evidence. Never silently switch backend, upload footage, or claim visual analysis that was not performed. Give a cost/quality report for comparing VideoDB and local SentrySearch.

**Current status:** source/configuration/documentation are versioned. No processing on the user's Windows PC has yet been executed or verified. Do not mark either backend as acceptance-passed without real-video test results.
