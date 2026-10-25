---
name: index-meeting-library
description: Inventory and selectively index existing MP4/transcript.txt pairs; avoid cost and accidental cloud upload of whole meeting archives.
---

# Index Meeting Library

1. Read `project.md`, `AGENTS.md`, `config/provider.json` and `config/pipeline.json`.
2. Scan local recording directory, pair MP4 with transcript.txt or matching stem; record unmatched/ambiguous names, transcript timecode presence and duration if available.
3. Do not read or upload all 40 in the first run: select one authorized test pair, then up to five after validation.
4. Use existing transcript text for keyword search. Optional local text semantic embeddings only after demonstrating need.
5. For VideoDB, require explicit upload approval per data policy and record credits.
6. For local SentrySearch, check GPU/VRAM and index video with `--backend local`; preserve clip offsets. SentrySearch does not ingest text transcripts into its visual index.
7. Maintain private results in `data/`; return matching status, provenance, source links/offsets, time/cost.
