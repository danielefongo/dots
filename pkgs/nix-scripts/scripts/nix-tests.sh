#!/usr/bin/env bash

set -euo pipefail

cd "$DOTS_PATH"

run_test() {
  local test_file="$1"
  local test_name
  test_name="$(basename "$test_file" _test.nix)"

  echo "🧪 testing: $test_name"

  if nix-instantiate --eval --strict --json "$test_file" -A result 2>&1 | sed 's/^trace: //' | grep -v '^true$'; then
    echo "✅ $test_name passed"
    return 0
  else
    echo "❌ $test_name failed"
    return 1
  fi
}

run_single_test() {
  local test_file="$1"

  if [ ! -f "$test_file" ]; then
    echo "❌ test file not found: $test_file"
    return 1
  fi

  run_test "$test_file"
}

find_and_run_tests() {
  mapfile -t test_files < <(find . -name "*_test.nix" -type f)

  if [ ${#test_files[@]} -eq 0 ]; then
    echo "⚠️  no test files found"
    return 0
  fi

  echo "Found ${#test_files[@]} test file(s)"
  echo ""

  for test_file in "${test_files[@]}"; do
    if ! run_test "$test_file"; then
      return 1
    fi
    echo ""
  done

  return 0
}

select_and_run_test() {
  mapfile -t test_files < <(find . -name "*_test.nix" -type f | sort)

  if [ ${#test_files[@]} -eq 0 ]; then
    echo "⚠️  no test files found"
    return 0
  fi

  local selection
  selection=$(printf "ALL\n%s\n" "${test_files[@]}" | fzf --prompt="select test: ")

  if [ "$selection" = "ALL" ]; then
    find_and_run_tests
  else
    run_single_test "$selection"
  fi
}

case "${1:-}" in
"")
  select_and_run_test
  ;;
"-a")
  find_and_run_tests
  ;;
*)
  run_single_test "$1"
  ;;
esac
