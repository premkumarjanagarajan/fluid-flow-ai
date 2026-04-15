# --------------------------------------------------------------
# load-env.ps1 - Load .env variables into your shell environment
# --------------------------------------------------------------
# Usage:
#   . .\load-env.ps1 C:\path\to\.env                           # one file
#   . .\load-env.ps1 C:\core\.env C:\dept\.env                  # multiple files
#   . .\load-env.ps1 -Persist C:\path\to\.env                   # persist as User env vars
#
# Accepts one or more .env file paths as arguments. Department
# vars override core vars when the same key appears in both.
# VS Code must be relaunched after loading.
# --------------------------------------------------------------

param(
    [switch]$Persist,
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$EnvFiles
)

if (-not $EnvFiles -or $EnvFiles.Count -eq 0) {
    Write-Host "[ERROR] No .env file paths provided." -ForegroundColor Red
    Write-Host "   Usage: . .\load-env.ps1 C:\path\to\.env [C:\path\to\another\.env]"
    return
}

$TotalLoaded = 0
$TotalSkipped = 0
$TotalFiles = 0

foreach ($EnvFile in $EnvFiles) {
    if (-not (Test-Path $EnvFile)) {
        Write-Host "[WARN]  Skipped: $EnvFile (file not found)" -ForegroundColor Yellow
        continue
    }

    $TotalFiles++
    Write-Host "-- Loading: $EnvFile" -ForegroundColor Cyan

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
            Write-Host "  [SKIP]  $Key (placeholder)" -ForegroundColor Yellow
            $script:TotalSkipped++
            return
        }

        # Export to current session
        [System.Environment]::SetEnvironmentVariable($Key, $Value, "Process")

        if ($Persist) {
            [System.Environment]::SetEnvironmentVariable($Key, $Value, "User")
            Write-Host "  [OK] $Key -> persisted (User env var)" -ForegroundColor Green
        } else {
            Write-Host "  [OK] $Key -> exported (session only)" -ForegroundColor Green
        }
        $script:TotalLoaded++
    }
}

Write-Host ""
Write-Host "-- Summary ------------------------------------------" -ForegroundColor Cyan
Write-Host "   Files:   $TotalFiles processed"
Write-Host "   Loaded:  $TotalLoaded variable(s)"
Write-Host "   Skipped: $TotalSkipped variable(s) (placeholders)"
if ($Persist) {
    Write-Host "   Persisted as User environment variables."
    Write-Host "   Restart VS Code to pick up the changes."
} else {
    Write-Host "   Session only. Use -Persist to save permanently."
    Write-Host "   Restart VS Code to pick up the changes."
}
Write-Host "-------------------------------------------------" -ForegroundColor Cyan
