#!/bin/bash
cd "$HOME/dotfiles/dots/"

node templating/index.js $1

i3-msg restart >/dev/null || true
killall dunst 2>/dev/null && notify-send "Dunst" "Restarted" >/dev/null || true
