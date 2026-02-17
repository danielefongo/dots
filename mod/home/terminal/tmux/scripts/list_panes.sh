#!/bin/bash

EXCLUDE_CURRENT=false

for arg in "$@"; do
  case "$arg" in
  --exclude-current) EXCLUDE_CURRENT=true ;;
  esac
done

current_session=$(tmux display-message -p '#{session_name}')
current_window=$(tmux display-message -p '#{window_index}')
current_pane=$(tmux display-message -p '#{pane_index}')

tmux list-panes -a -F '#{session_name}|#{window_index}|#{pane_index}|#{pane_current_path}|#{pane_current_command}' |
  while IFS='|' read -r sess win pane path cmd; do
    if $EXCLUDE_CURRENT && [ "$sess" = "$current_session" ] && [ "$win" = "$current_window" ] && [ "$pane" = "$current_pane" ]; then
      continue
    fi

    target="${sess}:${win}.${pane}"
    folder=$(basename "$path")

    if [ "$cmd" != "zsh" ] && [ "$cmd" != "bash" ] && [ "$cmd" != "sh" ]; then
      label="${folder} [${cmd}]"
    else
      label="$folder"
    fi

    priority=1
    [ "$sess" = "$current_session" ] && [ "$win" = "$current_window" ] && priority=1 ||
      [ "$sess" = "$current_session" ] && priority=2 || priority=3

    echo "${priority}|${target}|${target} - ${label}"
  done |
  sort -t'|' -k1,1n |
  cut -d'|' -f2,3
