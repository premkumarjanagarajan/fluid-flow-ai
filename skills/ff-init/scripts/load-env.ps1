# ──────────────────────────────────────────────────────────────
# load-env.ps1 — Load .env variables into your shell environment
# ──────────────────────────────────────────────────────────────
# Usage:
#   . .\load-env.ps1                  # Load for current session only
#   . .\load-env.ps1 -Persist         # Load + save as User env vars
#
# This script reads the .env file in the same directory and exports
# all variables. VS Code must be relaunched after loading.
# ──────────────────────────────────────────────────────────────

param(
    [switch]$Persist
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
# Find .env in the repo root (3 levels up from skills/ff-init/scripts/)
$RepoRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $ScriptDir))
$EnvFile = Join-Path $RepoRoot ".env"

if (-not (Test-Path $EnvFile)) {
    Write-Host "❌ .env file not found at: $EnvFile" -ForegroundColor Red
    Write-Host "   Run: Copy-Item .env.example .env  and fill in your tokens."
    return
}

$Loaded = 0
$Skipped = 0

Get-Content $EnvFile | ForEach-Object {
    $line = $_.Trim()

    # Skip comments and empty lines
    if ([string]::IsNullOrEmpty($line) -or $line.StartsWith("#")) { return }

    # Extract key=value
    $parts = $line -split "=", 2
    if ($parts.Count -ne 2) { return }

    $Key = $parts[0].Trim()
    $Value = $parts[1].Trim()

    # Skip placeholder values
    if ($Value -match "your-|CHANGE_ME" -or [string]::IsNullOrEmpty($Value)) {
        Write-Host "⚠️  Skipped $Key (placeholder value — update in .env first)" -ForegroundColor Yellow
        $script:Skipped++
        return
    }

    # Export to current session
    [System.Environment]::SetEnvironmentVariable($Key, $Value, "Process")

    if ($Persist) {
        [System.Environment]::SetEnvironmentVariable($Key, $Value, "User")
        Write-Host "✅ $Key → exported + persisted (User env var)" -ForegroundColor Green
    } else {
        Write-Host "✅ $Key → exported (session only)" -ForegroundColor Green
    }
    $script:Loaded++
}

Write-Host ""
Write-Host "── Summary ──────────────────────────────────────" -ForegroundColor Cyan
Write-Host "   Loaded:  $Loaded variable(s)"
Write-Host "   Skipped: $Skipped variable(s) (placeholders)"
if ($Persist) {
    Write-Host "   Persisted as User environment variables."
    Write-Host "   Restart VS Code to pick up the changes."
} else {
    Write-Host "   Session only. Use -Persist to save permanently."
    Write-Host "   Restart VS Code to pick up the changes."
}
Write-Host "─────────────────────────────────────────────────" -ForegroundColor Cyan
