{ lib, pkgs, ... }:

{
  imports = [
    ./keyboard.nix
    ./scripts.nix
  ];

  home.packages = with pkgs; [
    i3
    i3lock-fancy-rapid
  ];

  xdg.configFile."i3".source = lib.outLink "i3";

  systemd.user.targets = {
    i3-session = {
      Unit = {
        Description = "i3 session";
        BindsTo = "graphical-session.target";
        Wants = [ ];
      };
    };
  };
}
