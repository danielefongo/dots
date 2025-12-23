#!/usr/bin/env bash
set -euo pipefail

DOTS_PATH="${DOTS_PATH:-$HOME/dots}"
WORK_PATH="$DOTS_PATH/work"

USE_LATEST=0
TOOLS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
  --latest)
    USE_LATEST=1
    shift
    ;;
  *)
    TOOLS+=("$1")
    shift
    ;;
  esac
done

if [ "$USE_LATEST" -eq 1 ]; then
  echo "📦 using nixpkgs latest"
  exec nix shell "${TOOLS[@]/#/nixpkgs#}"
else
  if [ -d "$WORK_PATH" ]; then
    BASE="$WORK_PATH"
  else
    BASE="$DOTS_PATH"
  fi

  echo "📦 using nixpkgs from flake: $BASE"
  exec nix shell --inputs-from "$BASE" "${TOOLS[@]/#/nixpkgs#}"
fi
