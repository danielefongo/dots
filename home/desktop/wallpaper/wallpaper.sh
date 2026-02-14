#!/bin/bash

svg2png $DOTS_PATH/output/wallpaper/background.svg
feh --bg-center "$DOTS_PATH/output/wallpaper/background.svg"
