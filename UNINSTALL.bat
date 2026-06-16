@echo off
REM ===========================================================================
REM  Uninstall Claude Code
REM  Double-click to remove Claude Code, the Desktop icon, and the PATH entry.
REM  Your login/settings in ~/.claude are kept (reinstall won't ask you to log
REM  in again). To wipe those too, run: powershell -File uninstall.ps1 -Purge
REM ===========================================================================

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0uninstall.ps1"

pause
