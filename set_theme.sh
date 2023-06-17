#!/bin/bash
cd "$HOME/dotfiles/dots/"

node templating/index.js $1

killall dunst 2>/dev/null && notify-send "Dunst" "Restarted" >/dev/null || true
polybar-msg cmd restart >/dev/null
[ $(pidof picom) ] || picom --experimental-backends -b
i3-msg reload >/dev/null || true
