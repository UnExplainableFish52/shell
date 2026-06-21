#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_NAME="$(basename "$0")"
SCRIPT_VERSION="0.1.0"

DRY_RUN=false
VERBOSE=false
INPUT_PATH=""
OUTPUT_PATH=""
LOG_FILE=""
TMP_DIR=""

usage() {
  cat <<EOF
Usage:
  $SCRIPT_NAME [options]

Description:
  Short description of what this script does.

Options:
  -i, --input PATH       Input file or directory.
  -o, --output PATH      Output file or directory.
      --log-file PATH    Write logs to this file.
      --dry-run          Show what would happen without changing anything.
      --verbose          Print extra details while running.
  -h, --help             Show this help message.
      --version          Show script version.

Examples:
  $SCRIPT_NAME --input ./sample-data/input.log --output ./output/report.txt --dry-run
  $SCRIPT_NAME -i ./sample-data/input.log -o ./output/report.txt --log-file ./output/run.log

Notes:
  Start with sample data. Use --dry-run before any action that changes files,
  services, firewall rules, accounts, or system state.
EOF
}

timestamp() {
  date '+%Y-%m-%d %H:%M:%S'
}

log() {
  local level="$1"
  shift

  local line
  line="$(printf '%s [%s] %s' "$(timestamp)" "$level" "$*")"

  if [[ "$level" == "ERROR" ]]; then
    printf '%s\n' "$line" >&2
  else
    printf '%s\n' "$line"
  fi

  if [[ -n "$LOG_FILE" && "$DRY_RUN" != true ]]; then
    printf '%s\n' "$line" >> "$LOG_FILE"
  fi
}

log_info() {
  log "INFO" "$@"
}

log_warn() {
  log "WARN" "$@"
}

log_error() {
  log "ERROR" "$@"
}

debug() {
  if [[ "$VERBOSE" == true ]]; then
    log "DEBUG" "$@"
  fi
}

die() {
  log_error "$@"
  exit 1
}

cleanup() {
  if [[ -n "$TMP_DIR" && -d "$TMP_DIR" ]]; then
    debug "Removing temp directory: $TMP_DIR"
    rm -rf -- "$TMP_DIR"
  fi
}

trap cleanup EXIT

require_command() {
  local command_name="$1"

  if ! command -v "$command_name" >/dev/null 2>&1; then
    die "Required command not found: $command_name"
  fi
}

require_file() {
  local file_path="$1"

  if [[ ! -f "$file_path" ]]; then
    die "File does not exist: $file_path"
  fi
}

require_dir() {
  local dir_path="$1"

  if [[ ! -d "$dir_path" ]]; then
    die "Directory does not exist: $dir_path"
  fi
}

ensure_parent_dir() {
  local path="$1"
  local parent_dir

  parent_dir="$(dirname "$path")"

  if [[ ! -d "$parent_dir" ]]; then
    if [[ "$DRY_RUN" == true ]]; then
      log_info "Would create directory: $parent_dir"
    else
      mkdir -p -- "$parent_dir"
    fi
  fi
}

is_positive_int() {
  local value="$1"
  [[ "$value" =~ ^[1-9][0-9]*$ ]]
}

run_cmd() {
  if [[ "$DRY_RUN" == true ]]; then
    log_info "Would run: $*"
    return 0
  fi

  debug "Running: $*"
  "$@"
}

create_tmp_dir() {
  if [[ "$DRY_RUN" == true ]]; then
    debug "Would create temp directory"
    return 0
  fi

  TMP_DIR="$(mktemp -d)"
  debug "Created temp directory: $TMP_DIR"
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -i|--input)
        [[ $# -ge 2 ]] || die "Missing value for $1"
        INPUT_PATH="$2"
        shift 2
        ;;
      -o|--output)
        [[ $# -ge 2 ]] || die "Missing value for $1"
        OUTPUT_PATH="$2"
        shift 2
        ;;
      --log-file)
        [[ $# -ge 2 ]] || die "Missing value for $1"
        LOG_FILE="$2"
        shift 2
        ;;
      --dry-run)
        DRY_RUN=true
        shift
        ;;
      --verbose)
        VERBOSE=true
        shift
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      --version)
        printf '%s %s\n' "$SCRIPT_NAME" "$SCRIPT_VERSION"
        exit 0
        ;;
      --)
        shift
        break
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

validate_args() {
  [[ -n "$INPUT_PATH" ]] || die "Missing required option: --input"
  [[ -n "$OUTPUT_PATH" ]] || die "Missing required option: --output"

  require_file "$INPUT_PATH"
  ensure_parent_dir "$OUTPUT_PATH"

  if [[ -n "$LOG_FILE" ]]; then
    local output_parent
    local log_parent

    output_parent="$(dirname "$OUTPUT_PATH")"
    log_parent="$(dirname "$LOG_FILE")"

    if [[ "$log_parent" != "$output_parent" ]]; then
      ensure_parent_dir "$LOG_FILE"
    fi
  fi
}

do_work() {
  log_info "Starting work"
  debug "Input: $INPUT_PATH"
  debug "Output: $OUTPUT_PATH"

  create_tmp_dir

  if [[ "$DRY_RUN" == true ]]; then
    log_info "Would read input from: $INPUT_PATH"
    log_info "Would write output to: $OUTPUT_PATH"
    return 0
  fi

  printf 'Replace this block with the real project logic.\n' > "$OUTPUT_PATH"

  log_info "Wrote output: $OUTPUT_PATH"
}

main() {
  parse_args "$@"
  validate_args

  log_info "$SCRIPT_NAME started"
  do_work
  log_info "$SCRIPT_NAME finished"
}

main "$@"
