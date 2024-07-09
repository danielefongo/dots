{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    git
    delta
  ];

  xdg.configFile."git".source = lib.outLink "git";
}
