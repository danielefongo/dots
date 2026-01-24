#!/bin/bash
set -e

WINDOW_ID="$1"

if [[ -z "$WINDOW_ID" ]]; then
	echo "Usage: $0 <window_id>"
	exit 1
fi

MAX_LENGTH="${2:-}"

FIRST_PANE_PATH=$(tmux display-message -p -t "$WINDOW_ID.0" '#{pane_current_path}' 2>/dev/null || echo "")

if [[ -z "$FIRST_PANE_PATH" ]]; then
	echo "error"
	exit 1
fi

FOLDER_NAME=$(basename "$FIRST_PANE_PATH")

if [[ -n "$MAX_LENGTH" ]] && [[ ${#FOLDER_NAME} -gt $MAX_LENGTH ]]; then
	TRUNCATE_LEN=$((MAX_LENGTH - 1))
	FOLDER_NAME="${FOLDER_NAME:0:$TRUNCATE_LEN}…"
fi

CMDS=()

PANE_LIST=$(tmux list-panes -t "$WINDOW_ID" -F '#{pane_index}' 2>/dev/null)

while IFS= read -r PANE_IDX; do
	CMD=$(tmux display-message -p -t "$WINDOW_ID.$PANE_IDX" '#{pane_current_command}' 2>/dev/null)

	if [[ "$CMD" != "zsh" && "$CMD" != "bash" && "$CMD" != "sh" ]]; then
		CMDS+=("$CMD")
	fi
done <<<"$PANE_LIST"

if [[ ${#CMDS[@]} -gt 0 ]]; then
	CMDS_STR="${CMDS[*]}"
	echo "$FOLDER_NAME ($CMDS_STR)"
else
	echo "$FOLDER_NAME"
fi
