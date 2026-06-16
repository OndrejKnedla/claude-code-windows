<#
.SYNOPSIS
    Uninstall Claude Code (installed by this project) on Windows.

.DESCRIPTION
    Removes the Claude Code binary, the Desktop "CLAUDE" icon, and the PATH
    entry this installer added. By default it keeps your login/config in
    ~/.claude so you can reinstall without signing in again.

    One-line uninstall:
      irm https://raw.githubusercontent.com/OndrejKnedla/claude-code-windows/main/uninstall.ps1 | iex

.PARAMETER Purge
    Also delete ~/.claude (your settings AND login). You'll have to log in
    again after a future reinstall.
#>
[CmdletBinding()]
param([switch]$Purge)

$ErrorActionPreference = 'Continue'

function Info($m) { Write-Host "  [*]  $m" -ForegroundColor Cyan }
function Ok($m)   { Write-Host "  [OK] $m" -ForegroundColor Green }
function Warn($m) { Write-Host "  [!]  $m" -ForegroundColor Yellow }

Write-Host ""
Write-Host "  ===============================================================" -ForegroundColor Magenta
Write-Host "          Claude Code  -  Uninstaller  by OK" -ForegroundColor Magenta
Write-Host "  ===============================================================" -ForegroundColor Magenta
Write-Host ""

# Candidate install locations for the native binary.
$binDirs = @(
    (Join-Path $env:USERPROFILE '.local\bin'),
    (Join-Path $env:LOCALAPPDATA 'Programs\claude'),
    (Join-Path $env:LOCALAPPDATA 'Anthropic\claude')
)

# 1) Remove the claude.exe binary
$removed = $false
foreach ($d in $binDirs) {
    $exe = Join-Path $d 'claude.exe'
    if (Test-Path $exe) {
        try { Remove-Item -Force $exe; Ok "Removed $exe"; $removed = $true }
        catch { Warn "Could not remove $exe ($($_.Exception.Message)). Is Claude still running?" }
    }
    # Remove our PATH entry for this dir (only if the dir is now empty of claude)
    if (-not (Test-Path (Join-Path $d 'claude.exe'))) {
        $userPath = [System.Environment]::GetEnvironmentVariable('Path', 'User')
        $parts = @($userPath -split ';' | Where-Object { $_ -and $_ -ne $d })
        if (($userPath -split ';') -contains $d) {
            [System.Environment]::SetEnvironmentVariable('Path', ($parts -join ';'), 'User')
            Ok "Removed from PATH: $d"
        }
    }
}
if (-not $removed) { Warn "No claude.exe found in the usual locations (maybe already removed)." }

# 2) Remove the Desktop icon
$lnk = Join-Path ([System.Environment]::GetFolderPath('Desktop')) 'CLAUDE.lnk'
if (Test-Path $lnk) { Remove-Item -Force $lnk; Ok "Removed Desktop icon CLAUDE." }

# 3) Clean the downloads cache
$dl = Join-Path $env:USERPROFILE '.claude\downloads'
if (Test-Path $dl) { Remove-Item -Recurse -Force $dl -ErrorAction SilentlyContinue; Ok "Cleared download cache." }

# 4) Optionally purge settings + login
$cfg = Join-Path $env:USERPROFILE '.claude'
if ($Purge) {
    if (Test-Path $cfg) {
        Remove-Item -Recurse -Force $cfg -ErrorAction SilentlyContinue
        Ok "Purged ~/.claude (settings and login removed)."
    }
} else {
    if (Test-Path $cfg) { Info "Kept your settings/login in ~/.claude (use -Purge to remove them)." }
}

Write-Host ""
Write-Host "  ===============================================================" -ForegroundColor Green
Write-Host "          Claude Code uninstalled." -ForegroundColor Green
Write-Host "  ===============================================================" -ForegroundColor Green
Write-Host ""
Write-Host "  Note: Git for Windows was left installed (it's useful on its own)." -ForegroundColor DarkGray
Write-Host "  Open a NEW terminal for the PATH change to take effect." -ForegroundColor DarkGray
Write-Host ""
