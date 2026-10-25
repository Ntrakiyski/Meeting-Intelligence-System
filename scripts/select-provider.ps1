# Select one of the two MVP video-intelligence paths.
# Provider selection does not install upstream tools or process a recording.
param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("videodb", "local")]
    [string]$Provider
)
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$configDir = Join-Path $root "config"
$config = Join-Path $configDir "provider.json"
New-Item -ItemType Directory -Force -Path $configDir | Out-Null
@{ provider = $Provider } | ConvertTo-Json | Set-Content -Encoding utf8 -Path $config
Write-Host "Meeting Intelligence provider: $Provider"
Write-Host "Configuration: $config"
if ($Provider -eq "local") {
    Write-Host "Local provider: SentrySearch CLI with local Qwen3-VL video embeddings."
    Write-Host "Check GPU VRAM: nvidia-smi --query-gpu=name,memory.total --format=csv"
    Write-Host "See docs/local-mvp.md for hardware checks and official SentrySearch installation."
    Write-Host "Existing transcript.txt files are reused; Whisper is optional."
} else {
    Write-Host "Cloud provider: VideoDB API (usage credit may be charged)."
    Write-Host "Use the official VideoDB skill and secure authentication (docs/windows-mvp.md)."
    Write-Host "Existing transcript.txt files are reused where possible."
}
Write-Host "Open your agent and read AGENTS.md, project.md, config/pipeline.json and skills/analyze-meeting/SKILL.md."
