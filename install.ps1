<#
.SYNOPSIS
    Claude Code - one-command installer for Windows 10 / 11.

.DESCRIPTION
    Installs Claude Code the reliable way and fixes every common Windows pitfall
    in one shot:
      * Installs Claude Code via the official native installer (no Node.js needed)
      * Installs Git for Windows (Claude Code needs bash.exe) if missing
      * Repairs PATH inside the current session (no terminal restart required)
      * Fixes the PowerShell ExecutionPolicy block (the "scripts are disabled" error)
      * Falls back to npm + Node.js automatically if the native installer fails
      * Verifies the install actually works, and retries a broken install once

    One-line install (paste into PowerShell):
      irm https://raw.githubusercontent.com/OndrejKnedla/claude-code-windows/main/install.ps1 | iex

.PARAMETER Beginner
    Also creates a big "CLAUDE" icon on the Desktop so non-technical users can
    just double-click instead of using a terminal.

.PARAMETER NoGit
    Skip the Git for Windows step.

.PARAMETER NoLaunch
    Do not launch `claude` at the end.

.PARAMETER SkipPermissions
    Launch Claude with --dangerously-skip-permissions so it never stops to ask
    for permission. Convenient for non-technical users, but it lets Claude run
    commands and edit files without confirmation - only use it in a folder /
    account you trust. Also wires this mode into the Desktop icon (-Beginner).
#>
[CmdletBinding()]
param(
    [switch]$Beginner,
    [switch]$NoGit,
    [switch]$NoLaunch,
    [switch]$SkipPermissions
)

$ErrorActionPreference = 'Stop'
$ProgressPreference    = 'SilentlyContinue'   # much faster Invoke-WebRequest

# Force TLS 1.2 so downloads work on older Windows 10 builds whose PowerShell
# 5.1 still defaults to TLS 1.0/1.1 (GitHub/claude.ai reject those).
try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 } catch {}

# ---------------------------------------------------------------------------
#  Pretty output helpers
# ---------------------------------------------------------------------------
function Info($m) { Write-Host "  [*]  $m" -ForegroundColor Cyan }
function Ok($m)   { Write-Host "  [OK] $m" -ForegroundColor Green }
function Warn($m) { Write-Host "  [!]  $m" -ForegroundColor Yellow }
function Fail($m) { Write-Host "  [X]  $m" -ForegroundColor Red }
function Step($m) {
    Write-Host ""
    Write-Host "  -- $m " -ForegroundColor White -NoNewline
    Write-Host ("-" * [Math]::Max(0, 58 - $m.Length)) -ForegroundColor DarkGray
}

function Show-Banner {
    Write-Host ""
    Write-Host "  ===============================================================" -ForegroundColor Magenta
    Write-Host "       Claude Code  -  Windows 1-Click Installer  by OK" -ForegroundColor Magenta
    Write-Host "        github.com/OndrejKnedla/claude-code-windows" -ForegroundColor DarkGray
    Write-Host "  ===============================================================" -ForegroundColor Magenta
}

# ---------------------------------------------------------------------------
#  Core utilities
# ---------------------------------------------------------------------------

# Reload PATH (and a few other vars) from the registry into THIS session.
# This is the single most common reason "node/npm/claude not recognized"
# keeps happening right after an install: the open window never sees the
# updated PATH until it is refreshed.
function Update-SessionPath {
    $machine = [System.Environment]::GetEnvironmentVariable('Path', 'Machine')
    $user    = [System.Environment]::GetEnvironmentVariable('Path', 'User')
    $extra   = @(
        (Join-Path $env:USERPROFILE '.local\bin'),
        (Join-Path $env:LOCALAPPDATA 'Programs\claude'),
        (Join-Path $env:APPDATA 'npm'),
        'C:\Program Files\nodejs',
        'C:\Program Files\Git\cmd'
    ) -join ';'
    $env:Path = (@($machine, $user, $extra) | Where-Object { $_ } ) -join ';'
}

function Test-Cmd($name) {
    [bool](Get-Command $name -ErrorAction SilentlyContinue)
}

# Permanently add a directory to the USER PATH (registry), so NEW terminal
# windows can find the command. The native Claude installer doesn't always
# persist this reliably, which is why `claude` works during install but a
# fresh PowerShell then says "claude is not recognized".
function Add-ToUserPath($dir) {
    if (-not $dir -or -not (Test-Path $dir)) { return }
    $userPath = [System.Environment]::GetEnvironmentVariable('Path', 'User')
    $parts = @($userPath -split ';' | Where-Object { $_ })
    if ($parts -notcontains $dir) {
        $newPath = (($parts + $dir) -join ';')
        [System.Environment]::SetEnvironmentVariable('Path', $newPath, 'User')
        Ok "Added to PATH permanently: $dir"
    } else {
        Ok "Already on PATH: $dir"
    }
    if (($env:Path -split ';') -notcontains $dir) { $env:Path = "$env:Path;$dir" }
}

