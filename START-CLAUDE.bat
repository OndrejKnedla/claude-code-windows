@echo off
REM ===========================================================================
REM  Start Claude Code
REM  Double-click to launch Claude in this folder.
REM
REM  Want Claude to stop asking for permission on every action?
REM  Use START-CLAUDE-YOLO.bat instead (it adds --dangerously-skip-permissions).
REM ===========================================================================

where claude >nul 2>&1
if %errorlevel% neq 0 (
    echo Claude is not on PATH in this window.
    echo Close this window, open a NEW one, and try again - or run INSTALL.bat first.
    pause
    exit /b
)

claude
