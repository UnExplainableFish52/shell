# Lesson 04 — Loops and Iteration

## TL;DR
- **`for` loops** let you repeat an action for each item in a list, range, or set of files.
- **`while` loops** keep running as long as a condition stays true.
- **`break`** and **`continue`** give you control inside loops (stop early or skip an iteration).
- Loops are where scripting starts feeling genuinely powerful. Instead of doing something once, you do it a thousand times with one script.

---

## Keywords
- **Loop:** A block of code that runs repeatedly until a condition changes.
- **Iteration:** One pass through the loop body. If a loop runs 5 times, that's 5 iterations.
- **`for`:** Loops over a list of items, running the body once per item.
- **`while`:** Keeps looping as long as a condition is true.
- **`do` / `done`:** Mark the start and end of the loop body (like `then` / `fi` for `if` statements).
- **`break`:** Immediately exits the loop, no matter what.
- **`continue`:** Skips the rest of the current iteration and jumps to the next one.
- **`seq`:** A command that generates a sequence of numbers (e.g., `seq 1 10` gives you 1 through 10).
- **Glob:** A wildcard pattern like `*.txt` that matches filenames. The shell expands it into a list of matching files.

---

## 1) The `for` loop: doing something for each item

The most common loop you'll write. It takes a list of things and runs the body once for each one.

### Basic syntax

```bash
for variable in item1 item2 item3; do
    # do something with $variable
done
```

That's the shape. `variable` takes on each value in the list, one at a time, and the code between `do` and `done` runs for each one.

### A simple example

```bash
nano lessons/lesson04_names.sh
```

```bash
#!/usr/bin/env bash

for name in loki thor odin freya; do
    echo "Hello, $name!"
done
```

### Run it:
```bash
bash lessons/lesson04_names.sh
```

Output:
```
Hello, loki!
Hello, thor!
Hello, odin!
Hello, freya!
```

**What happened:**
- The loop goes through the list `loki thor odin freya`.
- On each iteration, `name` holds the current item.
- `echo` prints the greeting, then the loop moves to the next item.
- After the last item, the loop ends and the script continues past `done`.

---

## 2) Looping over a range of numbers

You'll often want to loop from 1 to some number. Bash has a built-in way to do that.

### Brace expansion

```bash
for i in {1..5}; do
    echo "Count: $i"
done
```

Output:
```
Count: 1
Count: 2
Count: 3
Count: 4
Count: 5
```

`{1..5}` expands to `1 2 3 4 5` before the loop even starts. Bash does this expansion for you.

### With a step value

```bash
for i in {0..20..5}; do
    echo "$i"
done
```

Output:
```
0
5
10
15
20
```

`{0..20..5}` means "start at 0, go to 20, step by 5."

### Using `seq` (the classic way)

```bash
for i in $(seq 1 10); do
    echo "Number: $i"
done
```

`seq 1 10` generates numbers 1 through 10. The `$(...)` runs the command and puts its output in place (this is called **command substitution**, we'll cover it more later but it's straightforward here).

> **When to use which:** Brace expansion `{1..10}` is simpler and doesn't spawn an extra process. `seq` is more flexible (it handles variables, which brace expansion can't). Use whichever makes sense for the situation.

---

## 3) Looping over files

This is where loops start saving you real time. Instead of running a command on each file one by one, you let the loop handle it.

### Example: listing all `.sh` files in the lessons folder

```bash
nano lessons/lesson04_listfiles.sh
```

```bash
#!/usr/bin/env bash

echo "Shell scripts in this directory:"
echo ""

for file in lessons/*.sh; do
    echo "  - $file"
done
```

### Run it:
```bash
bash lessons/lesson04_listfiles.sh
```

**What happens:**
- `lessons/*.sh` is a glob pattern. The shell expands it into a list of every file matching that pattern (e.g., `lessons/lesson01_hello.sh`, `lessons/lesson02_greet.sh`, etc.).
- The loop then iterates over each matching file.
- If no files match, the glob stays as the literal string `lessons/*.sh`, which can be confusing. We'll handle that edge case later.

### Example: batch renaming (preview only)

Let's say you have a bunch of `.txt` files and you want to see what renaming them to `.bak` would look like:

```bash
for file in *.txt; do
    echo "Would rename: $file -> ${file%.txt}.bak"
done
```

