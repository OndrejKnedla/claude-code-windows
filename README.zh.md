<h1 align="center">
  <a href="https://github.com/OndrejKnedla/claude-code-windows">
    <img alt="Claude Code Windows 1-Click Installer" width="800" src="https://raw.githubusercontent.com/OndrejKnedla/claude-code-windows/main/assets/banner.svg">
  </a>
  <br>
  <small>一行命令在 Windows 上安装 <a href="https://claude.com/claude-code">Claude Code</a>，无需 Node.js，无需折腾 PATH</small>
</h1>

<p align="center">
  <a href="https://github.com/OndrejKnedla/claude-code-windows/actions/workflows/test.yml"><img alt="CI" src="https://github.com/OndrejKnedla/claude-code-windows/actions/workflows/test.yml/badge.svg"></a>
  <img alt="Windows 10 | 11" src="https://img.shields.io/badge/Windows-10%20%7C%2011-0078D6?logo=windows&logoColor=white">
  <img alt="PowerShell 5.1+" src="https://img.shields.io/badge/PowerShell-5.1%2B-5391FE?logo=powershell&logoColor=white">
  <img alt="No Node.js required" src="https://img.shields.io/badge/Node.js-not%20required-success">
  <a href="LICENSE"><img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-green.svg"></a>
</p>

<p align="center">
  <a href="README.md">English</a> &nbsp;·&nbsp; <a href="README.cs.md">Čeština</a> &nbsp;·&nbsp; <b>中文</b>
</p>

<p align="center">
  <img alt="演示：用一行 PowerShell 命令安装 Claude Code" width="720" src="https://raw.githubusercontent.com/OndrejKnedla/claude-code-windows/main/assets/demo.svg">
</p>

---

## 🚀 安装（一行命令）

**1. 以管理员身份打开 PowerShell。** 按 **Windows 键**，输入 `powershell`，在 **Windows PowerShell** 上点击 **以管理员身份运行**，并在提示中点击 **是**。（用管理员身份可以让 Git 顺利安装，不会出现意外提示。）

**2. 粘贴下面这行并按回车：**

```powershell
irm https://raw.githubusercontent.com/OndrejKnedla/claude-code-windows/main/install.ps1 | iex
```

就这样。脚本会安装 Claude Code，必要时安装 Git for Windows，修复你的 PATH 和 PowerShell 策略，验证一切是否正常，然后启动 `claude`。

> **小技巧：** 想更快打开管理员 PowerShell，可以**右键点击开始按钮**，选择 **终端（管理员）** 或 **Windows PowerShell（管理员）**。

> **更喜欢点击操作？** [下载 ZIP](https://github.com/OndrejKnedla/claude-code-windows/archive/refs/heads/main.zip)，解压后双击 **`INSTALL.bat`**。它会请求管理员权限并完成其余工作。

---

## 🩹 它能解决的每一个 Windows 坑

如果你曾手动在 Windows 上安装 Claude Code，多半遇到过下面这些问题。本安装器会自动处理它们：

| 你看到的错误 | 原因 | 安装器的处理 |
|---|---|---|
| `claude : The term 'claude' is not recognized` | Claude Code 未安装（或不在 PATH 中） | 用官方方式安装，并在当前会话刷新 PATH |
| `npm : The term 'npm' is not recognized` | 未安装 Node.js | 使用**原生**安装器，因此根本不需要 Node.js |
| `node : The term 'node' is not recognized` *(刚装完 Node 后)* | 已打开的终端从未重新加载 PATH | 在当前窗口内从注册表重新加载 PATH |
| `claude.ps1 cannot be loaded because running scripts is disabled` | PowerShell `ExecutionPolicy` 为 `Restricted` | 为当前用户设置为 `RemoteSigned`（安全） |
| `claude.exe ... is not recognized` *(npm 安装后)* | npm 包安装不完整 / 损坏 | 检测到后执行一次干净的重新安装 |
| `Claude Code on Windows requires Git for Windows / PowerShell` | 缺少 `bash.exe` | 自动安装 Git for Windows |
| `Claude will return soon` *(登录时)* | Anthropic 临时服务中断，不是你的安装问题 | 提示你稍等一分钟再试 |

---

## ✨ 功能

- **一行命令，零配置。** 粘贴即用。
- **无需 Node.js。** 使用 Anthropic 官方原生安装器；仅在必要时才自动回退到 Node.js + npm。
- **自我修复。** 在当前会话刷新 PATH，修复 ExecutionPolicy，并就地修复损坏的安装。
- **安装 Git for Windows**（Claude Code 需要 `bash.exe`），如果你还没有的话。
- **验证结果**：在宣布成功之前，真正运行一次 `claude --version`。
- **新手模式**（`-Beginner`）会在桌面放一个大大的 **CLAUDE** 图标，非技术用户双击即可使用。

---

## ▶️ 如何启动 Claude Code

安装后，**打开一个新的 PowerShell 窗口**（让 PATH 是最新的），然后输入：

```powershell
claude
```

首次运行会打开浏览器登录你的 Claude 账户。把授权码粘贴回终端并按回车。之后只需输入你想做的事并按 **回车**。退出：输入 `/exit` 或按 **`Ctrl + C`** 两次。

**不想用终端？** 双击项目文件夹里的 **`START-CLAUDE.bat`**。

### 💻 终端基础（如果你从没用过）

那个黑白窗口就是*终端*。很简单：你**输入文字**并按 **回车**，Claude 就会回答。几个有用的小窍门：

- **回车** 发送消息。**Backspace** 删除。**上方向键** 调出你之前输入的内容。
- **退出 / 关闭：** 按 **`Ctrl + C`**（没反应就再按一次），或输入 `/exit`。也可以直接点 X 关掉窗口。你弄不坏任何东西。
- **复制：** 用鼠标选中文字，然后按 **`Ctrl + C`**（有时**右键**也能复制）。
- **粘贴：** **`Ctrl + V`**，或在窗口里**点右键**。
- **添加图片：** 直接把图片文件从文件夹**拖进窗口**放下。会出现它的路径，按回车，然后说比如*“描述一下这张照片”*。Claude 能看图。
- **添加链接：** 复制网址（`Ctrl + C`）并粘贴（`Ctrl + V`），然后说明要对它做什么。

> 可打印的捷克语版本见 [`beginner-pack/JAK_FUNGUJE_TERMINAL.txt`](beginner-pack/JAK_FUNGUJE_TERMINAL.txt)。

### ⚡ 跳过权限提示（`--dangerously-skip-permissions`）

默认情况下，Claude 在运行命令或修改文件前会先询问。想关掉它、让它不被打断地工作：

```powershell
claude --dangerously-skip-permissions
```

…或双击 **`START-CLAUDE-YOLO.bat`**。安装时也可以用 **`-SkipPermissions`** 开关把它固化下来（同时也会让桌面图标以这种方式启动）：

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/OndrejKnedla/claude-code-windows/main/install.ps1))) -Beginner -SkipPermissions
```

> ⚠️ **“dangerously”是什么意思：** 在这种模式下，Claude 可以**不经询问**就运行命令、修改文件。对只写文字（邮件、社交帖子）的非技术用户很合适，但在真实代码项目里有风险。只在你信任的文件夹和账户中使用。

---

## 🖱️ 新手模式（面向非技术用户）

要为从没用过终端的人配置 Claude Code？运行：

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/OndrejKnedla/claude-code-windows/main/install.ps1))) -Beginner
```

