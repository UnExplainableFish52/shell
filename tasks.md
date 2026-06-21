# Shell Project Objectives

This file is the project roadmap for the shell learning journey.

The goal is not to write random scripts. The goal is to build small real tools that teach shell scripting, Linux workflow, DevOps habits, security thinking, debugging, logging, testing, and clean documentation.

Each project should be useful by itself, safe to run in a lab, and good enough to use later as a reference.

## How to Use This Roadmap

Do the projects in order if possible. The early projects build habits that the later projects depend on.

For each project:

1. Understand the situation.
2. Build the smallest working version first.
3. Test it with fake or safe sample data.
4. Add options, logging, error handling, and dry-run mode.
5. Run ShellCheck.
6. Write a short README with usage examples.
7. Save a sample output file so the project is easy to review later.

Do not chase perfection on the first pass. Get it working, make it safe, then make it clean.

## Standard Rules for Every Project

Use these rules unless a project clearly says otherwise.

- Use Bash for scripts.
- Start scripts with `#!/usr/bin/env bash`.
- Use `set -euo pipefail` after you understand what each option does.
- Quote variables by default.
- Validate required files, directories, commands, and arguments before doing work.
- Add `--help` output for every real script.
- Add `--dry-run` before any script deletes, blocks, moves, restarts, or changes system state.
- Log important actions with timestamps.
- Use clear exit codes.
- Use functions when a script starts repeating logic.
- Keep config separate from code when values may change.
- Test on sample files before touching real system paths.
- Run `shellcheck` before calling the project done.

## Suggested Project Layout

Use a layout like this for every serious project:

```text
projects/
  01-project-name/
    README.md
    bin/
      tool-name.sh
    config/
      example.conf
    sample-data/
      input.log
    output/
      .gitkeep
    tests/
      manual-test-notes.md
```

This keeps the repo clean and makes every project easy to understand later.

## Project 0: Script Template and Local Lab

### Situation

Before building real tools, you need a repeatable base. Most beginner scripts fail because they have no argument handling, no help text, no logging, and no safe test folder.

### Objective

Create a reusable Bash script template and a local lab folder that every later project can use.

### Build

- A script template with:
  - shebang
  - strict mode
  - `usage` function
  - argument parsing
  - `log_info`, `log_warn`, and `log_error` functions
  - `die` function
  - dry-run support
  - basic cleanup with `trap`
- A local lab setup script that creates safe folders for testing:
  - `lab/input`
  - `lab/output`
  - `lab/logs`
  - `lab/tmp`
- A short README explaining how to start a new project from the template.

### Skills You Learn

- Script structure
- Functions
- Arguments
- Logging
- Safe defaults
- Exit codes
- Repeatable local testing

### Done When

- You can copy the template into a new project and run `--help`.
- The lab setup script creates folders safely and can run more than once.
- ShellCheck passes or every warning is understood and documented.

## Project 1: Failed SSH Login Monitor

### Situation

A cloud server is receiving brute force SSH login attempts. The security team needs a script that reads SSH auth logs, counts failed attempts per IP, and alerts when an IP crosses a limit.

### Objective

Parse SSH authentication logs, group failed login attempts by source IP, and alert when an IP exceeds a threshold inside a time window.

### Build

- Start with a sample `auth.log` file inside `sample-data`.
- Parse failed SSH login lines.
- Extract:
  - timestamp
  - username if available
  - source IP
  - reason if available
- Count failures per IP.
- Add options:
  - `--file path`
  - `--threshold number`
  - `--window minutes`
  - `--watch`
  - `--dry-run`
  - `--block`
- In dry-run mode, print what would happen.
- In block mode, write the blocked IP to a local blocklist file first.
- Only later, and only in a lab, connect it to a real firewall command.

### Real Workflow Practice

- Build from sample logs first.
- Keep auto-blocking disabled by default.
- Record all alerts in an audit log.
- Make the output easy to read during an incident.

### Skills You Learn

- `grep`, `awk`, `sed`, `sort`, `uniq`
- Log parsing
- Counting and grouping data
- Time window thinking
- Safe security automation
- Dry-run mode

### Done When

- The script correctly reports top failed login IPs from sample logs.
- Threshold alerts work.
- Dry-run mode clearly shows what would be blocked.
- No real firewall change happens unless an explicit apply option is used.

## Project 2: Automated Backup with Integrity Verification

### Situation

A team needs daily backups of important configuration files and small databases. The backup must be verified, old backups must be rotated, and failures must be visible.

### Objective

Create a backup script that archives selected paths, generates SHA-256 checksums, verifies the archive, rotates old backups, and reports success or failure.

### Build

- Read backup targets from a config file.
- Create timestamped archive files.
- Generate a checksum file for every archive.
- Verify the checksum immediately after creation.
- Keep only the latest N backups.
- Write a backup manifest with:
  - backup name
  - source paths
  - archive path
  - checksum
  - size
  - status
  - timestamp
