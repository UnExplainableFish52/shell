# Lesson 05 — Functions

## TL;DR
- **Functions** let you group commands into reusable blocks with a name.
- You call a function the same way you'd run a command: just type its name.
- Functions can take **arguments** (`$1`, `$2`, etc.) just like scripts do.
- **`local`** keeps variables scoped to the function so they don't leak into the rest of your script.
- **Return values** (`return`) set an exit code. For actual data, you `echo` from the function and capture it.
- Functions are what turn a messy 200-line script into something readable and maintainable.

---

## Keywords
- **Function:** A named block of code you can call by name whenever you need it.
- **`local`:** Declares a variable that only exists inside the function it's defined in.
- **Scope:** Where a variable is visible. A `local` variable's scope is the function; a regular variable is visible everywhere in the script.
- **`return`:** Exits the function with an exit code (0-255). NOT for returning strings or data.
- **`$?`:** Holds the exit code of the most recently finished command (or function call).
- **Command substitution (`$(...)`):** Captures the output (stdout) of a command or function call into a variable.

---

## 1) What's a function and why bother?

Imagine you have a chunk of code that you need to run in three different places in your script. Without functions, you copy-paste those lines three times. Then when you need to fix a bug in that logic, you fix it in three places (and probably forget one).

Functions solve that. Write the logic once, give it a name, call it whenever you need it.

### Basic syntax

There are two ways to define a function in Bash:

```bash
# Style 1 (most common)
greet() {
    echo "Hello!"
}

# Style 2 (uses the 'function' keyword)
function greet {
    echo "Hello!"
}
```

Both do the same thing. Style 1 is more portable (works in `sh`, `bash`, `zsh`). Style 2 is Bash-specific. You'll see both in the wild, but stick with Style 1 for consistency.

### Calling a function

You call it by name, no parentheses, no special syntax:

```bash
greet
```

That's it. Just the name. Bash sees `greet`, realizes it's a function you defined, and runs the code inside `{ }`.

---

## 2) Your first function script

```bash
nano lessons/lesson05_greet.sh
```

```bash
#!/usr/bin/env bash

greet() {
    echo "Hello from inside the function!"
}

echo "Before the function call."
greet
echo "After the function call."
```

### Run it:
```bash
bash lessons/lesson05_greet.sh
```

Output:
```
Before the function call.
Hello from inside the function!
After the function call.
```

**What happened:**
- Lines 3-5 **define** the function. Nothing runs yet. The function just gets registered so Bash knows about it.
- Line 7 prints "Before..."
- Line 8 **calls** the function. Bash jumps into the function body, runs `echo`, then comes back.
- Line 9 prints "After..."

> **Important:** You must define a function *before* you call it. If you try to call `greet` on line 2 but define it on line 10, Bash will say "command not found." This isn't like some other languages where order doesn't matter.

---

## 3) Functions with arguments

Functions take arguments the same way scripts do. You pass them after the function name, separated by spaces, and access them inside the function with `$1`, `$2`, `$#`, `$@`, etc.

```bash
nano lessons/lesson05_args.sh
```

```bash
#!/usr/bin/env bash

greet() {
    local name="$1"
    local time_of_day="$2"

    echo "Good $time_of_day, $name!"
}

greet "loki" "morning"
greet "thor" "evening"
greet "freya" "afternoon"
```

### Run it:
```bash
bash lessons/lesson05_args.sh
```

Output:
```
Good morning, loki!
Good evening, thor!
Good afternoon, freya!
```

**Line-by-line explanation:**
- `greet() { ... }` — defines the function.
- `local name="$1"` — takes the first argument passed to the function and stores it in a local variable called `name`. The `local` keyword means this variable only exists inside `greet`.
- `local time_of_day="$2"` — same deal with the second argument.
- `greet "loki" "morning"` — calls the function with two arguments. Inside the function, `$1` is `"loki"` and `$2` is `"morning"`.

> Notice: `$1` inside a function refers to the function's first argument, NOT the script's first argument. The function has its own set of positional parameters. This is something that confuses people early on.

---

## 4) Local vs global variables (scope)

This is where things get interesting and where bugs love to hide if you're not careful.

### Without `local` (global by default)

