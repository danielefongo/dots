{ pkgs, home, ... }:

let
  wrap-nixgl = pkgs.callPackage ../helpers/wrap-nixgl.nix { };
in
{
  home.packages = with pkgs; [
    (wrap-nixgl picom)
  ];

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
