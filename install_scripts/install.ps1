# JSXBIN to JSX Converter: Windows Installer (PowerShell)
# Handles tool checks, custom command naming, and PATH configuration.

$InstallDir = "C:\utsav-56\jsbin-conv"

# 1. Administrator check (just in case directly invoked)
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "This script requires Administrator privileges to update the PATH and copy files to C:\."
    Write-Host "Please restart your terminal with Administrator privileges or run 'install.bat'."
    pause
    exit 1
}

# 2. Handle Installation Mode (Keep Source vs Move)
Write-Host "`nDo you want to keep the original source files after installation?" -ForegroundColor Green
$KeepFiles = Read-Host "[Y]es / [N]o (Default is No)"
if ([string]::IsNullOrWhiteSpace($KeepFiles)) { $KeepFiles = "N" }

# Warning for moving
if ($KeepFiles -match "^n") {
    Write-Host "Warning: Your files will be moved to $InstallDir. This won't affect your usage and is recommended to keep your directories clean." -ForegroundColor Cyan
}

# 3. Handle Custom Command Name
$CommandName = Read-Host "`nWhat would you like the command to be called? (Default is 'jsxbin-conv')"
if ([string]::IsNullOrWhiteSpace($CommandName)) { $CommandName = "jsxbin-conv" }
$FinalExe = "$CommandName.exe"

# 4. Execute Installation
if (-not (Test-Path $InstallDir)) {
    New-Item -Path $InstallDir -ItemType Directory -Force
}

Write-Host "`nStarting installation to $InstallDir..." -ForegroundColor Cyan

# Source files check
if (-not (Test-Path "jsbin-conv.exe") -or -not (Test-Path "jsxbin-conv-makeup-man.exe")) {
    Write-Error "Required binaries (jsbin-conv.exe, jsxbin-conv-makeup-man.exe) not found in the current folder."
    pause
    exit 1
}

# Copy or Move
if ($KeepFiles -match "^y") {
    Copy-Item "jsbin-conv.exe" -Destination "$InstallDir\$FinalExe" -Force
    Copy-Item "jsxbin-conv-makeup-man.exe" -Destination "$InstallDir\jsxbin-conv-makeup-man.exe" -Force
} else {
    Move-Item "jsbin-conv.exe" -Destination "$InstallDir\$FinalExe" -Force
    Move-Item "jsxbin-conv-makeup-man.exe" -Destination "$InstallDir\jsxbin-conv-makeup-man.exe" -Force
}

# 6. Set PATH Environment Variable
$oldPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($oldPath -notlike "*$InstallDir*") {
    $newPath = "$oldPath;$InstallDir"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "Successfully added $InstallDir to your PATH." -ForegroundColor Green
} else {
    Write-Host "Path already exists." -ForegroundColor Gray
}

Write-Host "`nInstallation Successful!" -ForegroundColor Green
Write-Host "IMPORTANT: Please restart your CMD, PowerShell, or Terminal, else you won't be able to use the '$CommandName' command." -ForegroundColor Yellow
pause