- Add options:
  - `--config path`
  - `--dest path`
  - `--keep number`
  - `--dry-run`
  - `--verify-only archive`

### Real Workflow Practice

- Test with fake config folders before backing up anything important.
- Never delete old backups until the new backup has been verified.
- Make failures loud and clear.
- Keep backup output boring and predictable.

### Skills You Learn

- `tar`
- `sha256sum`
- config files
- file checks
- rotation logic
- defensive scripting

### Done When

- A backup archive is created.
- The checksum is generated and verified.
- Old backups rotate only after a successful backup.
- The README explains how to restore from the archive.

## Project 3: Bash Port Scanner

### Situation

During an authorized lab or internal assessment, you need basic network visibility from a machine with very limited tools. You do not have `nmap` or `netcat`.

### Objective

Build a small TCP port scanner using Bash and `/dev/tcp` for authorized targets only.

### Build

- Accept a target host.
- Accept a port list or range.
- Add a timeout so filtered ports do not hang forever.
- Print clean output:
  - host
  - port
  - status
  - time checked
- Add options:
  - `--host target`
  - `--ports 22,80,443`
  - `--range 1-1024`
  - `--timeout seconds`
  - `--output file`
- Add a safety reminder in `--help`.

### Real Workflow Practice

- Scan only systems you own or have clear permission to test.
- Test against localhost first.
- Keep the scanner simple. This is for learning and emergency visibility, not replacing real tools.
- Document limitations clearly.

### Skills You Learn

- Bash networking with `/dev/tcp`
- loops
- timeouts
- input validation
- clean terminal output
- responsible security testing

### Done When

- The scanner can detect open and closed ports on localhost.
- It does not hang on filtered or unreachable ports.
- It can write results to a file.
- The README explains when this tool is appropriate and when it is not.

## Project 4: Log Rotation and Cleanup Tool

### Situation

A web application writes large log files. Disk space ran out once and caused downtime. The team needs a safe cleanup tool with compression, retention, and disk usage alerts.

### Objective

Write a script that compresses old logs, deletes expired compressed logs, checks disk usage, and reports actions clearly.

### Build

- Work inside a lab log folder first.
- Find logs older than a configured number of days.
- Compress old logs.
- Delete compressed logs older than the retention limit.
- Check disk usage before and after cleanup.
- Add options:
  - `--log-dir path`
  - `--compress-after days`
  - `--delete-after days`
  - `--disk-threshold percent`
  - `--dry-run`
  - `--report path`

### Real Workflow Practice

- Use dry-run before deleting anything.
- Handle filenames with spaces.
- Do not process files outside the chosen log directory.
- Avoid running cleanup while files are actively being written.

### Skills You Learn

- `find`
- safe file handling
- compression
- disk checks
- retention policy
- cleanup automation

### Done When

- Dry-run shows exactly what will be compressed or deleted.
- Real mode works safely in the lab folder.
- Disk usage report is created.
- The script refuses dangerous or empty paths.

## Project 5: Service Health Monitor with Auto Recovery

### Situation

A critical service went down and nobody noticed quickly. The team needs a simple monitor that checks health endpoints, retries before declaring failure, and can attempt recovery.

### Objective

Monitor HTTP health endpoints, detect failures with retry logic, optionally run a recovery command, and send a notification.

### Build

- Read service definitions from a config file.
- Each service should include:
  - name
  - URL
  - expected status code
  - timeout
  - retry count
  - optional recovery command
- Use `curl` with timeouts.
- Add retry logic.
- Add dry-run recovery mode.
- Write status results to a log file.
- Add options:
  - `--config path`
  - `--once`
  - `--watch seconds`
  - `--dry-run`
  - `--notify-webhook url`

### Real Workflow Practice

- Do not restart services after one failed check.
- Log every check and every recovery attempt.
- Keep recovery commands explicit.
- Treat alerting as part of the project, not an afterthought.

### Skills You Learn

- `curl`
- config-driven scripts
- retries
- monitoring loops
- exit codes
- basic incident response workflow

### Done When

- The monitor detects a healthy endpoint.
- It detects a failing endpoint after retries.
- Dry-run recovery prints the command instead of running it.
- The log gives enough detail to understand what happened.

## Project 6: Firewall Rule Auditor

### Situation

During a security review, you need to inspect firewall rules across Linux servers and find risky settings like open SSH, exposed databases, or permissive default policies.

### Objective

Parse saved firewall output and generate a report that flags dangerous rules.

### Build

- Start by parsing saved files, not live firewall state.
- Support sample inputs from:
  - `iptables-save`
  - `ufw status verbose`
- Flag risky patterns:
  - default INPUT policy is ACCEPT
  - SSH open to the world
  - database ports open to the world
  - wide port ranges open to any source
  - missing deny policy
- Generate a Markdown report.
- Add options:
  - `--input path`
  - `--type iptables|ufw`
  - `--report path`
  - `--fail-on-high`