…或使用 [`beginner-pack/`](beginner-pack/) 里现成的捷克语工具包：

- **`INSTALUJ.bat`**：双击安装器，并会创建桌面图标
- **`TAHAK_pro_tisk.txt`**：可打印的单页速查表（“双击 → 输入 → 回车”）
- **`JAK_FUNGUJE_TERMINAL.txt`**：可打印的终端使用指南（Ctrl+C 退出、复制粘贴、拖入图片和链接）
- **`README.txt`**：通俗易懂的捷克语安装说明

安装后，用户只需双击 **CLAUDE** 图标，输入一句话，按回车即可。

---

## ⚙️ 选项（开关）

在脚本后面加上这些开关即可：

| 开关 | 作用 |
|---|---|
| `-Beginner` | 额外为非技术用户创建 **CLAUDE** 桌面快捷方式 |
| `-SkipPermissions` | 以 `--dangerously-skip-permissions` 启动 Claude（无权限提示）；也作用于桌面图标 |
| `-NoGit` | 跳过 Git for Windows 安装步骤 |
| `-NoLaunch` | 完成后不自动启动 `claude` |

从下载的副本运行：

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1 -Beginner
```

---

## 🔒 安全吗？

是的。而且你永远不应该在没看过的情况下运行来自互联网的脚本。这个脚本很短、完全可读：**[`install.ps1`](install.ps1)**。

- 它只安装官方软件：**Claude Code**（通过 `claude.ai/install.ps1`）和 **Git for Windows**（通过 `winget` 或官方发行版）。
- 它只更改**一项**设置：把你的用户级 PowerShell `ExecutionPolicy` 设为 `RemoteSigned`，这正是 Microsoft 推荐的日常值。
- 没有遥测，没有后台服务，没有任何隐藏行为。运行前请自行阅读。

---

## ❓ 故障排除

**安装后仍然找不到 `claude`？**
关闭窗口，打开一个**全新的** PowerShell。PATH 只会在新窗口里刷新。

**`irm ... | iex` 被拦截？**
你的策略很严格。先运行下面这行，再重试：
```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned -Force
```

**旧版 Windows 10 没有 `winget`？**
没问题，安装器会直接下载 Git 和 Node.js。你只需要联网。

**SmartScreen 对 `INSTALL.bat` 发出警告？**
点击 **更多信息 → 仍要运行**。（它未签名，因为这是免费的开源脚本。）

**登录时显示 “Claude will return soon”？**
这是 Anthropic 临时的服务问题，不是你的安装问题。等一分钟再运行 `claude`。

---

## 🗑️ 卸载

```powershell
irm https://raw.githubusercontent.com/OndrejKnedla/claude-code-windows/main/uninstall.ps1 | iex
```

…或双击 **`UNINSTALL.bat`**。它会删除 Claude Code 程序、桌面图标和 PATH 条目，但会保留 `~/.claude` 中的登录信息（加上 `-Purge` 可一并删除）。Git for Windows 会被保留。

---

## 🤝 参与贡献

欢迎提交 Issue 和 PR，尤其是安装器尚未覆盖的 Windows 边缘情况。请附上确切的错误文字以及你的 Windows / PowerShell 版本。

## 📄 许可证

[MIT](LICENSE)。随你使用，不提供任何担保。

<div align="center">
<sub>与 Anthropic 无关联。“Claude”和“Claude Code”是 Anthropic 的商标。这是一个非官方的社区安装器。</sub>
</div>
