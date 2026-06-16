<h1 align="center">
  <a href="https://github.com/OndrejKnedla/claude-code-windows">
    <img alt="Claude Code Windows 1-Click Installer" width="800" src="https://raw.githubusercontent.com/OndrejKnedla/claude-code-windows/main/assets/banner.svg">
  </a>
  <br>
  <small>Nainstaluj <a href="https://claude.com/claude-code">Claude Code</a> na Windows jedním řádkem, bez Node.js a bez starostí s PATH</small>
</h1>

<p align="center">
  <a href="https://github.com/OndrejKnedla/claude-code-windows/actions/workflows/test.yml"><img alt="CI" src="https://github.com/OndrejKnedla/claude-code-windows/actions/workflows/test.yml/badge.svg"></a>
  <img alt="Windows 10 | 11" src="https://img.shields.io/badge/Windows-10%20%7C%2011-0078D6?logo=windows&logoColor=white">
  <img alt="PowerShell 5.1+" src="https://img.shields.io/badge/PowerShell-5.1%2B-5391FE?logo=powershell&logoColor=white">
  <img alt="Node.js neni potreba" src="https://img.shields.io/badge/Node.js-not%20required-success">
  <a href="LICENSE"><img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-green.svg"></a>
</p>

<p align="center">
  <a href="README.md">English</a> &nbsp;·&nbsp; <b>Čeština</b> &nbsp;·&nbsp; <a href="README.zh.md">中文</a>
</p>

<p align="center">
  <img alt="Demo: instalace Claude Code jedním řádkem v PowerShellu" width="720" src="https://raw.githubusercontent.com/OndrejKnedla/claude-code-windows/main/assets/demo.svg">
</p>

---

## 🚀 Instalace (jeden řádek)

**1. Otevři PowerShell jako správce (administrátor).** Zmáčkni **klávesu Windows**, napiš `powershell`, u **Windows PowerShell** klikni na **Spustit jako správce** a potvrď **Ano**. (Jako správce se Git nainstaluje hladce bez problémů.)

**2. Vlož tento příkaz a dej Enter:**

```powershell
irm https://raw.githubusercontent.com/OndrejKnedla/claude-code-windows/main/install.ps1 | iex
```

A je to. Skript nainstaluje Claude Code, doinstaluje Git for Windows (když chybí), opraví PATH i politiku spouštění skriptů, vše ověří a spustí `claude`.

> **Tip:** admin PowerShell otevřeš ještě rychleji **pravým tlačítkem na tlačítko Start** → **Terminál (správce)** nebo **Windows PowerShell (správce)**.

