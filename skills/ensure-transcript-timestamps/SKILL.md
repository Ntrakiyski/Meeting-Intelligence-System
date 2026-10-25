---
name: ensure-transcript-timestamps
description: Preserve existing meeting transcripts and optionally create aligned timestamp sidecars with lightweight faster-whisper when source lacks usable timecodes.
---

# Ensure Transcript Timestamps (Optional)

Read `docs/transcript-timestamps.md` and `config/pipeline.json`.

1. Identify existing subtitle/timecode format, reuse if valid.
2. No timecodes? If the task doesn't require speech-to-video alignment, **skip Whisper**.
3. If needed, request permission to run a local `faster-whisper` CPU int8 `base`/`tiny` pass on the **selected** file or interval.
4. Whisper word timestamps align Whisper's **recognized audio text**, not arbitrary supplied transcript text. Fuzzy-match nearby original phrases to generated word/segment anchors, preserve original text verbatim, mark unverified spans.
5. Save separate derived `data/aligned/<meeting>.json` or SRT. Never overwrite original transcripts or bulk-run on all 40.
6. Manually verify at least two seek positions against original MP4.
