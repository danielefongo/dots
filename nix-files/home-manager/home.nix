{ config, pkgs, user, home, ... }:

{
  imports = [];

  home.username = user;
  home.homeDirectory = home;
  home.packages = [
    pkgs.rebuild
  ];

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
