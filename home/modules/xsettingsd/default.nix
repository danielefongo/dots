{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [ xsettingsd ];

  xdg.configFile."xsettingsd".source = pkgs.outLink "xsettingsd";

  systemd.user.services = {
    xsettingsd = {
      Unit = {
        Description = "Xsettingsd";
        PartOf = [ "x11-session.target" ];
      };

      Install = {
        WantedBy = [ "x11-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.xsettingsd}/bin/xsettingsd";
        Restart = "on-failure";
        RestartSec = 2;
      };
    };
  };
}
