#!/bin/sh
# Runs hooks/commit-msg.sh against every fixture, both via file argument and
# via stdin, and checks the exit status.
#
#   tests/run.sh            # uses /bin/sh to run the hook
#   SHELL_CMD=dash tests/run.sh
#   SHELL_CMD=bash tests/run.sh

here=$(cd "$(dirname "$0")" && pwd)
hook="$here/../hooks/commit-msg.sh"
shell_cmd="${SHELL_CMD:-sh}"

pass=0
fail=0

check() {
  # $1 = fixture path, $2 = expected exit status
  file=$1
  expected=$2

  "$shell_cmd" "$hook" "$file" >/dev/null 2>&1
  got=$?
  if [ "$got" -eq "$expected" ]; then
    pass=$((pass + 1))
  else
    fail=$((fail + 1))
    printf 'FAIL (file)  %s: expected %s, got %s\n' "$file" "$expected" "$got"
  fi

  "$shell_cmd" "$hook" <"$file" >/dev/null 2>&1
  got=$?
  if [ "$got" -eq "$expected" ]; then
    pass=$((pass + 1))
  else
    fail=$((fail + 1))
    printf 'FAIL (stdin) %s: expected %s, got %s\n' "$file" "$expected" "$got"
  fi
}

for f in "$here"/fixtures/valid/*.txt;   do check "$f" 0; done
for f in "$here"/fixtures/skip/*.txt;    do check "$f" 0; done
for f in "$here"/fixtures/invalid/*.txt; do check "$f" 1; done

printf '%s: %d passed, %d failed\n' "$shell_cmd" "$pass" "$fail"
[ "$fail" -eq 0 ]