> **Radši klikat?** [Stáhni ZIP](https://github.com/OndrejKnedla/claude-code-windows/archive/refs/heads/main.zip), rozbal ho a 2× klikni na **`INSTALL.bat`**. Sám si vyžádá práva správce a zařídí zbytek.

---

## 🩹 Každý zádrhel na Windows, který to řeší

Když ses pokoušel nainstalovat Claude Code na Windows ručně, nejspíš jsi narazil na něco z tohohle. Tenhle instalátor to všechno vyřeší automaticky:

| Chyba, kterou jsi viděl | Proč nastává | Co s tím instalátor udělá |
|---|---|---|
| `claude : The term 'claude' is not recognized` | Claude Code není nainstalovaný (nebo není v PATH) | Nainstaluje ho oficiální cestou a obnoví PATH v běžícím okně |
| `npm : The term 'npm' is not recognized` | Není nainstalovaný Node.js | Použije **nativní** instalátor, takže Node.js není vůbec potřeba |
| `node : The term 'node' is not recognized` *(hned po instalaci Node)* | Otevřené okno nikdy nenačetlo nové PATH | Načte PATH z registru přímo v aktuálním okně |
| `claude.ps1 cannot be loaded because running scripts is disabled` | PowerShell `ExecutionPolicy` je `Restricted` | Nastaví `RemoteSigned` pro tvého uživatele (bezpečné) |
| `claude.exe ... is not recognized` *(po instalaci přes npm)* | Částečný / rozbitý npm balíček | Pozná to a udělá jednu čistou přeinstalaci |
| `Claude Code on Windows requires Git for Windows / PowerShell` | Chybí `bash.exe` | Automaticky doinstaluje Git for Windows |
| `Claude will return soon` *(při přihlášení)* | Dočasný výpadek Anthropicu, ne tvoje instalace | Řekne ti, ať to za minutu zkusíš znovu |

---

## ✨ Co umí

- **Jeden příkaz, nulová konfigurace.** Vlož a hotovo.
- **Node.js není potřeba.** Používá oficiální nativní instalátor od Anthropicu; na Node.js + npm spadne automaticky jen v nouzi.
- **Sám se opraví.** Obnoví PATH v běžícím okně, opraví ExecutionPolicy a na místě napraví rozbitou instalaci.
- **Doinstaluje Git for Windows** (Claude Code potřebuje `bash.exe`), pokud ho ještě nemáš.
- **Ověří výsledek** tím, že reálně spustí `claude --version`, než prohlásí úspěch.
- **Režim pro začátečníky** (`-Beginner`) dá na plochu velkou ikonu **CLAUDE**, takže netechnický uživatel jen dvojklikne.

---

## ▶️ Jak zapnout Claude Code

Po instalaci **otevři nové okno PowerShellu** (aby bylo PATH čerstvé) a napiš:

```powershell
claude
```

Poprvé se otevře prohlížeč pro přihlášení k tvému Claude účtu. Zkopíruj autorizační kód zpět do terminálu a dej Enter. Pak už jen píšeš, co chceš, a mačkáš **Enter**. Konec: napiš `/exit` nebo zmáčkni **`Ctrl + C`** dvakrát.

**Nechceš terminál?** 2× klikni na **`START-CLAUDE.bat`** ve složce projektu.

### 💻 Základy terminálu (když jsi ho ještě nepoužíval)

To černobílé okno je *terminál*. Funguje jednoduše: **píšeš** a mačkáš **Enter**, Claude odpovídá. Pár věcí, co pomůžou:

- **Enter** odešle zprávu. **Backspace** maže. **Šipka nahoru** vrátí, cos psal předtím.
- **Konec / zavření:** zmáčkni **`Ctrl + C`** (dvakrát, když se nic nestane), nebo napiš `/exit`. Můžeš taky prostě zavřít okno křížkem. Nic nerozbiješ.
- **Kopírování:** označ text myší a dej **`Ctrl + C`** (někdy kopíruje i **pravé tlačítko**).
- **Vkládání:** **`Ctrl + V`**, nebo **pravé tlačítko** myši v okně.
- **Přidat fotku:** přetáhni soubor s obrázkem ze složky **přímo do okna** a pusť. Objeví se cesta, dej Enter a napiš třeba *„popiš tuhle fotku"*. Claude obrázky vidí.
- **Přidat odkaz:** zkopíruj URL (`Ctrl + C`) a vlož ji (`Ctrl + V`), pak napiš, co s ní má udělat.

> Verze na vytištění je v [`beginner-pack/JAK_FUNGUJE_TERMINAL.txt`](beginner-pack/JAK_FUNGUJE_TERMINAL.txt).

### ⚡ Přeskočit dotazy na povolení (`--dangerously-skip-permissions`)

Claude se ve výchozím stavu ptá, než spustí příkaz nebo upraví soubor. Když to chceš vypnout a nechat ho pracovat bez přerušování:

```powershell
claude --dangerously-skip-permissions
```

…nebo 2× klikni na **`START-CLAUDE-YOLO.bat`**. Při instalaci to můžeš zapnout natrvalo přepínačem **`-SkipPermissions`** (nastaví tak i ikonu na ploše):

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/OndrejKnedla/claude-code-windows/main/install.ps1))) -Beginner -SkipPermissions
```

> ⚠️ **Co znamená „dangerously":** v tomhle režimu může Claude spouštět příkazy a měnit soubory **bez ptaní**. Ideální pro netechnické uživatele, kteří jen píšou text (emaily, příspěvky), ale rizikové uvnitř skutečného kódu. Používej jen ve složce a účtu, kterým věříš.

---

## 🖱️ Režim pro začátečníky (pro netechnické uživatele)

Nastavuješ Claude Code někomu, kdo nikdy nepoužil terminál? Spusť:

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/OndrejKnedla/claude-code-windows/main/install.ps1))) -Beginner
```

