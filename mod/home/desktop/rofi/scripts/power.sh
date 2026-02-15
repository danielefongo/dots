#!/usr/bin/env bash
set -euo pipefail

OPTIONS="Lock\nLogout\nReboot\nShutdown"

CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -i -p "System" -no-custom)

case "$CHOICE" in
"Lock")
  loginctl lock-session
  ;;
"Logout")
  loginctl terminate-user "$USER"
  ;;
"Reboot")
  shutdown now -r
  ;;
"Shutdown")
  shutdown now
  ;;
*)
  exit 0
  ;;
esac
