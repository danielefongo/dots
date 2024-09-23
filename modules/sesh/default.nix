{ lib, pkgs, ... }:

let
  sesh = import ./package.nix { inherit lib pkgs; };
in
{
  home.packages = with pkgs; [
    sesh
  ];

  xdg.configFile."sesh/sesh.toml".source = lib.outLink "sesh/sesh.toml";
}