**What's `${file%.txt}` doing?**
- This is **parameter expansion**. `${variable%pattern}` removes the shortest match of `pattern` from the end of the variable.
- So if `file` is `notes.txt`, then `${file%.txt}` gives you `notes`.
- We then stick `.bak` on the end: `notes.bak`.

> Don't worry about memorizing every form of parameter expansion right now. Just know it exists and come back to it when you need it. The key takeaway is: Bash can manipulate strings without needing external tools.

---

## 4) The `while` loop: keep going until something changes

A `while` loop runs as long as its condition is true. The moment the condition becomes false, the loop stops.

### Basic syntax

```bash
while [ condition ]; do
    # do something
done
```

Looks a lot like an `if` statement, right? Same `[ ]` test expressions, same operators. The only difference is: `if` checks once, `while` checks *every iteration*.

### A simple counter

```bash
nano lessons/lesson04_counter.sh
```

```bash
#!/usr/bin/env bash

count=1

while [ "$count" -le 5 ]; do
    echo "Count: $count"
    count=$((count + 1))
done

echo "Done counting."
```

### Run it:
```bash
bash lessons/lesson04_counter.sh
```

Output:
```
Count: 1
Count: 2
Count: 3
Count: 4
Count: 5
Done counting.
```

**Line-by-line explanation:**
- `count=1` — start at 1.
- `[ "$count" -le 5 ]` — keep looping while `count` is **l**ess than or **e**qual to 5 (you know these from Lesson 03).
- `count=$((count + 1))` — increment the counter by 1 each time. `$(( ))` is Bash's way of doing **arithmetic**. Without this line, `count` would stay at 1 forever and the loop would never end (an **infinite loop**, which you'd have to kill with `Ctrl+C`).
- Once `count` hits 6, the condition `[ 6 -le 5 ]` is false, so the loop stops.

---

## 5) Reading a file line by line

One of the most practical uses of `while`: processing a file one line at a time.

### Create a test file first

```bash
echo -e "192.168.1.1\n192.168.1.2\n192.168.1.3\n10.0.0.1" > lessons/targets.txt
```

This creates a file called `targets.txt` with four IP addresses, one per line.

### Now write the script

```bash
nano lessons/lesson04_readline.sh
```

```bash
#!/usr/bin/env bash

input="lessons/targets.txt"

if [ ! -f "$input" ]; then
    echo "File not found: $input"
    exit 1
fi

echo "Reading targets from $input:"
echo ""

while IFS= read -r line; do
    echo "  Target: $line"
done < "$input"

echo ""
echo "Done. Total lines processed."
```

### Run it:
```bash
bash lessons/lesson04_readline.sh
```

Output:
```
Reading targets from lessons/targets.txt:

  Target: 192.168.1.1
  Target: 192.168.1.2
  Target: 192.168.1.3
  Target: 10.0.0.1

Done. Total lines processed.
```

**Line-by-line explanation:**
- `[ ! -f "$input" ]` — checks if the file does NOT exist. If it doesn't, print an error and exit (you learned this in Lesson 03).
- `while IFS= read -r line; do` — this is the standard idiom for reading a file line by line.
  - `IFS=` — temporarily clears the Internal Field Separator so leading/trailing whitespace in each line isn't stripped.
  - `read -r line` — reads one line into the variable `line`. The `-r` flag prevents backslashes from being treated as escape characters.
- `done < "$input"` — the `<` feeds the file's contents into the `while` loop as input. Each iteration of `read` grabs the next line.

> This pattern (while + read + file redirection) shows up constantly in real scripts. Log parsers, config readers, batch processors... all use this.

---

## 6) `break` and `continue`: controlling the loop

Sometimes you don't want to run every single iteration. Maybe you want to stop early or skip certain items.

### `break` — exit the loop immediately

```bash
#!/usr/bin/env bash

for i in {1..100}; do
    if [ "$i" -eq 5 ]; then
        echo "Hit 5, stopping."
        break
    fi
    echo "Number: $i"
done

echo "Loop ended."
```

Output:
```
Number: 1
Number: 2
Number: 3
Number: 4
Hit 5, stopping.
Loop ended.
```

The loop was supposed to go to 100, but `break` killed it at 5. The script continues with whatever comes after the loop.

### `continue` — skip to the next iteration

