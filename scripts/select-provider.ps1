# Choose model/processing architecture; does not process recordings.
param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("videodb", "hybrid", "local")]
    [string]$Provider
)
$ErrorActionPreference = "Stop"
if ($Provider -eq "local") {
    Write-Warning 'The older "local" mode now uses remote embeddings via LiteLLM/Azure Foundry; selecting "hybrid" instead. It is NOT offline.'
    $Provider = "hybrid"
}
$root = Split-Path -Parent $PSScriptRoot
$config = Join-Path $root "config\provider.json"
@{ provider = $Provider } | ConvertTo-Json | Set-Content -Encoding utf8 $config
Write-Host "Selected provider: $Provider"
if ($Provider -eq "videodb") {
    Write-Host "VideoDB Cloud manages video indexing/analysis. Our controlled AI calls use LiteLLM."
    Write-Host "Follow docs/windows-mvp.md and docs/litellm-integration.md."
} else {
    Write-Host "Windows local media/index + SentrySearch; video embeddings and reasoning via LiteLLM -> Azure Foundry."
    Write-Host "The video embedding API route is not yet verified. Do NOT index real recordings before compatibility testing."
    Write-Host "Follow docs/local-mvp.md and docs/litellm-integration.md."
}
