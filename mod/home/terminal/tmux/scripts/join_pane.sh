#!/bin/bash

DIRECTION="${1:-horizontal}"
JOIN_FLAG=$([[ "$DIRECTION" == "horizontal" ]] && echo "-h" || echo "-v")

current_session=$(tmux display-message -p '#{session_name}')
current_window=$(tmux display-message -p '#{window_index}')

tmux list-panes -a -F '#{session_name}|#{window_index}|#{pane_index}|#{window_id}|#{pane_title}' |
  while IFS='|' read -r sess win pane wid title; do
    target="${sess}:${win}.${pane}"
    wname=$(tmux_window_name "$wid" 20)
    priority=1

    [ "$sess" = "$current_session" ] && [ "$win" = "$current_window" ] && priority=1 ||
      [ "$sess" = "$current_session" ] && priority=2 || priority=3

    echo "${priority}|${target}|${target} - [${wname}] ${title}"

  done |
  sort -t'|' -k1,1n |
  cut -d'|' -f3 |
  fzf --ansi \
    --preview 'tmux capture-pane -ep -t {1}' \
    --preview-window right:70% |
  awk '{print $1}' |
  xargs -r tmux join-pane "$JOIN_FLAG" -s
