# Lesson 03 — Conditionals and Comparisons

## TL;DR
- **`if`/`else`/`elif`** let your script make decisions based on conditions.
- **Test expressions** (`[ ]`) are how you check things like "is this string empty?", "is this number bigger?", "does this file exist?"
- There are different comparison operators for **strings**, **numbers**, and **files**.
- You'll write scripts that react differently depending on the input they receive.

---

## Keywords
- **Conditional:** A block of code that only runs if a certain condition is true.
- **`if`:** Starts a conditional block. "If this is true, do this."
- **`else`:** The fallback. "If the condition wasn't true, do this instead."
- **`elif`:** Short for "else if." Lets you check multiple conditions one after another.
- **`fi`:** Closes an `if` block. It's `if` spelled backwards (you saw this in Lesson 02).
- **Test expression (`[ ]`):** A way to evaluate a condition. Returns true or false.
- **`-eq`, `-ne`, `-gt`, `-lt`, `-ge`, `-le`:** Comparison operators for numbers.
- **`=`, `!=`:** Comparison operators for strings.
- **`-f`:** Checks if a file exists (and is a regular file).
- **`-d`:** Checks if a directory exists.
- **`-z`:** Checks if a string is empty (zero length).
- **`-n`:** Checks if a string is NOT empty.

---

## 1) The basic `if` statement

The simplest form:

```bash
if [ condition ]; then
    # do something
fi
```

That's it. If the condition inside `[ ]` is true, the code between `then` and `fi` runs. If it's false, nothing happens and the script moves on.

### A simple example

```bash
nano lessons/lesson03_age.sh
```

```bash
#!/usr/bin/env bash

age=18

if [ "$age" -ge 18 ]; then
    echo "You are an adult."
fi
```

**Line-by-line explanation:**
- `age=18` — a variable holding a number.
- `[ "$age" -ge 18 ]` — tests if `age` is **g**reater than or **e**qual to 18. The `-ge` stands for "greater or equal."
- `echo "You are an adult."` — only prints if the condition is true.
- `fi` — end of the `if` block.

### Run it:
```bash
bash lessons/lesson03_age.sh
```

Output:
```
You are an adult.
```

> **Important:** Always leave spaces inside `[ ]`. Writing `["$age" -ge 18]` without spaces will break. Bash is picky about this, just like the no-spaces rule around `=` from Lesson 02.

---

## 2) Adding `else`

What if the condition is false? That's where `else` comes in:

```bash
#!/usr/bin/env bash

age=15

if [ "$age" -ge 18 ]; then
    echo "You are an adult."
else
    echo "You are a minor."
fi
```

Now the script handles both cases. If `age` is 18 or above, it prints one thing. Otherwise, it prints the other.

> Think of `if/else` like a fork in the road. The script can only go one way, and the condition decides which.

---

## 3) Checking multiple conditions with `elif`

Sometimes you need more than two paths. That's what `elif` (else if) does:

```bash
nano lessons/lesson03_grade.sh
```

```bash
#!/usr/bin/env bash

score=72

if [ "$score" -ge 90 ]; then
    echo "Grade: A"
elif [ "$score" -ge 80 ]; then
    echo "Grade: B"
elif [ "$score" -ge 70 ]; then
    echo "Grade: C"
elif [ "$score" -ge 60 ]; then
    echo "Grade: D"
else
    echo "Grade: F"
fi
```

### Run it:
```bash
bash lessons/lesson03_grade.sh
```

Output:
```
Grade: C
```

**How it works:**
- Bash checks each condition from top to bottom.
- The first one that is true gets executed, and all the rest are skipped.
- `else` at the bottom is the catch-all. If none of the conditions above matched, this runs.

> Try changing `score` to different values and running it again. See which grade you get.

---

## 4) Number comparisons

When comparing numbers in `[ ]`, you use these operators:

| Operator | Meaning | Example |
|----------|---------|---------|
| `-eq` | equal to | `[ "$a" -eq 10 ]` |
| `-ne` | not equal to | `[ "$a" -ne 10 ]` |
| `-gt` | greater than | `[ "$a" -gt 10 ]` |
| `-lt` | less than | `[ "$a" -lt 10 ]` |
| `-ge` | greater or equal | `[ "$a" -ge 10 ]` |
| `-le` | less or equal | `[ "$a" -le 10 ]` |

### Why not `>` and `<`?

Inside `[ ]`, the `>` and `<` symbols mean something else entirely (they deal with string/alphabetical sorting, not numbers). So Bash uses `-gt`, `-lt`, etc. for number comparisons.

> This is one of those things that feels weird at first but becomes natural after you write a few scripts.

---

## 5) String comparisons

Strings (text) use different operators:

| Operator | Meaning | Example |
|----------|---------|---------|
| `=` | strings are equal | `[ "$name" = "loki" ]` |
| `!=` | strings are NOT equal | `[ "$name" != "loki" ]` |
| `-z` | string is empty | `[ -z "$name" ]` |
| `-n` | string is NOT empty | `[ -n "$name" ]` |

### Example: checking a password

```bash
nano lessons/lesson03_password.sh
```

```bash
#!/usr/bin/env bash

read -sp "Enter the secret word: " answer
echo ""

if [ "$answer" = "abracadabra" ]; then
    echo "Access granted."
else
    echo "Wrong password."
fi
```

### Run it:
```bash
bash lessons/lesson03_password.sh
```

Type "abracadabra" and you get in. Type anything else and you don't.