### Real Workflow Practice

- Auditing should not change firewall rules.
- Keep findings clear and actionable.
- Explain why a rule is risky.
- Prefer evidence from command output over guesses.

### Skills You Learn

- parsing command output
- rule matching
- report generation
- security review mindset
- non-destructive auditing

### Done When

- The script parses sample firewall outputs.
- It produces a readable report.
- High risk findings are easy to spot.
- It exits with a non-zero code when `--fail-on-high` is used and high risk rules exist.

## Project 7: User Account Security Auditor

### Situation

As part of access review, you need to check Linux accounts for common risks: empty passwords, extra UID 0 users, old inactive users, and service accounts with login shells.

### Objective

Scan passwd-style and shadow-style data, identify risky accounts, and generate an actionable account security report.

### Build

- Start with sample `passwd` and `shadow` files.
- Detect:
  - UID 0 accounts other than root
  - accounts with empty password fields
  - service accounts with interactive shells
  - users with no home directory
  - users inactive past a chosen limit, if login data is provided
- Generate a report with severity levels.
- Add options:
  - `--passwd path`
  - `--shadow path`
  - `--lastlog path`
  - `--inactive-days number`
  - `--report path`

### Real Workflow Practice

- Do not print password hashes in reports.
- Use sample files first.
- Treat account audit data as sensitive.
- Make the report useful for a sysadmin who needs to fix issues.

### Skills You Learn

- `/etc/passwd` format
- `/etc/shadow` basics
- field parsing
- severity labels
- compliance style reporting

### Done When

- The script finds risky accounts in sample data.
- It creates a report without exposing password hashes.
- The README explains each finding in plain language.

## Project 8: Incident Response Data Collector

### Situation

A possible breach is detected on a Linux server. Before anything changes, the response team needs quick volatile data: processes, network connections, logged-in users, system info, recent files, and command evidence.

### Objective

Collect useful incident response data into a timestamped evidence folder, hash the files, and package them for later analysis.

### Build

- Create a timestamped case folder.
- Collect:
  - system info
  - hostname
  - current users
  - running processes
  - listening ports
  - network connections
  - recent login records
  - recent modified files from chosen paths
  - cron jobs if readable
- Hash every evidence file.
- Create a manifest.
- Package the evidence folder.
- Add options:
  - `--case-id value`
  - `--output-dir path`
  - `--paths path1,path2`
  - `--no-package`

### Real Workflow Practice

- Collect volatile data first.
- Do not clean, delete, or repair anything during collection.
- Write down what the script collected and when.
- In a real incident, prefer trusted tools and follow the incident response process.

### Skills You Learn

- evidence collection
- timestamps
- command output capture
- hashing
- packaging
- careful security workflow

### Done When

- The collector creates a complete case folder.
- Each evidence file has a hash.
- The manifest explains what was collected.
- The package can be moved to another machine for analysis.

## Project 9: Final Shell Operations Toolkit

### Situation

After building several scripts, you need to organize them like a small real toolkit instead of a pile of files.

### Objective

Package the finished scripts into a clean toolkit with consistent usage, docs, examples, and a simple install or run workflow.

### Build

- Create a `bin` folder for final scripts.
- Keep sample configs in `examples`.
- Add one main README with:
  - tool list
  - requirements
  - install notes
  - usage examples
  - safety notes
- Make every script support:
  - `--help`
  - `--dry-run` when it can change state
  - useful exit codes
  - clear error messages
- Add a simple test checklist.
- Add a release checklist.

### Real Workflow Practice

- Treat your scripts like tools someone else could run.
- Keep names consistent.
- Keep output predictable.
- Make documentation short but useful.
- Keep dangerous actions opt-in.

### Skills You Learn

- project organization
- reusable shell patterns
- documentation
- release thinking
- maintainable scripting

### Done When

- A new user can read the README and run at least one tool successfully.
- All scripts pass ShellCheck or document known warnings.
- Sample data exists for risky tools.
- The toolkit feels like a real reference project, not only practice code.

## Final Review Checklist

Use this checklist before calling any project complete.

- The script has a clear purpose.
- The script has `--help`.
- Inputs are validated.
- Variables are quoted.
- Destructive actions require `--dry-run` testing first.
- Errors are clear.
- Logs have timestamps.
- Sample data exists.
- The README has at least one real command example.
- ShellCheck has been run.
- The project has a sample output or report.
- The project teaches something worth remembering.

## What This Journey Should Build

By the end, you should be comfortable with:

- reading and writing real Bash scripts
- safely handling files
- parsing logs and command output
- building scripts with arguments
- using functions and reusable patterns
- creating reports
- adding dry-run mode
- thinking before running dangerous commands
- documenting tools clearly
- using shell scripting for DevOps and security work

The point is simple: build tools that solve real problems, then keep improving them until they are safe, readable, and useful.
