{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    sesh
  ];

  xdg.configFile."sesh/sesh.toml".source = lib.outLink "sesh/sesh.toml";
}
