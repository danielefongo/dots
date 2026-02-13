{ lib, pkgs, ... }:

let
  playerctlStatus = pkgs.writeShellScriptBin "playerctl-status" ''
    #!/bin/env bash
    PLAYER="$1"
    NOPLAYER_FORMAT=$(echo "$2" | sed -E 's/<([^>]+)>/{{ \1 }}/g')
    STOPPED_FORMAT=$(echo "$3" | sed -E 's/<([^>]+)>/{{ \1 }}/g')
    PLAY_FORMAT=$(echo "$4" | sed -E 's/<([^>]+)>/{{ \1 }}/g')
    PAUSE_FORMAT=$(echo "$5" | sed -E 's/<([^>]+)>/{{ \1 }}/g')

    PLAYERCTL_STATUS=$(playerctl --player=$PLAYER status 2>/dev/null)
    EXIT_CODE=$?

    if [ $EXIT_CODE -eq 0 ]; then
    	STATUS=$PLAYERCTL_STATUS
    else
    	STATUS="No player is running"
    fi

    if [ "$STATUS" = "Stopped" ]; then
    	echo "$STOPPED_FORMAT"
    elif [ "$STATUS" = "Paused" ]; then
    	playerctl --player=$PLAYER metadata --format "$PAUSE_FORMAT"
    elif [ "$STATUS" = "No player is running" ]; then
    	echo "$NOPLAYER_FORMAT"
    else
    	playerctl --player=$PLAYER metadata --format "$PLAY_FORMAT"
    fi
  '';
in
lib.opts.module "desktop.playerctl" { } (_: {
  home.packages = [
    pkgs.playerctl
    playerctlStatus
  ];
})
