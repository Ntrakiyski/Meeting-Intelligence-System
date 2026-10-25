# Windows Local MVP — SentrySearch + Existing Transcripts

## Scope

Visual search = [SentrySearch](https://github.com/ssrajadh/sentrysearch), local Qwen3-VL embeddings. Text search = existing transcript.txt files (keyword first). Optional faster-whisper only if timestamps are missing and required. There is **no video-context-mcp dependency** and no custom application required.

**Limit:** 24 GB system RAM reported. Before installing Qwen, establish GPU/VRAM (cannot infer from system RAM):

```powershell
nvidia-smi --query-gpu=name,memory.total --format=csv
```

If `nvidia-smi` is absent, ask Codex to inspect `Get-CimInstance Win32_VideoController | Select-Object Name`. CPU-only Qwen is documented as very slow; do not promise successful visual embedding indexing on CPU. In that situation, local keyword search + inspected screenshots is a **limited fallback**, not proof of full local video-search parity.

## Pilot setup (only after preflight)

Follow [upstream Windows install instructions](https://github.com/ssrajadh/sentrysearch). From a *separate checkout* of SentrySearch, Python 3.11/3.12 and uv:

```powershell
uv python install 3.12
git clone https://github.com/ssrajadh/sentrysearch.git
cd sentrysearch
# Use CUDA quantization when NVIDIA VRAM is sufficient:
uv tool install --python 3.12 ".[local-quantized]"
```

Use local `qwen2b` first where appropriate and ensure the local tool can read the user's approved MP4. SentrySearch accepts a folder path for indexing. Test one **small isolated folder** (not all 40 recordings). The `--no-skip-still` flag matters for screen-sharing where dashboards remain static.

```powershell
sentrysearch index "C:\path\to\one-approved-meeting" --backend local --model qwen2b --no-skip-still
sentrysearch search "Kubernetes terminal error shown on screen" --results 5 --no-trim
```

Upstream CLI should be inspected before use because dependency/flag behavior can change. On-screen small text may require retrieving full-resolution frames and optional OCR. The local model may be impractical on underpowered GPUs; stop/record failure instead of silently using Gemini or another hosted backend.

## Existing transcript handling

Use `transcript.txt` directly. Agent may use keyword/text search tools first (`rg` or PowerShell `Select-String`) without embedding. SentrySearch does **not** directly ingest transcripts. If transcripts have timestamps, map speech to original MP4. If they lack timestamps and a speech timestamp is required, see `docs/transcript-timestamps.md`.

## Run

```powershell
.\scripts\select-provider.ps1 -Provider local
```

Agent prompt:

> Read AGENTS.md, config/pipeline.json, docs/local-mvp.md and skills/analyze-meeting/SKILL.md. Verify GPU hardware. For ONE meeting, keep transcript.txt as primary speech source. Use local SentrySearch video retrieval (if hardware permits) to find a **screen-only** fact and return exact seekable clip times. No VideoDB, Gemini, Azure or other cloud ingestion. Optional Whisper only if genuinely needed for missing timestamps. Report incomplete capabilities; do not claim full visual understanding from transcript.

## Validation

- [ ] Correct MP4/transcript pairing confirmed
- [ ] GPU/VRAM checked and Qwen local install tested or limitation recorded
- [ ] Local visual index/search ran (or failure documented)
- [ ] At least one seen-but-not-said fact grounded in video clip
- [ ] Original transcript preserved; optional timing sidecar separate
- [ ] No VideoDB credits consumed; no cloud video embedding used
- [ ] Any clips/frames shown to a cloud coding agent explicitly disclosed
- [ ] Results under `data/local-validation.md` (gitignored)

If CPU-only hardware blocks native video embeddings, compare with VideoDB Cloud first, then decide on a managed Azure hybrid experiment (see `docs/azure-foundry.md`) rather than building a bespoke stack.
