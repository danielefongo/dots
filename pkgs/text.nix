{ pkgs, ... }:

final: prev: {
  type-text =
    isWayland:
    if isWayland then
      pkgs.dot.script "type-text" "ydotool type \"$1\"" [ pkgs.ydotool ]
    else
      pkgs.dot.script "type-text" "xdotool type --delay 10 \"$1\"" [ pkgs.xdotool ];

  paste-text =
    isWayland:
    if isWayland then
      pkgs.dot.script "paste-text" "wtype -M ctrl v -m ctrl" [ pkgs.wtype ]
    else
      pkgs.dot.script "paste-text" "xdotool key ctrl+v" [ pkgs.xdotool ];
}
