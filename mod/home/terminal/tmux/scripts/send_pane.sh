#!/bin/bash

DIRECTION="${1:-horizontal}"
JOIN_FLAG=$([[ "$DIRECTION" == "horizontal" ]] && echo "-h" || echo "-v")

current_session=$(tmux display-message -p '#{session_name}')
current_window=$(tmux display-message -p '#{window_index}')
current_pane=$(tmux display-message -p '#{pane_index}')

preview_pane() {
  local line="$1"
  local target
  target=$(echo "$line" | cut -d"|" -f1)
  if [ "$target" = "new" ]; then
    echo "Create a new window"
  else
    tmux capture-pane -ep -t "$target"
  fi
}

export -f preview_pane

{
  echo "0|new|[New Window]"
  tmux list-panes -a -F '#{session_name}|#{window_index}|#{pane_index}|#{window_id}|#{pane_title}' |
    while IFS='|' read -r sess win pane wid title; do
      [ "$sess" = "$current_session" ] && [ "$win" = "$current_window" ] && [ "$pane" = "$current_pane" ] && continue

      target="${sess}:${win}.${pane}"
      wname=$(tmux_window_name "$wid" 20)

      priority=1
      [ "$sess" = "$current_session" ] && [ "$win" = "$current_window" ] && priority=1 ||
        [ "$sess" = "$current_session" ] && priority=2 || priority=3

      echo "${priority}|${target}|${target} - [${wname}] ${title}"
    done
} |
  sort -t'|' -k1,1n |
  cut -d'|' -f2,3 |
  fzf --ansi --delimiter='|' --with-nth=2 \
    --preview-window right:70% \
    --preview 'bash -c "preview_pane {}"' |
  cut -d'|' -f1 |
  {
    read -r selected
    if [ "$selected" = "new" ]; then
      tmux break-pane -d
    elif [ -n "$selected" ]; then
      tmux join-pane "$JOIN_FLAG" -t "$selected"
    fi
  }
