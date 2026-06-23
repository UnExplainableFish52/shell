#!/usr/bin/env bash
# there is a long story behind this, but note these summary: 1. shebang is apex  2. hardcoding filepath is not portable  3. always use modern shebang 4. 


# Strict mode makes beginner mistakes easier to catch.
# -e: stop when a command fails
# -u: stop when using an unset variable
# -o pipefail: fail a pipeline if any command inside it fails
set -euo pipefail

main(){
  echo "hello world"
  #statements go in this block
}

main 