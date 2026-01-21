{ lib, pkgs, ... }:

{
  imports = [
    ./keyboard.nix
  ];

  home.packages = with pkgs; [
    i3
    i3lock-color
    (pkgs.dotScript "i3resize" ./scripts/i3resize.sh [ ])
    (pkgs.dotScript "i3restart" ./scripts/i3restart.sh [ pkgs.xdotool ])
    (pkgs.dotScript "i3block" ./scripts/i3block.sh [ ])
  ];

  xdg.configFile."i3".source = pkgs.outLink "i3";

  systemd.user.targets = {
    x11-session = {
      Unit = {
        Description = "i3 session";
        BindsTo = "graphical-session.target";
        Wants = [ ];
      };
    };
  };
}
