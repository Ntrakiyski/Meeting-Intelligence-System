---
name: select-provider
description: Switch Meeting Intelligence System between VideoDB Cloud and local-first MCP without changing the business workflows or creating an application.
---

# Select Provider

Use `scripts/select-provider.ps1 -Provider videodb|local` to change `config/provider.json`, then follow `docs/windows-mvp.md` or `docs/local-mvp.md`.

Show the user:
- `videodb`: uploaded MP4 and AI processing on VideoDB Cloud; consumes usage credit; visual analyzers and clips.
- `local`: local transcription, OCR, keyframes and search; no VideoDB API fee; image reasoning may still involve cloud coding-agent model.
Do not silently switch providers or mix evidence between provider runs.
