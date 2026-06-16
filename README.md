<h1 align="center">
  <a href="https://github.com/OndrejKnedla/claude-code-windows">
    <img alt="Claude Code Windows 1-Click Installer" width="800" src="https://raw.githubusercontent.com/OndrejKnedla/claude-code-windows/main/assets/banner.svg">
  </a>
  <br>
  <small>Install <a href="https://claude.com/claude-code">Claude Code</a> on Windows in one line, no Node.js, no PATH headaches</small>
</h1>

<p align="center">
  <a href="https://github.com/OndrejKnedla/claude-code-windows/actions/workflows/test.yml"><img alt="CI" src="https://github.com/OndrejKnedla/claude-code-windows/actions/workflows/test.yml/badge.svg"></a>
  <img alt="Windows 10 | 11" src="https://img.shields.io/badge/Windows-10%20%7C%2011-0078D6?logo=windows&logoColor=white">
  <img alt="PowerShell 5.1+" src="https://img.shields.io/badge/PowerShell-5.1%2B-5391FE?logo=powershell&logoColor=white">
  <img alt="No Node.js required" src="https://img.shields.io/badge/Node.js-not%20required-success">
  <a href="LICENSE"><img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-green.svg"></a>
</p>

<p align="center">
  <b>English</b> &nbsp;·&nbsp; <a href="README.cs.md">Čeština</a> &nbsp;·&nbsp; <a href="README.zh.md">中文</a>
</p>

<p align="center">
  <a href="#-install-one-line"><b>Install</b></a> &nbsp;·&nbsp;
  <a href="#-every-windows-gotcha-it-fixes">What it fixes</a> &nbsp;·&nbsp;
  <a href="#-how-to-start-claude-code">Start Claude</a> &nbsp;·&nbsp;
  <a href="#-beginner-mode-for-non-technical-users">Beginner mode</a> &nbsp;·&nbsp;
  <a href="#-uninstall">Uninstall</a> &nbsp;·&nbsp;
  <a href="#-troubleshooting">Troubleshooting</a>
</p>

<p align="center">
  <img alt="Demo: installing Claude Code from one PowerShell line" width="720" src="https://raw.githubusercontent.com/OndrejKnedla/claude-code-windows/main/assets/demo.svg">
</p>

---

## 🚀 Install (one line)

**1. Open PowerShell as Administrator.** Press the **Windows key**, type `powershell`, then on **Windows PowerShell** click **Run as administrator** and confirm with **Yes**. (Admin lets it install Git cleanly without surprise prompts.)

**2. Paste this and press Enter:**

```powershell
irm https://raw.githubusercontent.com/OndrejKnedla/claude-code-windows/main/install.ps1 | iex
```

That's it. The script installs Claude Code, installs Git for Windows if needed, fixes your PATH and PowerShell policy, verifies everything, and launches `claude`.

> **Tip:** to open an admin PowerShell even faster, **right-click the Start button** and choose **Terminal (Admin)** or **Windows PowerShell (Admin)**.

> **Prefer clicking?** [Download the ZIP](https://github.com/OndrejKnedla/claude-code-windows/archive/refs/heads/main.zip), unzip it, and double-click **`INSTALL.bat`**. It will ask for Administrator rights and do the rest.

---

## 🩹 Every Windows gotcha it fixes

If you've tried installing Claude Code on Windows by hand, you've probably hit some of these. This installer handles all of them automatically:

| The error you saw | Why it happens | What this installer does |
|---|---|---|
| `claude : The term 'claude' is not recognized` | Claude Code isn't installed (or not on PATH) | Installs it the official way and refreshes PATH in-session |
| `npm : The term 'npm' is not recognized` | Node.js isn't installed | Uses the **native** installer, so Node.js isn't even required |
| `node : The term 'node' is not recognized` *(right after installing Node)* | The open terminal never reloaded PATH | Reloads PATH from the registry inside the current window |
| `claude.ps1 cannot be loaded because running scripts is disabled` | PowerShell `ExecutionPolicy` is `Restricted` | Sets `RemoteSigned` for your user (safe) |
| `claude.exe ... is not recognized` *(after npm install)* | A partial / broken npm package | Detects it and does one clean reinstall |
| `Claude Code on Windows requires Git for Windows / PowerShell` | `bash.exe` is missing | Installs Git for Windows automatically |
| `Claude will return soon` *(at login)* | Temporary Anthropic outage, not your install | Tells you to simply retry in a minute |

---

## ✨ Features

- **One command, zero config.** Paste and go.
- **No Node.js required.** Uses Anthropic's official native installer; falls back to Node.js + npm automatically only if needed.
- **Self-healing.** Refreshes PATH in the live session, fixes ExecutionPolicy, and repairs a broken install on the spot.
- **Installs Git for Windows** (Claude Code needs `bash.exe`) if you don't already have it.
- **Verifies the result** by actually running `claude --version` before claiming success.
- **Beginner mode** (`-Beginner`) puts a big **CLAUDE** icon on the Desktop so non-technical users can just double-click.

---

## ▶️ How to start Claude Code

After installing, **open a new PowerShell window** (so PATH is fresh) and type:

```powershell
claude
```

The first time, it opens a browser to log in to your Claude account. Paste the authorization code back into the terminal and press Enter. After that, just type what you want and press **Enter**. To quit, type `/exit` or press `Ctrl + C` twice.

**Don't want to use a terminal?** Double-click **`START-CLAUDE.bat`** in the repo folder.

### 💻 Terminal basics (if you've never used one)

The black/white window is a *terminal*. It's simple: you **type** and press **Enter**, Claude answers. A few things that help:

- **Enter** sends your message. **Backspace** deletes. **Up arrow** brings back what you typed before.
- **Quit / close:** press **`Ctrl + C`** (twice if nothing happens), or type `/exit`. You can also just close the window with the X. You can't break anything.
- **Copy:** select text with the mouse, then **`Ctrl + C`** (sometimes **right-click** copies too).
- **Paste:** **`Ctrl + V`**, or **right-click** inside the window.
- **Add a photo:** drag the image file straight from a folder **into the window** and drop it. Its path appears, press Enter, then ask e.g. *"describe this photo"*. Claude can see images.
- **Add a link:** copy the URL (`Ctrl + C`) and paste it (`Ctrl + V`), then say what to do with it.

> A printable Czech version of all this is in [`beginner-pack/JAK_FUNGUJE_TERMINAL.txt`](beginner-pack/JAK_FUNGUJE_TERMINAL.txt).

### ⚡ Skip the permission prompts (`--dangerously-skip-permissions`)

By default Claude asks before it runs a command or edits a file. To turn that off and let it work without interruptions:

```powershell
claude --dangerously-skip-permissions
```

…or double-click **`START-CLAUDE-YOLO.bat`**. During install you can bake this in with the **`-SkipPermissions`** flag (it also makes the beginner Desktop icon launch this way):

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/OndrejKnedla/claude-code-windows/main/install.ps1))) -Beginner -SkipPermissions
```

> ⚠️ **What "dangerously" means:** in this mode Claude can run commands and change files **without asking you first**. It's perfect for non-technical users who only write text (emails, social posts), but risky inside a real code project. Only use it in a folder and account you trust.

---

## 🖱️ Beginner mode (for non-technical users)

Setting up Claude Code for someone who has never used a terminal? Run:

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/OndrejKnedla/claude-code-windows/main/install.ps1))) -Beginner
```