```bash
#!/usr/bin/env bash

for i in {1..10}; do
    if [ "$i" -eq 3 ] || [ "$i" -eq 7 ]; then
        continue
    fi
    echo "Number: $i"
done
```

Output:
```
Number: 1
Number: 2
Number: 4
Number: 5
Number: 6
Number: 8
Number: 9
Number: 10
```

Numbers 3 and 7 are missing. When `continue` runs, it skips the rest of the loop body for that iteration and jumps straight to the next one.

> Think of `break` as "I'm done here, get me out" and `continue` as "skip this one, keep going."

---

## 7) Nested loops

You can put a loop inside another loop. The inner loop runs completely for each iteration of the outer loop.

```bash
#!/usr/bin/env bash

for row in A B C; do
    for col in 1 2 3; do
        echo "$row$col"
    done
done
```

Output:
```
A1
A2
A3
B1
B2
B3
C1
C2
C3
```

The outer loop picks a letter, then the inner loop runs through all three numbers before the outer loop moves to the next letter.

> You won't use nested loops every day, but they come up when you're working with grids, combinations, or scanning multiple things against each other (e.g., checking multiple hosts against multiple ports).

---

## 8) Infinite loops (on purpose)

Sometimes you *want* a loop that runs forever, for example a menu that keeps showing until the user chooses to exit.

```bash
#!/usr/bin/env bash

while true; do
    echo ""
    echo "1) Say hello"
    echo "2) Show date"
    echo "3) Quit"
    read -p "Pick an option: " choice

    if [ "$choice" = "1" ]; then
        echo "Hello there!"
    elif [ "$choice" = "2" ]; then
        date
    elif [ "$choice" = "3" ]; then
        echo "Bye."
        break
    else
        echo "Invalid option."
    fi
done
```

`while true` means the condition is always true, so the loop never stops on its own. The only way out is `break` (or `Ctrl+C` from the terminal).

> This is a common pattern for simple interactive menus. You'll see it in setup scripts, toolkits, and admin utilities.

---

## 9) Practice script: putting it all together

Create this file:

```bash
nano lessons/lesson04_practice.sh
```

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "=== Loop Practice ==="
echo ""

# --- Part 1: for loop over arguments ---
if [ "$#" -eq 0 ]; then
    echo "No arguments given. Pass some names to greet."
    echo "Usage: bash lessons/lesson04_practice.sh name1 name2 name3"
    exit 1
fi

echo "Greeting everyone:"
for person in "$@"; do
    echo "  Hey, $person!"
done

echo ""

# --- Part 2: counting with while ---
echo "Countdown:"
n=5
while [ "$n" -gt 0 ]; do
    echo "  $n..."
    n=$((n - 1))
done
echo "  Go!"

echo ""

