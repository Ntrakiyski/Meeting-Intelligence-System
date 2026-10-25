# Using Meeting Intelligence after setup

## One skill for all use cases

Codex and supported VS Code/GitHub Copilot agents discover project skills under `.agents/skills/<skill-name>/SKILL.md`. The canonical entrypoint is:

- [`.agents/skills/meeting-intelligence/SKILL.md`](../.agents/skills/meeting-intelligence/SKILL.md)

In Codex, open the repo and use `$meeting-intelligence` to explicitly invoke it, or make a plain-language request and let skill discovery match the description. VS Code Copilot can also discover repository skills at `.agents/skills`. If not visible, reload/restart the agent and check its skills menu.

This master skill delegates to the existing instructions in `skills/*/SKILL.md`; no extra server is created.

## Typical operations

| Goal | What to type in the agent |
|---|---|
| Get help | `$meeting-intelligence status` |
| Inspect one video | `$meeting-intelligence analyze Meeting-001 and identify what was shown on screen` |
| Find a specific moment | `$meeting-intelligence find the NGC dashboard in my video library` |
| Extract confirmed decisions | `$meeting-intelligence list approved infrastructure decisions, with evidence` |
| Compare sessions | `$meeting-intelligence compare the first and last Kubernetes demos` |
| Create docs | `$meeting-intelligence draft the technical handover from the last session` |
| Draft issue | `$meeting-intelligence create a draft issue from the on-screen deployment error` |
| Index more recordings | `$meeting-intelligence inventory my recordings, then ask before indexing new ones` |

## Provider operation

The agent reads `config/provider.json`; a skill request does not automatically switch it.

```powershell
.\scripts\select-provider.ps1 -Provider videodb
# or
.\scripts\select-provider.ps1 -Provider hybrid
```

- `videodb`: native managed VideoDB VLM/index/OCR, user-approved cloud upload and VideoDB credits; supplemental reasoning via LiteLLM.
- `hybrid`: Windows local storage/index via SentrySearch and remote Azure embedding/vision/reasoning *through self-hosted LiteLLM*. It is not offline.
- SentrySearch video embedding via Azure through LiteLLM must pass a synthetic native-video and text-query compatibility smoke test **before** full video indexing. Status should report this as unverified until tested.

## Inputs, timestamps and privacy

Use existing `transcript.txt` wherever available; optionally run faster-whisper only for necessary missing timestamps. Never claim a speech timecode without evidence.

Recordings, transcripts, screenshots and private reports stay in the user's authorized local folders; none belong in the public GitHub repository. Ask before triggering external model/media transfer, provider charge, or action in Jira/GitHub.

## What is ready now

- Master skill instructions and use-case workflows: versioned and discoverable from this repository.
- VideoDB/ hybrid setup and provider selection: documented.
- Actual Azure deployment aliases, video embedding compatibility, VideoDB processing and full Windows test: **not verified from the GitHub documentation alone**.

Before treating either provider as production-ready, run `docs/compare-backends.md` on the same authorized MP4 and inspect evidence timestamps.

## Technical handoff for new implementation agents

Begin with [Tomorrow's Codex Kickoff](TOMORROW-CODEX-KICKOFF.md), then [Implementation Plan](IMPLEMENTATION-PLAN.md). Other design docs are indexed in [../README.md](../README.md). Use the project master skill as an **operator interface after tools are configured**, not as proof that models and upstream connectors already work.
