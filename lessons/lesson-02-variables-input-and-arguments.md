# Lesson 02 — Variables, Input, Arguments & Safety Habits

## TL;DR
- **Variables** let you store and reuse values (`name="loki"`).
- **`read`** lets your script ask the user for input at runtime.
- **Positional arguments** (`$1`, `$2`, …) let you pass values to a script when you run it.
- **`set -euo pipefail`** is a safety net that catches common silent failures in your scripts.
- Today you'll write scripts that talk back, take input, and fail loudly when something breaks.

---

## Keywords 
- **Variable:** A named container that holds a value (text, number, path, etc.).
- **Environment variable:** A variable that's available to the current shell *and* any programs it launches (e.g., `$HOME`, `$USER`).
- **`read`:** A built-in Bash command that pauses the script and waits for the user to type something.
- **Positional parameter:** The values passed to a script on the command line. `$1` is the first, `$2` is the second, and so on.
- **`$0`:** The name of the script itself.
- **`$#`:** The total number of arguments passed.
- **`$@`:** All arguments as a list.

> **Example:** If you run:
> ```bash
> bash scan.sh 192.168.1.1 80 tcp
> ```
> Then inside `scan.sh`:
> | Variable | Value |
> |----------|-------|
> | `$0` | `scan.sh` |
> | `$1` | `192.168.1.1` |
> | `$2` | `80` |
> | `$3` | `tcp` |
> | `$#` | `3` |
> | `$@` | `192.168.1.1 80 tcp` |

- **Exit code:** A number (0–255) a command returns when it finishes. `0` = success, anything else = some kind of failure.
- **`set`:** A built-in command that changes how the shell behaves.
- **Pipe (`|`):** Sends the output of one command as input to another (e.g., `ls | grep txt`).

---

## 1) Variables: storing and reusing values

A variable is just a label that points to a value. You create one like this:

```bash
name="loki"
```

### The golden rule: NO SPACES around `=`

```bash
# Correct
name="loki"

# Wrong (Bash will think "name" is a command)
name = "loki"
```

This trips up literally everyone at first. Bash is *very* picky about spaces here, unlike most other languages you might have seen.

### Using a variable

To access the value, prefix the name with `$`:

```bash
name="loki"
echo "Hello, $name"
```

Output:
```
Hello, loki
```

### Curly braces: when and why

Sometimes you need to tell Bash exactly where the variable name ends. That's what `${}` is for:

```bash
animal="cat"
echo "I have 3 ${animal}s"
```

Output:
```
I have 3 cats
```

