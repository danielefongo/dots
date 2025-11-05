{ pkgs, user_data, ... }:

let
  wallpaper = pkgs.writeShellScriptBin "wallpaper" ''
    DESTINATION=${user_data.dots_path}/output/wallpaper/background.svg

    ${pkgs.feh}/bin/feh --bg-scale "${user_data.dots_path}/output/wallpaper/background.svg"
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
