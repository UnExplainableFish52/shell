# Tips & Extras (Read This Early, Save Pain Later)

These are the “small things” most courses skip, but they make you **faster, safer, and way more comfortable** in the terminal.

This repo is **Bash-focused for scripting**, but it’s totally normal to use **Zsh** as your *daily interactive shell* because it’s modern, customizable, and looks cool.

> **Quick idea**
> - Use **Zsh** for your daily terminal experience.
> - Write scripts with a **shebang** like `#!/usr/bin/env bash` so they run in **Bash** consistently.

---

## 1) Bash vs Zsh (what you should actually do)

### Why people use Zsh
People often use **Zsh** because:
- it’s **highly customizable** (themes, plugins, prompt styles)
- the interactive experience is smoother (autocomplete, suggestions, etc.)
- it supports *most* things Bash users do day-to-day

### Reality check (important)
- **Most Bash scripts work in Zsh** *only if you run them with Bash*.
- Zsh is **not** “Bash with skins”—it has differences.
- That’s why scripts should specify the interpreter using a **shebang**.

Best workflow:
- Interactive shell: **Zsh**
- Script interpreter: **Bash** (via shebang)

---

## 2) “Which shell am I using?” (check when in doubt)
If you’re ever unsure what shell you (or your friend) is using:

```bash
echo "$SHELL"
```

More accurate for the current session:
```bash
ps -p $$ -o comm=
```

> `$SHELL` often shows your *default login shell*. 
> The `ps ... $$` command tells you what’s running *right now*.

---

## 3) Learn these early: `man`, `--help`, `tldr` (lifesavers)
These three tools save you from guessing commands:

```bash
man ls
ls --help
tldr tar
```

Install `tldr` on Debian/Kali/Ubuntu:
```bash
sudo apt update
sudo apt install -y tldr
```

**What they mean**
- `man <command>`: full manual (detailed)
- `<command> --help`: quick built-in usage summary
- `tldr <command>`: practical examples (fastest when you’re learning)

You’ll thank yourself later.

---

## 4) Quote variables by default (safe habit = fewer weird bugs)
A huge beginner trap is unquoted variables.

Bad:
```bash
rm -r $dir
```

Good:
```bash
rm -r -- "$dir"
```

**Why it matters**
- filenames can contain spaces
- empty variables can cause dangerous behavior
- quoting makes scripts predictable and safer

---

## 5) Use ShellCheck (your Bash “spellchecker”)
**ShellCheck** catches bugs and bad practices before you run a script.

Install:
```bash
sudo apt install -y shellcheck
```

Use:
```bash
shellcheck script.sh
```

> In real sensitive environment, it might save you from a catastrophe.

---

## 6) Make a safe practice playground folder
Beginners sometimes run destructive commands in the wrong directory.

Make a safe playground:
```bash
mkdir -p ~/playground/shell
cd ~/playground/shell
```

Now experiment there first, not in random system folders.

---

## 7) Understand `PATH` (why a command runs / doesn’t run)
When you see “command not found” or “wrong version”, it’s often `PATH`.

Check:
```bash
echo "$PATH"
which bash
type -a python
```
> if it is still not working, you can start an AI Assistant troubleshooting session from there, and fix that problem easily.

---

## 8) Use history like a power user
Search your command history:
- `Ctrl + R` → reverse search (type a few letters)

Show recent commands:
```bash
history | tail -n 20
```

**Why it matters**
- massive speed boost
- reduces mistakes from retyping long commands

---

## 9) Customize your shell config (`~/.bashrc`, `~/.zshrc`) — life changer
Your shell config file controls:
- aliases (`alias ll='ls -la'`)
- prompt style
- keybindings
- environment variables
- plugins (especially in Zsh)

Common files:
- `~/.bashrc` → Bash config (interactive)
- `~/.zshrc` → Zsh config (interactive)

> you should find a guide on this also in this repo, I should share a template and also teach you how to customize it.

### Pro move: back up your config on GitHub
Make a private repo (or public if you’re comfortable) for your dotfiles:
- `dotfiles` repository idea:
  - `.zshrc`
  - `.bashrc`
  - `.gitconfig`
  - terminal theme exports (optional)

**Why it matters**
- you can restore your setup instantly after reinstall
- you can quickly load your setup on another machine
- helps you build a consistent workflow everywhere

> Safety note: never upload secrets (API keys, tokens, passwords). 
> If unsure, don’t push it, review first.

---

## 10) “If Zsh causes issues, can I switch back to Bash easily?”
Yes.

### Run Bash for just one session (temporary)
```bash
bash
```
Exit back to Zsh:
```bash
exit
```

### Change your default shell back to Bash (Linux)
```bash
chsh -s "$(which bash)"
```

Change to Zsh:
```bash
chsh -s "$(which zsh)"
```

> You may need to log out and log back in for the default shell change to take effect.

---

## 11) About shebangs (important: what they do and what they don’t)
A **shebang** like this:
```bash
#!/usr/bin/env bash
```

…tells the OS: “run this script using Bash”.

### So do we always need to type `bash script.sh`?
No — *if*:
- the script has a shebang,
- it has execute permission (`chmod +x script.sh`),
- and you run it like `./script.sh`.

Example:
```bash
chmod +x script.sh
./script.sh
```

