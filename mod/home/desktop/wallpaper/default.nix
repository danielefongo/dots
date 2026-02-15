{
  config,
  lib,
  pkgs,
  ...
}:

let
  svg2png = pkgs.writeShellScriptBin "svg2png" ''
    #!/usr/bin/env bash
    set -euo pipefail

    in="$1"
    out="''$(printf '%s\n' "$in" | sed -E 's/\.svg$/.png/i')"
    dpi=96

    ${pkgs.librsvg}/bin/rsvg-convert -d "$dpi" -p "$dpi" "$in" > "$out" || true
  '';

  isWayland = lib.hasHomeModule config "desktop.wayland";
  sessionTarget = if isWayland then "wayland-session.target" else "x11-session.target";

  wallpaper =
    if isWayland then
      pkgs.dot.script "wallpaper" ./wallpaper-wayland.sh [
        svg2png
        pkgs.swaybg
      ]
    else
      pkgs.dot.script "wallpaper" ./wallpaper-x11.sh [
        svg2png
        pkgs.feh
      ];
in
lib.homeOpts.module "desktop.wallpaper" { } (_: {
  systemd.user.services.wallpaper = {
    Unit = {
      Description = "Wallpaper";
      PartOf = [ sessionTarget ];
    };

    Install = {
      WantedBy = [ sessionTarget ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${wallpaper}/bin/wallpaper";
    };
  };
})
