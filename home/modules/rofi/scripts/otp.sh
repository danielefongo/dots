#!/usr/bin/env bash
set -euo pipefail

mapfile -t ACCOUNTS < <(ykman oath accounts code 2>/dev/null)

if [[ ${#ACCOUNTS[@]} -eq 0 ]]; then
  notify-send "YubiKey OATH" "No accounts found"
  exit 1
fi

declare -a ACCOUNT_NAMES=()
declare -a ACCOUNT_CODES=()

for line in "${ACCOUNTS[@]}"; do
  if [[ "$line" =~ ^(.+)[[:space:]]+([0-9]{6,8})$ ]]; then
    account="${BASH_REMATCH[1]}"
    code="${BASH_REMATCH[2]}"

    ACCOUNT_NAMES+=("$account")
    ACCOUNT_CODES+=("$code")
  fi
done

selection_index="$(printf '%s\n' "${ACCOUNT_NAMES[@]}" | rofi -dmenu -i -p 'YubiKey OATH' -no-custom -format i)"

if [[ -z "${selection_index}" || "${selection_index}" -lt 0 ]]; then
  exit 0
fi

SELECTED_CODE="${ACCOUNT_CODES[$selection_index]}"

sleep 0.2
xdotool type --delay 10 "$SELECTED_CODE"
