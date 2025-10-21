#!/usr/bin/env bash
set -euo pipefail

CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
CONFIG_FILE="${CONFIG_HOME}/nix-theme.json"

mapfile -t JS_FILES < <(find "$DOTS_PATH/themes" -maxdepth 1 -type f -name "*.js" -printf "%f\n" | sort)

CURRENT_PATH=""
if [[ -f "$CONFIG_FILE" ]]; then
  CURRENT_PATH="$(grep -oP '(?<="themeFile": ")[^"]+' "$CONFIG_FILE" || true)"
fi

extract_name() {
  local filepath="$1"
  perl -0777 -ne '
    if (m/module\.exports\s*=\s*\{.*?\bname\s*:\s*["'\''`](.*?)["'\''`]/si) {
      print "$1\n";
      exit 0;
    }
  ' -- "$filepath" 2>/dev/null || true
}

declare -a DISPLAY_NAMES=()
declare -a FULL_PATHS=()

for f in "${JS_FILES[@]}"; do
  full="${DOTS_PATH}/themes/${f}"
  name="$(extract_name "$full" | head -n1 || true)"
  if [[ -z "$name" ]]; then
    name="$f"
  fi
  DISPLAY_NAMES+=("$name")
  FULL_PATHS+=("$full")
done

selected_index=-1
if [[ -n "$CURRENT_PATH" ]]; then
  for i in "${!FULL_PATHS[@]}"; do
    if [[ "${FULL_PATHS[$i]}" == "$CURRENT_PATH" ]]; then
      selected_index=$i
      break
    fi
  done
fi

if [[ $selected_index -ge 0 ]]; then
  selection_index="$(printf '%s\n' "${DISPLAY_NAMES[@]}" | rofi -dmenu -i -p 'Select theme' -no-custom -format i -selected-row "$selected_index")"
else
  selection_index="$(printf '%s\n' "${DISPLAY_NAMES[@]}" | rofi -dmenu -i -p 'Select theme' -no-custom -format i)"
fi

if [[ -z "${selection_index}" || "${selection_index}" -lt 0 ]]; then
  echo "No selection made."
  exit 0
fi

THEME_PATH="${FULL_PATHS[$selection_index]}"

printf '{\n  "themeFile": "%s"\n}\n' "${THEME_PATH}" >"${CONFIG_FILE}"

nix-theme