Without the braces, Bash would look for a variable called `$animals` (which doesn't exist) and print nothing there.

### Single quotes vs double quotes

This is important and will save you debugging time:

```bash
name="loki"
echo "Hello, $name"    # Double quotes: variable gets expanded
echo 'Hello, $name'    # Single quotes: everything is literal text
```

Output:
```
Hello, loki
Hello, $name
```

**Rule of thumb:**
- Use **double quotes** `" "` when you want variables to be replaced with their values.
- Use **single quotes** `' '` when you want the text exactly as-is, no substitution.

---

## 2) Environment variables vs regular variables

When you create a variable normally, it only exists inside your current script or shell session. It's called a **local/shell variable**.

```bash
greeting="hey there"
```

An **environment variable** is one that gets passed down to any child process (programs or scripts launched from the current shell). You create one using `export`:

```bash
export API_KEY="abc123"
```

### Common built-in environment variables

Your system already has a bunch of these set for you. Try running these:

```bash
echo $HOME       # Your home directory
echo $USER       # Your username
echo $SHELL      # Your default shell
echo $PWD        # Your current working directory
echo $PATH       # Where the system looks for executables
```

> You don't need to memorize all of these. Just know they exist and you can always check with `env` or `printenv` to see them all.

---

## 3) User input with `read`

So far our scripts just print stuff. Let's make them interactive.

### Create the script

```bash
nano lessons/lesson02_greet.sh
```

### Write this:

```bash
#!/usr/bin/env bash

echo "What's your name?"
read username
echo "Welcome, $username. Let's learn some shell scripting."
```

**Line-by-line explanation:**
- `read username` — pauses the script, waits for the user to type something and hit Enter, then stores whatever they typed into the variable `username`.
- We then use `$username` to print it back.

### Run it:

```bash
./lessons/lesson02_greet.sh
```

It will pause, wait for you to type your name, and then greet you. Simple but powerful, this is how real CLI tools ask for confirmation, passwords, config values, etc.

### `read` with a prompt (cleaner way)

You can skip the separate `echo` and use `read -p` instead:

```bash
read -p "What's your name? " username
echo "Welcome, $username."
```

The `-p` flag lets you show a prompt message and read input on the same line. Looks cleaner.

### Reading multiple values

```bash
read -p "Enter first and last name: " first last
echo "First: $first"
echo "Last: $last"
```

If the user types `loki odinson`, then `first` gets `loki` and `last` gets `odinson`.

### Silent input (for passwords)

```bash
read -sp "Enter password: " password
echo ""
echo "Password received. (not printing it obviously, lol)"
```

The `-s` flag hides what the user types (no characters show on screen). Useful for passwords or secrets.

---

## 4) Script arguments 

Instead of asking for input interactively, you can pass values **when you run the script**.

### Create the script

```bash
nano lessons/lesson02_args.sh
```

### Write this:

```bash
#!/usr/bin/env bash

echo "Script name: $0"
echo "First argument: $1"
echo "Second argument: $2"
echo "Total arguments: $#"
echo "All arguments: $@"
```

### Run it:

```bash
bash lessons/lesson02_args.sh loki odinson
```

Output:
```
Script name: lessons/lesson02_args.sh
First argument: loki
Second argument: odinson
Total arguments: 2
All arguments: loki odinson
```

**What just happened:**
- `$0` = the script's own name/path
- `$1` = first thing you typed after the script name (`loki`)
- `$2` = second thing (`odinson`)
- `$#` = how many arguments were passed (`2`)
- `$@` = all of them as a list

> **Quick note:** `$0` changes depending on *how* you run the script. If you run `bash lessons/lesson02_args.sh`, then `$0` is `lessons/lesson02_args.sh`. But if you run `./lesson02_args.sh` from inside the `lessons/` folder, `$0` becomes `./lesson02_args.sh`. The way you invoke the script defines what `$0` holds.

### Why this matters

Arguments make scripts reusable. Instead of editing a script every time you want to change a value, you just pass it in:

```bash
bash backup.sh /home/loki /mnt/usb
```

The script reads `$1` as the source and `$2` as the destination. One script, infinite uses.

### A practical example: a simple greeter

```bash
#!/usr/bin/env bash

name=$1

if [ "$name" = "" ]; then
  echo "Please give me a name."
  exit 1
fi

echo "Hello, $name!"
```

**Line-by-line explanation:**
- `name=$1` — takes the first argument passed to the script and stores it in a variable called `name`. This makes the code easier to read than using `$1` everywhere.
- `if [ "$name" = "" ]; then` — checks if `name` is empty (meaning no argument was given). The `[ ]` is a test/comparison block in Bash.
- `echo "Please give me a name."` — if no name was provided, we tell the user what went wrong.
- `exit 1` — stops the script immediately with an error code (`1`). This tells the system "something went wrong."
- `fi` — closes the `if` block (it's `if` spelled backwards, that's literally how Bash ends an if statement).
- `echo "Hello, $name!"` — if we made it past the check, greet the user with the name they gave.

> `exit 1` tells the system "this script failed" (any non-zero exit code means failure). `exit 0` means success. This becomes important when scripts call other scripts.

---

## 5) Combining variables, input, and arguments

Now let's use everything from this lesson in one simple script, think of it as revision:

```bash
nano lessons/lesson02_combo.sh
```

```bash
#!/usr/bin/env bash

# Variable (hardcoded)
course="Shell Scripting"

# Argument (passed when running the script)
name="$1"

# User input (asked at runtime)
read -p "How old are you? " age

echo "-------------------"
echo "Name: $name"
echo "Age: $age"
echo "Course: $course"
echo "-------------------"
echo "Welcome to $course, $name!"
```

### Run it:
```bash
bash lessons/lesson02_combo.sh loki
```

It will ask for your age, and then print everything together.

**What's happening here (revision):**
- `course="Shell Scripting"` — a regular variable, hardcoded inside the script.
- `name="$1"` — comes from the argument you pass when running the script.
- `read -p "..." age` — asks the user to type their age at runtime.
- The `echo` lines just print it all out.

Three different ways to get data into a script: **hardcoded**, **argument**, and **user input**. That's the core of this lesson.

---

## 6) Safety habits: `set -euo pipefail`

By default, Bash is *dangerously forgiving*. If a command fails in the middle of your script, Bash just shrugs and keeps going. That can lead to scripts that *seem* to work but silently corrupt data or skip critical steps.

This is where `set -euo pipefail` comes in. Add it near the top of your script (right after the shebang) and Bash becomes strict:

```bash
#!/usr/bin/env bash
set -euo pipefail
```

Let's break down what each flag does. But first, those short letters actually have full names:

| Short form | Long form | Meaning |
|------------|-----------|---------|
| `-e` | `-o errexit` | **err**or? **exit**. |
| `-u` | `-o nounset` | **no** **unset** variables allowed. |
| `-o pipefail` | `-o pipefail` | Already the long form. Catch failures in **pipe**lines. |

So `set -euo pipefail` is just a compact way of writing:

```bash
set -o errexit
set -o nounset
set -o pipefail
```

Both do the exact same thing. The short form is what you'll see in the wild because it's quicker to type, but now you know what those letters actually stand for.

### `set -e` (errexit)

**Without `-e`:**
```bash
#!/usr/bin/env bash
cp /nonexistent/file /tmp/backup    # This fails silently
echo "Backup complete!"              # This still runs (gaslights the user into believing that backup completed but it didnt, so it's bad) 
```

**With `-e`:**
```bash
#!/usr/bin/env bash
set -e
cp /nonexistent/file /tmp/backup    # This fails
echo "Backup complete!"              # This NEVER runs (good!)
```

The script stops immediately when any command returns a non-zero exit code.

### `set -u` (error on undefined variables)

**Without `-u`:**
```bash
#!/usr/bin/env bash
echo "Hello, $naem"    # Typo: "naem" instead of "name"
                        # Bash just prints "Hello, " and moves on
```

**With `-u`:**
```bash
#!/usr/bin/env bash
set -u
echo "Hello, $naem"    # Bash throws an error: "naem: unbound variable"
```

This catches typos in variable names instantly instead of letting them become weird silent bugs.

### `set -o pipefail` (catch failures in pipes)

A **pipe** (`|`) sends output from one command into another. By default, Bash only checks if the *last* command in the pipe succeeded.

**Without `pipefail`:**
```bash
#!/usr/bin/env bash
cat /nonexistent/file | grep "something"    # cat fails, but grep's exit code is used
echo "All good!"                             # This runs even though cat failed
```

**With `pipefail`:**
```bash
#!/usr/bin/env bash
set -o pipefail
cat /nonexistent/file | grep "something"    # The whole pipe fails because cat failed
echo "All good!"                             # Never runs
```

`pipefail` makes the entire pipe return the exit code of the *first* command that fails, not just the last one.

### All together

```bash
#!/usr/bin/env bash
set -euo pipefail
```

One line. Three safety checks. This is considered **best practice** for any script that does real work. You'll see it in professional scripts, deployment pipelines, and security tools.

### When NOT to use it

- **Quick throwaway one-liners** you're testing in the terminal: don't bother.
- **Scripts where you intentionally expect some commands to fail** (e.g., checking if a file exists before creating it): you can handle those with `if` statements or `|| true` to prevent the script from dying.

Example of handling expected failures:
```bash
#!/usr/bin/env bash
set -euo pipefail

# This might not exist, and that's fine
rm /tmp/old_log.txt 2>/dev/null || true

echo "Cleanup done."
```

The `|| true` at the end tells Bash: "if `rm` fails, that's okay, treat it as a success because we wanted to clean that file, if the file wasnt there, then we dont need to do anything so that's a success as well"

---

## 7) Practice script: putting it all together

Create this file:

```bash
nano lessons/lesson02_practice.sh
```

```bash
#!/usr/bin/env bash
set -euo pipefail

# --- Variables ---
course="Shell Scripting"
lesson="02"

# --- Arguments ---
if [ -z "${1:-}" ]; then
    read -p "No name provided. What's your name? " student
else
    student="$1"
fi

# --- Output ---
echo "==========================="
echo " Course: $course"
echo " Lesson: $lesson"
echo " Student: $student"
echo "==========================="
echo ""
echo "Hey $student, you just learned:"
echo "  - Variables and quoting"
echo "  - Reading user input"
echo "  - Positional arguments"
echo "  - set -euo pipefail"
echo ""
echo "You're building real skills. See you in Lesson 03."
```

**Note:** `${1:-}` is a neat trick. It means "use `$1` if it exists, otherwise use an empty string." This prevents `set -u` from screaming at us for accessing an undefined `$1` when no argument is passed.

### Run it both ways:

```bash
# With an argument
bash lessons/lesson02_practice.sh loki

# Without an argument (it will ask for your name)
bash lessons/lesson02_practice.sh
```

---

## Checkpoint quiz
1) What happens if you write `name = "loki"` (with spaces around `=`)?
2) What's the difference between `"Hello, $name"` and `'Hello, $name'`?
3) What does `$2` refer to in a script?
4) What does `set -u` protect you from?
5) Why is `set -o pipefail` important when using pipes?

---

## Progress update
You now understand:
- how to create and use variables (and the no-spaces rule)
- single vs double quoting
- environment variables vs local variables
- reading user input with `read`
- passing arguments to scripts (`$1`, `$2`, `$#`, `$@`)
- the `set -euo pipefail` safety net and what each flag does

---

## Next lesson
Next we'll learn:
- conditionals (`if`, `else`, `elif`)
- comparisons and test expressions (`[ ]`, `-eq`, `-f`, `-d`, etc.)
- writing scripts that make decisions

See you in Lesson 03.
