@echo off
REM ===========================================================================
REM  SPUSTIT CLAUDE (pro zacatecnice - bez ptani na povoleni)
REM  Dvojklik = spusti Claude. Claude se uz na nic neptá, jen pis a dej Enter.
REM  Pouziva --dangerously-skip-permissions, takze zadne potvrzovani.
REM ===========================================================================

where claude >nul 2>&1
if %errorlevel% neq 0 (
    echo Claude zatim neni nainstalovany v tomto okne.
    echo Zavri okno, otevri nove, nebo nejdriv spust INSTALUJ.bat.
    pause
    exit /b
)

claude --dangerously-skip-permissions