# --- Part 3: looping over files ---
echo "Shell scripts found in lessons/:"
for script in lessons/*.sh; do
    if [ -f "$script" ]; then
        echo "  $(basename "$script")"
    fi
done

echo ""
echo "=== All done. See you in Lesson 05. ==="
```

**What's new here (overview):**
- `"$@"` — all arguments passed to the script, properly quoted. The `for` loop iterates over each one individually.
- `basename "$script"` — strips the directory path and gives you just the filename. So `lessons/lesson01_hello.sh` becomes `lesson01_hello.sh`.
- We're combining `for` loops, `while` loops, file checks from Lesson 03, and `set -euo pipefail` from Lesson 02. Everything stacks.

### Detailed breakdown

**Part 1 — `"$@"` and iterating over arguments:**

```bash
if [ "$#" -eq 0 ]; then
    echo "No arguments given. Pass some names to greet."
    echo "Usage: bash lessons/lesson04_practice.sh name1 name2 name3"
    exit 1
fi

echo "Greeting everyone:"
for person in "$@"; do
    echo "  Hey, $person!"
done
```

- `"$#"` — the number of arguments passed to the script. If you ran `bash lesson04_practice.sh loki thor`, then `$#` is `2`. If you ran it with no arguments, `$#` is `0`.
- `[ "$#" -eq 0 ]` — checks if zero arguments were given. If true, print a usage message and `exit 1` (non-zero = failure). This is a standard defensive guard at the top of scripts that require input.
- `"$@"` — expands to **all the arguments** you passed to the script, as separate quoted words. So `bash lesson04_practice.sh loki thor freya` means `$@` becomes `"loki" "thor" "freya"`.
- `for person in "$@"` — the loop takes each argument one at a time. First iteration: `person="loki"`. Second: `person="thor"`. And so on.

> **Why not just `$@` without quotes?** Without quotes, arguments with spaces break apart. If someone passed `"john doe"` as one argument, unquoted `$@` would split it into `john` and `doe` — two separate items. `"$@"` preserves each argument as one unit, even if it contains spaces.

---

**Part 2 — The countdown with `while` and arithmetic:**

```bash
n=5
while [ "$n" -gt 0 ]; do
    echo "  $n..."
    n=$((n - 1))
done
echo "  Go!"
```

- `n=5` — start the counter at 5.
- `[ "$n" -gt 0 ]` — loop while `n` is **g**reater **t**han 0. The moment `n` hits 0, this condition is false and the loop stops.
- `n=$((n - 1))` — subtract 1 from `n` each iteration. `$(( ))` is Bash's arithmetic block. Without this line, `n` would stay at 5 forever and the loop would never end (infinite loop).
- After the loop, `echo "  Go!"` runs — this line is outside the loop body, so it only prints once, after the countdown finishes.

The sequence: `n` goes 5 → 4 → 3 → 2 → 1 → 0. The `echo` runs *before* the decrement each time, so you see `5... 4... 3... 2... 1...`. Then the check `[ 0 -gt 0 ]` fails and the loop exits, printing `Go!`.

---

**Part 3 — The file glob with the `[ -f ]` guard and `basename`:**

```bash
for script in lessons/*.sh; do
    if [ -f "$script" ]; then
        echo "  $(basename "$script")"
    fi
done
```

- `lessons/*.sh` — a **glob pattern**. The shell expands this into a list of every file in the `lessons/` directory that ends in `.sh`, before the loop even starts running. So it might become `lessons/lesson01_hello.sh lessons/lesson02_greet.sh ...` etc.
- `if [ -f "$script" ]` — this guard exists because of an edge case: if there are **no** `.sh` files in that directory, the shell doesn't expand the glob at all. Instead, it leaves the literal string `lessons/*.sh` as the value of `$script`. The `[ -f "$script" ]` check makes sure `$script` is actually a real file before printing it — if the glob didn't match anything, the check fails and the body is skipped cleanly.
- `basename "$script"` — strips the directory part from the path. `lessons/lesson04_listfiles.sh` → `lesson04_listfiles.sh`. It's a small built-in command that takes a path and returns just the final filename without the folder prefix.
- `$(basename "$script")` — command substitution. The `$(...)` runs `basename "$script"` and replaces itself with the output. So `echo "  $(basename "$script")"` becomes `echo "  lesson04_listfiles.sh"` at runtime.

### Run it:

```bash
# With arguments
bash lessons/lesson04_practice.sh loki thor freya

# Without arguments (see the error message)
bash lessons/lesson04_practice.sh
```

---

## 10) Quick reference: loop syntax

| Loop type | Syntax | Use when |
|-----------|--------|----------|
| `for` (list) | `for x in a b c; do ... done` | You have a known list of items |
| `for` (range) | `for x in {1..10}; do ... done` | You need a sequence of numbers |
| `for` (files) | `for f in *.txt; do ... done` | You want to process matching files |
| `while` | `while [ condition ]; do ... done` | You need to repeat until something changes |
| `while` (read) | `while IFS= read -r line; do ... done < file` | You're reading a file line by line |
| `while true` | `while true; do ... done` | You want an infinite loop (exit with `break`) |

---

## Checkpoint quiz
1) What's the difference between a `for` loop and a `while` loop?
2) What does `{1..10..2}` expand to?
3) How do you read a file line by line in Bash?
4) What does `break` do inside a loop? What about `continue`?
5) Why is `count=$((count + 1))` necessary in a `while` counter loop?

---

## Progress update
You now understand:
- `for` loops over lists, ranges, and file globs
- `while` loops with conditions
- reading files line by line (the `while read` pattern)
- `break` and `continue` for loop control
- nested loops
- infinite loops with `while true`
- arithmetic with `$(( ))`

---

## Next lesson
Next we'll learn:
- functions (reusable blocks of code)
- local variables and scope
- return values and exit codes in functions
- writing cleaner, more organized scripts

See you in Lesson 05.