# Find the claude executable even if it is not yet on PATH.
function Get-ClaudePath {
    $cmd = (Get-Command claude -ErrorAction SilentlyContinue | Select-Object -First 1).Source
    if ($cmd) { return $cmd }
    $candidates = @(
        (Join-Path $env:USERPROFILE '.local\bin\claude.exe'),
        (Join-Path $env:LOCALAPPDATA 'Programs\claude\claude.exe'),
        (Join-Path $env:LOCALAPPDATA 'Anthropic\claude\claude.exe')
    )
    foreach ($c in $candidates) { if (Test-Path $c) { return $c } }
    return $null
}

# Does `claude` actually run? (Catches the "broken install / missing exe" case.)
function Test-ClaudeWorks {
    Update-SessionPath
    $exe = Get-ClaudePath
    if (-not $exe) { return $false }
    try {
        & $exe --version *> $null
        return ($LASTEXITCODE -eq 0)
    } catch { return $false }
}

# ---------------------------------------------------------------------------
#  Fix 1: ExecutionPolicy
#  The "claude.ps1 cannot be loaded because running scripts is disabled"
#  error. Allow locally-created scripts for the current user (safe).
# ---------------------------------------------------------------------------
function Repair-ExecutionPolicy {
    try {
        $p = Get-ExecutionPolicy -Scope CurrentUser
        if ($p -in @('Restricted', 'AllSigned', 'Undefined')) {
            Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
            Ok "ExecutionPolicy set to RemoteSigned (CurrentUser)."
        } else {
            Ok "ExecutionPolicy already permits local scripts ($p)."
        }
    } catch {
        Warn "Could not change ExecutionPolicy: $($_.Exception.Message)"
    }
}

# Download a file with a few retries (networks on fresh PCs can be flaky).
function Get-FileWithRetry($url, $outFile, $tries = 3) {
    for ($i = 1; $i -le $tries; $i++) {
        try {
            Invoke-WebRequest -Uri $url -OutFile $outFile -UseBasicParsing -TimeoutSec 300
            if ((Test-Path $outFile) -and (Get-Item $outFile).Length -gt 0) { return $true }
        } catch {
            Warn "Download attempt $i/$tries failed: $($_.Exception.Message)"
            Start-Sleep -Seconds 2
        }
    }
    return $false
}

# Resolve the REAL latest Git-for-Windows installer URL from the GitHub API.
# (The fixed name 'Git-64-bit.exe' does not exist - assets are versioned,
#  e.g. 'Git-2.54.0-64-bit.exe'.)
function Get-GitDownloadUrl {
    $arch = if ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64') { 'arm64' } else { '64-bit' }
    $rel  = Invoke-RestMethod -Uri 'https://api.github.com/repos/git-for-windows/git/releases/latest' `
                -UseBasicParsing -Headers @{ 'User-Agent' = 'claude-code-windows-installer' }
    $asset = $rel.assets | Where-Object { $_.name -match "^Git-.*-$arch\.exe$" } | Select-Object -First 1
    if ($asset) { return $asset.browser_download_url }
    return $null
}

# ---------------------------------------------------------------------------
#  Fix 2: Git for Windows (Claude Code needs bash.exe). Best-effort: a failure
#  here must NOT abort the whole install - Claude Code is the priority.
# ---------------------------------------------------------------------------
function Install-Git {
    if (Test-Cmd 'git') { Ok "Git already installed: $(git --version)"; return }

    Info "Installing Git for Windows ..."
    if (Test-Cmd 'winget') {
        winget install --id Git.Git -e --source winget `
            --accept-source-agreements --accept-package-agreements --silent
    } else {
        Info "winget not available - fetching the latest Git installer ..."
        $url = Get-GitDownloadUrl
        if (-not $url) { throw "Could not determine the Git download URL from GitHub." }
        $exe = Join-Path $env:TEMP 'git-for-windows-setup.exe'
        Info "Downloading $url"
        if (-not (Get-FileWithRetry $url $exe)) { throw "Failed to download Git after several attempts." }
        Start-Process -FilePath $exe -ArgumentList '/VERYSILENT', '/NORESTART', '/NOCANCEL', '/SP-' -Wait
        Remove-Item $exe -ErrorAction SilentlyContinue
    }
    Update-SessionPath
    if (Test-Cmd 'git') { Ok "Git installed: $(git --version)" }
    else { Warn "Git installed but not on PATH yet - it will appear in a new terminal." }
}

