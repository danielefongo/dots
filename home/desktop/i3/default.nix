{ lib, pkgs, ... }:

lib.opts.module "desktop.i3" { } (cfg: {
  imports = [
    ./keyboard.nix
  ];

  home.packages = with pkgs; [
    i3
    i3lock-color
    (pkgs.dot.script "i3resize" ./scripts/i3resize.sh [ ])
    (pkgs.dot.script "i3restart" ./scripts/i3restart.sh [ pkgs.xdotool ])
    (pkgs.dot.script "i3block" ./scripts/i3block.sh [ ])
  ];

  xdg.configFile."i3".source = pkgs.dot.outLink "i3";

  systemd.user.targets = {
    x11-session = {
      Unit = {
        Description = "i3 session";
        BindsTo = "graphical-session.target";
        Wants = [ ];
      };
    };
  };

  module.system.theme.enable = true;
  module.apps.copyq.enable = true;
  module.apps.ocr.enable = true;
  module.terminal.kitty.enable = true;
})
