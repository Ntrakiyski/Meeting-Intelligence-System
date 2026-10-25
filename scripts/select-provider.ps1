# Select which existing video intelligence tool the agent uses. No video processing code.
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
    Write-Host "Check local MCP: video-context-mcp doctor --json"
    Write-Host "Ensure video-context-mcp is registered in your agent MCP client."
} else {
    Write-Host "Ensure the official VideoDB skill is installed and securely authenticated."
}
Write-Host "Open your coding agent and ask it to read skills/analyze-meeting/SKILL.md and process recordings/test.mp4."
