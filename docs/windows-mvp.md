# Windows MVP — Primary VideoDB Cloud

1. Place one authorized MP4 and its existing transcript.txt together (or record explicit matching paths). Never commit source files.
2. Run `.\scripts\select-provider.ps1 -Provider videodb`.
3. Install the maintained [VideoDB skill](https://github.com/video-db/skills): `npx skills add video-db/skills`. Authenticate safely through the skill / supported MCP.
4. Record current VideoDB trial balance. Confirm permission to upload this MP4.
5. Process video using VideoDB's `vlm` scene and `ocr` analyzers and create indexes for timestamped retrieval. Prefer the original transcript.txt as text evidence; if VideoDB requires its own `spoken_words` index for full search, record that duplication, cost and differences rather than masking them.
6. Find one **visual-only** technical detail and one **speech-only** decision; cite actual clip timestamps and inspect visible frames. If transcript timestamps missing, either mark approximate context or invoke optional `faster-whisper` alignment as in `docs/transcript-timestamps.md`.
7. Save locally in `data/videodb-validation.md`: tested clip, provider usage delta, verified evidence, analyzer status, uncertainty and limitations.
8. Repeat exactly the same pilot in local mode for `docs/compare-backends.md`.

Do not claim using an existing transcript means VideoDB can skip speech costs in every API workflow — verify actual SDK capabilities and usage.
