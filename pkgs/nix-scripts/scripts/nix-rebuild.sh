#!/usr/bin/env bash

set -euo pipefail

is_nixos() {
  [ -r /etc/os-release ] && grep -q '^ID=nixos' /etc/os-release
}

rebuild_nixos() {
  cd "$DOTS_PATH"
  case "${1-}" in
  "")
    echo "🔄 nixos-rebuild switch"
    sudo nixos-rebuild switch --flake .
    ;;
  -t)
    echo "🧪 nixos-rebuild test"
    sudo nixos-rebuild test --flake .
    ;;
  esac
}

rebuild_non_nixos() {
  cd "$DOTS_PATH/work"
  local MODE="both"

  case "${1-}" in
  "") MODE="both" ;;
  -h) MODE="-h" ;;
  -s) MODE="-s" ;;
  esac

  if [ "$MODE" != "-s" ]; then
    echo "🏠 home-manager switch (.#$USER)"
    home-manager switch -b hm-bak --flake ".#$USER"
  fi

  if [ "$MODE" != "-h" ]; then
    echo "🖥️ system-manager switch (.#default)"
    sudo -E "$(which nix)" run github:numtide/system-manager -- switch --flake ".#default"
  fi
}

if is_nixos; then
  echo "🧭 detected NixOS."
  rebuild_nixos "${1-}"
else
  echo "🧭 detected non-NixOS."
  rebuild_non_nixos "${1-}"
fi