### What shebang does NOT do
- It does **not** change your interactive shell.
  - You can be using Zsh interactively and still run Bash scripts perfectly.

 That’s exactly why using Zsh + Bash-shebang scripts is a clean combo.

---

## One rule to keep you safe
If you don’t understand a command, don’t run it as `sudo` yet. 
Learn what it does first (use `man`, `--help`, `tldr`).

---


## Optional: “Ricing” your terminal (Zsh + Oh My Zsh + Powerlevel10k)

If you’re going to spend a lot of time in the terminal, making it look clean and feel comfortable is a **real productivity win**.

This section is **optional** (you can skip it and still follow the whole course), but if you do it, your daily terminal experience becomes way nicer.

We’ll set up:
- **Zsh** (Z Shell) as your interactive shell
- **Oh My Zsh** for managing Zsh config/plugins/themes easily
- **Powerlevel10k** for a modern, fast prompt
- **Nerd Font** so icons/symbols render properly
- Two useful plugins:
  - **zsh-autosuggestions** (suggests commands as you type)
  - **zsh-syntax-highlighting** (color highlights commands; helps catch mistakes)

> Optional video (sleek inspiration): 
> https://youtu.be/DmpMgTL6R9A?si=IWOcNPoytzeDJ0qt 
> Not required if you follow the steps below.

---

### Step 0) Install Zsh (Kali/Debian/Ubuntu)
```bash
sudo apt update
sudo apt install -y zsh git curl
zsh --version
```

Make Zsh your default shell (recommended if you want the full experience):
```bash
chsh -s "$(which zsh)"
```

> You may need to log out and log back in (or restart your terminal) for this to apply.

---

### Step 1) Install Oh My Zsh
Official repo: https://github.com/ohmyzsh/ohmyzsh

Install (curl):
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

After install, you’ll have:
- `~/.zshrc` (your Zsh config)
- `~/.oh-my-zsh/` (Oh My Zsh directory)

---

### Step 2) Install Powerlevel10k theme
Official repo: https://github.com/romkatv/powerlevel10k

```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
```

Enable it in `~/.zshrc`:
```bash
nano ~/.zshrc
```

Find:
```bash
ZSH_THEME="..."
```

Replace with:
```bash
ZSH_THEME="powerlevel10k/powerlevel10k"
```

Reload:
```bash
source ~/.zshrc
```

If it’s set up correctly, you’ll usually see the Powerlevel10k wizard. 
If not, run it manually:
```bash
p10k configure
```

---

### Step 3) Install a Nerd Font (so icons don’t look broken)
Powerlevel10k looks best with a **Nerd Font**. Without it you may see squares or weird symbols.

Recommended: **MesloLGS NF** (commonly used with Powerlevel10k)

Quick install helper (downloads fonts to your home directory):
```bash
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
fc-cache -fv
```

Now go to your terminal settings and select **MesloLGS NF** as the font, then restart the terminal.

> Font setting is done in your terminal app (not inside Bash/Zsh).

---

### Step 4) Install plugins (autosuggestions + syntax highlighting)

#### 4.1) zsh-autosuggestions
Repo: https://github.com/zsh-users/zsh-autosuggestions

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

#### 4.2) zsh-syntax-highlighting
Repo: https://github.com/zsh-users/zsh-syntax-highlighting

```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

#### Enable plugins in `~/.zshrc`
Open:
```bash
nano ~/.zshrc
```

Find the plugins line:
```bash
plugins=(git)
```

Change it to (make sure syntax-highlighting is last):
```bash
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
```

Reload:
```bash
source ~/.zshrc
```

---

### Troubleshooting (fast fixes)

**1) Theme not applying**
- Confirm `~/.zshrc` contains:
  ```bash
  ZSH_THEME="powerlevel10k/powerlevel10k"
  ```
- Then:
  ```bash
  source ~/.zshrc
  ```

**2) Icons look broken**
- Your font is not set to a Nerd Font in terminal settings.
- Set it to **MesloLGS NF**, restart terminal.

**3) `p10k: command not found`**
- Powerlevel10k isn’t loaded; re-check the theme line in `~/.zshrc`.

---

### How to revert (important)
If you ever want to undo this setup:

#### Revert 1) Switch back to Bash temporarily (one terminal session)
```bash
bash
```
Back to Zsh:
```bash
exit
```

#### Revert 2) Change default shell back to Bash
```bash
chsh -s "$(which bash)"
```
Log out and log back in.

#### Revert 3) Disable Powerlevel10k theme
Edit:
```bash
nano ~/.zshrc
```

Change:
```bash
ZSH_THEME="powerlevel10k/powerlevel10k"
```

To something simple like:
```bash
ZSH_THEME="robbyrussell"
```

Reload:
```bash
source ~/.zshrc
```

#### Revert 4) Disable plugins
Edit the plugins line back to:
```bash
plugins=(git)
```
Reload:
```bash
source ~/.zshrc
```

#### Revert 5) Uninstall Oh My Zsh (full removal)
Oh My Zsh usually provides an uninstall script:
```bash
uninstall_oh_my_zsh
```

If that command isn’t found, remove the folder manually (careful):
```bash
rm -rf ~/.oh-my-zsh
```

Then you can remove OMZ-related lines from `~/.zshrc` or restore a backup.

---