# ---------------------------------------------------------------------------
#  Fix 3a: Claude Code via the official NATIVE installer (preferred)
#  No Node.js, no npm shim, no ExecutionPolicy problems with a .ps1 wrapper.
# ---------------------------------------------------------------------------
function Install-ClaudeNative {
    Info "Running the official native installer (claude.ai/install.ps1) ..."
    try {
        $script = Invoke-RestMethod -Uri 'https://claude.ai/install.ps1' -UseBasicParsing
        # Run it in a SEPARATE PowerShell process. The official installer calls
        # `exit` on failure; isolating it means that exit can't kill THIS script
        # (and our npm fallback) when we are launched via `irm | iex`.
        $tmp = Join-Path $env:TEMP 'claude-native-install.ps1'
        Set-Content -Path $tmp -Value $script -Encoding UTF8
        & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $tmp
        Remove-Item $tmp -ErrorAction SilentlyContinue
    } catch {
        Warn "Native installer failed: $($_.Exception.Message)"
        return $false
    }
    if (Test-ClaudeWorks) { Ok "Claude Code installed (native)."; return $true }
    Warn "Native installer ran but 'claude' is not working yet."
    return $false
}

# ---------------------------------------------------------------------------
#  Fix 3b: Fallback - Node.js + npm package (with all the PATH/policy repairs)
# ---------------------------------------------------------------------------
function Install-NodeIfNeeded {
    Update-SessionPath
    if (Test-Cmd 'npm') { Ok "Node.js / npm present: node $(node --version)"; return }

    Info "Installing Node.js LTS ..."
    if (Test-Cmd 'winget') {
        winget install --id OpenJS.NodeJS.LTS -e --source winget `
            --accept-source-agreements --accept-package-agreements --silent
    } else {
        # Resolve the current LTS MSI dynamically so it never goes stale.
        $nodeArch = if ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64') { 'arm64' } else { 'x64' }
        $url = "https://nodejs.org/dist/v22.11.0/node-v22.11.0-$nodeArch.msi"
        try {
            $idx = Invoke-RestMethod -Uri 'https://nodejs.org/dist/index.json' -UseBasicParsing
            $lts = $idx | Where-Object { $_.lts } | Select-Object -First 1
            if ($lts) { $url = "https://nodejs.org/dist/$($lts.version)/node-$($lts.version)-$nodeArch.msi" }
        } catch { Warn "Could not query nodejs.org index; using a known LTS." }
        $msi = Join-Path $env:TEMP 'node-lts.msi'
        Info "Downloading $url"
        if (-not (Get-FileWithRetry $url $msi)) { throw "Failed to download Node.js after several attempts." }
        Start-Process msiexec.exe -ArgumentList "/i `"$msi`" /qn /norestart" -Wait
        Remove-Item $msi -ErrorAction SilentlyContinue
    }
    Update-SessionPath
    if (Test-Cmd 'npm') { Ok "Node.js installed: node $(node --version)" }
    else { throw "npm still not found after installing Node.js. Open a new terminal and re-run." }
}

function Install-ClaudeNpm {
    Install-NodeIfNeeded
    Info "Installing @anthropic-ai/claude-code via npm ..."
    # Clean install to avoid the "claude.exe is not recognized" broken-package case.
    npm uninstall -g @anthropic-ai/claude-code 2>$null | Out-Null
    npm cache clean --force 2>$null | Out-Null
    npm install -g @anthropic-ai/claude-code
    Update-SessionPath
    if (Test-ClaudeWorks) { Ok "Claude Code installed (npm)."; return $true }
    Warn "npm install finished but 'claude' is not working yet."
    return $false
}

