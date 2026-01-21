{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [ sesh ];

  xdg.configFile."sesh/sesh.toml".source = pkgs.outLink "sesh/sesh.toml";
}
