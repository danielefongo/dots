{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    tmux
    tmuxinator
  ];

  xdg.configFile."tmux/tmux.conf".source = lib.outLink "tmux/tmux.conf";
}
