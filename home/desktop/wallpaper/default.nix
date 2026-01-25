{ pkgs, user_data, ... }:

let
  svg2png = pkgs.writeShellScriptBin "svg2png" ''
    #!/usr/bin/env bash
    set -euo pipefail

    in="$1"
    out="''$(printf '%s\n' "$in" | sed -E 's/\.svg$/.png/i')"
    dpi=96

    ${pkgs.librsvg}/bin/rsvg-convert -d "$dpi" -p "$dpi" "$in" > "$out" || true
  '';

  wallpaper = pkgs.writeShellScriptBin "wallpaper" ''
    ${svg2png}/bin/svg2png ${user_data.dots_path}/output/wallpaper/background.svg

    ${pkgs.feh}/bin/feh --bg-center "${user_data.dots_path}/output/wallpaper/background.svg"
  '';
in
{
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
}
