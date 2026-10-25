# Comparing VideoDB vs Local on the Same MP4

Run **each provider independently**, explicitly switching with `scripts/select-provider.ps1`. Do not automatically fall back or mix results while scoring.

## Common questions

1. What exact technical error, terminal command or configuration is **visible** but not spoken?
2. What decision or explanation is present in **speech** but not screen text?
3. What occurred on screen immediately before or after a named statement?
4. Find one application setting or diagram and provide a source timestamp and inspectable image/clip.
5. Identify one uncertain detail and state why it could not be established.

## Scorecard (human verified)

| Check | VideoDB | Local |
|---|---|---|
| Installed and tool connected | Not tested | Not tested |
| Speech available | Not tested | Not tested |
| On-screen text available | Not tested | Not tested |
| Visually meaningful frame/scene analysis | Not tested | Not tested |
| Screen-only claim accurate | Not tested | Not tested |
| Timestamp accurate | Not tested | Not tested |
| Evidence can be manually inspected | Not tested | Not tested |
| Citation correctness (0–5) | — | — |
| Visual understanding (0–5) | — | — |
| Transcript correctness (0–5) | — | — |
| Total runtime | — | — |
| Provider/API cost | — | $0 VideoDB API, local compute |
| Data leaving PC | Video file to VideoDB | Possibly selected frames/text to cloud coding agent |

Save filled results to `data/comparison.md` (ignored by Git). Record upstream tool version, local GPU/RAM, video duration and test timestamp. In local mode, image-keyframe inspection by a cloud AI agent is **not** the same as offline VLM inference.

## Decision

Choose the provider based on **actual visual quality, confidentiality requirements, runtime and recurring costs**, not advertised repo features.
