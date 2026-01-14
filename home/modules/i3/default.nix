{ lib, pkgs, ... }:

{
  imports = [
    ./keyboard.nix
  ];

  home.packages = with pkgs; [
    i3
    i3lock-color
    (lib.dotScript "i3resize" ./scripts/i3resize.sh [ ])
    (lib.dotScript "i3restart" ./scripts/i3restart.sh [ pkgs.xdotool ])
    (lib.dotScript "i3block" ./scripts/i3block.sh [ ])
  ];

  xdg.configFile."i3".source = lib.outLink "i3";

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
