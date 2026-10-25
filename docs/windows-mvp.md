# Windows MVP — VideoDB Primary, LiteLLM Supplemental Inference

1. Pair one **approved** MP4 and its existing transcript.txt, inspect timecodes.
2. Select `videodb` with `.\scripts\select-provider.ps1 -Provider videodb`.
3. Set up official VideoDB skill/MCP/SDK, using the existing account and API key securely.
4. Record VideoDB credit balance before processing. Get approval for uploading MP4 to VideoDB.
5. Use VideoDB managed `vlm` scenes, OCR and timestamped retrieval; let its pipeline use its own internal analyzers as needed. Existing transcripts remain primary for our reasoning workflow, but VideoDB may still require its speech analyzer for native indexing.
6. Route any **application-controlled** text/image summaries, meeting decisions, optional transcript embeddings, and custom agent reasoning through user's self-hosted LiteLLM aliases. Do not claim VideoDB's internal analyzers route through LiteLLM.
7. Verify screen-only vs speech-only facts from the original video, then record VideoDB credits plus LiteLLM/Azure spend as separate line items.
8. Run the same test in hybrid mode if Azure video embedding compatibility is verified; otherwise record hybrid blocker.

See `docs/litellm-integration.md` and `docs/compare-backends.md`.
