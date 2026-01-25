{ pkgs, ... }:

{
  home.packages = with pkgs; [ sesh ];

  xdg.configFile."sesh/sesh.toml".source = pkgs.dot.outLink "sesh/sesh.toml";
}
