$ErrorActionPreference = "Stop"

$os = "windows"
$shellType = "powershell"

if ($IsLinux) {
    $os = "linux"
    $shellType = "bash"
} elseif ($IsMacOS) {
    $os = "darwin"
    $shellType = "bash"
}

Write-Output "SHELL_TYPE=$shellType OS=$os"
