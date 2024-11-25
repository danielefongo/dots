{ user, home, ... }:

{
  imports = [
    ./modules
    ./prima/home.nix
  ];

  home.username = user;
  home.homeDirectory = home;
  home.packages = [ ];

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