# ---------------------------------------------------------------------------
#  Optional: big Desktop icon for absolute beginners (-Beginner)
# ---------------------------------------------------------------------------
function New-DesktopIcon {
    Info "Creating a 'CLAUDE' icon on the Desktop ..."
    try {
        Update-SessionPath
        $claude  = Get-ClaudePath
        $desktop = [Environment]::GetFolderPath('Desktop')

        # Launch Claude inside a project folder if one is present, so it picks
        # up CLAUDE.md automatically. Adjust the folder name to your setup.
        $workDir = Join-Path $desktop 'Cowork-Vincent-Kavarna'
        if (-not (Test-Path $workDir)) { $workDir = $env:USERPROFILE }

        $inner = if ($SkipPermissions) { 'claude --dangerously-skip-permissions' } else { 'claude' }

        $lnk      = Join-Path $desktop 'CLAUDE.lnk'
        $shell    = New-Object -ComObject WScript.Shell
        $shortcut = $shell.CreateShortcut($lnk)
        $shortcut.TargetPath       = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"
        $shortcut.Arguments        = "-NoExit -NoProfile -ExecutionPolicy Bypass -Command `"Set-Location -LiteralPath '$workDir'; $inner`""
        $shortcut.WorkingDirectory = $workDir
        $shortcut.Description       = 'Start Claude Code'
        $shortcut.WindowStyle       = 1
        if ($claude) { $shortcut.IconLocation = "$claude,0" }
        $shortcut.Save()
        Ok "Desktop icon 'CLAUDE' created (double-click to start)."
    } catch {
        Warn "Could not create the Desktop icon: $($_.Exception.Message)"
    }
}

# ===========================================================================
#  MAIN
# ===========================================================================
Show-Banner

$os = [System.Environment]::OSVersion.Version
Info "Windows $($os.Major) (build $($os.Build))  |  PowerShell $($PSVersionTable.PSVersion)"

if (Test-Cmd 'winget') { Ok "winget detected - using it for system packages." }
else { Warn "winget not found (older Windows) - will download installers directly." }

Step "Step 1 / 4  -  Fix PowerShell script policy"
Repair-ExecutionPolicy

Step "Step 2 / 4  -  Git for Windows"
if ($NoGit) {
    Warn "Skipped (-NoGit)."
} else {
    # Best-effort: never let a Git problem abort the Claude install.
    try { Install-Git }
    catch {
        Warn "Git step failed: $($_.Exception.Message)"
        Warn "Continuing without Git. You can install it later from https://git-scm.com/downloads/win"
    }
}

Step "Step 3 / 4  -  Claude Code"
$done = Install-ClaudeNative
if (-not $done) {
    Warn "Falling back to the Node.js + npm method ..."
    $done = Install-ClaudeNpm
}
# One automatic repair pass if it is still broken.
if (-not $done -and (Test-Cmd 'npm')) {
    Warn "Attempting one clean reinstall ..."
    $done = Install-ClaudeNpm
}

Step "Step 4 / 4  -  Verify"
Update-SessionPath
$exe = Get-ClaudePath
if (Test-ClaudeWorks) {
    Ok "Claude Code is working:  $(& $exe --version 2>$null)"
    Ok "Location: $exe"
    # Persist claude's folder to the USER PATH so a NEW window finds `claude`.
    Add-ToUserPath (Split-Path -Parent $exe)
} else {
    Fail "Claude Code is installed but not verified in this window."
    Warn "Close this window, open a NEW PowerShell, and run:  claude"
}

if ($Beginner) {
    Step "Extra  -  Beginner Desktop icon"
    New-DesktopIcon
}

# ---------------------------------------------------------------------------
#  Done
# ---------------------------------------------------------------------------
Write-Host ""
Write-Host "  ===============================================================" -ForegroundColor Green
Write-Host "                       Installation complete" -ForegroundColor Green
Write-Host "  ===============================================================" -ForegroundColor Green
Write-Host ""
$startCmd = if ($SkipPermissions) { 'claude --dangerously-skip-permissions' } else { 'claude' }

Write-Host "  Next steps:" -ForegroundColor White
Write-Host "    1) Open a NEW PowerShell window (so PATH is fresh)."
Write-Host "    2) Type:  $startCmd"
Write-Host "    3) On first run it opens a browser to log in to your Claude account."
Write-Host "       Paste the authorization code back into the terminal and press Enter."
Write-Host ""
if ($SkipPermissions) {
    Write-Host "  Note: --dangerously-skip-permissions lets Claude run commands and edit" -ForegroundColor Yellow
    Write-Host "  files WITHOUT asking. Only use it in a folder/account you trust." -ForegroundColor Yellow
    Write-Host ""
}
Write-Host "  If login shows 'Claude will return soon', that is a temporary" -ForegroundColor DarkGray
Write-Host "  Anthropic service blip - wait a minute and run 'claude' again." -ForegroundColor DarkGray
Write-Host ""

if (-not $NoLaunch -and (Test-ClaudeWorks)) {
    Write-Host "  Launching Claude Code now ..." -ForegroundColor Cyan
    Write-Host ""
    try {
        if ($SkipPermissions) { & (Get-ClaudePath) --dangerously-skip-permissions }
        else { & (Get-ClaudePath) }
    } catch { Warn "Could not auto-launch. Open a new terminal and run: $startCmd" }
}
