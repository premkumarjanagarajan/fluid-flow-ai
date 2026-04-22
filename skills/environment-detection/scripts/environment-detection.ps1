$ErrorActionPreference = "Stop"

# ──────────────────────────────────────────────────────────────
# environment-detection.ps1
# ──────────────────────────────────────────────────────────────
# Usage:
#   pwsh environment-detection.ps1 [dir1 dir2 ...]
#
# Pass workspace root directories as arguments. If none given,
# falls back to $env:WORKSPACE_ROOTS (path-separated) or ".".
#
# Output: single JSON object to stdout.
# ──────────────────────────────────────────────────────────────

# --- OS and Shell ---
$os = "windows"
$shellType = "powershell"

if ($IsLinux) {
    $os = "linux"
    $shellType = "bash"
} elseif ($IsMacOS) {
    $os = "darwin"
    $shellType = "bash"
}

# --- Package Managers ---
$commands = @("dotnet", "npm", "yarn", "pnpm", "terraform", "az", "docker", "pip")
$found = @()
foreach ($cmd in $commands) {
    if (Get-Command $cmd -ErrorAction SilentlyContinue) {
        $found += $cmd
    }
}

$pkgCsv = if ($found.Count -gt 0) { $found -join "," } else { "none" }

# --- Resolve scan directories from args, env, or fallback ---
$scanDirs = @()
if ($args.Count -gt 0) {
    $scanDirs = $args
} elseif ($env:WORKSPACE_ROOTS) {
    $scanDirs = $env:WORKSPACE_ROOTS -split [IO.Path]::PathSeparator
} else {
    $scanDirs = @(".")
}

# --- Tech Stack + Source Repo Classification (single pass) ---
$techStack = @()
$repoJsonItems = @()

foreach ($dir in $scanDirs) {
    if (-not (Test-Path $dir -PathType Container)) { continue }

    $repoName = Split-Path -Leaf $dir
    $repoType = "greenfield"
    $hasCode = $false

    # .csproj / .sln / .fsproj → dotnet
    if (Get-ChildItem -Path $dir -Recurse -Depth 2 -Include "*.csproj","*.sln","*.fsproj" -ErrorAction SilentlyContinue | Select-Object -First 1) {
        $techStack += "dotnet"; $hasCode = $true
    }

    # package.json → typescript or javascript
    $pkgJson = Get-ChildItem -Path $dir -Recurse -Depth 1 -Filter "package.json" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($pkgJson) {
        $content = Get-Content $pkgJson.FullName -Raw -ErrorAction SilentlyContinue
        if ($content -match '"typescript"') {
            $techStack += "typescript"
        } else {
            $techStack += "javascript"
        }
        $hasCode = $true
    }

    # *.tf / terraform/ → terraform
    $tfFile = Get-ChildItem -Path $dir -Recurse -Depth 1 -Filter "*.tf" -ErrorAction SilentlyContinue | Select-Object -First 1
    $tfDir = if (Test-Path "$dir/terraform" -PathType Container) { $true } else { $false }
    if ($tfFile -or $tfDir) {
        $techStack += "terraform"; $hasCode = $true
    }

    # go.mod → go
    if (Get-ChildItem -Path $dir -Recurse -Depth 1 -Filter "go.mod" -ErrorAction SilentlyContinue | Select-Object -First 1) {
        $techStack += "go"; $hasCode = $true
    }

    # Cargo.toml → rust
    if (Get-ChildItem -Path $dir -Recurse -Depth 1 -Filter "Cargo.toml" -ErrorAction SilentlyContinue | Select-Object -First 1) {
        $techStack += "rust"; $hasCode = $true
    }

    # docker-compose.yml / Dockerfile → docker
    if (Get-ChildItem -Path $dir -Recurse -Depth 1 -Include "docker-compose.yml","docker-compose.yaml","Dockerfile" -ErrorAction SilentlyContinue | Select-Object -First 1) {
        $techStack += "docker"; $hasCode = $true
    }

    # azure-pipelines.yml → azure
    if (Get-ChildItem -Path $dir -Recurse -Depth 1 -Filter "azure-pipelines.yml" -ErrorAction SilentlyContinue | Select-Object -First 1) {
        $techStack += "azure"; $hasCode = $true
    }

    # *.py / requirements.txt / pyproject.toml → python
    if (Get-ChildItem -Path $dir -Recurse -Depth 2 -Include "*.py","requirements.txt","pyproject.toml" -ErrorAction SilentlyContinue | Select-Object -First 1) {
        $techStack += "python"; $hasCode = $true
    }

    # *.sql → sql
    if (Get-ChildItem -Path $dir -Recurse -Depth 2 -Filter "*.sql" -ErrorAction SilentlyContinue | Select-Object -First 1) {
        $techStack += "sql"; $hasCode = $true
    }

    if ($hasCode) {
        $repoType = "brownfield"
    }

    # Check reverse-engineering timestamp
    $reTs = "null"
    $reFile = Join-Path $dir "reverse-engineering/reverse-engineering-timestamp.md"
    if (Test-Path $reFile) {
        $reContent = Get-Content $reFile -Raw -ErrorAction SilentlyContinue
        if ($reContent -match '(\d{4}-\d{2}-\d{2}T[\d:ZT+\-]+)') {
            $reTs = "`"$($Matches[1])`""
        }
    }

    $repoJsonItems += "{`"name`":`"$repoName`",`"type`":`"$repoType`",`"reTimestamp`":$reTs}"
}

# Deduplicate tech stack
$uniqueTech = ($techStack | Sort-Object -Unique) -join ","
if (-not $uniqueTech) { $uniqueTech = "none" }

# Build repos JSON array
$reposJson = "[" + ($repoJsonItems -join ",") + "]"

# --- Output JSON ---
@"
{
  "os": "$os",
  "shellType": "$shellType",
  "packageManagers": "$pkgCsv",
  "techStack": "$uniqueTech",
  "sourceRepos": $reposJson
}
"@
