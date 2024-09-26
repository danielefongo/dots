{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    playerctl
    xbindkeys
  ];

  home.file.".xbindkeysrc".source = lib.outLink "xbindkeys/.xbindkeysrc";

  systemd.user.services = {
    xbindkeys = {
      Unit = {
        Description = "Xbindkeys";
        PartOf = [ "i3-session.target" ];
      };

      Install = {
        WantedBy = [ "i3-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.xbindkeys}/bin/xbindkeys -n";
        Restart = "always";
        RestartSec = 2;
      };
    };
  };
}
