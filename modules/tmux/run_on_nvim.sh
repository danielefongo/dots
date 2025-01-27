#!/bin/bash

file_name=$(echo "$1" | awk -F: '{print $1}')
line_number=$(echo "$1" | awk -F: '{print $2}')
column_number=$(echo "$1" | awk -F: '{print $3}')

current_session=$(tmux display-message -p "#{session_name}")
current_cwd=$(tmux display-message -p "#{pane_current_path}")

target_session=""
target_window=""
target_pane=""

current_session=$(tmux display-message -p "#{session_name}")
tmux_windows=$(tmux list-windows -t "$current_session" -aF "#{window_index}")

while IFS= read -r window_index; do
  tmux_panes=$(tmux list-panes -t "$window_index" -F "#{pane_index} #{pane_current_command} #{pane_current_path}")

  while IFS= read -r pane_info; do
    pane_index=$(echo "$pane_info" | awk '{print $1}')
    current_command=$(echo "$pane_info" | awk '{print $2}')
    current_path=$(echo "$pane_info" | awk '{print $3}')

    if [ "$current_command" == "nvim" ] && [ "$current_path" == "$current_cwd" ]; then
      target_session="$current_session"
      target_window="$window_index"
      target_pane="$pane_index"
      break 2
    fi
  done <<<"$tmux_panes"
done <<<"$tmux_windows"

if [ -n "$target_pane" ]; then
  tmux switch-client -t "$target_session"
  tmux select-window -t "$target_window"
  tmux select-pane -t "$target_pane"
  tmux send-keys ":e $file_name" C-m
  tmux send-keys ":call cursor(${line_number:-1}, ${column_number:-1})" C-m
fi