```bash
#!/usr/bin/env bash

set_name() {
    name="loki"
}

name="stranger"
echo "Before: $name"

set_name
echo "After: $name"
```

Output:
```
Before: stranger
After: loki
```

The function *changed* the outer variable. `name` inside the function is the **same** `name` as outside. This is called **global scope**, and it's the default in Bash.

### With `local` (contained)

```bash
#!/usr/bin/env bash

set_name() {
    local name="loki"
    echo "Inside function: $name"
}

name="stranger"
echo "Before: $name"

set_name
echo "After: $name"
```

Output:
```
Before: stranger
Inside function: loki
After: stranger
```

Now the function's `name` is a completely separate variable. The outer `name` is untouched.

> **Rule of thumb:** Always use `local` for variables inside functions unless you specifically *intend* to modify something globally. This prevents subtle bugs where a function accidentally overwrites a variable you were using elsewhere.

---

## 5) Return values vs output

This is the single biggest source of confusion with Bash functions, so let's get it right.

### `return` sets an exit code (a number, 0-255)

```bash
is_even() {
    if [ $(($1 % 2)) -eq 0 ]; then
        return 0    # success = true
    else
        return 1    # failure = false
    fi
}
```

`return` is like `exit` but for functions. It doesn't terminate the whole script, just the function. And the value you return is an **exit code**, same concept as Lesson 02: `0` means success, anything else means failure.

You check the return value with `$?` or use the function directly in an `if`:

```bash
if is_even 4; then
    echo "4 is even"
fi
```

This works because `if` checks the exit code of whatever command you give it. If `is_even` returns 0 (success), the `if` body runs.

### For actual data, use `echo` + command substitution

`return` can only give you a number between 0 and 255. If you want to get a string, a filename, a computed result, anything that isn't just "yes/no", you `echo` it and capture the output:

```bash
get_greeting() {
    local name="$1"
    echo "Hello, $name"
}

message=$(get_greeting "loki")
echo "$message"
```

Output:
```
Hello, loki
```

**What's happening:**
- `get_greeting "loki"` runs the function.
- The function `echo`s `"Hello, loki"` to stdout.
- `$(...)` captures that stdout output.
- `message` now holds `"Hello, loki"`.

> This is the standard pattern: `return` for success/failure status, `echo` for data. Don't try to use `return` to send back a string. It won't work.

---

## 6) A practical example: putting it together

```bash
nano lessons/lesson05_fileutil.sh
```

```bash
#!/usr/bin/env bash
set -euo pipefail

# --- Function: check if a file exists ---
file_exists() {
    local path="$1"

    if [ -f "$path" ]; then
        return 0
    else
        return 1
    fi
}

# --- Function: count lines in a file ---
count_lines() {
    local path="$1"
    local lines

    lines=$(wc -l < "$path")
    echo "$lines"
}

# --- Function: print a separator ---
separator() {
    echo "================================="
}

# --- Main script ---
separator
echo " File Utility"
separator
echo ""

target="${1:-}"

if [ -z "$target" ]; then
    echo "Usage: bash lessons/lesson05_fileutil.sh <filename>"
    exit 1
fi

if file_exists "$target"; then
    echo "File found: $target"
    line_count=$(count_lines "$target")
    echo "Line count: $line_count"
else
    echo "File not found: $target"
    exit 1
fi

separator
```

### Run it:
```bash
# Check a file that exists
bash lessons/lesson05_fileutil.sh lessons/lesson05_fileutil.sh

# Check a file that doesn't exist
bash lessons/lesson05_fileutil.sh nope.txt
```

**What's going on:**
- `file_exists` — takes a path, returns 0 (success) if the file exists, 1 (failure) if it doesn't. Used directly in an `if`.
- `count_lines` — takes a path, echoes the number of lines. We capture the output with `$(count_lines "$target")`.
- `separator` — just prints a line. Simple helper to keep the output neat.
- The main script uses all three functions. Notice how the main logic reads almost like plain English: "if file exists, count lines." That's the power of well-named functions.

> **`wc -l < "$path"`** — `wc -l` counts lines. The `<` feeds the file's content into `wc` as stdin. We do it this way (instead of `wc -l "$path"`) because the second form includes the filename in the output, and we just want the number.

---

## 7) Functions calling other functions

Functions can call other functions. There's nothing special about it; as long as the function you're calling is defined before the call happens, it works.

