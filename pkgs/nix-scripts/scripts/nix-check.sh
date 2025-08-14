#!/usr/bin/env bash

set -euo pipefail

cd "$DOTS_PATH"

run_dry() {
  local LOG
  LOG="$(mktemp)"
  if nix build --no-warn-dirty --dry-run --no-link "$1" >"$LOG" 2>&1; then
    rm -f "$LOG"
    return 0
  else
    echo "❌ Dry-run failed for: $1"
    cat "$LOG"
    rm -f "$LOG"
    return 1
  fi
}

check_nixos_host() {
  local host="$1"
  local attr=".#nixosConfigurations.$host.config.system.build.toplevel"
  echo "🔎 checking nixos: $host"
  run_dry "$attr"
  echo "✅ $host"
}

check_nixos_all() {
  mapfile -t hosts < <(nix eval --json ".#nixosConfigurations" --apply builtins.attrNames | jq -r '.[]')
  for h in "${hosts[@]}"; do
    check_nixos_host "$h"
  done
}

check_nixos_some() {
  for h in "$@"; do
    check_nixos_host "$h"
  done
}

check_work() {
  echo "🔎 checking work (home + system)"
  run_dry "./work#homeConfigurations.$USER.activationPackage"
  run_dry "./work#systemConfigs.default"
  echo "✅ work"
}

case "${1:-}" in
nixos)
  shift
  if (($# > 0)); then
    check_nixos_some "$@"
  else
    check_nixos_all
  fi
  ;;
work)
  check_work
  ;;
*)
  check_nixos_all
  check_work
  ;;
esac
