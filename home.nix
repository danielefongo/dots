{ config, pkgs, user, home, ... }:

{
  imports = [
    ./git
    ./theme
    ./tig
    ./wallpaper
  ];

  home.username = user;
  home.homeDirectory = home;
  home.packages = [ ];

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
