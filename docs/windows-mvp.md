# Windows MVP — Agent-Only Validation

## Prerequisites

- Windows PowerShell, Node.js + npx, Codex or GitHub Copilot with agent skills support.
- VideoDB account and an API key.
- One authorized sample MP4 in a locally created `recordings/` directory.
- Internet access; VideoDB understanding is hosted.

## Procedure

1. Open this repository in the agent and run:

   ```powershell
   npx skills add video-db/skills
   ```

2. Say to the agent: `Read AGENTS.md and project.md. Use the VideoDB skill to set up and validate my VideoDB connection. Do not create a custom application.`

3. Use the upstream skill's setup command (`/videodb setup` in some clients; use the equivalent in Codex/Copilot). Let it show the supported secure way to configure the key. If a local environment variable is needed, consult the current SDK docs (`VIDEO_DB_API_KEY` in the official skill).

4. Say: `Using VideoDB's existing skill or official Python SDK, process recordings/test.mp4. Create spoken_words, vlm and ocr understanding as supported. Index all usable outputs. Do not stop at a transcript.`

5. Say: `Find a real error, command, setting, diagram or UI change on screen that wasn't evident from speech alone. Return source timestamps, a playable clip when available, and quote only text you can read reliably.`

6. Say: `Give me (a) five decisions with evidence and uncertainty, (b) outstanding issues, (c) a technical handover, (d) provider credits/usage spent so far.`

7. Manually play the recording at the cited moments. Mark each answer correct/incorrect/uncertain.

## Acceptance checklist

- [ ] MP4 ingested via approved VideoDB account
- [ ] `spoken_words` analysis completed (or a documented error)
- [ ] `vlm` scene analysis completed (or a documented error)
- [ ] `ocr` analysis completed (or a documented error)
- [ ] Timestamped evidence found for at least one screen-only observation
- [ ] Agent can answer a question that cannot be answered reliably from transcript alone
- [ ] Hallucination and low-confidence behavior checked
- [ ] Privacy/consent verified
- [ ] Exact usage/cost reviewed in provider console
- [ ] Findings saved to a local, gitignored report

## Report

Create locally in `data/mvp-validation.md`. Record file ID (not sensitive paths), SDK/skill version, analyzer configuration, source timestamps, manual verdict, processing duration, cost, errors and a recommendation. Do not commit reports containing private meeting details.
