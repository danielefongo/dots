#!/usr/bin/env bash

set -euo pipefail

has_attr() {
  local ref="$1"
  nix eval --json "$ref" >/dev/null 2>&1
}

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
    if has_attr ".#homeConfigurations.$USER.activationPackage"; then
      echo "🏠 home-manager switch (.#$USER)"
      home-manager switch --flake ".#$USER"
    else
      echo "⚠️ homeConfigurations.$USER not found; skipping home-manager."
    fi
  fi

  if [ "$MODE" != "-h" ]; then
    if has_attr ".#systemConfigs.default"; then
      echo "🖥️ system-manager switch (.#default)"
      sudo -E "$(which nix)" run github:numtide/system-manager -- switch --flake ".#default"
    else
      echo "⚠️ systemConfigs.default not found; falling back to root flake."
      sudo -E "$(which nix)" run github:numtide/system-manager -- switch --flake .
    fi
  fi
}

if is_nixos; then
  echo "🧭 detected NixOS."
  rebuild_nixos "${1-}"
else
  echo "🧭 detected non-NixOS."
  rebuild_non_nixos "${1-}"
fi
