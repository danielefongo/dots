#!/usr/bin/env bash

current_coordinates=$(xdotool getmouselocation --shell)

i3-msg restart || true

eval "$(echo "$current_coordinates" | grep X)"
eval "$(echo "$current_coordinates" | grep Y)"

xdotool mousemove "$X" "$Y"
