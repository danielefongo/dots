#!/bin/bash

tmux_list_panes |
  fzf --ansi --multi --delimiter='|' --with-nth=2 \
    --preview-window right:70% \
    --preview 'target=$(echo {} | cut -d"|" -f1); tmux capture-pane -ep -t "$target" 2>/dev/null || echo "Unable to preview pane"' |
  cut -d'|' -f1 |
  while read -r selected; do
    if [ -n "$selected" ]; then
      tmux kill-pane -t "$selected"
    fi
  done