**Line-by-line explanation:**
- `read -sp "..." answer` — asks for input silently (no characters shown on screen, you learned this in Lesson 02).
- `[ "$answer" = "abracadabra" ]` — checks if what the user typed matches the string "abracadabra" exactly.
- If it matches, access granted. If not, denied.

> Always quote your variables in comparisons like `"$answer"`. If the variable is empty and you don't quote it, Bash will see `[ = "abracadabra" ]` which makes no sense and throws an error.

---

## 6) File and directory checks

Bash can check if files and directories exist, which is incredibly useful for scripts that work with the filesystem.

| Operator | Meaning |
|----------|---------|
| `-f` | file exists (and is a regular file) |
| `-d` | directory exists |
| `-e` | anything exists (file, directory, link, etc.) |
| `-r` | file is readable |
| `-w` | file is writable |
| `-x` | file is executable |

### Example: checking before writing

```bash
nano lessons/lesson03_filecheck.sh
```

```bash
#!/usr/bin/env bash

filename="notes.txt"

if [ -f "$filename" ]; then
    echo "$filename already exists. Not overwriting."
else
    echo "Hello from Lesson 03" > "$filename"
    echo "Created $filename."
fi
```

### Run it:
```bash
bash lessons/lesson03_filecheck.sh
```

**What happens:**
- First run: `notes.txt` doesn't exist, so the script creates it.
- Second run: `notes.txt` already exists, so the script tells you and doesn't overwrite it.

**Line-by-line explanation:**
- `filename="notes.txt"` — storing the filename in a variable so we don't repeat it everywhere.
- `[ -f "$filename" ]` — checks if a file called `notes.txt` exists.
- `echo "..." > "$filename"` — the `>` redirects the output of `echo` into the file (creates it if it doesn't exist, overwrites if it does). This is file redirection, we'll cover it more in a later lesson.

> You can clean up after yourself by running `rm notes.txt` to delete the file and test the script again.

---

## 7) Combining conditions with AND and OR

Sometimes you need to check more than one thing at once.

### AND: both conditions must be true

Use `-a` inside `[ ]`, or `&&` between two separate `[ ]` blocks:

```bash
age=20
name="loki"

# Using &&
if [ "$age" -ge 18 ] && [ "$name" = "loki" ]; then
    echo "Welcome, adult Loki."
fi
```

### OR: at least one condition must be true

Use `-o` inside `[ ]`, or `||` between two separate `[ ]` blocks:

```bash
day="Saturday"

if [ "$day" = "Saturday" ] || [ "$day" = "Sunday" ]; then
    echo "It's the weekend!"
else
    echo "It's a weekday."
fi
```

### NOT: flip a condition

Use `!` before the condition:

```bash
name=""

if [ ! -n "$name" ]; then
    echo "Name is empty."
fi
```

This checks "if name is NOT non-empty" which means "if name is empty." You could also write this as `[ -z "$name" ]` and it would do the same thing.

> **Tip:** `&&` and `||` between `[ ]` blocks are the more common and readable style. You'll see them everywhere.

---

## 8) Making the greeter smarter

Let's take the simple greeter from Lesson 02 and make it smarter with conditionals:

```bash
nano lessons/lesson03_smartgreet.sh
```

```bash
#!/usr/bin/env bash

read -p "What's your name? " name

if [ -z "$name" ]; then
    echo "You didn't type anything. I'll call you stranger."
    name="stranger"
fi

read -p "How old are you? " age

if [ "$age" -lt 13 ]; then
    echo "Hey $name, you're pretty young to be learning shell scripting. Gang you goat for real."
elif [ "$age" -lt 18 ]; then
    echo "Nice, $name. You're getting a head start before most people even know what a terminal is."
else
    echo "Welcome, $name. Let's get to work."
fi
```

### Run it:
```bash
bash lessons/lesson03_smartgreet.sh
```

This script uses everything from this lesson:
- `-z` to check for empty input
- `-lt` for number comparisons
- `if`/`elif`/`else` for multiple paths
- Variables and `read` from Lesson 02

---

## 9) Quick reference: `[ ]` syntax rules

Before you go, here are the common mistakes people make with `[ ]`:

| Mistake | Fix |
|---------|-----|
| `[$name = "loki"]` | `[ "$name" = "loki" ]` — spaces inside brackets are required |
| `[ $name = "loki" ]` | `[ "$name" = "loki" ]` — always quote variables |
| `[ "$a" > "$b" ]` | `[ "$a" -gt "$b" ]` — use `-gt` for numbers, not `>` |
| `if [ ... ]` without `then` | `if [ ... ]; then` — `then` is required |
| Forgetting `fi` | Every `if` needs a `fi` to close it |

---

## Checkpoint quiz
1) What does `elif` do, and when would you use it instead of just `else`?
2) What's the difference between `=` and `-eq` in a test expression?
3) What does `[ -f "myfile.txt" ]` check?
4) Why do we always put quotes around variables inside `[ ]`?
5) How do you check if a number is less than 10?

---

## Progress update
You now understand:
- `if`, `else`, and `elif` for making decisions
- number comparisons (`-eq`, `-ne`, `-gt`, `-lt`, `-ge`, `-le`)
- string comparisons (`=`, `!=`, `-z`, `-n`)
- file and directory checks (`-f`, `-d`, `-e`, `-r`, `-w`, `-x`)
- combining conditions with `&&`, `||`, and `!`
- common `[ ]` syntax mistakes and how to avoid them

---

## Next lesson
Next we'll learn:
- loops (`for`, `while`)
- iterating over files, lists, and ranges
- writing scripts that repeat tasks automatically

See you in Lesson 04.