```bash
#!/usr/bin/env bash

log_info() {
    echo "[INFO] $1"
}

log_error() {
    echo "[ERROR] $1" >&2
}

check_file() {
    local path="$1"

    if [ -f "$path" ]; then
        log_info "Found: $path"
    else
        log_error "Missing: $path"
        return 1
    fi
}

check_file "/etc/hostname"
check_file "/nonexistent/file"
```

**What's `>&2` doing?**
- `>&2` redirects the output to **stderr** (standard error) instead of stdout. Error messages should go to stderr so they don't mix with normal output. This is a good habit to build.

> This is how real scripts are structured. You build small, focused functions and compose them together. Each function does one thing well.

---

## 8) Default values for function arguments

In Lesson 02 you learned `${1:-}` to safely handle missing script arguments with `set -u`. The same trick works inside functions, and you can use it to set defaults:

```bash
greet() {
    local name="${1:-stranger}"
    local greeting="${2:-Hello}"

    echo "$greeting, $name!"
}

greet "loki" "Hey"    # Hey, loki!
greet "thor"          # Hello, thor!
greet                 # Hello, stranger!
```

`${1:-stranger}` means "use `$1` if it was provided, otherwise use `stranger`." Clean and defensive.

---

## 9) Practice script: putting it all together

Create this file:

```bash
nano lessons/lesson05_practice.sh
```

```bash
#!/usr/bin/env bash
set -euo pipefail

# --- Helper functions ---

print_header() {
    echo ""
    echo "============================="
    echo "  $1"
    echo "============================="
    echo ""
}

print_item() {
    echo "  [$1] $2"
}

confirm() {
    local prompt="${1:-Continue?}"
    local answer

    read -p "$prompt [y/n]: " answer
    if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
        return 0
    else
        return 1
    fi
}

count_scripts() {
    local dir="${1:-.}"
    local count=0

    for f in "$dir"/*.sh; do
        if [ -f "$f" ]; then
            count=$((count + 1))
        fi
    done

    echo "$count"
}

# --- Main ---

print_header "Lesson 05 Practice"

echo "This script demonstrates functions in action."
echo ""

# Using count_scripts
total=$(count_scripts "lessons")
echo "Found $total shell scripts in the lessons/ directory."
echo ""

# Listing them with print_item
n=1
for script in lessons/*.sh; do
    if [ -f "$script" ]; then
        print_item "$n" "$(basename "$script")"
        n=$((n + 1))
    fi
done

echo ""

# Using confirm
if confirm "Do you want to see a greeting?"; then
    echo ""
    echo "Hey! You've now learned functions."
    echo "Your scripts can be clean, organized, and reusable."
else
    echo ""
    echo "Alright, no greeting. But you still learned functions."
fi

echo ""
echo "See you in Lesson 06."
```

### Run it:
```bash
bash lessons/lesson05_practice.sh
```

**What's happening (overview):**
- `print_header` and `print_item` are tiny formatting helpers. They keep the main script clean.
- `confirm` is a reusable yes/no prompt. Returns 0 for yes, 1 for no. Used directly in an `if`.
- `count_scripts` counts `.sh` files in a directory. Uses `echo` to return the number.
- The main script reads like a story because the messy details are tucked away inside functions.

### Detailed breakdown

Let's go through the trickier parts line by line.

**`count_scripts` — how the counting works:**

```bash
count_scripts() {
    local dir="${1:-.}"   # use the argument, or "." (current dir) if none given
    local count=0

    for f in "$dir"/*.sh; do
        if [ -f "$f" ]; then
            count=$((count + 1))
        fi
    done

    echo "$count"
}
```

- `"${1:-.}"` — you learned this in Lesson 02. It means: use `$1` if it was provided, otherwise fall back to `.` (the current directory). So if you call `count_scripts` with no argument, it counts scripts in the directory you're currently in.
- `for f in "$dir"/*.sh` — this is a **glob pattern**. Bash expands `"$dir"/*.sh` into a list of every filename in that directory ending in `.sh`. `f` takes the value of each filename, one by one, as the loop runs.
- `if [ -f "$f" ]` — the glob `*.sh` *could* match nothing, in which case Bash sets `f` to the literal string `lessons/*.sh` (the unexpanded pattern itself). The `[ -f "$f" ]` check guards against that: it makes sure `$f` is actually a real file before counting it. If the directory is empty or has no `.sh` files, `count` stays 0.
- `count=$((count + 1))` — arithmetic expansion. `$(( ))` does the math and assigns the result back to `count`.
- `echo "$count"` — this is how the function "returns" the number. Remember: `return` only works for exit codes (0–255). To send actual data back, you `echo` it, and the caller captures it with `$(...)`.

