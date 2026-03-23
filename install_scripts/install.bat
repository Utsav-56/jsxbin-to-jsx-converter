@echo off
:: JSXBIN to JSX Converter: Windows Elevation Wrapper
:: This script ensures the installer runs with Administrator privileges.

SET "SCRIPT_PATH=%~dp0install.ps1"

:: Check for Administrator privileges
NET SESSION >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    echo [INFO] Running with Administrator privileges.
    powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_PATH%"
) ELSE (
    echo [INFO] Requesting Administrator elevation...
    powershell -Command "Start-Process cmd -ArgumentList '/c ""%~f0""' -Verb RunAs"
)
