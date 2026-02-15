#!/bin/bash

svg2png $DOTS_PATH/output/wallpaper/background.svg
swaybg -i "$DOTS_PATH/output/wallpaper/background.png" -m center
