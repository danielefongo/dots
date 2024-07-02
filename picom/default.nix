{ pkgs, home, config, dots_path, ... }:

let
  wrap-nixgl = pkgs.callPackage ../helpers/wrap-nixgl.nix { };
  picom = (wrap-nixgl pkgs.picom);
in
{
  home.packages = [
    picom
  ];

  xdg.configFile."picom".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/picom";

  systemd.user.services = {
    picom = {
      Unit = {
        Description = "Picom";
      };

      Service = {
        ExecStart = "${picom}/bin/picom";
        Restart = "always";
      };
    };
  };
}
