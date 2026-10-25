# Compare VideoDB Cloud vs LiteLLM + Azure hybrid

Both paths use **the same approved MP4 and existing transcript.txt**, both keep timestamps and report evidence. Each is tested independently.

| Metric | VideoDB primary | SentrySearch / LiteLLM / Azure hybrid |
|---|---|---|
| Video indexing backend | VideoDB Cloud | Local SentrySearch/ChromaDB |
| Model path we control | LiteLLM | LiteLLM → Azure Foundry |
| Internal provider models | VideoDB managed | Needs verified multimodal video embedding route |
| Video embedding compatibility | Managed by VideoDB | **Unverified: /embeddings vs /multimodalembeddings** |
| Existing transcript preserved | Untested | Untested |
| Screen-only finding at correct timestamp | Untested | Untested |
| Speech-only decision at correct timestamp | Untested | Untested |
| Full-resolution visual text inspection | Untested | Untested |
| Real cost | VideoDB credits + optional Azure | Azure model charges + local storage/index |
| Media transferred outside Windows | Approved video → VideoDB | Video chunks/screens → Azure through LiteLLM |
| Optional Whisper | On-demand | On-demand |

## Gate order

1. Confirm LiteLLM aliases `meeting-reasoning`, `meeting-vision` and optional `meeting-text-embedding` via synthetic calls.
2. Verify `meeting-video-embedding` using SentrySearch-compatible base64 MP4 via LiteLLM. **Do not claim route supported until tested.**
3. Run one approved meeting in VideoDB; verify visual-only finding, citation and credits.
4. If step 2 passed, run same meeting via SentrySearch hybrid; compare returned clips.
5. If step 2 failed, record hybrid video retrieval **blocked**, optionally test manually extracted frames via LiteLLM vision without claiming parity.
6. Capture timings, embedding dims, exact models, API cost and authorized transfers in gitignored `data/`.

No new service or forced adapter in MVP.
