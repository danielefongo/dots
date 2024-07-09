{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    flameshot
  ];

  xdg.configFile."flameshot".source = lib.outLink "flameshot";

  systemd.user.services = {
    flameshot = {
      Unit = {
        Description = "Flameshot";
        PartOf = "graphical-session.target";
      };

      Service = {
        ExecStart = "${pkgs.flameshot}/bin/flameshot";
        Restart = "on-failure";
      };
    };
  };
}
