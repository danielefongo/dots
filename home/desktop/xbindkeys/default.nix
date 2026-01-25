{ pkgs, ... }:

{
  home.packages = with pkgs; [
    playerctl
    xbindkeys
  ];

  home.file.".xbindkeysrc".source = pkgs.dot.outLink "xbindkeys/xbindkeysrc";

  systemd.user.services = {
    xbindkeys = {
      Unit = {
        Description = "Xbindkeys";
        PartOf = [ "x11-session.target" ];
      };

      Install = {
        WantedBy = [ "x11-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.xbindkeys}/bin/xbindkeys -n";
        Restart = "always";
        RestartSec = 2;
      };
    };
  };
}
