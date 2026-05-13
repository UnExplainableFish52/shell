# Lesson 01 — Getting Started with Bash (and what a “shell” really is)

## TL;DR
- A computer runs **hardware**. 
- An **Operating System (OS)** manages that hardware and provides a usable environment. 
- The OS has a **kernel** (core) + **user-space tools** (everything you interact with daily). 
- A **shell** (like **Bash** or **Zsh**) is the *command interpreter* that turns your typed commands into actions by asking the OS to do things.
- A **terminal** is the app/window that lets you *talk to the shell*.
- Today, you’ll write and run your first script: **Hello, World**.

---

## Keywords (new terms + abbreviations)
- **OS (Operating System):** The main software layer that manages hardware and runs programs.
- **Kernel:** The core part of an OS that talks directly to hardware (CPU, memory, disks, devices).
- **User space:** The tools/programs you use (commands, apps). They ask the kernel for services.
- **Shell:** A program that reads commands and runs them (e.g., `bash`, `zsh`, `fish`).
- **Terminal / Terminal emulator:** The app you type into (e.g., GNOME Terminal, Windows Terminal, iTerm2).
- **CLI (Command Line Interface):** Text-based way of interacting with a computer.
- **Script:** A text file containing commands that run in order.
- **Shebang:** The first line in a script like `#!/bin/bash` that tells the system what interpreter to use.

---

## 1) Start from the OS (Operating System)
An **Operating System (OS)** is the software that:
- manages your computer’s resources (CPU, RAM, storage, devices),
- provides ways for programs to run,
- and gives you interfaces to interact with the machine (GUI and/or CLI).

### OS is not “one single blob”
On Linux (the easiest OS family to *see* and understand), it helps to think like this:

- **Kernel**: the “core manager” that directly controls hardware and provides core services.
- **Utilities & libraries**: tools and building blocks in user space (commands like `ls`, `cp`, `grep`, plus many system services).
- **Applications**: your programs (browsers, editors, games, etc.).

> Windows and macOS also have kernels and user-space software, but Linux tends to be more transparent and educational.

---

## 2) Kernel: why it matters
Programs generally **do not** talk to hardware directly (that would be chaos and unsafe). 
Instead:

**Applications → ask the OS (kernel) → kernel talks to hardware**

So how do applications “ask” the kernel? They use **system calls** (OS-provided request mechanisms).

> You don’t need to memorize system calls now—just remember: 
> the kernel is the gatekeeper that safely provides access to hardware and core resources.

---

## 3) Shell vs Terminal
This confusion is everywhere, so let’s make it crystal clear:

### Terminal (the window/app)
A **terminal emulator** is the app that displays:
- your typed input
- the output from commands
- the interactive session

Examples:
- Kali/Linux: GNOME Terminal, Konsole, xfce4-terminal, etc.
- macOS: Terminal, iTerm2
- Windows: Windows Terminal

### Shell (the brain behind the terminal)
A **shell** is the program that:
- reads what you type,
- interprets it as commands,
- and runs those commands by calling OS services.

Common shells:
- **bash** (Bourne Again SHell) — extremely common
- **zsh** (Z Shell) — very popular for interactive use
- **fish** (Friendly Interactive SHell) — friendly UX, different syntax in places
- **csh / tcsh** (C Shell variants) — older family, different scripting style

---

## 4) Restaurant analogy
Think of it like this:

- **Kernel = the kitchen + head chef rules** (only the kitchen can touch the “real hardware” like fire and knives)
- **Shell = the waiter** (takes your request and converts it into the correct “kitchen instructions”)
- **Terminal = your table/menu area** (where you place your order and see what you got)

So when you type:
```bash
ls
```
You’re basically “ordering” a task. The **shell** understands your order and asks the OS to perform it, and the **terminal** shows you the results.

---

## 5) What about Windows users?
Windows has shells too.