At the call site:
```bash
total=$(count_scripts "lessons")
```
`$(...)` runs `count_scripts "lessons"`, captures everything it `echo`'d, and stores it in `total`. So `total` ends up holding a number like `3` or `7`.

---

**`print_item` — the nested command substitution:**

```bash
print_item "$n" "$(basename "$script")"
```

This looks dense, but break it apart:

1. `basename "$script"` — `basename` strips the directory prefix from a path. So `lessons/lesson05_greet.sh` becomes just `lesson05_greet.sh`.
2. `$(basename "$script")` — command substitution: runs `basename "$script"` and replaces `$(...)` with its output. So this whole thing evaluates to the bare filename.
3. `print_item "$n" "..."` — calls `print_item` with two arguments: the current number `$n`, and the bare filename from step 2.

Inside `print_item`:
```bash
print_item() {
    echo "  [$1] $2"
}
```
`$1` is the number, `$2` is the filename. So you get output like:
```
  [1] lesson05_greet.sh
  [2] lesson05_args.sh
```

---

**`confirm` used directly in an `if`:**

```bash
if confirm "Do you want to see a greeting?"; then
```

This confuses people because you're not comparing anything — you're just calling a function as the condition. Here's why it works:

`if` doesn't care about comparisons. It only cares about **exit codes**. After running whatever command you give it, `if` checks the exit code:
- Exit code `0` → condition is **true**, run the `then` block.
- Any other exit code → condition is **false**, run the `else` block.

`confirm` reads user input and runs `return 0` if the user typed `y` or `Y`, and `return 1` otherwise. So `if confirm "..."` is exactly equivalent to asking the user a question and branching based on their answer. The function's `return` value *is* the true/false signal for the `if`.

This is the same mechanism as `if file_exists "$target"` from section 6 — functions that return 0/1 can be used directly as `if` conditions.

> This is how professional scripts are written. The main logic is short and readable. The helper functions handle the details. Anyone reading the script can understand what it does at a glance, and dig into individual functions only when they need to.

---

## 10) Quick reference: function syntax

| Pattern | Example | Use when |
|---------|---------|----------|
| Define a function | `myfunc() { ... }` | You need reusable logic |
| Call a function | `myfunc` | You want to run that logic |
| Pass arguments | `myfunc "arg1" "arg2"` | The function needs input |
| Access arguments | `$1`, `$2`, `$@`, `$#` | Inside the function body |
| Local variable | `local x="value"` | You don't want to pollute global scope |
| Return exit code | `return 0` or `return 1` | Success/failure signaling |
| Return data | `echo "result"` | You need to send back a string/value |
| Capture output | `result=$(myfunc "arg")` | You need the echoed value in a variable |
| Default argument | `local x="${1:-default}"` | Handle missing arguments gracefully |

---

## Checkpoint quiz
1) What's the difference between `return` and `echo` in a function?
2) What happens if you don't use `local` for a variable inside a function?
3) How do you capture a function's output into a variable?
4) Does `$1` inside a function refer to the script's first argument or the function's first argument?
5) Why should error messages use `>&2`?

---

## Progress update
You now understand:
- how to define and call functions
- passing arguments to functions (`$1`, `$2`, etc.)
- `local` variables and why scope matters
- the difference between `return` (exit code) and `echo` (data output)
- capturing function output with `$(...)`
- default argument values with `${1:-default}`
- structuring scripts with small, focused helper functions
- redirecting errors to stderr with `>&2`

---

## Next lesson
Next we'll learn:
- input/output redirection (`>`, `>>`, `<`, `2>`)
- pipes and pipelines in depth
- useful text-processing commands (`grep`, `cut`, `sort`, `wc`, `head`, `tail`)
- chaining commands together to build powerful one-liners

See you in Lesson 06.
