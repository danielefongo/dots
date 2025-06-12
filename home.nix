{ user, home, ... }:

{
  imports = [
    ./modules
    ./prima/home.nix
  ];

  home.username = user;
  home.homeDirectory = home;
  home.packages = [ ];

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