- **PowerShell** is a powerful Windows shell (and scripting language) — but its syntax and style are *different* from Bash/Zsh.
- If you want to follow along with **Bash/Zsh syntax**, the easiest path on Windows is:

### Option A (recommended): WSL
**WSL (Windows Subsystem for Linux)** lets you run a Linux environment inside Windows.

From there, you can use Bash (and install Zsh if you want).

### Option B: VirtualBox Linux 
You can run Kali (or Ubuntu) inside VirtualBox and follow along exactly the same.

---

## 6) Check what shell you’re using (Linux/macOS/WSL)
Run:
```bash
echo $SHELL
```

Common outputs:
- `/bin/bash`
- `/usr/bin/zsh`

Check versions:
```bash
bash --version
zsh --version
```

---

## 7) Install Bash/Zsh (only if you need it)

### Debian/Kali/Ubuntu
Update first:
```bash
sudo apt update
```

Install Bash (usually already installed):
```bash
sudo apt install -y bash
```

Install Zsh:
```bash
sudo apt install -y zsh
```

Switch your default shell to Zsh (optional):
```bash
chsh -s $(which zsh)
```

> `chsh` = “change shell”. 
> You may need to log out and log back in for it to fully apply.

---

## 8) What is “scripting”?
A **script** is a text file containing commands that run in order.

Why scripts are powerful:
- **automation** (repeatable tasks)
- **speed** (one command triggers many steps)
- **consistency** (less human error)
- **real-world value** (admin work, DevOps, cybersecurity workflows, backups, setup scripts)

Also: Shell scripting is great, but later you’ll love **Python scripting** too.
- Python is beginner-friendly
- great for automation + data processing
- widely used in industry

---

## 9) Your first script: Hello World
We’ll create a script file, write a few lines, and run it.

### Pick a text editor
Options:
- **nano** (simple, recommended)
- **vim/neovim** (powerful… but if you choose vim on day 1, your either a veteran or you dont have a life lol)

We’ll use **nano**.

### Create a file
In your terminal:
```bash
mkdir -p lessons
nano lessons/lesson01_hello.sh
```

> `mkdir -p lessons` creates a folder named `lessons` (safe if it already exists). 
> `nano` opens the file editor.

### Paste this script
```bash
#!/usr/bin/env bash
echo "Hello, World!"
echo "My shell scripting journey starts here."
```

**Line-by-line explanation:**
- `#!/usr/bin/env bash` 
  This is the **shebang**. It tells the system: “Run this file using `bash`.” 
  Using `/usr/bin/env` helps find bash in a flexible way across systems, Because in different systems the binary of bash might be present in different file locations that we cannot hardcode, so a smart and flexible approach.
- `echo "..."` 
  `echo` prints text to the terminal, it is a command.

### Save and exit nano
- Save: `Ctrl + O` then press `Enter`
- Exit: `Ctrl + X`

---

## 10) Run the script (two correct ways)

### Way A: run it explicitly with bash (recommended at first)
```bash
bash lessons/lesson01_hello.sh
```

### Way B: make it executable and run it
```bash
chmod +x lessons/lesson01_hello.sh
./lessons/lesson01_hello.sh
```

**What these mean:**
- `chmod +x` adds **execute** permission. Click to learn about it: https://lokii.tech/intermediate/notes/linux_course.html
- `./` means “run the file from this directory path”.

---

## Checkpoint quiz 
1) What’s the difference between a **terminal** and a **shell**? 
2) What does the **kernel** do, at a high level? 
3) What is a **shebang**, and why do we use it? 
4) What does `chmod +x` change?

---

## Progress update
You now understand:
- OS → kernel → user tools 
- terminal vs shell 
- what scripting is 
- how to write + run your first Bash script

---

## Next lesson (Lesson 02 teaser)
Next we’ll learn:
- variables (`name="loki"`)
- input (`read`)
- arguments (`$1`, `$2`)
- basic safety habits (`set -euo pipefail` — what it means and when to use it)

See you in Lesson 02.
