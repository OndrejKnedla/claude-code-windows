@echo off
REM ===========================================================================
REM  Start Claude Code WITHOUT permission prompts
REM  (--dangerously-skip-permissions)
REM
REM  WARNING: In this mode Claude can run commands and edit files WITHOUT
REM  asking you first. Only use it in a folder / account you trust.
REM  Great for non-technical users who only write text; risky in a code repo.
REM ===========================================================================

where claude >nul 2>&1
if %errorlevel% neq 0 (
    echo Claude is not on PATH in this window.
    echo Close this window, open a NEW one, and try again - or run INSTALL.bat first.
    pause
    exit /b
)

claude --dangerously-skip-permissions
