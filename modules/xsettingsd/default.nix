{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    xsettingsd
  ];

  xdg.configFile."xsettingsd".source = lib.outLink "xsettingsd";

  systemd.user.services = {
    xsettingsd = {
      Unit = {
        Description = "Xsettingsd";
        PartOf = [ "i3-session.target" ];
      };

      Install = {
        WantedBy = [ "i3-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.xsettingsd}/bin/xsettingsd";
        Restart = "on-failure";
        RestartSec = 2;
      };
    };
  };
}
