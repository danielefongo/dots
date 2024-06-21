{ config, pkgs, user, home, ... }:

{
  imports = [
    ./modules/alacritty.nix
    ./modules/firefox
    ./modules/git.nix
    ./modules/neovim.nix
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
