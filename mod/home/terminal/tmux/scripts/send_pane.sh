#!/bin/bash

DIRECTION="${1:-horizontal}"
JOIN_FLAG=$([[ "$DIRECTION" == "horizontal" ]] && echo "-h" || echo "-v")

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
  echo "new|[New Window]"
  tmux_list_panes --exclude-current
} |
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
