$ErrorActionPreference = "Stop"

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

Write-Output "SHELL_TYPE=$shellType"
Write-Output "OS=$os"

# --- Package Managers ---
$commands = @("dotnet", "npm", "yarn", "pnpm", "terraform", "az", "docker")
$found = @()
foreach ($cmd in $commands) {
    if (Get-Command $cmd -ErrorAction SilentlyContinue) {
        $found += $cmd
    }
}

$pkgManagers = if ($found.Count -gt 0) { $found -join "," } else { "none" }
Write-Output "PACKAGE_MANAGERS=$pkgManagers"

# --- Tech Stack ---
$techStack = @()
$scanDirs = @()

if ($env:WORKSPACE_ROOTS) {
    $scanDirs = $env:WORKSPACE_ROOTS -split [IO.Path]::PathSeparator
} else {
    $scanDirs = @(".")
}

foreach ($dir in $scanDirs) {
    if (-not (Test-Path $dir -PathType Container)) { continue }

    if ((Get-ChildItem -Path $dir -Filter "*.csproj" -ErrorAction SilentlyContinue) -or
        (Get-ChildItem -Path $dir -Filter "*.sln" -ErrorAction SilentlyContinue) -or
        (Get-ChildItem -Path $dir -Filter "*.fsproj" -ErrorAction SilentlyContinue)) {
        $techStack += "dotnet"
    }

    if (Test-Path "$dir/package.json") {
        $content = Get-Content "$dir/package.json" -Raw -ErrorAction SilentlyContinue
        if ($content -match '"typescript"') {
            $techStack += "typescript"
        } else {
            $techStack += "javascript"
        }
    }

    if ((Get-ChildItem -Path $dir -Filter "*.tf" -ErrorAction SilentlyContinue) -or
        (Test-Path "$dir/terraform" -PathType Container)) {
        $techStack += "terraform"
    }

    if (Test-Path "$dir/go.mod") { $techStack += "go" }
    if (Test-Path "$dir/Cargo.toml") { $techStack += "rust" }

    if ((Test-Path "$dir/docker-compose.yml") -or
        (Test-Path "$dir/docker-compose.yaml") -or
        (Test-Path "$dir/Dockerfile")) {
        $techStack += "docker"
    }

    if (Test-Path "$dir/azure-pipelines.yml") { $techStack += "azure" }

    if ((Test-Path "$dir/requirements.txt") -or
        (Test-Path "$dir/pyproject.toml") -or
        (Get-ChildItem -Path $dir -Filter "*.py" -ErrorAction SilentlyContinue)) {
        $techStack += "python"
    }
}

$uniqueTech = ($techStack | Sort-Object -Unique) -join ","
if (-not $uniqueTech) { $uniqueTech = "none" }
Write-Output "TECH_STACK=$uniqueTech"
