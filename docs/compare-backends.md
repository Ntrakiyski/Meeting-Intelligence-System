# VideoDB Cloud vs SentrySearch Local — MVP Acceptance

Both must process the **same approved MP4** with the **same original transcript.txt**. No fallback between providers. Compare results with source evidence.

| Metric | VideoDB (primary) | SentrySearch (local) |
|---|---|---|
| Connection/install | Unverified | Unverified |
| MP4 + transcript paired | Unverified | Unverified |
| Existing transcript reused | Unverified | Unverified |
| Screen-only event found | Unverified | Unverified |
| Speech-only evidence found | Unverified | Unverified |
| Exact video seek timestamp | Unverified | Unverified |
| Error/UI text legible | Unverified | Unverified |
| Prompt/image and model privacy boundary disclosed | Unverified | Unverified |
| Optional Whisper needed? | Undetermined | Undetermined |
| Cost/credit delta | Not yet measured | No VideoDB API fee; hardware/model costs possible |
| GPU/preflight | Not required locally | Required for performant local Qwen |
| Processing time | Not yet measured | Not yet measured |

### Mandatory questions

1. Find a terminal error or configuration visible but never spoken about; show the exact clip/frame.
2. Identify an explicitly approved decision in speech; distinguish from proposal.
3. What was visible immediately when the participant mentioned a particular component?
4. Provide one thing you **cannot** read confidently on screen.
5. Report transcript timestamp format and whether alignment was needed.

### Validation and rollout

- Run on **one** recording, check manually, then 5, then potentially all 40.
- Record original MP4 seconds, transcript source line/offset, embedding engine/model, provider mode, any OCR usage and evidence preview.
- VideoDB cost: actual credit balance before/after; local cost: installation/model download size, CPU/GPU/VRAM, elapsed time, and any cloud inference.
- Save completed scorecard at `data/compare-backends.md` (ignored by Git).
- **Both paths are documented but not yet executed on user's Windows machine.** If local GPU is inadequate, local video retrieval fails its acceptance criterion until a viable alternative exists.
