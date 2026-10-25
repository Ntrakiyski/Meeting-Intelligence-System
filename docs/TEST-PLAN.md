# Acceptance and Quality Test Plan

Two MVP paths must be tested on the **same authorized** MP4 and existing transcript. **A documented integration is not a verified runtime.** Record pass/fail evidence, not just an agent summary.

## Test dataset

Start with:
- **Fixture A:** Synthetic 5–10 s MP4 with two distinct colored/text-labelled screens and an unrelated control MP4. Used for API format and query/vector tests; no customer media.
- **Fixture B:** One consented screen-heavy Teams session with existing transcript, containing a known small error or setting, an explicit spoken decision and static screen segments.
- **Fixture C:** A second short meeting with contrasting settings, for negative/no-match and cross-meeting results.
- Store all under ignored local paths; manifest contains hashes/relative paths, not raw private content.

## T0. Repo and process

| ID | Test | Acceptance |
|---|---|---|
| T0.1 | Clone repository, read architecture/ADRs and execute `$meeting-intelligence status` | Skill discoverable and reports actual provider/config capabilities |
| T0.2 | Scan 40 local files without indexing | Count paired/unmatched/ambiguous, no mutation/egress |
| T0.3 | Provider selection | `videodb` and `hybrid` distinct; no silent fallback |
| T0.4 | Secrets protection | No keys or data entered Git / printed in logs |
| T0.5 | Model alias check | Actually deployed aliases confirmed, not just config placeholders |

## T1. Gateway

| ID | Test | Acceptance |
|---|---|---|
| T1.1 | LiteLLM chat | `meeting-reasoning` responds through gateway |
| T1.2 | LiteLLM vision | `meeting-vision` reads synthetic screenshot text |
| T1.3 | LiteLLM text embedding | Numeric vector, stable dimensions |
| T1.4 | Native video via SentrySearch LiteLLM | MP4 vector AND text query vectors from same alias; matching clip retrieved |
| T1.5 | Unsupported video model | Fails explicitly, **no** automatic direct Azure/Gemini bypass |
| T1.6 | Embedding model swap | Existing index never queried with altered model/space |

## T2. VideoDB primary

| ID | Test | Acceptance |
|---|---|---|
| T2.1 | Consent and upload | Only approved file sent; provider ID recorded |
| T2.2 | VLM/OCR | Analyzer statuses explicitly successful; partial failures not hidden |
| T2.3 | Visual-only question | At least one *screen-visible and unsaid* fact, correct timestamp on playback |
| T2.4 | Spoken decision | Original transcript supported and decision explicitly approved |
| T2.5 | Crossmodal event | Connects discussion and **verified** displayed state within timestamp window |
| T2.6 | Credit ledger | Actual before/after credits, media duration and analyzer settings logged |

## T3. Hybrid

| ID | Test | Acceptance |
|---|---|---|
| T3.1 | Native video compatibility | `T1.4` pass before real video indexing |
| T3.2 | Frame retrieval | SentrySearch finds a visible event with original MP4 seekable timestamp |
| T3.3 | Readable error | Original-resolution inspection verifies exact text or marks unreadable |
| T3.4 | Index privacy | Files/index local; outbound MP4 chunks/frames via LiteLLM→Azure documented |
| T3.5 | Model billing | Actual model alias, usage and Azure/LiteLLM costs recorded |
| T3.6 | Frame-caption fallback (if needed) | Correctly labels **reduced coverage**, searchable time-stamped caption with original frame; never calls it native video embedding |

## T4. Evidence integrity

- Every material claim includes meeting ID, original-video seconds, evidence modality and inspectable frame/clip or transcript text location.
- Sample a minimum of **two independent screen-only observations**, **one spoken decision**, **one cross-modal event**, and **one negative/unsupported query** per provider/strategy, when such evidence exists in chosen fixture.
- Human reviewer opens the cited MP4 at those times. Mark `confirmed` / `rejected` / `uncertain` and why.
- Do not accept claims with fabricated citations, silent transcript-only downgrade, hallucinated full-resolution OCR, or blank/expired video references without original timestamp backup.
- Clip-relative times MUST include chunk start offsets when mapped back to original recording.
- If a key scenario lacks evidence in the video, choose a more suitable test rather than invent a fact.

## Quality scorecard (record raw counts, not made-up statistics)

- Visual retrieval: relevant clips in top 5, count of manually validated hits, missed events.
- Speech: source transcript/timecode quality, decision/proposal distinction.
- Timestamp delta: manually observed offset in seconds.
- OCR/screen reading: exact vs approximate vs unreadable.
- Performance: wall-clock time, video duration, clip preprocessing time, CPU/RAM, network.
- Monetary: VideoDB credit delta + LiteLLM model charges (separately).
- Data handling: what left local PC, which provider saw media, storage/retention status.
- Failure: HTTP error, stale alias, limits, permissions, partial analyzer.
- Plan future batch only once human accepts the first video and cost.

## Final disposition

`PASS` / `PARTIAL` / `BLOCKED` / `FAIL` per provider and by capability:
- Native multimodal video retrieval
- Frame-caption searchable fallback
- Existing transcript use
- Timestamp precision
- Vision error reading
- Agent operation
- Privacy/cost traceability

**End-to-end success** cannot be declared when hybrid video embeddings have never been accepted by the proxy or when no human verified retrieved visual evidence.
