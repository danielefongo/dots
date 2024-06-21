#!/usr/bin/env bash

CONFIG_FILE=$HOME/.config/polybar/config

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

export WLAN=$(ip link show | grep 'wl' | awk -F' ' '{print $2}' | sed 's/://g')

for m in $(polybar --list-monitors | cut -d":" -f1); do
	MONITOR=$m polybar top -c $CONFIG_FILE &
done
sleep infinity
