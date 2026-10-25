# Reuse Existing Transcripts; Optional Lightweight Whisper

## Starting point

Library already contains ~40 MP4 videos and transcript.txt files. These transcripts should be used **as provided**, not unnecessarily retranscribed.

## Timestamp discovery

Detect an existing time format:
- SRT (`00:01:02,000 --> 00:01:07,500`)
- WebVTT (`00:01:02.000 --> 00:01:07.500`)
- Timecoded lines (`[00:01:02] Speaker: message`)
- Untimed plain text

If timestamps exist: normalize to original MP4 seconds and preserve source speaker text. Report any offset/clock mismatch. If untimed: search words to identify relevant *meeting* first, then use a visual search or frame inspection to find moments. Do **not invent** exact times.

## Optional Whisper policy

`config/pipeline.json` provides agent preference (not executable configuration). The optional helper is [faster-whisper](https://github.com/SYSTRAN/faster-whisper), CPU int8, `base` multilingual (or `tiny` if faster exploratory alignment is preferable).

Only trigger when:
1. A transcript has no timecodes **and** a verified spoken-to-video timestamp is required; or
2. Sections are missing or too inaccurate for retrieval.

One-off installation when needed: `python -m pip install faster-whisper` in an isolated virtual environment.

Using the upstream API, `WhisperModel("base", device="cpu", compute_type="int8")` with `transcribe(audio_path, word_timestamps=True)` produces time-anchored *recognized* words; it **does not forced-align an arbitrary external transcript automatically**.

To map timestamps onto supplied transcript:
1. Segment Whisper output into timestamped phrases.
2. Fuzzy-match recognized phrases with neighboring spans of the original transcript.
3. Preserve the original wording; assign only confidently matched time ranges.
4. Mark uncertain/dropped matches instead of forcing invented timestamps.
5. Save a *derived sidecar* such as `data/aligned/<meeting>.json` or `.srt`; never overwrite transcript.txt.
6. Manually check two anchors (early and late) against the MP4 and note drift, language and accuracy.

For accuracy beyond light MVP alignment, research dedicated forced alignment separately; do not introduce heavy packages by default.

## Cost/performance

- If original timestamps available: 0 Whisper runs.
- If unavailable: only process the selected pilot file or relevant time interval, not all 40.
- CPU int8 `base` should be reasonable to experiment with on a 24 GB RAM PC; actual throughput depends on CPU, language, audio and duration.

## Safety

Original transcripts and derived alignments remain local in gitignored `recordings/` and `data/` unless user separately authorizes a provider upload. VideoDB may run its own speech processor for its indexing features even when a local transcript exists; document this duplicate provider work and cost.
