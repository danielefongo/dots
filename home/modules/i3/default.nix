{ lib, pkgs, ... }:

lib.optionalModule "x11.i3" { } (cfg: {
  imports = [
    ./keyboard.nix
    ./scripts.nix
  ];

  home.packages = with pkgs; [
    i3
    i3lock-color
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
})
