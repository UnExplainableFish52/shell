# Shell Scripting (Bash + Zsh) — Follow Along Repo

A small, focused repository to help you **learn shell usage + shell scripting** by *actually doing it*.

Big projects can be powerful, but they can also get overwhelming fast. This repo stays intentionally simple so you can:
- follow along without burnout,
- read scripts that are easy to understand,
- spot mistakes/weaknesses,
- fix them (or improve them),
- and learn faster by interacting with real material.

---

## What this project is about
This repo is a **learning + practice space** for:
- **Bash** scripting (common on Linux servers and many environments)
- **Zsh** usage/scripting (popular for interactive terminals)

You can follow along on:
- Kali Linux (VirtualBox) what I’m using
- any Linux distro
- macOS (Zsh is common)
- WSL (Windows Subsystem for Linux) on Windows

As long as you have a working **shell** (Bash or Zsh) and a terminal, you’re good.

> **Terms**
> - **Shell**: the program that reads your commands and runs them (e.g., `bash`, `zsh`).
> - **Script**: a file (usually `.sh`) containing commands that run in order.
> - **Repo**: repository (a project folder tracked by Git/GitHub).
> - **PR**: Pull Request (a proposed change you want merged into the repo).

---

## What you’ll get here
- Simple scripts you can run locally
- A structured “learning path” format (intro → examples → practice)
- A place to experiment safely and build confidence
- A beginner-friendly project that still teaches real workflows

---

## Getting started

### 1) Clone the repository
1. Click the **Code** button on GitHub
2. Copy the **HTTPS** URL
3. Clone it:

```bash
git clone https://github.com/UnExplainableFish52/shell.git
cd shell
```

---

### 2) Read the materials
If you’re using **VS Code**:
- Open the folder
- Click `README.md` (or any `.md` file)
- Use the **Markdown Preview** (usually: `Ctrl+Shift+V`)

---

### 3) Run scripts (Bash / Zsh)

#### Option A — run with Bash
```bash
bash path/to/script.sh
```

#### Option B — run with Zsh
```bash
zsh path/to/script.sh
```

> Tip: Explicitly using `bash` or `zsh` avoids confusion about which shell is executing the script.

---

## Want deeper notes + practice?
If you want **textbook-style notes** + **practice questions**, use these pages:

- Notes: https://lokii.tech/intro/notes/1.7-shell-scripting.html
- Practice: https://lokii.tech/intro/notes/1.8-shell-scripting-practice.html

If you can understand everything there, you’re already moving into **intermediate/advanced** territory.

---

## A learning mindset (important)
Don’t just copy commands—**explore**.
When you hit something new:
- Google it
- test it in your terminal
- break it safely
- fix it
- write down what you learned

That “curiosity loop” is how your foundation becomes strong fast.

---

## Contributing (Open Source)
This repo is open-source under **GNU GPL v3** (GNU General Public License v3).

If you want to contribute:
1. **Fork** this repo on GitHub
2. Clone your fork:
   ```bash
   git clone https://github.com/UnExplainableFish52/shell.git
   cd shell
   ```
3. Create a branch (recommended):
   ```bash
   git checkout -b my-change
   ```
4. Make your changes, commit, and push:
   ```bash
   git add .
   git commit -m "Improve: explanation for variables"
   git push -u origin my-change
   ```
5. Open a **Pull Request (PR)** on GitHub
   - GitHub will guide you with a “Contribute” / “Compare & pull request” button.

If auto-merge is enabled on my side and everything looks good, your contribution can be merged quickly.

---

## Good wishes
Happy shell scripting, and happy learning.

This is a *practical* skill that makes you closer to your machine; and it’s a genuinely valuable item on your resume when you can automate real tasks.
