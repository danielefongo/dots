#!/usr/bin/env bash

set -euo pipefail

cd "$DOTS_PATH"

echo "🔄 updating flakes"
nix flake update "$@" --flake .
nix flake update "$@" --flake ./work
