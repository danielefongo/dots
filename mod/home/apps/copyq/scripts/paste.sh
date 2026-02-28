#!/usr/bin/env bash
set -euo pipefail

sleep 0.1

if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
  wtype -M ctrl v -m ctrl
else
  xdotool key ctrl+v
fi