…or use the ready-made Czech pack in [`beginner-pack/`](beginner-pack/):

- **`INSTALUJ.bat`**: double-click installer that also creates the Desktop icon
- **`TAHAK_pro_tisk.txt`**: a printable one-page cheat sheet ("double-click → type → Enter")
- **`JAK_FUNGUJE_TERMINAL.txt`**: printable guide to the terminal itself (Ctrl+C to quit, copy/paste, dragging in photos and links)
- **`README.txt`**: plain-language setup notes in Czech

After install, the user just double-clicks the **CLAUDE** icon, types a sentence, and presses Enter.

---

## ⚙️ Options

Run any of these by adding the flag after the script:

| Flag | What it does |
|---|---|
| `-Beginner` | Also create a **CLAUDE** Desktop shortcut for non-technical users |
| `-SkipPermissions` | Launch Claude with `--dangerously-skip-permissions` (no permission prompts); also applies to the Desktop icon |
| `-NoGit` | Skip the Git for Windows step |
| `-NoLaunch` | Don't auto-launch `claude` when finished |

From a downloaded copy:

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1 -Beginner
```

---

## 🔒 Is it safe?

Yes, and you should never run a script from the internet without checking it. This one is short and fully readable: **[`install.ps1`](install.ps1)**.

- It only installs official software: **Claude Code** (via `claude.ai/install.ps1`) and **Git for Windows** (via `winget` or the official release).
- It changes **one** setting: your user-scope PowerShell `ExecutionPolicy` → `RemoteSigned`, the value Microsoft recommends for everyday use.
- No telemetry, no background services, nothing hidden. Read it before you run it.

---

## ❓ Troubleshooting

**`claude` still not found after install?**
Close the window and open a **brand-new** PowerShell. PATH only refreshes in new windows.

**`irm ... | iex` blocked?**
Your policy is strict. Run this first, then retry:
```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned -Force
```

**Old Windows 10 without `winget`?**
No problem, the installer downloads Git and Node.js directly. You just need an internet connection.

**SmartScreen warns about `INSTALL.bat`?**
Click **More info → Run anyway**. (It's unsigned because it's a free open-source script.)

**Login says "Claude will return soon"?**
That's a temporary Anthropic service issue, not your install. Wait a minute and run `claude` again.

---

## 🗑️ Uninstall

```powershell
irm https://raw.githubusercontent.com/OndrejKnedla/claude-code-windows/main/uninstall.ps1 | iex
```

…or double-click **`UNINSTALL.bat`**. It removes the Claude Code binary, the Desktop icon, and the PATH entry, but keeps your login in `~/.claude` (add `-Purge` to remove that too). Git for Windows is left installed.

---

## 🤝 Contributing

Issues and PRs welcome, especially reports of Windows edge cases the installer doesn't cover yet. Paste the exact error text and your Windows / PowerShell version.

## 📄 License

[MIT](LICENSE). Do whatever you want, no warranty.

<div align="center">
<sub>Not affiliated with Anthropic. "Claude" and "Claude Code" are trademarks of Anthropic. This is an unofficial community installer.</sub>
</div>
