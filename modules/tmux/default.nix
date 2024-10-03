{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    entr
    tmux
    tmuxinator
  ];

  xdg.configFile."tmux/tmux.conf".source = lib.outLink "tmux/tmux.conf";
}
