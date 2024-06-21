{ config, pkgs, user, home, ... }:

{
  imports = [
    ./modules/alacritty.nix
    ./modules/dunst.nix
    ./modules/firefox
    ./modules/fonts.nix
    ./modules/git.nix
    ./modules/i3.nix
    ./modules/neovim.nix
    ./modules/picom.nix
    ./modules/polybar.nix
    ./modules/shell.nix
  ];

  home.username = user;
  home.homeDirectory = home;
  home.packages = [
    pkgs.rebuild
  ];

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
