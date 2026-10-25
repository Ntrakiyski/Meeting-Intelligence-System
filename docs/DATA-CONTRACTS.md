# Evidence, Input and Run Data Contracts (v0.1)

This is a **logical contract**, not a mandate to build a new service/DB. Emit JSON/Markdown sidecars under ignored `data/` or `outputs/` only after consent. Use one schema for either processing provider.

## Input pairing and source identity

Accept:
- `recordings/Meeting-001/recording.mp4` + `recordings/Meeting-001/transcript.txt`
- `recordings/meeting-001.mp4` + `recordings/meeting-001.txt`
- Explicit user-supplied paths.

Pair based on explicit path, same directory and matching stem; detect ambiguous matches, never use alphabetic position. For the pilot, calculate SHA-256 of MP4 if feasible, as a **local** dedupe/provenance ID; never publish hashes if they could reveal customer identifiers. Do not move source assets.

```json
{
  "schema_version": "0.1",
  "meeting_id": "meeting-001",
  "source": {
    "video_path": "recordings/Meeting-001/recording.mp4",
    "transcript_path": "recordings/Meeting-001/transcript.txt",
    "sha256_local_only": null,
    "duration_seconds": null,
    "transcript_timecodes": "unknown",
    "time_alignment_status": "not_checked"
  }
}
```

## Single evidence record

All times in **seconds from the original MP4 start**; start inclusive/end exclusive when possible. If video is clipped, add trim-start offset before reporting the timestamp. Preserve time zone separately if meeting creation time is available; recording-relative timestamps remain authoritative.

```json
{
  "schema_version": "0.1",
  "evidence_id": "ev-0001",
  "meeting_id": "meeting-001",
  "provider": "videodb",
  "modality": "screen",
  "claim_type": "observation",
  "claim": "A pod status panel displayed a visible failure.",
  "start_seconds": 142.3,
  "end_seconds": 148.8,
  "transcript_ref": null,
  "visual_ref": {"kind": "video_time_range", "uri_or_local_path": "recordings/Meeting-001/recording.mp4"},
  "source_model": "provider-reported-or-null",
  "verification": "human_pending",
  "confidence": "medium",
  "limitations": ["Exact error code not readable at sampled resolution"],
  "provider_record_id": null
}
```

This JSON is **illustrative**, not an actual meeting result. Allowed:
- `provider`: `videodb`, `hybrid`.
- `modality`: `screen`, `speech`, `cross_modal`.
- `claim_type`: `observation`, `participant_assertion`, `agent_inference`, `uncertain`.
- `verification`: `human_pending`, `human_confirmed`, `rejected`.
- `confidence`: `low`, `medium`, `high` (self-reported, not statistically calibrated).
- `visual_ref.kind`: `video_time_range`, `local_frame`, `temporary_stream`.
- Unknown source, timestamp or model must be `null`; never invent citations.

Provider-specific retrieval scores (cosine, VideoDB relevance) are incomparable across engines. Do not merge those as calibrated confidence. Exact error strings require readable original-resolution evidence or mark as uncertain.

## Run manifest and index identity

```json
{
  "schema_version": "0.1",
  "run_id": "YYYYMMDDThhmmssZ-provider-meeting",
  "provider": "hybrid",
  "status": "planned",
  "meeting_ids": ["meeting-001"],
  "model_aliases": {
    "reasoning": "meeting-reasoning",
    "vision": "meeting-vision",
    "text_embedding": "meeting-text-embedding",
    "video_embedding": "meeting-video-embedding"
  },
  "embedding_identity": {
    "provider_deployment": null,
    "model_revision": null,
    "vector_dimensions": null,
    "index_name": null,
    "clip_settings": {"seconds": 30, "overlap_seconds": 5, "skip_still": false}
  },
  "stage_results": {
    "source_pairing": "not_started",
    "transcript": "not_started",
    "visual_index": "not_started",
    "visual_qa": "not_started"
  },
  "provider_usage": {"videodb_credit_usd_delta": null, "litellm_cost_usd": null},
  "errors": []
}
```

Stages: `not_started` / `running` / `succeeded` / `partial` / `failed` / `blocked`. A failed analyzer MUST NOT be labeled success. Reuse manifest and index only when the source hash, actual embedding model/deployment, dimensions, preprocessing/chunk parameters and relevant tool version match.

## Output storage

```text
data/                                # gitignored
  inventory.json
  runs/<run-id>/manifest.json
  runs/<run-id>/evidence.json
  runs/<run-id>/report.md
  runs/<run-id>/screenshots/...
  comparison.md
```

Do not bake VideoDB temporary stream URLs into permanent reports without marking that they can expire. Include original local MP4/time fallback where authorized.
