#!/usr/bin/bash

notify="notify-send -u low dunst"

case $(dunstctl is-paused) in
    true) dunstctl set-paused false;;
    false) (dunstctl close && dunstctl set-paused true) &;;
esac
