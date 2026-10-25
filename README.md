# Meeting Intelligence System

An agent-first, **video-aware** knowledge workflow for Microsoft Teams recordings and other MP4 meeting files.

**MVP approach:** use VideoDB's official agent skill, hosted MCP and Python SDK. Do not develop a custom backend or frontend until an evidenced gap requires one.

## Start on Windows

1. Clone this repository and open its folder in your preferred AI coding agent (Codex or GitHub Copilot).
2. Put one authorized, non-sensitive test recording at `recordings/test.mp4` (create this folder locally; it is gitignored).
3. Sign into [VideoDB Console](https://console.videodb.io) and use the API key already created. **Never paste an API key into chat, commits, or issue descriptions.**
4. In a PowerShell terminal with Node.js/npx available:

   ```powershell
   npx skills add video-db/skills
   ```

5. Ask your agent: **"Set up the official VideoDB skill in this repository, authenticate securely without saving the key to Git, and verify its MCP/SDK connectivity."** The official skill documents `/videodb setup` (or your agent's equivalent).
6. Ask: **"Using the official VideoDB skill, analyze recordings/test.mp4 for spoken words, visual scenes and on-screen text/OCR. Index results, then answer: what errors or configuration screens appeared? Give exact timestamps and playable evidence."**

This **uses VideoDB cloud processing**; local files and a local agent do not imply offline operation.

## Project documents

- [project.md](project.md) — goals, scope, technical strategy and acceptance criteria
- [resources.md](resources.md) — VideoDB-only tools and links
- [AGENTS.md](AGENTS.md) — agent development and review contract
- [docs/windows-mvp.md](docs/windows-mvp.md) — reproducible manual acceptance workflow
- [skills/](skills/) — reusable business/use-case instructions, not competing SDK implementations

## Guiding rule

**Orchestrate first; implement only if necessary.** No app/API/MCP/React service for the first experiment. Validate perception quality, timestamp citations, privacy, usage costs and reliability before building a product.
