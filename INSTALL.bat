@echo off
REM ===========================================================================
REM  Claude Code - one-click installer launcher
REM  Double-click this file. It asks for Administrator rights and then runs
REM  install.ps1, which installs Claude Code + Git and fixes Windows PATH /
REM  ExecutionPolicy issues automatically.
REM ===========================================================================

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting Administrator rights...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

echo Installing Claude Code...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1"

pause
