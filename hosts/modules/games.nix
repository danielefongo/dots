{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    package = pkgs.steam;
  };
}
