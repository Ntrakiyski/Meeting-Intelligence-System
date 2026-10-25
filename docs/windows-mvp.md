# Windows MVP — VideoDB Provider (Cloud)

## Prerequisites

- Windows PowerShell, Node.js + npx, Codex or Copilot with VideoDB official skill.
- VideoDB account/API key. Check free credit/usage in the console.
- One approved MP4 under `recordings/` (ignored by Git).
- Internet access and permission to upload this recording to VideoDB.

## Select provider and install official skill

```powershell
.\scripts\select-provider.ps1 -Provider videodb
npx skills add video-db/skills
```

Ask your agent to use the official skill's setup instructions to authenticate securely (`/videodb setup` or its equivalent). Never print or commit the API key.

## Processing

Tell the agent:

> Read AGENTS.md and skills/analyze-meeting/SKILL.md. Confirm `config/provider.json` says `videodb` and that uploading this approved MP4 is permitted. Using the VideoDB skill or documented Python SDK, process recordings/test.mp4 with spoken_words + vlm + ocr. Index the resulting artifacts and ask what errors/settings/UI states appeared on screen. Return grounded timestamps and clips.

The Python SDK documents `understand → index → search/ask`. Agent must verify analyzer completion instead of silently using transcript alone.

## Validation

- [ ] Upload approved by operator
- [ ] `spoken_words`, `vlm`, `ocr` analyzers ran, or failure documented
- [ ] Screen-only finding identified accurately with exact timestamp or playable source clip
- [ ] Speech-grounded finding and cross-modal example checked
- [ ] VideoDB credits before/after recorded in `data/videodb-validation.md`
- [ ] Any missing modalities and uncertainty explained

See [docs/compare-backends.md](compare-backends.md) to compare it with local mode on the *same* video.
