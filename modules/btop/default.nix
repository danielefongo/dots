{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    btop
  ];

  xdg.configFile."btop".source = lib.outLink "btop";
}
