#!/bin/bash

tmux_list_panes --exclude-current |
  fzf --ansi --delimiter='|' --with-nth=2 \
    --preview-window right:70% \
    --preview 'target=$(echo {} | cut -d"|" -f1); tmux capture-pane -ep -t "$target" 2>/dev/null || echo "Unable to preview pane"' |
  cut -d'|' -f1 |
  {
    read -r selected
    if [ -n "$selected" ]; then
      tmux switch-client -t "$selected"
    fi
  }