…nebo použij hotový český balíček v [`beginner-pack/`](beginner-pack/):

- **`INSTALUJ.bat`**: instalátor na dvojklik, který navíc vytvoří ikonu na ploše
- **`TAHAK_pro_tisk.txt`**: tahák na jednu stránku k vytištění („dvojklik → piš → Enter")
- **`JAK_FUNGUJE_TERMINAL.txt`**: tištěný návod k samotnému terminálu (Ctrl+C = konec, kopírování, vkládání fotek a odkazů)
- **`README.txt`**: srozumitelné poznámky k nastavení v češtině

Po instalaci uživatel jen 2× klikne na ikonu **CLAUDE**, napíše větu a dá Enter.

---

## ⚙️ Možnosti (přepínače)

Přidej přepínač za skript:

| Přepínač | Co dělá |
|---|---|
| `-Beginner` | Navíc vytvoří na ploše zástupce **CLAUDE** pro netechnické uživatele |
| `-SkipPermissions` | Spustí Claude s `--dangerously-skip-permissions` (bez dotazů na povolení); platí i pro ikonu na ploše |
| `-NoGit` | Přeskočí instalaci Git for Windows |
| `-NoLaunch` | Po dokončení automaticky nespustí `claude` |

Ze stažené kopie:

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1 -Beginner
```

---

## 🔒 Je to bezpečné?

Ano. A nikdy bys neměl spouštět skript z internetu, aniž by ses na něj podíval. Tenhle je krátký a celý čitelný: **[`install.ps1`](install.ps1)**.

- Instaluje jen oficiální software: **Claude Code** (přes `claude.ai/install.ps1`) a **Git for Windows** (přes `winget` nebo oficiální release).
- Mění **jediné** nastavení: PowerShell `ExecutionPolicy` pro tvého uživatele na `RemoteSigned`, což je hodnota, kterou Microsoft doporučuje pro běžné používání.
- Žádná telemetrie, žádné služby na pozadí, nic skrytého. Přečti si to, než to spustíš.

---

## ❓ Řešení problémů

**`claude` se po instalaci pořád nenajde?**
Zavři okno a otevři **úplně nový** PowerShell. PATH se obnoví jen v novém okně.

**`irm ... | iex` je zablokované?**
Máš přísnou politiku. Spusť nejdřív tohle a zkus znovu:
```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned -Force
```

**Starý Windows 10 bez `winget`?**
Nevadí, instalátor si Git a Node.js stáhne přímo. Stačí připojení k internetu.

**SmartScreen varuje u `INSTALL.bat`?**
Klikni na **Další informace → Přesto spustit**. (Není podepsaný, protože je to bezplatný open-source skript.)

**Přihlášení hlásí „Claude will return soon"?**
To je dočasný výpadek na straně Anthropicu, ne tvoje instalace. Počkej minutu a spusť `claude` znovu.

---

## 🗑️ Odinstalace

```powershell
irm https://raw.githubusercontent.com/OndrejKnedla/claude-code-windows/main/uninstall.ps1 | iex
```

…nebo 2× klikni na **`UNINSTALL.bat`**. Odstraní binárku Claude Code, ikonu na ploše i záznam v PATH, ale ponechá přihlášení v `~/.claude` (přidej `-Purge`, ať se smaže i to). Git for Windows zůstane nainstalovaný.

---

## 🤝 Příspěvky

Issues a PR jsou vítané, hlavně hlášení okrajových případů na Windows, které instalátor ještě neřeší. Přilož přesné znění chyby a verzi Windows / PowerShellu.

## 📄 Licence

[MIT](LICENSE). Dělej si s tím, co chceš, bez záruky.

<div align="center">
<sub>Není přidružené k Anthropicu. „Claude" a „Claude Code" jsou ochranné známky Anthropicu. Jde o neoficiální komunitní instalátor.</sub>
</div>
