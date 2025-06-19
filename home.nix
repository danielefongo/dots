{
  pkgs,
  user,
  home,
  ...
}:
{
  imports = [
    ./modules
  ];

  home.username = user;
  home.homeDirectory = home;

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
