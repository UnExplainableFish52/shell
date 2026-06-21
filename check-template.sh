#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_NAME="$(basename "$0")"

TEMPLATE_PATH="./template.sh"
LAB_DIR="./template-check-lab"
RUN_ID="$(date '+%Y%m%d-%H%M%S')"
RUN_DIR=""
PASSED=0
FAILED=0

usage() {
  cat <<EOF
Usage:
  $SCRIPT_NAME [options]

Description:
  Runs basic checks against template.sh so you can see how --help, --version,
  --dry-run, --verbose, --log-file, normal output, and errors behave.

Options:
      --template PATH    Template script to check. Default: ./template.sh
      --lab-dir PATH     Lab folder for test files. Default: ./template-check-lab
  -h, --help             Show this help message.

Examples:
  cd path/to/shell
  bash $SCRIPT_NAME
  bash $SCRIPT_NAME --template ./template.sh --lab-dir ./template-check-lab

Output:
  Each run creates a timestamped folder inside the lab directory.
EOF
}

log() {
  printf '%s\n' "$*"
}

die() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --template)
        [[ $# -ge 2 ]] || die "Missing value for $1"
        TEMPLATE_PATH="$2"
        shift 2
        ;;
      --lab-dir)
        [[ $# -ge 2 ]] || die "Missing value for $1"
        LAB_DIR="$2"
        shift 2
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      -*)
        die "Unknown option: $1"
        ;;
      *)
        die "Unexpected argument: $1"
        ;;
    esac
  done
}

setup_lab() {
  [[ -f "$TEMPLATE_PATH" ]] || die "Template script not found: $TEMPLATE_PATH"

  RUN_DIR="$LAB_DIR/$RUN_ID"
  mkdir -p -- "$RUN_DIR/input" "$RUN_DIR/output" "$RUN_DIR/logs"

  cat > "$RUN_DIR/input/sample.txt" <<EOF
This is sample input for checking template.sh.
Use this file to test --input and --output behavior.
EOF
}

record_pass() {
  local name="$1"

  PASSED=$((PASSED + 1))
  log "PASS: $name"
}

record_fail() {
  local name="$1"
  local output_file="$2"

  FAILED=$((FAILED + 1))
  log "FAIL: $name"
  log "      See: $output_file"
}

run_should_pass() {
  local name="$1"
  local output_file="$2"
  shift 2

  if "$@" > "$output_file" 2>&1; then
    record_pass "$name"
  else
    record_fail "$name" "$output_file"
  fi
}

run_should_fail() {
  local name="$1"
  local output_file="$2"
  shift 2

  if "$@" > "$output_file" 2>&1; then
    record_fail "$name" "$output_file"
  else
    record_pass "$name"
  fi
}

assert_file_exists() {
  local name="$1"
  local file_path="$2"

  if [[ -f "$file_path" ]]; then
    record_pass "$name"
  else
    FAILED=$((FAILED + 1))
    log "FAIL: $name"
    log "      Missing file: $file_path"
  fi
}

run_checks() {
  local input_file="$RUN_DIR/input/sample.txt"
  local output_file="$RUN_DIR/output/result.txt"
  local log_file="$RUN_DIR/logs/template.log"

  log "Checking template: $TEMPLATE_PATH"
  log "Lab folder: $RUN_DIR"
  log ""

  run_should_pass \
    "syntax check" \
    "$RUN_DIR/logs/01-syntax-check.txt" \
    bash -n "$TEMPLATE_PATH"

  run_should_pass \
    "help output" \
    "$RUN_DIR/logs/02-help.txt" \
    bash "$TEMPLATE_PATH" --help

  run_should_pass \
    "version output" \
    "$RUN_DIR/logs/03-version.txt" \
    bash "$TEMPLATE_PATH" --version

  run_should_pass \
    "dry-run with verbose output" \
    "$RUN_DIR/logs/04-dry-run.txt" \
    bash "$TEMPLATE_PATH" \
      --input "$input_file" \
      --output "$output_file" \
      --log-file "$log_file" \
      --dry-run \
      --verbose

  run_should_pass \
    "real run with log file" \
    "$RUN_DIR/logs/05-real-run.txt" \
    bash "$TEMPLATE_PATH" \
      --input "$input_file" \
      --output "$output_file" \
      --log-file "$log_file" \
      --verbose

  assert_file_exists "output file created" "$output_file"
  assert_file_exists "log file created" "$log_file"

  run_should_fail \
    "missing required options should fail" \
    "$RUN_DIR/logs/06-missing-options.txt" \
    bash "$TEMPLATE_PATH"

  run_should_fail \
    "unknown option should fail" \
    "$RUN_DIR/logs/07-unknown-option.txt" \
    bash "$TEMPLATE_PATH" --does-not-exist
}

print_summary() {
  log ""
  log "Summary:"
  log "  Passed: $PASSED"
  log "  Failed: $FAILED"
  log "  Logs:   $RUN_DIR/logs"

  if [[ "$FAILED" -gt 0 ]]; then
    exit 1
  fi
}

main() {
  parse_args "$@"
  setup_lab
  run_checks
  print_summary
}

main "$@"
