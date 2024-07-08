{ pkgs, home, config, dots_path, ... }:

{
  home.packages = with pkgs; [
    playerctl
    xbindkeys
  ];

  home.file.".xbindkeysrc".source = config.lib.file.mkOutOfStoreSymlink "${dots_path}/output/xbindkeys/.xbindkeysrc";

  systemd.user.services = {
    xbindkeys = {
      Unit = {
        Description = "Xbindkeys";
        PartOf = "graphical-session.target";
      };

      Service = {
        ExecStart = "${pkgs.xbindkeys}/bin/xbindkeys -n";
        Restart = "always";
        RestartSec = "1";
      };
    };
  };
}
