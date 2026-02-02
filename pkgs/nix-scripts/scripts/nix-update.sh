#!/usr/bin/env bash

set -euo pipefail

cd "$DOTS_PATH"

echo "🔄 updating flakes"
nix flake update "$@" --flake .
nix flake update "root-flake" --flake ./work
nix flake update "$@" --flake ./work
