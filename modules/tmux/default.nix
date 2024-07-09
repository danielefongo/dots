{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    tmux
  ];

  xdg.configFile."tmux/tmux.conf".source = lib.outLink "tmux/tmux.conf";
}
