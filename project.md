# PROJECT — Meeting Intelligence System

## Purpose

Turn 40 pre-recorded Teams meetings (MP4 + transcript.txt) into searchable evidence about **what was said** and **what appeared on screen**. Extract verified decisions, visible errors, diagrams, interface states and timestamped source clips for human and agent workflows.

## Business goals

1. Reuse all existing transcript text instead of bulk re-transcribing.
2. Provide agent-first skills: finding evidence, analyzing a meeting, extracting decisions, creating issue drafts and handovers.
3. Offer two independently testable MVP providers sharing the same output/evidence requirements.
4. Use the existing self-hosted LiteLLM as **the single model gateway for calls under our control**, with Azure AI Foundry models behind it.
5. Preserve data provenance, provider permissions and per-path costs; build no duplicate app infrastructure.

## Two MVP paths

### A. Primary: VideoDB Cloud (`videodb`)

- Existing VideoDB Skill, MCP and/or Python SDK for approved MP4 cloud ingestion, scene/VLM understanding, OCR, indexing and retrieval.
- VideoDB itself controls its internal analysis/indexing; **do not claim its internal model calls route through LiteLLM**.
- Our subsequent summarization, agent visual inspection, optional text embeddings and other **custom** model reasoning call aliases via the existing LiteLLM proxy.
- Consume trial credit only after recording user approval and before/after usage.

### B. Alternative: Windows processing + LiteLLM + Azure Foundry (`hybrid`)

- Local MP4, transcript pairing, evidence store and indexes on Windows.
- Existing [SentrySearch](https://github.com/ssrajadh/sentrysearch) CLI handles video chunking, visual retrieval and local ChromaDB; choose its documented `litellm` backend when compatible with the model exposed by the gateway.
- All video embedding and text embedding / vision / reasoning models **we control** route through self-hosted LiteLLM, backed by confirmed Azure Foundry deployments.
- **No local Qwen model is required** under this agreed architecture; 24 GB system RAM is fine for file/metadata handling, but inference occurs via cloud deployments.
- A major gate remains: SentrySearch encodes MP4 chunks as `data:video/mp4;base64` for a standard `/embeddings` proxy route; Azure Voyage multimodal documents a different `/v1/multimodalembeddings` API. Neither a working LiteLLM adapter nor compatibility is confirmed. A Foundry catalog listing is not evidence of a deployed endpoint.
- If native video embedding fails, use selected frames + existing transcripts + LiteLLM vision/reasoning as a **limited visual-inspection pilot**. Do not misrepresent it as indexed video search or build a custom adapter without approval.

## Shared input, outputs and workflow

- Inputs: local MP4 + matching transcript.txt; preserve files. Extract existing timestamps; optional `faster-whisper` base/tiny CPU int8 only if timestamps are needed and missing.
- Outputs: speech evidence, visual evidence, source timestamp, associated media/frame reference, provenance, uncertain claims, action candidates, provider usage and runtime.
- Start one authorized recording, then five, then ~40.
- Agent workflows and skills select provider from `config/provider.json` via `scripts/select-provider.ps1`.
- Models are referenced only by validated **LiteLLM aliases**, never hard-coded provider API keys in the project repo.

## Proposed gateway aliases

- `meeting-reasoning`: an available reasoning/chat model via LiteLLM.
- `meeting-vision`: a model proven to accept image input via LiteLLM.
- `meeting-text-embedding`: Azure text embedding deployment; optional for existing transcript.txt semantic matching.
- `meeting-video-embedding`: only assign once an Azure Foundry **video-capable** deployment works through the LiteLLM proxy with native video input and compatible query vectors.

These are **configuration intentions**, not claims that deployments already exist.

## Acceptance gates

1. Both providers can be chosen, with no silent cross-provider ingestion.
2. The same approved recording and existing transcript used in both tests.
3. Timecoded, manually verified **screen-only** and **speech-only** findings; screenshots/clips truly match source times.
4. Before hybrid video retrieval: check video embedding endpoint compatibility, response dimensions, text query vs video vector alignment, stable model identity and index isolation.
5. Before model use: verify through LiteLLM /models or proxy management and make successful controlled inference calls.
6. Document Azure/model credits separately from VideoDB usage; both may bill.
7. Never claim offline processing: SentrySearch may store/index locally while embeddings and reasoning are sent to Azure through LiteLLM.
8. Optional Whisper never overwrites original transcript and does not run on all 40 by default.
9. No real client uploads to Azure or VideoDB without authorization; no credentials or media in public GitHub.
10. No custom application/backend/MCP until upstream approaches are tested and a gap is documented.

## Later phases

Cross-meeting project memory, permission-aware shared access, optional Vite/React frontend or thin MCP wrapper, live Teams capture/agent participation, audit and budgets.
