{ lib, pkgs, ... }:

lib.homeOpts.module "desktop.i3" { } (_: {
  imports = [
    ./keyboard.nix
  ];

  home.packages = with pkgs; [
    i3
    i3lock-color
    xss-lock
    (pkgs.dot.script "i3-resize" ./scripts/i3resize.sh [ ])
    (pkgs.dot.script "i3-restart" ./scripts/i3restart.sh [ pkgs.xdotool ])
    (pkgs.dot.script "i3-lock" (pkgs.dot.outLink "i3/lock.sh") [ ])
  ];

  xdg.configFile."i3".source = pkgs.dot.outLink "i3";

  systemd.user.targets.x11-session = {
    Unit = {
      Description = "i3 session";
      BindsTo = "graphical-session.target";
      Wants = [ ];
    };
  };

  mod.home.system.theme.enable = true;
  mod.home.apps.copyq.enable = true;
  mod.home.apps.ocr.enable = true;
  mod.home.terminal.kitty.enable = true;
})
