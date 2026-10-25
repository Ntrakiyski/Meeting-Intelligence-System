# Agent Implementation Plan — Run in Order

**Instruction to next agent:** Make the smallest changes needed to get a working, testable, agent-operated MVP. Read `AGENTS.md` and `docs/DECISIONS.md`; stop at gates and report blockers. Do **not** promise success before testing on Windows. Use private, approved recordings only.

## Phase 0: Repository and environment preflight (no provider calls)

- Verify clean git worktree, Python 3.11/3.12 available (via `uv`), Node/npm for VideoDB skill, FFmpeg, Windows Powershell, available disk and accessible user media folder.
- Confirm installed agent discovers `.agents/skills/meeting-intelligence/SKILL.md`. Run `$meeting-intelligence status`.
- Validate `config/provider.json` and `config/pipeline.json`; inspect selected provider script. Do not edit keys.
- Inventory the folder of ~40 MP4 and `transcript.txt` pairs **metadata only**, duration/timecode format, ambiguous pairings and approximate input size. Write local `data/inventory.json`.
- Choose ONE non-sensitive authorized pilot (ideally Teams screen share with clear terminal text, diagrams and an explicit spoken decision). Record privacy approval.
- **Artifact:** `data/runs/<run-id>/preflight.md`. **Gate:** one valid MP4+transcript pair and confirmed permissions.

## Phase 1: LiteLLM/Azure contract tests (synthetic data only)

- User will connect Azure Foundry deployments to existing LiteLLM; do not invent proxies/endpoints.
- Probe proxy authenticated `/models`, model aliases, tiny text chat, vision input, short text embedding.
- For video embedding: generate or use **synthetic** 5–10 second MP4; send via the exact SentrySearch `LiteLLMEmbedder` proxy request, then a text query and compare model identity/dimension and similarity on a small positive/negative pair.
- Important: SentrySearch sends `data:video/mp4;base64` through `/embeddings`; Voyage Foundry uses `/v1/multimodalembeddings` with content types and input_type. An alias may appear in `/models` but still be incompatible. Verify actual requests and responses, not just catalog availability.
- Disable embedding fallback to a different model. Do not use SentrySearch `--rerank` in LiteLLM mode (upstream docs say not supported).
- **Artifact:** `data/runs/<run-id>/gateway-smoke.md` with redacted request shape, alias, HTTP status, dimension, latency, billed usage. **Gate:** full video/text embedding pair works or explicitly mark native hybrid retrieval **BLOCKED**.

## Phase 2: VideoDB primary MVP (approved 1 clip)

- Install/use official VideoDB skill and current Python SDK/MCP, authenticate without logging key; record starting credits.
- Run visual scene/VLM and OCR; spoken_words only when required for native VideoDB indexing rather than blindly retranscribing.
- **Check analyzer-level status**: the upstream VideoDB skill warns that `partial` is not always treated as terminal by `wait_until_complete()`. Poll analyzer statuses with a bound and index successful artifacts only. Do not claim complete visual index when VLM/OCR failed.
- Retrieve one visual-only error/setting, one speech decision and a cross-modal event; inspect original clip and source time.
- Use app-controlled LiteLLM reasoning where needed; VideoDB native internal models remain independent.
- **Artifact:** `data/runs/<run-id>/videodb-report.md` + evidence JSON + before/after credit usage. **Gate:** at least one manually verified screen-only finding with timestamp.

## Phase 3: Hybrid alternative MVP (approved 1 clip)

### 3A: preferred native video embedding
- Only if Phase 1 video embedding compatibility passes, use SentrySearch `--backend litellm` with the confirmed alias (no direct Azure API, no local Qwen inference).
- Index a single small folder; for static Teams screens start with `--no-skip-still`. Use original-resolution clips/frames to verify small on-screen text; do not trust embedding matches alone.
- Reuse original transcript separately; no automatic transcript indexing by SentrySearch; use optional faster-whisper only for needed timecodes.
- **Artifact:** `data/runs/<run-id>/hybrid-native-report.md`. **Gate:** one human-verified screen-only retrieval and bounded usage.

### 3B: explicitly reduced-fidelity fallback (if native embedding fails)
- Document failed proxy contract first. Use existing FFmpeg to sample periodic frames and scene changes for ONE approved video. Preserve original MP4 offsets.
- Use validated LiteLLM `meeting-vision` for screenshots to generate short timestamped *screen descriptions* (not unsupported OCR claims); optional Tesseract on only selected full-resolution frames.
- Use validated LiteLLM `meeting-text-embedding` on those captions and the query; write only **minimal glue** if existing tools cannot perform the association/search directly, ideally no more than a small isolated script and local JSON/SQLite sidecar, not a new service.
- Clearly label `hybrid-frame-fallback` as **reduced visual retrieval**, not native video embeddings and not equivalent recall. Gate separately; never report 3B as 3A success.
- **Artifact:** `data/runs/<run-id>/hybrid-fallback-report.md` documenting selected frame interval/scene threshold and known missed events.

## Phase 4: Cross-provider acceptance + scale decision

- Use exactly same original MP4 + transcript. Apply `docs/TEST-PLAN.md`; verify specific video timestamps and visible characters manually.
- Record cost/latency and quality per mode; inspect provider usage, whether frames/video left Windows, and list incomplete requirements.
- Do not bulk-process all 40 until pilot is accepted and user authorizes spend/egress.
- Then run 5 representative screen-heavy recordings, finally optional full library with idempotent caching and budget caps.
- **Artifacts:** `data/comparison.md` + `data/handoff.md` listing implemented vs blocked, commands, known issues, secrets locations WITHOUT VALUES and next tests.

## Stop conditions

- Invalid/missing approved file; no authorization for cloud upload; revoked/bad gateway key; missing model capability; VideoDB credit cap exceeded; provider response shape incompatible; sensitive footage not approved for external processing; agent cannot read actual MP4 timestamps; unexpectedly large budget estimate. Explain what stopped and retain completed artifacts.

## What NOT to build

Do not create REST server, UI, autonomous bot, accounts, permissions database, background service, custom video encoder, Go MCP, or provider SDK clone. Prefer upstream tools; propose a tiny compatibility adapter only after proving the exact API mismatch and estimating effort.
