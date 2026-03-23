# JSXBIN to JSX Converter: Windows Build Script
# This compiles the Dart core and the Bun-based beautifier into a minimal bundle.

$TempDir = "__temp_compile_build"
$ReleaseDir = "release"
$Platform = "windows"

# Clean old artifacts
Write-Host "Cleaning old build files..." -ForegroundColor Cyan
if (Test-Path $TempDir) { Remove-Item -Path $TempDir -Recurse -Force }
if (Test-Path $ReleaseDir) { Remove-Item -Path $ReleaseDir -Recurse -Force }
New-Item -Path $TempDir -ItemType Directory
New-Item -Path $ReleaseDir -ItemType Directory

# 1. Compile Dart (with obfuscation and stripped symbols)
Write-Host "Compiling Dart core engine..." -ForegroundColor Cyan
Set-Location jsbin-conv
dart pub get
# -S removes debugging information from the output
dart compile exe bin/jsbin_conv.dart -o "..\$TempDir\jsbin-conv.exe" -S "..\$TempDir\debug_info"
Set-Location ..

# 2. Compile Bun (minified and bytecode cached)
Write-Host "Compiling Bun beautification engine..." -ForegroundColor Cyan
Set-Location js-beautify
bun install
bun build ./index.ts --compile --minify --bytecode --outfile "..\$TempDir\Jsbeautify.exe"
Set-Location ..

# 3. Copy Installation Scripts
Write-Host "Bundling installation scripts..." -ForegroundColor Cyan
Copy-Item "install_scripts\install.ps1" -Destination "$TempDir\"

# 4. Create ZIP Bundle
Write-Host "Creating the bundle repository..." -ForegroundColor Cyan
$ZipName = "jsbin-conv-$Platform-bundle.zip"
if (Get-Command Compress-Archive -ErrorAction SilentlyContinue) {
    # Re-zip for a clean archive
    Compress-Archive -Path "$TempDir\*" -DestinationPath "$ReleaseDir\$ZipName"
} else {
    Write-Warning "PowerShell 'Compress-Archive' is not available. Please manually archive: $TempDir"
}

Write-Host "`nBuild Procedure Completed." -ForegroundColor Green
Write-Host "Artifact generated at: $ReleaseDir\$ZipName" -ForegroundColor White
