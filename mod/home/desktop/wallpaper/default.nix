{
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

  wallpaper = pkgs.dot.script "wallpaper" ./wallpaper.sh [
    svg2png
    pkgs.feh
  ];
in
lib.homeOpts.module "desktop.wallpaper" { } (_: {
  systemd.user.services = {
    wallpaper = {
      Unit = {
        Description = "Wallpaper";
        PartOf = [ "x11-session.target" ];
      };

      Install = {
        WantedBy = [ "x11-session.target" ];
      };

      Service = {
        Type = "simple";
        ExecStart = "${wallpaper}/bin/wallpaper";
      };
    };
  };
})
