@echo off
REM ===========================================================================
REM  Claude Code - instalator pro uplne zacatecniky (verze pro Vincent Cowork)
REM  Dvakrat klikni na tento soubor. Sam si vyzada prava administratora,
REM  spusti instalator a navic vytvori na PLOSE velkou ikonu "CLAUDE".
REM  Ikona spousti Claude bez ptani na povoleni (--dangerously-skip-permissions),
REM  aby zacatecnice nemusely nic potvrzovat - jen pisou.
REM ===========================================================================

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Zadam o prava administratora...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

echo Spoustim instalator Claude Code...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0..\install.ps1" -Beginner -SkipPermissions

pause
