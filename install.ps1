# JSXBIN to JSX Converter: Windows Install Script
# Sets up the environment and adds binaries to PATH

$InstallDir = "C:\utsav-56\jsbin-conv"

# Check for Admin rights
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "This script requires Administrator privileges to update the PATH and copy files to C:\."
    Write-Host "Please restart your terminal with Administrator privileges and try again."
    pause
    exit 1
}

# Create installation directory if it doesn't exist
if (-not (Test-Path $InstallDir)) {
    New-Item -Path $InstallDir -ItemType Directory -Force
}

Write-Host "Installing to $InstallDir..."

# Copy binaries to the installation directory
if ((Test-Path "jsbin-conv.exe") -and (Test-Path "Jsbeautify.exe")) {
    Copy-Item "jsbin-conv.exe" -Destination "$InstallDir\" -Force
    Copy-Item "Jsbeautify.exe" -Destination "$InstallDir\" -Force
} else {
    Write-Error "Error: Binaries (jsbin-conv.exe and Jsbeautify.exe) not found in the current directory."
    pause
    exit 1
}

# Add to the USER level PATH environment variable
$oldPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($oldPath -notlike "*$InstallDir*") {
    $newPath = "$oldPath;$InstallDir"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "Added $InstallDir to User PATH environment variable."
} else {
    Write-Host "Path already exists in the User environment variables."
}

Write-Host "Installation complete! Please restart your terminal."
pause
