# Tomorrow's Codex Kickoff — Copy this prompt

Use this directly inside the **cloned** Meeting-Intelligence-System GitHub repository on the Windows PC. Its contents are instructions to the agent operating in that repo, not executable commands.

---

You are the implementation/orchestration agent for Meeting Intelligence System.

**Goal:** Get a small, real end-to-end pilot working using VideoDB Cloud (primary) and evaluate the alternative SentrySearch + LiteLLM + Azure Foundry path on the *same approved* MP4 + transcript.txt. We value reusing tools more than writing code. We already have ~40 MP4/transcript pairs and an existing self-hosted LiteLLM gateway; Azure Foundry deployments are to be connected behind LiteLLM. The first VideoDB API trial has $20 advertised credit, but remaining balance and real rates must be checked.

**Read first, in order:** AGENTS.md; project.md; docs/DECISIONS.md; docs/ARCHITECTURE.md; docs/IMPLEMENTATION-PLAN.md; docs/GATEWAY-CONTRACT.md; docs/DATA-CONTRACTS.md; docs/TEST-PLAN.md; docs/SECURITY-AND-COSTS.md; docs/UPSTREAM-COMPATIBILITY.md; then provider-specific docs and .agents/skills/meeting-intelligence/SKILL.md.

**Priorities and constraints:**

1. Do not build a frontend, Go MCP, FastAPI server, database, auth product, or custom video processing engine. Prefer official VideoDB skill/MCP/Python SDK and SentrySearch CLI.
2. Check the Windows environment, gitignore, available input folder, exact transcript formats and provider selection. Invent no file paths, secrets, model aliases or costs.
3. Check LiteLLM real /models and actual chat/vision/text-embedding capability using synthetic examples; try native video embedding via **the actual SentrySearch LiteLLM payload** on synthetic MP4 and matching text query. Azure Foundry Voyage's multimodal endpoint format is different from OpenAI /embeddings. If incompatible, report blocker before any real Azure media upload.
4. Confirm consent for any real file sent to VideoDB or Azure. Never commit a private MP4, transcript, frame, key or model index.
5. Use ONE approved MP4 with its existing transcript.txt; do not transcribe if it already has useful timecodes. If missing and exact speech time is essential, optional faster-whisper base CPU int8 with separately saved alignment, not overwrite.
6. **VideoDB primary**: get VLM/OCR indexed timestamped visual evidence; check partial analyzer states; verify actual timestamp against original video, compare cost before/after.
7. **Hybrid native**: only when video/text embeddings passed proxy smoke test, run SentrySearch --backend litellm (no --rerank). Verify video evidence with original clip. If blocked, evaluate minimal selected-frame + LiteLLM vision + text embedding fallback, labeling lower fidelity and creating minimal isolated script only if truly necessary.
8. Produce human-verifiable, original-video-relative evidence in the documented schema, separating what was shown, what was said, and inference/unknown. Try two screen-only observations, one explicit decision and one uncertainty case.
9. Document completed vs blocked stages, tests, commands, active models, model/data boundaries, and actual credits. A passing test must include inspection of real timestamped evidence.
10. Before adding dependencies or coding, look up current official sources and identify exactly what capability is missing. Do not overwrite previous user decisions, and do not process all 40 files without a cost/consent approval.

**Deliverables — all local and ignored by Git until sanitized:** `data/inventory.json`, `data/runs/<run-id>/preflight.md`, `gateway-smoke.md`, `manifest.json`, `evidence.json`, primary VideoDB result, hybrid result/blocked report, `data/comparison.md` and `data/handoff.md`.

**Definition of done:** at least one accurate, manually inspectable screen-only finding with original video timestamp from VideoDB and a transparent PASS/PARTIAL/BLOCKED verdict for hybrid (full native video retrieval separately distinguished from frame-caption fallback). Never claim work completed without running it.

Start by summarizing repo decisions and environment preflight; then perform the first useful safe commands. Ask the operator only when credentials, explicit sensitive-media consent or billable provider actions genuinely require it.

---

## Quick commands from PowerShell (after clone)

```powershell
git pull
git status --short
Get-Content .\config\provider.json
Get-Content .\config\pipeline.json
.\scripts\select-provider.ps1 -Provider videodb
```

Do not paste secrets into chat. VideoDB first; then optionally run `-Provider hybrid` after compatibility test.
