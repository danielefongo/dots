{ pkgs, home, config, dots_path, ... }:

let
  wrap-nixgl = pkgs.callPackage ../helpers/wrap-nixgl.nix { };
in
{
  home.packages = with pkgs; [
    (wrap-nixgl picom)
  ];

  xdg.configFile."picom".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/picom";

  systemd.user.services = {
    picom = {
      Unit = {
        Description = "Picom";
      };

      Service = {
        ExecStart = "${pkgs.picom}/bin/picom";
        Restart = "always";
      };
    };
  };
}
